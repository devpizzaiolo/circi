class GarlicBread < ActiveRecord::Base
  attr_accessible :name, :price, :description, :price_one_to_five, :price_six_to_nineteen, :price_twenty_plus, :product_image, :active, :extra_info

  mount_uploader :product_image, ProductImageUploader

end
