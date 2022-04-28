class AddProductImageToSalad < ActiveRecord::Migration
  def change
    add_column :salads, :product_image, :string
  end
end
