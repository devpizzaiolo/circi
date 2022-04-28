class AddSentToPrinterToOrder < ActiveRecord::Migration
  
  def change
    add_column :orders, :sent_to_printer, :boolean, :default => false
    add_column :orders, :email_sent, :boolean, :default => false
  end
  
end
