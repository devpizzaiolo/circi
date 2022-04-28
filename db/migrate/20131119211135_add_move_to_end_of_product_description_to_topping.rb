class AddMoveToEndOfProductDescriptionToTopping < ActiveRecord::Migration
  def change
    add_column :toppings, :move_to_end_of_description, :boolean, :default => false
  end
end
