class AddFieldstoCartProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :cart_products, :cart, null: false, foreign_key: true
    add_reference :cart_products, :product, null: false, foreign_key: true
    add_column :cart_products, :quantity, :integer
  end
end
