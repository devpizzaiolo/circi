class AddPriceToPizzaSize < ActiveRecord::Migration
  def change
    add_column :pizza_sizes, :price, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end
