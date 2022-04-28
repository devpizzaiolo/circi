class UpdateNewToppingsPriceIntoPizzaSize < ActiveRecord::Migration
  def up
    @pizza_sizes = PizzaSize.find(:all)
    @pizza_sizes.each do |pizza_size|
      case pizza_size.name
        when "Medium"
          pizza_size.normal_topping_price = 1.99
          pizza_size.extra_topping_price = 1.99 * 1.5
          pizza_size.double_topping_price = 1.99 * 1.9
        when "Large"
          pizza_size.normal_topping_price = 2.39
          pizza_size.extra_topping_price = 2.39 * 1.5
          pizza_size.double_topping_price = 2.39 * 1.9
        when "XLarge"
          pizza_size.normal_topping_price = 2.99
          pizza_size.extra_topping_price = 2.99 * 1.5
          pizza_size.double_topping_price = 2.99 * 1.9
        when "Party"
          pizza_size.normal_topping_price = 3.49
          pizza_size.extra_topping_price = 3.49 * 1.5
          pizza_size.double_topping_price = 3.49 * 1.9
        when "Gluten Free"
          pizza_size.normal_topping_price = 1.99
          pizza_size.extra_topping_price = 1.99 * 1.5
          pizza_size.double_topping_price = 1.99 * 1.9
        when "Gluten Free Small"
          pizza_size.normal_topping_price = 1.49
          pizza_size.extra_topping_price = 1.49 * 1.5
          pizza_size.double_topping_price = 1.49 * 1.9
        end
      pizza_size.save
    end
  end
end
