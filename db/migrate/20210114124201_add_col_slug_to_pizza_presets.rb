class AddColSlugToPizzaPresets < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :slug, :string
  end
end
