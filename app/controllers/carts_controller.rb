class CartsController < ApplicationController
  def show
    @cart = Cart.find(params[:id])
    @cart_products = @cart.cart_products.map do |cart_product|
      cart_product.product
    end
  end
end
