class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new
    @order.product = Product.find(params[:product_id])
    if @order.save
    else
      render :new
    end

  end

  private

end
