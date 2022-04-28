class PizzaSize < ActiveRecord::Base
  attr_accessible :active, :price, :name, :topping_price, :deep_dish_option_price, :has_deep_dish_option, :image_ref, :external_name, :position

  def light_topping_price
    self.normal_topping_price
  end
end
