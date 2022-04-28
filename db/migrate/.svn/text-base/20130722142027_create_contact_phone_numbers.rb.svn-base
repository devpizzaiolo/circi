class CreateContactPhoneNumbers < ActiveRecord::Migration
  def change
    create_table :contact_phone_numbers do |t|
      t.string :phone_number
      t.references :customer

      t.timestamps
    end
    add_index :contact_phone_numbers, :customer_id
  end
end
