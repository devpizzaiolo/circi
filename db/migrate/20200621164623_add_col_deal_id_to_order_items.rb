class AddColDealIdToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :deal_id, :string
  end
end
