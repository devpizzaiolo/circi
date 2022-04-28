class CreateCustomerServices < ActiveRecord::Migration
  
  def change
    create_table :customer_services do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :telephone
      t.text :comment
      t.boolean :pickup
      t.references :franchise_location

      t.timestamps
    end
    add_index :customer_services, :franchise_location_id
  end
  
end
