class UserStocksController < ApplicationController
  before_action :set_user_stock, only: [:show, :edit, :update, :destroy]

  def index
    @user_stocks = UserStock.all
  end

  def show
  end

  def new
    @user_stock = UserStock.new
  end

  def edit
  end

  def create
    if params[:stock_id].present?
      @user_stock = UserStock.new(stock_id: params[:stock_id], user: current_user)
    else
      stock = Stock.find_by_ticker(params[:stock_ticker])
      if stock
        @user_stock = UserStock.new(user: current_user, stock: stock)
      else
        stock = Stock.new_from_lookup(params[:stock_ticker])
        if stock.save
          @user_stock = UserStock.new(user: current_user, stock: stock)
        else
          @user_stock = nil
          flash[:error] = "This stock is not available."
        end
      end
    end

    respond_to do |format|
      if @user_stock.save
        format.html { redirect_to my_portfolio_path, notice: "#{@user_stock.stock.ticker}
                      was successfully added." }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user_stock.update(user_stock_params)
        format.html { redirect_to @user_stock, notice: "#{@user_stock.stock.ticker} was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user_stock.destroy
    respond_to do |format|
      format.html { redirect_to my_portfolio_path, notice: "#{@user_stock.stock.ticker} was successfully removed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_stock
      @user_stock = UserStock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_stock_params
      params.require(:user_stock).permit(:user_id, :stock_id)
    end
end
