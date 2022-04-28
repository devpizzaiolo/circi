class AddSlugToPizzaCategory < ActiveRecord::Migration
  def change
    add_column :pizza_categories, :slug, :string
    add_column :pizza_categories, :page_title, :string
    PizzaCategory.all.each do |pizza_category|
      case pizza_category.name 
      when "Gourmet Meat Pizzas"
        pizza_category.page_title = "Pizzaiolo loves meat!"
      when "Gourmet Vegetarian Pizzas"
        pizza_category.page_title = "Great tasting veggies pizzas."
      when "Gourmet Vegan Pizzas"
        pizza_category.page_title = "Vegans, meet great tasting pizza."
      when "Create Your Own Pizza"
        pizza_category.page_title = "Are you ready to pizza?"
      end
      pizza_category.save
    end
  end
end
