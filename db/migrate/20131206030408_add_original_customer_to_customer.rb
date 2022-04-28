class AddOriginalCustomerToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :original_customer, :boolean, :default => false
  end
end
