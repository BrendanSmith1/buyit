class UpdateQuantityforCartProducts < ActiveRecord::Migration[7.1]
  def change
    change_column :cart_products, :quantity, :integer, default: 0
  end
end
