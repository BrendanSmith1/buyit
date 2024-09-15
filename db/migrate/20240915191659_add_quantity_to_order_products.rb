class AddQuantityToOrderProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :order_products, :quantity, :integer, default: 0
  end
end
