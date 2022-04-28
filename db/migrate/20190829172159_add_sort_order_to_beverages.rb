class AddSortOrderToBeverages < ActiveRecord::Migration
  def change
    add_column :beverages, :pop_and_juice, :boolean
    add_column :beverages, :water, :boolean
    add_column :beverages, :premium_drinks, :boolean
    add_column :beverages, :sort_order, :integer
  end
end
