class UpdatePizzaCategoriesPageTitle < ActiveRecord::Migration
  def up
    PizzaCategory.all.each do |pizza_category|
      case pizza_category.name 
      when "Gourmet Vegetarian Pizzas"
        pizza_category.page_title = "Great tasting veggie pizzas."
      end
      pizza_category.save
    end
  end

  def down
    PizzaCategory.all.each do |pizza_category|
      case pizza_category.name 
      when "Gourmet Vegetarian Pizzas"
        pizza_category.page_title = "Great tasting veggies pizzas."
      end
      pizza_category.save
    end
  end
end