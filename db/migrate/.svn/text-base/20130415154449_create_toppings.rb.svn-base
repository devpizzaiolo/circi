class CreateToppings < ActiveRecord::Migration
  def change
    create_table :toppings do |t|
      t.references :type_of_topping
      
      t.string :name
      t.boolean :active, :default => true
      t.boolean :free_topping, :default => false
      t.boolean :non_gluten_free, :default => false
      
      t.timestamps
    end
    add_index :toppings, :type_of_topping_id
  end
end
