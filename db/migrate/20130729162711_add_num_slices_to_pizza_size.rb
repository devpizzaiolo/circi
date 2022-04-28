class AddNumSlicesToPizzaSize < ActiveRecord::Migration
  def change
    add_column :pizza_sizes, :num_slices, :string
  end
end
