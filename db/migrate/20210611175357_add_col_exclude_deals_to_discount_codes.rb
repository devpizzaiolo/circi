class AddColExcludeDealsToDiscountCodes < ActiveRecord::Migration
  def change
    add_column :discount_codes, :exclude_deals, :boolean, default: false
  end
end
