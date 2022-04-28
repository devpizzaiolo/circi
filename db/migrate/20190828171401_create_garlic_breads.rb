class CreateGarlicBreads < ActiveRecord::Migration
  def change
    create_table :garlic_breads do |t|

      t.string :name
      t.boolean :active, :default => true
      t.decimal :price, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :price_one_to_five, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :price_six_to_nineteen, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :price_twenty_plus, :precision => 10, :scale => 2, :default => 0.0
      t.string  :description
      t.string  :product_image

      t.timestamps
    end
  end
end
