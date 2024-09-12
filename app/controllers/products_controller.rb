class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    # If the user is logged in, we want to find the cart that belongs to the user
    # If the user is not logged in, we want to create a new cart
  end
end
