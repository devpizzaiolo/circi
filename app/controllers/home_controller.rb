class HomeController < ApplicationController
  
  def index
    @pizzas = PizzaPreset.order("RAND()").first(12)
    @pizza_category =  PizzaCategory.where(:active => true)

    # for home page categories slider
    @fans_favourite = PizzaPreset.tagged_with(["fans_favourite", "pizza_makers_picks"], :any => true)
    @speciality_pizza = PizzaPreset.tagged_with(["speciality_pizza"], :any => true)
    # Gluten Free & Cauliflower
    @gluten_free = PizzaPreset.tagged_with(["gluten_free", "cauliflower"], :any => true)
  end
  
end
