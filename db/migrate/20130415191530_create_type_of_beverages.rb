class CreateTypeOfBeverages < ActiveRecord::Migration
  def change
    create_table :type_of_beverages do |t|
      t.string :name
      
      t.boolean :active, :default => true
      
      t.decimal :price, :precision => 10, :scale => 2, :default => 0.0
      

      t.timestamps
    end
  end
end
