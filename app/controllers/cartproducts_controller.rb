class CartproductsController < ApplicationController

  def create
    # If the user has a cart, we want to use that cart, otherwise we want to create a new one
    if current_user.cart.present?
      @cart = current_user.cart
    else
      @cart = Cart.new
      @cart.user = current_user
    end
    @product = Product.find(params[:product_id])
    @cart_product = @cart.cart_products.find_by(product_id: @product.id)
    # @cart_product = CartProduct.create(cart: @cart, product: @product)

    # We want to add the product to the cart
    # if @cart_product.present?
    #   # If the product already exists in the cart, increase the quantity
    #   @cart_product.update(quantity: (@cart_product.quantity + 1))
    # else
      # Otherwise, create a new cart product
      @cart_product = @cart.cart_products.create!(product: @product, quantity: 1)
    # end

    # debugger

    # If the cart is saved, we want to redirect the user to the cart show page
    if @cart.save
      redirect_to cart_path(@cart)
    else
      redirect_to product_path(@product)
    end
  end
end
