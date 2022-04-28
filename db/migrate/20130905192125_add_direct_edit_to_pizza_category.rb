class AddDirectEditToPizzaCategory < ActiveRecord::Migration
  def change
    add_column :pizza_categories, :direct_edit, :boolean, :default => false
  end
end
