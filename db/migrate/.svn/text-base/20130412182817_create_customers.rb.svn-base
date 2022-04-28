class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :postal_code
      t.string :phone_number
      t.boolean :active, :default => true
      t.boolean :mailing_list, :default => false

      t.timestamps
    end
  end
end
