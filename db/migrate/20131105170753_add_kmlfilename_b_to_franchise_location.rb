class AddKmlfilenameBToFranchiseLocation < ActiveRecord::Migration
  def change
    
    add_column :franchise_locations, :kmlfilename_b, :string
    
  end
end
