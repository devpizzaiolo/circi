class TypeOfTopping < ActiveRecord::Base
  attr_accessible :active, :name, :preference_light, :preference_extra,	:preference_double, :preference_normal, :position
  has_many :toppings
end
