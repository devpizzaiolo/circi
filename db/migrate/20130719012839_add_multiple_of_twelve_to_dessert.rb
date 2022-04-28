class AddMultipleOfTwelveToDessert < ActiveRecord::Migration
  def change
    add_column :desserts, :multiple_of_12, :boolean, :default => false
  end
end
