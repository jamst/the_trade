class PromoteCharge < ApplicationRecord
  attr_accessor :subtotal
  belongs_to :item, class_name: 'Promote', foreign_key: :promote_id

  validates :max, numericality: { greater_than: -> (o) { o.min } }
  validates :min, numericality: { less_than: -> (o) { o.max } }

  def final_price(amount = 1)
    raise 'Should Implement in Subclass'
  end

end

# :min, :integer
# :max, :integer
# :price, :decimal
# :type, :string     # SingleCharge / TotalCharge