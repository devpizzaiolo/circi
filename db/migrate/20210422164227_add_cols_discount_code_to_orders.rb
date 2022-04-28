class AddColsDiscountCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :discount_code, :string
    add_column :orders, :discount_code_id, :integer
    add_column :orders, :discount_dollar_value, :decimal, precision: 15, scale: 2, default: 0.0, :null => false
  end
end
