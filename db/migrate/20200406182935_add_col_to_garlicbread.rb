class AddColToGarlicbread < ActiveRecord::Migration
  def change
    add_column :garlic_breads, :extra_info, :string
  end
end
