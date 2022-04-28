class AddCustomerContactInfoToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_first_name, :string
    add_column :orders, :delivery_last_name, :string
    add_column :orders, :delivery_email, :string
    add_column :orders, :delivery_address_1, :string
    add_column :orders, :delivery_address_2, :string
    add_column :orders, :delivery_postal_code, :string
    add_column :orders, :delivery_phone_number, :string
    add_column :orders, :contact_phone_number, :string
  end
end
