class RenameColDiscountCodeToOrders < ActiveRecord::Migration
  def up
    rename_column :orders, :discount_code, :discount_promo_code
  end

  def down
    rename_column :orders, :discount_promo_code, :discount_code
  end
end
