class User < ApplicationRecord
  has_many :orders
  has_many :order_products, through: :orders
  has_many :products, through: :order_products

  validates :email, presence: true, uniqueness: true
end
