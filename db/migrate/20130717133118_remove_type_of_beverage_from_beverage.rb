class RemoveTypeOfBeverageFromBeverage < ActiveRecord::Migration
  
  def up
    remove_index :beverages, :type_of_beverage_id
    remove_column :beverages, :type_of_beverage_id
  end

  def down
    add_column :beverages, :type_of_beverage_id, :integer
    add_index :beverages, :type_of_beverage_id
  end
  
end
