class AddColToBeverage < ActiveRecord::Migration
  def change
    add_column :beverages, :extra_info, :string
  end
end
