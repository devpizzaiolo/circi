class AddSortOrderForCombosToBeverages < ActiveRecord::Migration
  def change
    add_column :beverages, :sort_order_for_combos, :integer
    add_column :dipping_sauces, :sort_order_for_combos, :integer
  end
end
