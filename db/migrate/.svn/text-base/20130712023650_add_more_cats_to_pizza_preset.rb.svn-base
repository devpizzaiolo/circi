class AddMoreCatsToPizzaPreset < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :pizzaiolo_favourites, :boolean, :default => false
    add_column :pizza_presets, :spicy, :boolean, :default => false
    add_column :pizza_presets, :customer_favourites, :boolean, :default => false
    add_column :pizza_presets, :vegan, :boolean, :default => false
    add_column :pizza_presets, :health_check, :boolean, :default => false
  end
end
