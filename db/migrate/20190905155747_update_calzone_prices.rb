class UpdateCalzonePrices < ActiveRecord::Migration
  def up
    @calzone_preset = CalzonePreset.first
    @calzone_preset.price = 8.99
    @calzone_preset.topping_price = 1.99
    @calzone_preset.save
  end

  def down
    @calzone_preset = CalzonePreset.first
    @calzone_preset.price = 8.95
    @calzone_preset.topping_price = 1.75
    @calzone_preset.save
  end
end
