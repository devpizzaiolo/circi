class AddTopOfTheListToPizzaSize < ActiveRecord::Migration
  def change
    add_column :pizza_sizes, :top_of_the_list, :boolean, :default => false
  end
end
