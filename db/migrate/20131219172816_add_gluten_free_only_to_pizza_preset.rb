class AddGlutenFreeOnlyToPizzaPreset < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :gluten_free_only, :boolean, :default => false
  end
end
