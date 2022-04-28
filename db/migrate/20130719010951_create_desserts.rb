class CreateDesserts < ActiveRecord::Migration
  def change
    create_table :desserts do |t|
      t.string :name
      t.boolean :active, :default => true
      
      
      t.decimal :price, :precision => 10, :scale => 2, :default => 0.0
      # t.decimal :price_six_to_nineteen, :precision => 10, :scale => 2, :default => 0.0
      # t.decimal :price_twenty_plus, :precision => 10, :scale => 2, :default => 0.0
      

      t.timestamps
    end
  end
end
