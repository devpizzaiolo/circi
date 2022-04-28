class AddNewColSaladTypeToSalads < ActiveRecord::Migration
  def change
    add_column :salads, :salad_type, :string
  end
end
