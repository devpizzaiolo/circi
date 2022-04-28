class AddColsToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :first_name, :string
    add_column :payment_transactions, :last_name, :string
    add_column :payment_transactions, :email, :string
    add_column :payment_transactions, :phone_number, :string
    add_column :payment_transactions, :address_1, :string
    add_column :payment_transactions, :address_2, :string
    add_column :payment_transactions, :city, :string
    add_column :payment_transactions, :province, :string
    add_column :payment_transactions, :country, :string
  end
end
