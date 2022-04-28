class AddPositionToTypeOfTopping < ActiveRecord::Migration
  def change
    add_column :type_of_toppings, :position, :integer, :default => 0
  end
end
