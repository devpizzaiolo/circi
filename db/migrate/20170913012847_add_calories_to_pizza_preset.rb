class AddCaloriesToPizzaPreset < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :calories, :string
  end
end
