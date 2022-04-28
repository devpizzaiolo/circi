require 'csv'

namespace :product_combo do
  
  desc "Delivery special - "
  task :delivery_special_large => :environment do
    ProductCombo.create!(
      title: "Delivery Special", 
      banner: "", 
      no_of_pizza: 1, 
      pizza_size_id: PizzaSize.find_by_name("Large").id, 
      no_of_toppings_on_each_pizza: 2,
      combo_base_price: 14.99, 
      paid_extra_topping_price: 2.39,
      description: "LARGE GOURMET - 2 TOPPING PIZZA + 2 FREE COKE or 2 FREE DIPS", 
      no_of_free_additional_items: 2, 
      categories_of_additional_items: "beverages,dipping_sauces", 
      beverages_additional_items: Beverage.where(name: ["Coke (cans)", "Diet Coke (cans)", "Sprite (cans)", "Coca-Cola (355mL)", "Diet Coke (355mL)", "Canada Dry Ginger Ale (355mL)"]).where(active: true).pluck(:id).join(","), 
      dipping_sauces_aditional_items: DippingSauce.pluck(:id).join(","), 
      salads_aditional_items: [], 
      garlic_breads_aditional_items: [], 
      is_active: true
    )
  end
  
  desc "Pickup special - "
  task :pickup_special_medium => :environment do
    ProductCombo.create!(
      title: "Pickup Special", 
      banner: "", 
      no_of_pizza: 1, 
      pizza_size_id: PizzaSize.find_by_name("Medium").id, 
      no_of_toppings_on_each_pizza: 2,
      combo_base_price: 11.99, 
      paid_extra_topping_price: 2.39,
      description: "MEDIUM GOURMET - 2 TOPPING PIZZA", 
      no_of_free_additional_items: 0, 
      categories_of_additional_items: nil, 
      beverages_additional_items: nil, 
      dipping_sauces_aditional_items: nil, 
      salads_aditional_items: nil, 
      garlic_breads_aditional_items: nil, 
      is_active: true
    )
  end

  desc "Pepperoni special - "
  task :pepperoni_special_medium => :environment do
    ProductCombo.create!(
      title: "2 DOUBLE PEPPERONI PIZZAS FOR ONLY $19.98",
      banner: "", 
      no_of_pizza: 2, 
      pizza_size_id: PizzaSize.find_by_name("Medium").id, 
      no_of_toppings_on_each_pizza: 2,
      combo_base_price: 19.98, 
      first_pizza_base_price: 9.99,
      second_pizza_base_price: 9.99,
      first_pizza_freeze_toopings: "48", #comma seperated string
      second_pizza_freeze_toopings: "20", #comma seperated string
      paid_extra_topping_price: 1.99,
      description: "PEPPERONI SPECIAL - MEDIUM", 
      no_of_free_additional_items: 0,
      categories_of_additional_items: nil, 
      beverages_additional_items: nil, 
      dipping_sauces_aditional_items: nil, 
      salads_aditional_items: nil, 
      garlic_breads_aditional_items: nil, 
      is_active: true,
      slug: "pepperoni-special"
    )
  end
end