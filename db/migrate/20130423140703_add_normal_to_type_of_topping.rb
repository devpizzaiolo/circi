class AddNormalToTypeOfTopping < ActiveRecord::Migration
  def change
    add_column :type_of_toppings, :preference_normal, :boolean, :default => true
  end
end
