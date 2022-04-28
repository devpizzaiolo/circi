class AddColPrintNameToToppings < ActiveRecord::Migration
  def change
    add_column :toppings, :print_name, :string
  end
end