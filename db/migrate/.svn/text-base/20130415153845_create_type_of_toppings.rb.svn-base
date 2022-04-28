class CreateTypeOfToppings < ActiveRecord::Migration
  def change
    create_table :type_of_toppings do |t|
      
      t.string :name
      t.boolean :active, :default => true
      
      # placement preferences available per topping type
      t.boolean :preference_light, :default => true
      t.boolean :preference_extra, :default => true
      t.boolean :preference_double, :default => false

      t.timestamps
    end
  end
end
