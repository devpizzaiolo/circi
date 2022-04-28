class AddPizzaCategoryToPizzaPreset < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :pizza_category_id, :integer
    add_index :pizza_presets, :pizza_category_id
  end
end
