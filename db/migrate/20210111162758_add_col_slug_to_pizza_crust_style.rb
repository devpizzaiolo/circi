class AddColSlugToPizzaCrustStyle < ActiveRecord::Migration
  def change
    add_column :pizza_crust_styles, :slug, :string
  end
end
