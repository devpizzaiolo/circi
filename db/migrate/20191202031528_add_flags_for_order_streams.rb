class AddFlagsForOrderStreams < ActiveRecord::Migration
  def up
    add_column :franchise_locations, :enable_pos_orders, :boolean
    add_column :franchise_locations, :enable_printer_orders, :boolean, default: true
  end

  def down
    remove_column :franchise_locations, :enable_pos_orders
    remove_column :franchise_locations, :enable_printer_orders
  end
end
