
namespace :pizza_quick_update do
  
  desc "Update Pizza num_slices in Large  - "
  task :update_num_slices_large => :environment do
    largePizza = PizzaSize.find_by_name("Large")
    largePizza.num_slices = "(10 slices)"
    largePizza.save
  end

  desc "Update gourmet-meat-pizzas  - "
  task :update_meat_pizza_page_title => :environment do
    meatPizzaTitle = PizzaCategory.find_by_name("Gourmet Meat Pizzas")
    meatPizzaTitle.page_title = "MEAT YOUR <br>PIZZA!"
    meatPizzaTitle.save
  end

  desc "Update gourmet vegetarian pizzas  - "
  task :update_vegetarian_pizza_page_title => :environment do
    meatPizzaTitle = PizzaCategory.find_by_name("Gourmet Vegetarian Pizzas")
    meatPizzaTitle.page_title = "VEGGIE LOVERS!"
    meatPizzaTitle.save
  end

  desc "Update gourmet vegan pizzas  - "
  task :update_vegan_pizza_page_title => :environment do
    meatPizzaTitle = PizzaCategory.find_by_name("Gourmet Vegan Pizzas")
    meatPizzaTitle.page_title = "GO VEGAN!"
    meatPizzaTitle.save
  end

  desc "Add 10 inches pizza size "
  task :add_pizza_size_10_inch => :environment do
    @pizza_size = PizzaSize.new
    @pizza_size.name = "10 Inches"
    @pizza_size.active = true
    @pizza_size.topping_price = 1
    @pizza_size.deep_dish_option_price = 1.99
    @pizza_size.has_deep_dish_option = false
    @pizza_size.price = 8.99
    @pizza_size.abbr_name = "10 in"
    @pizza_size.num_slices = "(6 slices)"
    @pizza_size.top_of_the_list = false
    @pizza_size.gluten_free = false
    @pizza_size.external_name = '10"'
    @pizza_size.position = 8
    @pizza_size.normal_topping_price = 1
    @pizza_size.extra_topping_price = 1.5
    @pizza_size.double_topping_price = 1.9
    @pizza_size.is_catering = true
    @pizza_size.save
  end

  desc "Pizza size reordering"
  task :pizza_size_reorder => :environment do
    PizzaSize.all.each do |pizza_size|
      case pizza_size.name
        when "Gluten Free"
          pizza_size.position = 2
        when "Gluten Free Small"
          pizza_size.position = 1
        when "Cauliflower S"
          pizza_size.position = 3
        when "Cauliflower M"
          pizza_size.position = 4
        when "10 Inches"
          pizza_size.position = 5
        when "Medium"
          pizza_size.position = 6
        when "Large"
          pizza_size.position = 7
        when "XLarge"
          pizza_size.position = 8
        when "Party"
          pizza_size.position = 9
        end
      pizza_size.save
    end
  end

  desc "Add 10 inches pizza"
  task :ten_inches_pizza => :environment do
    pizza_names = ["Canadiana", "Capone", "Gianni Ola", "Honolulu", "Americana", "Sicilian", "Soprano", "Thai Pie", "The Godfather", "Toni Pepperoni", "Whole Wheat Meat", "Veggie Lover", "Sofia", "Bomba", "Casino", "Primavera", "Bianca", "Spinotta", "The Sonny (Like It Hot)", "Whole Wheat Veggie", "Vittoria", "Fredo", "Whole Wheat Diana"]
    PizzaPreset.where(product_name: pizza_names, :active => true, :is_10_inches => false, :is_product_combo => false).each do |pizza_preset|
      puts "### starts #{pizza_preset.product_name}###"
      new_pizza_preset = PizzaPreset.new
      new_pizza_preset.product_info = pizza_preset.product_info
      new_pizza_preset.is_10_inches = true
      new_pizza_preset.product_name = '10"' + " #{pizza_preset.product_name}"
      new_pizza_preset.product_info["product_name"] = '10"' + " #{pizza_preset.product_name}"
      new_pizza_preset.product_info["pizza_size"] = "10-inches"
      new_pizza_preset.active = true
      new_pizza_preset.pizza_image_flat = pizza_preset.pizza_image_flat
      new_pizza_preset.pizza_image_angled = pizza_preset.pizza_image_angled
      new_pizza_preset.image_flat_file_name = pizza_preset.image_flat_file_name
      new_pizza_preset.image_flat_content_type = pizza_preset.image_flat_content_type
      new_pizza_preset.image_flat_file_size = pizza_preset.image_flat_file_size
      new_pizza_preset.pizzaiolo_favourites = pizza_preset.pizzaiolo_favourites
      new_pizza_preset.spicy = pizza_preset.spicy
      new_pizza_preset.vegan = pizza_preset.vegan
      new_pizza_preset.description = pizza_preset.description
      new_pizza_preset.show_images = pizza_preset.show_images
      new_pizza_preset.nut_free = pizza_preset.nut_free
      new_pizza_preset.gluten_free_only = pizza_preset.gluten_free_only
      new_pizza_preset.calories = pizza_preset.calories
      new_pizza_preset.is_product_combo = pizza_preset.is_product_combo
      new_pizza_preset.product_combo_id = pizza_preset.product_combo_id
      new_pizza_preset.category_id = pizza_preset.pizza_category_id
      new_pizza_preset.pizza_category_id = PizzaCategory.where(name: "Create Your Own Pizza").try(:first).try(:id) || 4
      if new_pizza_preset.save!
        puts "create #{pizza_preset.id}"
      else
        puts "failed from #{pizza_preset.id}"
      end
    end

    # hack
    PizzaPreset.where(:active => true, :is_10_inches=> true).map {|p| p.save}
  end

  desc "Gluten Free external_name and num_slices update"
  task :gluten_free_name_update => :environment do
    PizzaSize.all.each do |pizza_size|
      case pizza_size.name
        when "Gluten Free"
          pizza_size.external_name = 'Gluten Free 13"'
          pizza_size.num_slices = "(8 slices)"
        when "Gluten Free Small"
          pizza_size.external_name = 'Gluten Free 10"'
          pizza_size.num_slices = "(6 slices)"
        end
      pizza_size.save
    end
  end

  desc "Add New Pizza Category NEW GLUTEN FREE"
  task :add_new_gluten_free_category => :environment do
    newGlutenFree = PizzaCategory.new
    newGlutenFree.name = "GLUTEN FREE"
    newGlutenFree.page_title =  "gluten free & cauliflower"
    newGlutenFree.save
  end

  desc "update Category GLUTEN FREE name"
  task :update_gluten_free_category => :environment do
    newGlutenFree = PizzaCategory.find_by_name("GLUTEN FREE")
    newGlutenFree.name = "Gluten Free"
    newGlutenFree.page_title =  "Gluten Free & Cauliflower"
    newGlutenFree.save
  end
  
  desc "Gluten Free inches remove"
  task :gluten_free_size_remove => :environment do
    PizzaSize.all.each do |pizza_size|
      case pizza_size.name
      when "Gluten Free"
        pizza_size.external_name = 'Gluten Free'
      when "Gluten Free Small"
        pizza_size.external_name = 'Gluten Free'
      end
      pizza_size.save
    end
  end

  
  desc "Pizza Crust Style Deep Dish Name Change"
  task :pizza_crust_style_name_change => :environment do
    PizzaCrustStyle.all.each do |style_name|
      case style_name.name
      when "Deep Dish"
        style_name.name = 'Deep Dish (Extra Thick Crust)'
      end
      style_name.save
    end
  end
  
  desc "Add Cauliflower pizza size "
  task :add_pizza_size_cauliflower => :environment do
    @pizza_size_cauliflower_m = PizzaSize.new
    @pizza_size_cauliflower_m.name = "Cauliflower M"
    @pizza_size_cauliflower_m.active = true
    @pizza_size_cauliflower_m.topping_price = 1
    @pizza_size_cauliflower_m.deep_dish_option_price = 0
    @pizza_size_cauliflower_m.has_deep_dish_option = false
    @pizza_size_cauliflower_m.price = 14.99
    @pizza_size_cauliflower_m.abbr_name = "Culfl M"
    @pizza_size_cauliflower_m.num_slices = "(8 slices)"
    @pizza_size_cauliflower_m.top_of_the_list = false
    @pizza_size_cauliflower_m.gluten_free = true
    @pizza_size_cauliflower_m.external_name = 'Cauliflower M'
    @pizza_size_cauliflower_m.position = 4
    @pizza_size_cauliflower_m.normal_topping_price = 1.99
    @pizza_size_cauliflower_m.extra_topping_price = 2.99
    @pizza_size_cauliflower_m.double_topping_price = 3.78
    @pizza_size_cauliflower_m.is_catering = false
    @pizza_size_cauliflower_m.save


    @pizza_size_cauliflower_s = PizzaSize.new
    @pizza_size_cauliflower_s.name = "Cauliflower S"
    @pizza_size_cauliflower_s.active = true
    @pizza_size_cauliflower_s.topping_price = 1.49
    @pizza_size_cauliflower_s.deep_dish_option_price = 0
    @pizza_size_cauliflower_s.has_deep_dish_option = false
    @pizza_size_cauliflower_s.price = 11.99
    @pizza_size_cauliflower_s.abbr_name = "Culfl S"
    @pizza_size_cauliflower_s.num_slices = "(6 slices)"
    @pizza_size_cauliflower_s.top_of_the_list = false
    @pizza_size_cauliflower_s.gluten_free = true
    @pizza_size_cauliflower_s.external_name = 'Cauliflower S'
    @pizza_size_cauliflower_s.position = 3
    @pizza_size_cauliflower_s.normal_topping_price = 1.49
    @pizza_size_cauliflower_s.extra_topping_price = 2.24
    @pizza_size_cauliflower_s.double_topping_price = 2.83
    @pizza_size_cauliflower_s.is_catering = false
    @pizza_size_cauliflower_s.save
  end


  desc "Add Slug To Pizza Crust Style"
  task :pizza_crust_style_slug_update => :environment do
    PizzaCrustStyle.all.each do |style_name|
      case style_name.name
        when "Original"
          style_name.slug = 'original'
        when "Thin Crust"
          style_name.slug = 'thin-crust'
        when "Deep Dish (Extra Thick Crust)"
          style_name.slug = 'deep-dish-extra-thick-crust'    
        end
        style_name.save
    end
  end  

  desc "Pizza Size Name Update"
  task :pizza_size_external_name_update => :environment do
    PizzaSize.all.each do |pizza_size|
      case pizza_size.name
        when "Gluten Free"
          pizza_size.external_name = 'Gluten Free Medium'
        when "Gluten Free Small"
          pizza_size.external_name = 'Gluten Free Small'
        when "Cauliflower M"
          pizza_size.external_name = 'Cauliflower Medium'
        when "Cauliflower S"
          pizza_size.external_name = 'Cauliflower Small'    
        end
      pizza_size.save
    end
  end

end
