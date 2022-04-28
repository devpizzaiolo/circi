class AddStoreIdAndStoreKeyToFranchiseLocations < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :store_id, :string
    add_column :franchise_locations, :api_key, :string
  end
end
