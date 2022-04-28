class AddKmlFileToLocation < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :kmlfilename, :string
  end
end
