class AddPrinterToFranchiseLocation < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :printer_ip, :string, :default => '192.168.0.29'
    add_column :franchise_locations, :printer_port, :string, :default => '9100'
  end
end
