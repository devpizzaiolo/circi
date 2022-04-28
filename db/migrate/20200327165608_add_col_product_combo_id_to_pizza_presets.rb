class AddColProductComboIdToPizzaPresets < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :is_product_combo, :boolean, default: false
    add_column :pizza_presets, :product_combo_id, :integer
  end
end
