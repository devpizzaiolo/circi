class AddColMetadataToProductCombos < ActiveRecord::Migration
  def change
    add_column :product_combos, :seo_title, :text
    add_column :product_combos, :seo_metadescription, :text
    add_column :product_combos, :seo_keywords, :text
  end
end
