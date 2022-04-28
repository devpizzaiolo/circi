class Dessert < ActiveRecord::Base
  attr_accessible :active, :name, :price, :multiple_of_12, :description
end
