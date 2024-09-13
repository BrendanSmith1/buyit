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

    # We want to add the product to the cart
    if @cart_product.present?
      # If the product already exists in the cart, increase the quantity
      @cart_product.update(quantity: (@cart_product.quantity + 1))
    else
      # Otherwise, create a new cart product
      @cart_product = @cart.cart_products.create!(product: @product, quantity: 1)
    end

    # If the product is added to the cart, reduce the stock
    @product.update(stock_quantity: (@product.stock_quantity - 1))

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
    # debugger

    # If the quantity is > 0, update the quantity, otherwise destroy the cart product
    if params[:cart_product][:quantity].to_i.positive?
      @cart_product.update(quantity: params[:cart_product][:quantity])
    else
      @cart_product.destroy
    end

    # If the quantity is increased (prev < new) reduce stock, if quantity is decreased (prev > new) increase stock
    if @product.enough_stock?(@new_quantity)
      if @prev_quantity < @new_quantity
        @product.update(stock_quantity: (@product.stock_quantity + @prev_quantity - @new_quantity))
      elsif @prev_quantity > @new_quantity
        @product.update(stock_quantity: (@product.stock_quantity + @prev_quantity - @new_quantity))
      else
        # Do nothing
      end
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
