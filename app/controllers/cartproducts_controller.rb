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

    # If the new quantity is less than the previous quantity, increase the stock
    if @prev_quantity > @new_quantity && @new_quantity.positive?
      @cart_product.update(quantity: @new_quantity)
      @product.increase_stock!(@prev_quantity - @new_quantity)
    else
    # If the new quantity is more than the previous quantity, decrease the stock
      if @product.enough_stock?(@new_quantity - @prev_quantity)
        @cart_product.update(quantity: @new_quantity)
        @product.decrease_stock!(@new_quantity - @prev_quantity)
      else
        flash[:alert] = "There's not enough stock for this product"
      end
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
