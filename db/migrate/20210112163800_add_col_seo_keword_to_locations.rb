class AddColSeoKewordToLocations < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :seo_keywords, :text
  end
end
