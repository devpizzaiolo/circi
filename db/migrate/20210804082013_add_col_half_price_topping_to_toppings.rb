class AddColHalfPriceToppingToToppings < ActiveRecord::Migration
  def change
    add_column :toppings, :half_price_topping, :boolean, default: false
  end
end
