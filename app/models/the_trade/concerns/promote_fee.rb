class PromoteFee
  thread_mattr_accessor :current_currency, :current_nation, instance_accessor: true
  attr_reader :good, :buyer, :number, :charges, :prices, :discount

  def initialize(good_type, good_id, number = 1, buyer_id: nil)
    @good = good_type.constantize.unscoped.find good_id
    @number = number
    @buyer = Buyer.find(buyer_id) if buyer_id
    verbose_fee
  end

  def compute_fee
    @prices.values.sum(good.price)
  end

  def verbose_fee
    @charges = []
    @prices = {}
    @discount = {}
    SinglePromote.verified.each do |promote|
      charge = promote.compute_price(good.quantity, good.unit)
      if charge
        @charges << charge
        @prices.merge! promote.name => charge.final_price(good.quantity)
        @discount.merge! promote.name => charge.discount_price(good.quantity, number) if number > 1 && promote.discount
      end
    end
    QuantityPromote.verified.each do |promote|
      charge = promote.compute_price(number, nil)
      if charge
        @charges << charge
        @prices.merge! promote.name => charge.final_price(number)
      end
    end

    if buyer
      buyer.promotes.each do |promote|
        charge = promote.compute_price(total_subtotal, nil)
        if charge
          @charges << charge
          @prices.merge! promote.name => charge.final_price(total_subtotal)
        end
      end
    end

    @charges
  end

  def single_subtotal
    self.compute_fee.to_d
  end

  def discount_subtotal
    self.discount.values.sum
  end

  def total_subtotal
    self.single_subtotal * self.number
  end

end
