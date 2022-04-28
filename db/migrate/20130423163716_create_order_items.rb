class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.string :product_type
      t.string :product_name
      t.text :product_info
      t.references :order

      t.timestamps
    end
    add_index :order_items, :order_id
  end
end
