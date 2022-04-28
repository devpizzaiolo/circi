class AddIsNewPizzaSortToPizzaPresets < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :is_new_pizza, :boolean
    add_column :pizza_presets, :sort, :integer
  end
end
