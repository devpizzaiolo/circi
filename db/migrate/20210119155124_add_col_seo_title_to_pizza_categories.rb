class AddColSeoTitleToPizzaCategories < ActiveRecord::Migration
  def change
    add_column :pizza_categories, :seo_title, :text
    add_column :pizza_categories, :seo_metadescription, :text
    add_column :pizza_categories, :seo_keywords, :text
  end
end
