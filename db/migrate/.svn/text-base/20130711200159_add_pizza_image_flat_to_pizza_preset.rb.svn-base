class AddPizzaImageFlatToPizzaPreset < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :pizza_image_flat, :string
    add_column :pizza_presets, :pizza_image_angled, :string
    remove_column :pizza_presets, :product_image
    remove_column :pizza_presets, :product_image_angled
  end
end
