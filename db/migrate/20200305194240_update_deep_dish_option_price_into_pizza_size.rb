class UpdateDeepDishOptionPriceIntoPizzaSize < ActiveRecord::Migration
  def up
    @pizza_sizes = PizzaSize.find(:all)
    @pizza_sizes.each do |pizza_size|
      case pizza_size.name
       when "Medium"
        pizza_size.deep_dish_option_price = 1.99
      when "Large"
        pizza_size.deep_dish_option_price = 2.49
      when "XLarge"
        pizza_size.deep_dish_option_price = 2.99
      when "Party"
        pizza_size.deep_dish_option_price = 3.49
      end
      pizza_size.save
    end
  end

  def down
    @pizza_sizes = PizzaSize.find(:all)
    @pizza_sizes.each do |pizza_size|
      case pizza_size.name
       when "Medium"
        pizza_size.deep_dish_option_price = 2.49
      when "Large"
        pizza_size.deep_dish_option_price = 2.49
      when "XLarge"
        pizza_size.deep_dish_option_price = 3.49
      when "Party"
        pizza_size.deep_dish_option_price = 3.49
      end  
      pizza_size.save
    end
  end
end
