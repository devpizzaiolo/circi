class CustomerService < ActiveRecord::Base
  
  apply_simple_captcha
  
  belongs_to :location
  
  attr_accessible :comment, :email, :first_name, :last_name, :pickup, :telephone, :franchise_location_id, :address_1, :address_2, :city, :captcha, :captcha_key
  
  belongs_to :franchise_location

  
  
  #validations
  
  validates :comment, presence: true
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  # validates :pickup, presence: true
  #validates :telephone, presence: true
  validates :franchise_location_id, presence: true
  

end
