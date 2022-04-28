namespace :pizza_category do

  desc "Create new pizza category - Plant Based "
  task :create_plant_based => :environment do
    puts "###### Creating new Pizza Category - Plant Based ######"
    PizzaCategory.create(
      name: "Plant Based",
      page_title: "Plant Based Pizzas",
      seo_title: "Pizzaiolo | Toronto and Plant Based Pizzas",
      seo_keywords: "Pizzaiolo, Plant Based, Peppi, Sausage, Pizza, Online Ordering",
      seo_metadescription: "Plant Based your Pizza!. Order any of our plant based pizzas today!"
    )
    puts "###### Created new Pizza Category - Plant Based ######"
  end

  task :update_plant_based => :environment do
    puts "###### Update new Pizza Category - Plant Based ######"
    pizza_category = PizzaCategory.find_by_slug('plant-based')
    if pizza_category.present?
      pizza_category.update_attributes(page_title: "The Garden of Eatin<span class='title-apostrophp'>'</span>")
      puts "###### Update new Pizza Category - Plant Based ######"
    end
  end

  task :update_gluten_free => :environment do
    puts "###### Update new Pizza Category - Gluten Free ######"
    pizza_category = PizzaCategory.find_by_slug('gluten-free')
    if pizza_category.present?
      pizza_category.update_attributes(page_title: "GLUTEN FREE & CAULIFLOWER")
      puts "###### Update new Pizza Category - Gluten Free ######"
    end
  end

end