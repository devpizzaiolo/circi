class AddProductImageToBeverages < ActiveRecord::Migration
  def change
    add_column :beverages, :product_image, :string
  end
end
