class AddColIs10InchesOnlyToPizzaPresets < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :is_10_inches, :boolean, default: false
  end
end
