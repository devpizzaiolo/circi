class ChangeColumnLatLongToFranchiseLocations < ActiveRecord::Migration
  def change
    change_column :franchise_locations, :latitude, :decimal, :precision => 15, :scale => 10
    change_column :franchise_locations, :longitude, :decimal, :precision => 15, :scale => 10
  end
end
