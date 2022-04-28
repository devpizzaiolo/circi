class Beverage < ActiveRecord::Base
  
  after_update :expire_fragments
  after_create :expire_fragments
  
  attr_accessible :name, :pop_and_juice, :water, :premium_drinks, :sort_order, :sort_order_for_combos, :price, :product_image, :active, :extra_info
  
  mount_uploader :product_image, ProductImageUploader
  
  private
  
    def expire_fragments
      ActionController::Base.new.expire_fragment('beverages')
    end
  
end
