class AddGoogleMapsUrlToFranchiseLocation < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :google_maps_url, :string
  end
end
