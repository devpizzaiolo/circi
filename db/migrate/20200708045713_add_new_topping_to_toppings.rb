class AddNewToppingToToppings < ActiveRecord::Migration
  def change
    add_column :toppings, :new_topping, :boolean
  end
end
