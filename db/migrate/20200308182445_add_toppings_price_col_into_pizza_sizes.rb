class AddToppingsPriceColIntoPizzaSizes < ActiveRecord::Migration
  def change
    add_column :pizza_sizes, :normal_topping_price, :decimal, :precision => 10, :scale => 2, :default => 0.0
    add_column :pizza_sizes, :extra_topping_price, :decimal, :precision => 10, :scale => 2, :default => 0.0
    add_column :pizza_sizes, :double_topping_price, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end
