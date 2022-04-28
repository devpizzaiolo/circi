class AddColsDiscountCodeToPaymentsTransactions < ActiveRecord::Migration
  def change
    add_column :payment_transactions, :discount_code, :string
    add_column :payment_transactions, :discount_code_id, :integer
    add_column :payment_transactions, :discount_dollar_value, :decimal, precision: 15, scale: 2, default: 0.0, :null => false
  end
end
