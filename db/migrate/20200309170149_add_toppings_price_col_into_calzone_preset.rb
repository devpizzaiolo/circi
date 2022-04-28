class AddToppingsPriceColIntoCalzonePreset < ActiveRecord::Migration
  def change
    add_column :calzone_presets, :normal_topping_price, :decimal, :precision => 10, :scale => 2, :default => 0.0
    add_column :calzone_presets, :extra_topping_price, :decimal, :precision => 10, :scale => 2, :default => 0.0
    add_column :calzone_presets, :double_topping_price, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end
