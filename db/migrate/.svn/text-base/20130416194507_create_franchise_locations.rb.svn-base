class CreateFranchiseLocations < ActiveRecord::Migration
  def change
    create_table :franchise_locations do |t|

      t.string :address
      t.string :address_details
      t.string :phone
      t.string :area_name
      
      # opening and closing times
      t.time :mon_open
      t.time :mon_closed
      t.time :tue_open
      t.time :tue_closed
      t.time :wed_open
      t.time :wed_closed
      t.time :thu_open
      t.time :thu_closed
      t.time :fri_open
      t.time :fri_closed
      t.time :sat_open
      t.time :sat_closed
      t.time :sun_open
      t.time :sun_closed
      
      # geo data
      t.float :latitude
      t.float :longitude
      
      # is the franchise active?
      t.boolean :active, :default => true

      t.timestamps
      
    end
  end
end
