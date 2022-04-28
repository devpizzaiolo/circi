class AddAddressCityFieldToCustomerServices < ActiveRecord::Migration
  def change
    add_column :customer_services, :address_1, :string
    add_column :customer_services, :address_2, :string
    add_column :customer_services, :city, :string
  end
end
