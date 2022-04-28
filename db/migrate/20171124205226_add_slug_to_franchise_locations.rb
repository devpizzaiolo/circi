class AddSlugToFranchiseLocations < ActiveRecord::Migration
  def self.up
  	add_column :franchise_locations, :slug, :string
  	add_index :franchise_locations, :slug, unique: true
  end

  def self.down
  	remove_column :franchise_locations, :slug
  	remove_index :franchise_locations, :slug
  end
end
