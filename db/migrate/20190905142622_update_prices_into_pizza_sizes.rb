class UpdatePricesIntoPizzaSizes < ActiveRecord::Migration
  def up
    @pizza_sizes = PizzaSize.find(:all)
    @pizza_sizes.each do |pizza_size|
      case pizza_size.name
       when "Medium"
        pizza_size.price = 10.99
        pizza_size.topping_price = 1.99
        pizza_size.deep_dish_option_price = 2.49
      when "Large"
        pizza_size.price = 12.79
        pizza_size.topping_price = 2.39
        pizza_size.deep_dish_option_price = 2.49
      when "XLarge"
        pizza_size.price = 14.99
        pizza_size.topping_price = 2.99
        pizza_size.deep_dish_option_price = 3.49
      when "Party"
        pizza_size.price = 17.99
        pizza_size.topping_price = 3.49
        pizza_size.deep_dish_option_price = 3.49
      when "Gluten Free"  
        pizza_size.price = 14.99
        pizza_size.topping_price = 1.99
      when "Gluten Free Small"  
        pizza_size.price = 11.99
        pizza_size.topping_price = 1.49
      end
      pizza_size.save
    end
  end
  
  def down
    @pizza_sizes = PizzaSize.find(:all)
    @pizza_sizes.each do |pizza_size|
      case pizza_size.name
       when "Medium"
        pizza_size.price = 10.95
        pizza_size.topping_price = 1.99
        pizza_size.deep_dish_option_price = 2.00
      when "Large"
        pizza_size.price = 12.75
        pizza_size.topping_price = 1.99
        pizza_size.deep_dish_option_price = 2.00
      when "XLarge"
        pizza_size.price = 14.95
        pizza_size.topping_price = 1.99
        pizza_size.deep_dish_option_price = 3.00
      when "Party"
        pizza_size.price = 17.95
        pizza_size.topping_price = 1.99
        pizza_size.deep_dish_option_price = 3.00
      when "Gluten Free"  
        pizza_size.price = 14.95
        pizza_size.topping_price = 2.00
      when "Gluten Free Small" 
        pizza_size.price = 11.95
        pizza_size.topping_price = 1.25
      end
      pizza_size.save
    end
  end
end
