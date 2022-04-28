class AddFranchiseLocationIdToOrder < ActiveRecord::Migration
  
  def change
    add_column :orders, :franchise_location_id, :integer
    add_index :orders, :franchise_location_id
  end
  
end
