class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    # If the user is logged in, we want to find the cart that belongs to the user
    # If the user is not logged in, we want to create a new cart
    if current_user.cart.present?
      @cart = current_user.cart
    else
      @cart = Cart.new
      @cart.user = current_user
    end

    # We want to add the product to the cart
    # @cart.products << @product
    console

    # if @cart.save
    #   redirect_to cart_path(@cart)
    # else
    #   redirect_to product_path(@product)
    # end
  end
end
