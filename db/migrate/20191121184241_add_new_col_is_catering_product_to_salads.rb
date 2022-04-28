class AddNewColIsCateringProductToSalads < ActiveRecord::Migration
  def change
    add_column :salads, :is_catering_product, :boolean, :default => false
  end
end
