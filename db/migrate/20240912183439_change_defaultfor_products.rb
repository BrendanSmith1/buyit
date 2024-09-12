class ChangeDefaultforProducts < ActiveRecord::Migration[7.1]
  def change
    change_column_default :products, :stock_quantity, 0
  end
end
