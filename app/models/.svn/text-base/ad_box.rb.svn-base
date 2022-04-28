class AdBox < ActiveRecord::Base
  
  after_update :expire_fragments
  after_create :expire_fragments
  
  attr_accessible :pod, :name, :url_link, :active, :position
  
  mount_uploader :pod, AdBoxUploader
  
  private
    
    def expire_fragments
      ActionController::Base.new.expire_fragment('ad_pods_homepage')
    end
  
end
