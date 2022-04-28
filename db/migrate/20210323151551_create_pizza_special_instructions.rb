class CreatePizzaSpecialInstructions < ActiveRecord::Migration
  def change
    create_table :pizza_special_instructions do |t|
      t.string :name
      t.string :slug
      t.boolean :active, :default => true
      t.integer :position, :default => 0
      
      t.timestamps
    end
  end
end
