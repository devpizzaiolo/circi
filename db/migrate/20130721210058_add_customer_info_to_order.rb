class AddCustomerInfoToOrder < ActiveRecord::Migration
  def change
    
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :email, :string
    add_column :orders, :address_1, :string
    add_column :orders, :address_2, :string
    add_column :orders, :postal_code, :string
    add_column :orders, :phone_number, :string
    
    add_column :orders, :for_pickup, :boolean, :default => false
    
  end
  
  
  
end
