class CreatePizzaPresets < ActiveRecord::Migration
  def change
    create_table :pizza_presets do |t|
      t.text :product_info
      t.string :product_name
      t.boolean :active, :default => true
      t.string :product_image

      t.timestamps
    end
  end
end
