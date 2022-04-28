class AddColSlugToProductCombos < ActiveRecord::Migration
  def change
    add_column :product_combos, :slug, :string
  end
end
