class AddColCategoryIdToPizzaPresets < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :category_id, :integer
  end
end