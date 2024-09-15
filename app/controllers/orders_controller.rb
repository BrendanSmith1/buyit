class OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    @cart = current_user.cart
    if @cart.cart_products.empty?
      redirect_to cart_path(@cart), alert: 'Your cart is empty'
    end

    @order = current_user.orders.new(status: 'pending')
    @order.user = current_user
    @cart.cart_products.each do |cart_product|
      @order.order_products.build(
        product: cart_product.product,
        quantity: cart_product.quantity
      )
    end

    if @order.save
      @order.update(status: 'Completed')
      @cart.cart_products.destroy_all
      redirect_to order_path(@order), notice: 'Order was successfully created.'
    else
      redirect_to cart_path(@cart), alert: 'There was an error creating your order.'
    end
  end

  private

  def order_params
    params.require(:order).permit(:status, :user_id)
  end
end
