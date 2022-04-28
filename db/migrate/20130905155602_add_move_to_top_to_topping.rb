class AddMoveToTopToTopping < ActiveRecord::Migration
  def change
    add_column :toppings, :move_to_top, :boolean, :default => false
  end
end
