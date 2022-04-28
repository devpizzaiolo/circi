class Flyer < ActiveRecord::Base
  attr_accessible :active, :filename, :name
  
  mount_uploader :filename, FlyerUploader
  

  
end
