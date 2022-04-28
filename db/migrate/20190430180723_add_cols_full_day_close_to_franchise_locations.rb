class AddColsFullDayCloseToFranchiseLocations < ActiveRecord::Migration
  
    def up
      add_column :franchise_locations, :mon_full_day_close, :boolean, default: false
      add_column :franchise_locations, :tue_full_day_close, :boolean, default: false
      add_column :franchise_locations, :wed_full_day_close, :boolean, default: false
      add_column :franchise_locations, :thu_full_day_close, :boolean, default: false
      add_column :franchise_locations, :fri_full_day_close, :boolean, default: false
      add_column :franchise_locations, :sat_full_day_close, :boolean, default: false
      add_column :franchise_locations, :sun_full_day_close, :boolean, default: false
    end
  
    def down
      remove_column :franchise_locations, :mon_full_day_close
      remove_column :franchise_locations, :tue_full_day_close
      remove_column :franchise_locations, :wed_full_day_close
      remove_column :franchise_locations, :thu_full_day_close
      remove_column :franchise_locations, :fri_full_day_close
      remove_column :franchise_locations, :sat_full_day_close
      remove_column :franchise_locations, :sun_full_day_close
    end
  
end
