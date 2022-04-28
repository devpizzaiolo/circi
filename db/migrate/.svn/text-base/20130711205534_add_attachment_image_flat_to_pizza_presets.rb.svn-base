class AddAttachmentImageFlatToPizzaPresets < ActiveRecord::Migration
  def self.up
    add_column :pizza_presets, :image_flat_file_name, :string
    add_column :pizza_presets, :image_flat_content_type, :string
    add_column :pizza_presets, :image_flat_file_size, :integer
    add_column :pizza_presets, :image_flat_updated_at, :datetime
  end

  def self.down
    remove_column :pizza_presets, :image_flat_file_name
    remove_column :pizza_presets, :image_flat_content_type
    remove_column :pizza_presets, :image_flat_file_size
    remove_column :pizza_presets, :image_flat_updated_at
  end
end
