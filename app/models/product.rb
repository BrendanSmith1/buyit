class Product < ApplicationRecord
  has_many :cart_products, dependent: :destroy
  has_many :carts, through: :cart_products, dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products, dependent: :destroy
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  def enough_stock?(quantity)
    stock_quantity >= quantity
  end

  def decrease_stock!(quantity)
    update!(stock_quantity: stock_quantity - quantity)
  end

  def increase_stock!(quantity)
    update!(stock_quantity: stock_quantity + quantity)
  end

  def add_to_cart(cart, quantity)
    cart_product = cart.cart_products.find_by(product: self)
    if cart_product.present?
      # If the product already exists in the cart, increase the quantity
      cart_product.update!(quantity: cart_product.quantity + quantity)
    else
      # If the product does not exist in the cart, create a new cart product
      cart.cart_products.create!(product: self, quantity: quantity)
    end
    # If the product is added to the cart, reduce the stock
    decrease_stock!(quantity)
  end
end
