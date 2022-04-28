class AddSentToPosAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :sent_to_pos_at, :datetime
    add_column :orders, :acknowledged_by_pos_at, :datetime
  end
end
