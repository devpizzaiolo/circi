class CreatePizzaCrustStyles < ActiveRecord::Migration
  def change
    create_table :pizza_crust_styles do |t|
      
      t.string :name
      t.boolean :active, :default => true
      t.integer :position, :default => 0
      t.boolean :deep_dish_pricing, :default => false

      t.timestamps
      
    end
  end
end
