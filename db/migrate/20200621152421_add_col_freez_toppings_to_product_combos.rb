class AddColFreezToppingsToProductCombos < ActiveRecord::Migration
  def change
    add_column :product_combos, :first_pizza_freeze_toopings, :string
    add_column :product_combos, :second_pizza_freeze_toopings, :string
    add_column :product_combos, :third_pizza_freeze_toopings, :string
    add_column :product_combos, :first_pizza_base_price, :string
    add_column :product_combos, :second_pizza_base_price, :string
    add_column :product_combos, :third_pizza_base_price, :string
  end
end
