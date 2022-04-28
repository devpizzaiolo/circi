class AddImageRefToPizzaCategory < ActiveRecord::Migration
  def change
    add_column :pizza_categories, :image_ref, :string
  end
end
