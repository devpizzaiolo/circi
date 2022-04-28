class CreateMethodOfPayments < ActiveRecord::Migration
  def change
    create_table :method_of_payments do |t|
      
      t.string :name
      t.boolean :active, :default => true
      t.integer :position

      t.timestamps
      
    end
  end
end
