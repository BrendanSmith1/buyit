class AddReferenceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :orders, null: false, foreign_key: true
  end
end
