class AddColQuantityToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :quantity, :string, default: '1'
  end
end
