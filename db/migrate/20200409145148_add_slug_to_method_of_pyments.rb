class AddSlugToMethodOfPyments < ActiveRecord::Migration
  def change
    add_column :method_of_payments, :slug, :string
    add_index :method_of_payments, :slug, :unique => true
  end
end
