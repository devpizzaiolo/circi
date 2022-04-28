class AddShowEachToDessert < ActiveRecord::Migration
  def change
    add_column :desserts, :show_each, :boolean, :default => true
  end
end
