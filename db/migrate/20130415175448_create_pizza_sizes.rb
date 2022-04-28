class CreatePizzaSizes < ActiveRecord::Migration
  def change
    create_table :pizza_sizes do |t|
      
      t.string :name
      t.boolean :active, :default => true
      
      # price per topping (unless free) at the given size
      t.decimal :topping_price, :precision => 10, :scale => 2, :default => 0.0
      
      # price for the deep dish option
      t.decimal :deep_dish_option_price, :precision => 10, :scale => 2, :default => 0.0
      
      # specify whether the size can be deep dish
      t.boolean :has_deep_dish_option, :default => true

      t.timestamps
    end
  end
end
