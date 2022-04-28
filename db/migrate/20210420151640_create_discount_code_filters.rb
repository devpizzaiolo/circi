class CreateDiscountCodeFilters < ActiveRecord::Migration
  def change
    create_table :discount_code_filters do |t|
      t.string  :filter_type  #franchise_location|email|toppings
      t.string  :email
      t.string  :toppings
      t.integer :franchise_location_id
      t.integer :discount_code_id

      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
