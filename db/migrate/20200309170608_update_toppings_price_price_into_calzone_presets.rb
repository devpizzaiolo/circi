class UpdateToppingsPricePriceIntoCalzonePresets < ActiveRecord::Migration
  def up
    @calzone_preset = CalzonePreset.first
    @calzone_preset.normal_topping_price = 1.99
    @calzone_preset.extra_topping_price = 2.99
    @calzone_preset.double_topping_price = 3.75
    @calzone_preset.save
  end


  def down
    @calzone_preset = CalzonePreset.first
    @calzone_preset.price = 8.99
    @calzone_preset.topping_price = 1.99
    @calzone_preset.save
  end
end
