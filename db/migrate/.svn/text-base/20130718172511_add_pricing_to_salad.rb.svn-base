class AddPricingToSalad < ActiveRecord::Migration
  def change
    add_column :salads, :price_one_to_five, :decimal, :precision => 10, :scale => 2, :default => 0.0
    add_column :salads, :price_six_to_nineteen, :decimal, :precision => 10, :scale => 2, :default => 0.0
    add_column :salads, :price_twenty_plus, :decimal, :precision => 10, :scale => 2, :default => 0.0
    remove_column :salads, :price
  end
end
