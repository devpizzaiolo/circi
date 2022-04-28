class CreateNewFranchiseLocations < ActiveRecord::Migration
  def up
    # @franchise_location = FranchiseLocation.find_by_slug("346-bloor-street")
    # @new_franchise_location =  @franchise_location.dup
    # @new_franchise_location.address = "416 Bloor Street"
    # @new_franchise_location.save
  end

  def down
    # @franchise_location = FranchiseLocation.find_by_slug("416-bloor-street")
    # @franchise_location.destroy
  end
end
