class AddToBeReadyAtToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :to_be_ready_at, :datetime
  end
end
