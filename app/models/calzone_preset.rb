class CalzonePreset < ActiveRecord::Base
  
  after_update :expire_fragments
  after_create :expire_fragments

  before_save :create_or_update_slug
  
  attr_accessible :active, :calzone_image_angled, :calzone_image_flat, :product_info, :product_name, :nut_free
  serialize :product_info, JSON
  
  # upload images into the preset
  mount_uploader :calzone_image_flat, ProductImageUploader
  mount_uploader :calzone_image_angled, ProductImageUploader

  def light_topping_price
    self.normal_topping_price
  end

  def to_param
    self.slug
  end
  
  private
  
    def expire_fragments
      ActionController::Base.new.expire_fragment('calzone_preset_selection')
    end

    def create_or_update_slug
      if self.slug.nil?
        self.slug = "baked-calzone" # hard coded for now
      end
    end
  
end
