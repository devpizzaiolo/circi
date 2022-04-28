class AddExternalNameToPizzaSize < ActiveRecord::Migration
  def change
    add_column :pizza_sizes, :external_name, :string
  end
end
