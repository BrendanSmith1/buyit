class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products, dependent: :destroy

  def total_price
    order_products.map { |order_product| order_product.product.price * order_product.quantity }.sum
  end
end
