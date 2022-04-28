class AddEmailToFranchiseLocation < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :email, :string
  end
end
