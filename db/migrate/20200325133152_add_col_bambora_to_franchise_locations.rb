class AddColBamboraToFranchiseLocations < ActiveRecord::Migration
  def change
    add_column :franchise_locations, :encrypted_bambora_dev_merchant_id, :string unless column_exists? :franchise_locations, :encrypted_bambora_dev_merchant_id
    add_column :franchise_locations, :encrypted_bambora_dev_merchant_id_iv, :string unless column_exists? :franchise_locations, :encrypted_bambora_dev_merchant_id_iv
    add_column :franchise_locations, :encrypted_bambora_dev_api_key, :string unless column_exists? :franchise_locations, :encrypted_bambora_dev_api_key
    add_column :franchise_locations, :encrypted_bambora_dev_api_key_iv, :string unless column_exists? :franchise_locations, :encrypted_bambora_dev_api_key_iv
    add_column :franchise_locations, :encrypted_bambora_pro_merchant_id, :string unless column_exists? :franchise_locations, :encrypted_bambora_pro_merchant_id
    add_column :franchise_locations, :encrypted_bambora_pro_merchant_id_iv, :string unless column_exists? :franchise_locations, :encrypted_bambora_pro_merchant_id_iv
    add_column :franchise_locations, :encrypted_bambora_pro_api_key, :string unless column_exists? :franchise_locations, :encrypted_bambora_pro_api_key
    add_column :franchise_locations, :encrypted_bambora_pro_api_key_iv, :string unless column_exists? :franchise_locations, :encrypted_bambora_pro_api_key_iv
    add_column :franchise_locations, :enable_online_payments, :boolean, default: false unless column_exists? :franchise_locations, :enable_online_payments
  end
end
