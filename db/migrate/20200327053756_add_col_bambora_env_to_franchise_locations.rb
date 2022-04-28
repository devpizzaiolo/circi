class AddColBamboraEnvToFranchiseLocations < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :bambora_env, :string, default: 'production'
  end
end
