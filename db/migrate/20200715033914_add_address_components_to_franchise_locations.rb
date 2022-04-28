class AddAddressComponentsToFranchiseLocations < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :postal_code, :string
    add_column :franchise_locations, :province, :string
    add_column :franchise_locations, :city, :string
  end
end
