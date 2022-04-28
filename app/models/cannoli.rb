class Cannoli < ActiveRecord::Base
  attr_accessible :name, :price, :description, :product_image, :active

  mount_uploader :product_image, ProductImageUploader
end
