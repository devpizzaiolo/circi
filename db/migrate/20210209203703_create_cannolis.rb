class CreateCannolis < ActiveRecord::Migration
  def change
    create_table :cannolis do |t|
      t.string  :name
      t.boolean :active, default: true
      t.decimal :price, :precision => 10, :scale => 2, :default => 0.0
      t.string  :description
      t.string  :product_image

      t.timestamps
    end
  end
end
