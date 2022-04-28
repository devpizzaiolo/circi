class CreateDiscountCodes < ActiveRecord::Migration
  def change
    create_table :discount_codes do |t|
      t.string  :promotion_name
      t.string  :code
      t.string  :value
      t.string  :discount_type # percent|dollar

      t.integer :used_order_id
      
      t.boolean :active, :default => true
      t.boolean :one_time_use, :default => false

      t.datetime  :expired_at
      t.datetime  :one_time_used_at

      t.timestamps
    end
  end
end
