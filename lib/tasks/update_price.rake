namespace :update do

  desc 'Update pizza sizes price'
  task pizza_sizes_price: :environment do
    puts "##### Starting updating price #####"
    PizzaSize.all.each do |pizza_size|
      case pizza_size.name
      when 'Medium'
        pizza_size.price = 11.49
        pizza_size.topping_price = 2.25
        pizza_size.normal_topping_price = 2.25
        pizza_size.extra_topping_price = 2.25 * 1.5
        pizza_size.double_topping_price = 2.25 * 1.9
        pizza_size.save
      when 'Large'
        pizza_size.price = 13.49
        pizza_size.topping_price = 2.69
        pizza_size.normal_topping_price = 2.69
        pizza_size.extra_topping_price = 2.69 * 1.5
        pizza_size.double_topping_price = 2.69 * 1.9
        pizza_size.save
      when 'XLarge'
        pizza_size.price = 16.49
        pizza_size.topping_price = 3.25
        pizza_size.normal_topping_price = 3.25
        pizza_size.extra_topping_price = 3.25 * 1.5
        pizza_size.double_topping_price = 3.25 * 1.9
        pizza_size.save
      when 'Party'
        pizza_size.price = 18.99
        pizza_size.topping_price = 3.59
        pizza_size.normal_topping_price = 3.59
        pizza_size.extra_topping_price = 3.59 * 1.5
        pizza_size.double_topping_price = 3.59 * 1.9
        pizza_size.save
      when '10 Inches' # Small
        pizza_size.price = 9.49
        pizza_size.topping_price = 1.79
        pizza_size.normal_topping_price = 1.79
        pizza_size.extra_topping_price = 1.79 * 1.5
        pizza_size.double_topping_price = 1.79 * 1.9
        pizza_size.save
      when 'Gluten Free Small'
        pizza_size.price = 12.25
        pizza_size.topping_price = 1.79
        pizza_size.normal_topping_price = 1.79
        pizza_size.extra_topping_price = 1.79 * 1.5
        pizza_size.double_topping_price = 1.79 * 1.9
        pizza_size.save
      when 'Gluten Free' # Medium
        pizza_size.topping_price = 2.25
        pizza_size.normal_topping_price = 2.25
        pizza_size.extra_topping_price = 2.25 * 1.5
        pizza_size.double_topping_price = 2.25 * 1.9
        pizza_size.save
      when 'Cauliflower S'
        pizza_size.price = 12.25
        pizza_size.topping_price = 1.79
        pizza_size.normal_topping_price = 1.79
        pizza_size.extra_topping_price = 1.79 * 1.5
        pizza_size.double_topping_price = 1.79 * 1.9
        pizza_size.save
      when 'Cauliflower M' # Medium
        pizza_size.topping_price = 2.25
        pizza_size.normal_topping_price = 2.25
        pizza_size.extra_topping_price = 2.25 * 1.5
        pizza_size.double_topping_price = 2.25 * 1.9
        pizza_size.save
      end
      
    end
    puts "##### Finished updating price #####"
  end

  desc 'Update dipping sauces price'
  task dipping_sauces_price: :environment do
    puts "##### Starting updating dipping sauces price #####"
    DippingSauce.update_all(price: 0.99)
    puts "##### Finished updating dipping sauces price #####"
  end

  desc 'Update drinks price'
  task drinks_price: :environment do
    puts "##### Starting updating drinks price #####"
    Beverage.where(pop_and_juice: true, price: 2.49).update_all(price: 2.59)
    puts "##### Finished updating drinks price #####"
  end

  desc 'Update premium drinks price'
  task premium_drinks_price: :environment do
    puts "##### Starting updating premium drinks price #####"
    Beverage.where(premium_drinks: true, price: 2.49).update_all(price: 2.69)
    puts "##### Finished updating premium drinks price #####"
  end

  desc 'Update water price'
  task water_price: :environment do
    puts "##### Starting updating water price #####"
    Beverage.where(water: true, price: 2.49).update_all(price: 2.69)
    puts "##### Finished updating water price #####"
  end
  
end