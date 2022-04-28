class AddMethodOfPaymentIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :method_of_payment_id, :integer
    add_index :orders, :method_of_payment_id
  end
end
