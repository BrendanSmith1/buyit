class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products, dependent: :destroy

  def total_price
    cart_products.map { |cart_product| cart_product.product.price * cart_product.quantity }.sum
  end
end
