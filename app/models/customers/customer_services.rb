class Customers::CustomerServices < ActiveRecord::Base
  belongs_to :location
  attr_accessible :comment, :email, :first_name, :last_name, :pickup, :telephone, :address_1, :address_2, :city
end
