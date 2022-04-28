class AddingSeoFieldsToLocations < ActiveRecord::Migration
  def up
  	add_column :franchise_locations, :seo_title, :text
  	add_column :franchise_locations, :seo_metadescription, :text
  end

  def down
  	remove_column :franchise_locations, :seo_title
  	remove_column :franchise_locations, :seo_metadescription
  end
end
