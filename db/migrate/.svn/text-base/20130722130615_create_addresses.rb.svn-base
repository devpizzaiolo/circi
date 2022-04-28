class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :postal_code
      t.string :phone_number
      t.references :customer

      t.timestamps
      
    end
    add_index :addresses, :customer_id
  end
end
