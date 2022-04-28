class AddColIsCateringToPizzaSize < ActiveRecord::Migration
  def change
    add_column :pizza_sizes, :is_catering, :boolean, default: false
  end
end
