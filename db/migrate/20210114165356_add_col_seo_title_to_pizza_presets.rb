class AddColSeoTitleToPizzaPresets < ActiveRecord::Migration
  def change
    add_column :pizza_presets, :seo_title, :text
    add_column :pizza_presets, :seo_metadescription, :text
    add_column :pizza_presets, :seo_keywords, :text
  end
end
