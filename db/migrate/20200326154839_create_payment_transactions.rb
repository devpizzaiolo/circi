class CreatePaymentTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|
      t.string   :transaction_id
      t.datetime :transaction_date
      t.string   :status
      t.string   :card_type
      t.string   :last_four_digits
      t.string   :remarks
      t.string   :amount
      t.integer  :order_id
      t.integer  :franchise_location_id

      t.timestamps
    end
  end
end
