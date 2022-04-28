class AddColIsDeletedInAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :is_deleted, :boolean, default: false
  end
end
