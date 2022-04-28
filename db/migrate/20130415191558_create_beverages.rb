class CreateBeverages < ActiveRecord::Migration
  def change
    create_table :beverages do |t|
      
      t.string :name
      
      t.boolean :active, :default => true
      
      t.references :type_of_beverage

      t.timestamps
      
    end
    add_index :beverages, :type_of_beverage_id
  end
end
