class AddColSeoTitleToCalzonePresets < ActiveRecord::Migration
  def change
    add_column :calzone_presets, :seo_title, :text
    add_column :calzone_presets, :seo_metadescription, :text
    add_column :calzone_presets, :seo_keywords, :text
  end
end
