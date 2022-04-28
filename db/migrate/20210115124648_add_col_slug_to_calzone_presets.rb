class AddColSlugToCalzonePresets < ActiveRecord::Migration
  def change
    add_column :calzone_presets, :slug, :string
  end
end
