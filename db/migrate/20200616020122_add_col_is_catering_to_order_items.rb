class AddColIsCateringToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :is_catering, :boolean, default: false
  end
end
