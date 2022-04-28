class AddToppingPriceToCalzonePreset < ActiveRecord::Migration
  def change
    add_column :calzone_presets, :topping_price, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end
