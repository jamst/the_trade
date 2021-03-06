class TheTradeAdmin::PromotesController < TheTradeAdmin::BaseController
  before_action :set_promote, only: [:show, :edit, :update, :toggle, :discount, :overall, :destroy]

  def index
    @promotes = Promote.default_where(params.permit(:scope)).page(params[:page])
  end

  def search
    @promotes = Promote.special.default_where('name-like': params[:q])
    render json: { results: @promotes.as_json(only: [:id, :name]) }
  end

  def new
    @promote = Promote.new
  end

  def create
    @promote = Promote.new(promote_params)

    respond_to do |format|
      if @promote.save
        format.html { redirect_to admin_promotes_url, notice: 'Promote was successfully created.' }
        format.json { render action: 'show', status: :created, location: @promote }
      else
        format.html { render action: 'new' }
        format.json { render json: @promote.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @promote.update(promote_params)
        format.html { redirect_to admin_promotes_url, notice: 'Promote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @promote.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    if params[:verified] == '1'
      @promote.update(verified: true)
    else
      @promote.update(verified: false)
    end

    head :no_content
  end

  def discount
    if params[:discount] == '1'
      @promote.update(discount: true)
    else
      @promote.update(discount: false)
    end

    head :no_content
  end

  def overall
    if params[:overall] == '1'
      @promote.update(overall: true)
    else
      @promote.update(overall: false)
    end

    head :no_content
  end

  def contain
    if params[:contain_max] == '1'
      @serve.update(contain_max: true)
    else
      @serve.update(contain_max: false)
    end

    head :no_content
  end

  def destroy
    @promote.destroy
    respond_to do |format|
      format.html { redirect_to admin_promotes_url }
      format.json { head :no_content }
    end
  end

  private
  def set_promote
    @promote = Promote.find(params[:id])
  end

  def promote_params
    params.fetch(:promote, {}).permit(:unit, :type, :name, :start_at, :finish_at, :verified, :scope, :discount)
  end
end
