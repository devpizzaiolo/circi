class AddColPizzaPositionToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :pizza_position, :integer
  end
end
