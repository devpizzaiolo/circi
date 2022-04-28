class AddColTipsToOrders < ActiveRecord::Migration
  def change
    unless column_exists?(:orders, :tip_type)
      add_column :orders, :tip_type, :string
    end
    unless column_exists?(:orders, :tip_percentage)
      add_column :orders, :tip_percentage, :string
    end
    unless column_exists?(:orders, :tip_amount)
      add_column :orders, :tip_amount, :float, default: 0.0 
    end
  end
end
