class AddColPostalCodeToPaymentTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :postal_code, :string
  end
end
