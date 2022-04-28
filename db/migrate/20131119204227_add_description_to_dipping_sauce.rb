class AddDescriptionToDippingSauce < ActiveRecord::Migration
  def change
    add_column :dipping_sauces, :description, :string
  end
end
