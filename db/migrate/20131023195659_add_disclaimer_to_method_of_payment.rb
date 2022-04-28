class AddDisclaimerToMethodOfPayment < ActiveRecord::Migration
  def change
    add_column :method_of_payments, :disclaimer, :string
  end
end
