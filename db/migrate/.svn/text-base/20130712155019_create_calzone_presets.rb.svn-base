class CreateCalzonePresets < ActiveRecord::Migration
  def change
    create_table :calzone_presets do |t|
      t.text :product_info
      t.string :product_name
      t.boolean :active, :default => false
      t.string :calzone_image_flat
      t.string :calzone_image_angled

      t.timestamps
    end
  end
end
