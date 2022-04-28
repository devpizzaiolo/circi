class Salad < ActiveRecord::Base
  
  after_update :expire_fragments
  after_create :expire_fragments
  
  attr_accessible :name, :price_one_to_five, :price_six_to_nineteen, :price_twenty_plus, :price, :product_image, :active, :description, :is_catering_product, :salad_type
  
  SALAD_TYPE = {
    "SINGLE" => "Single Serving", 
    "MEDIUM" => "Medium Tray", 
    "LARGE"  => "Large Tray"
  }

  mount_uploader :product_image, ProductImageUploader
  
 
  
  private
  
    def expire_fragments
      ActionController::Base.new.expire_fragment('salads')
      ActionController::Base.new.expire_fragment('salads_menu')
      ActionController::Base.new.expire_fragment('catering_salads')
      ActionController::Base.new.expire_fragment('salads_modal')
    end
  
end
