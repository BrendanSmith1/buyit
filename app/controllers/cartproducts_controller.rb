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
    @product.add_to_cart(@cart, 1)

    # If the cart is saved, redirect the user to the cart show page
    if @cart.save
      redirect_to cart_path(@cart)
    else
      redirect_to product_path(@product)
    end
  end

  def update
    # Find the cart product and update the quantity
    @cart = current_user.cart
    @cart_product = @cart.cart_products.find(params[:id])
    @prev_quantity = @cart_product.quantity
    @new_quantity = params[:cart_product][:quantity].to_i
    @product = Product.find(@cart_product.product_id)

    # If the quantity is > 0, update the quantity, otherwise destroy the cart product
    @new_quantity.positive? ? @cart_product.update(quantity: params[:cart_product][:quantity]) : @cart_product.destroy

    # If the stock is not enough, update the cart product quantity to the stock quantity
    # The user can change the quant of stock!
    # Need a new attribute to store the original quantity of the product, which only gets changed when the user checks out
    if @product.enough_stock?(@new_quantity)
      # If the quantity is increased (prev < new) reduce stock, if quantity is decreased (prev > new) increase stock
      @new_quantity > @prev_quantity ? @product.decrease_stock!(@new_quantity - @prev_quantity) : @product.increase_stock!(@prev_quantity - @new_quantity)
    else
      # If the stock is not enough, update the cart product quantity to the stock quantity
      @cart_product.update(quantity: @product.stock_quantity)
    end

    redirect_to cart_path(@cart)
  end

  def destroy
    @cart = current_user.cart
    @cart_product = @cart.cart_products.find(params[:id])
    @cart_product.destroy
    redirect_to cart_path(@cart)
  end
end
