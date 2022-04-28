class AddColIsAsapToOrders < ActiveRecord::Migration
  def change
    unless column_exists?(:orders, :is_asap)
      add_column :orders, :is_asap, :boolean, default: false
    end
  end
end
