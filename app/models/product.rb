class Product < ApplicationRecord
  has_many :cart_products
  has_many :carts, through: :cart_prodcuts
  has_many :order_items
  has_many :orders, through: :order_items
end
