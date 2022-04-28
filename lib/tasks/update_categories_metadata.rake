namespace :update do
  desc 'Update Pizza Categories metadata'
  task pizza_categories_metadata: :environment do
    puts "####### Starting updating metadata ######"
    categories = PizzaCategory.find(:all)
    categories.each do |category|
      case category.slug.try(:strip)
        when "gourmet-meat-pizzas"
          puts "####### Starting updating metadata for pizza category: #{category.slug.strip} ########"
          category.seo_title = "Pizzaiolo | Toronto and GTA's Gourmet Meat Pizzas"
          category.seo_metadescription = "Meat your Pizza! If you love meat on your pizza, we have you covered.  Order any of our meaty pizzas today!"
          category.seo_keywords = "Pizzaiolo, Meat Lover, Meat Pizza, Gourmet Pizza, Pepperoni, Sausage, Ground Beef, Bacon, Chicken, Ham, Pizza, Online Ordering"
          puts "####### Ending updating metadata for pizza category: #{category.slug.strip} ########"
        when "gourmet-vegetarian-pizzas"
          puts "####### Starting updating metadata for pizza category: #{category.slug.strip} ########"
          category.seo_title = "Pizzaiolo | Toronto and GTA's Gourmet Vegetarian Pizzas"
          category.seo_metadescription = "No Meat? No Problem! We have our Veggie Lovers covered with our Gourmet Vegetarian Pizzas.  Order your favourite today!"
          category.seo_keywords = "Pizzaiolo, Veggie Lovers, Vegetarian Pizza, Zucchini, Peppers, Olives, Tomatoes, Mushrooms, Spinach, Pizza, Gourmet Pizza, Online Ordering"
          puts "####### Ending updating metadata for pizza category: #{category.slug.strip} ########"
        when "gourmet-vegan-pizzas"
          puts "####### Starting updating metadata for pizza category: #{category.slug.strip} ########"
          category.seo_title = "Pizzaiolo | Toronto and GTA's Gourmet Vegan Pizzas"
          category.seo_metadescription = "Meat Free and Dairy Free options are our specialty! We have our Vegan customers covered with Gourmet Pizza options available.  Order your favourite today!"
          category.seo_keywords = "Pizzaiolo, Vegan Pizza, Vegan Options, Dairy Free, Gourmet Vegan Pizza, Online Ordering"
          puts "####### Ending updating metadata for pizza category: #{category.slug.strip} ########"
        when "create-your-own-pizza"
          puts "####### Starting updating metadata for pizza category: #{category.slug.strip} ########"
          category.seo_title = "Pizzaiolo | Gourmet Pizzeria | Create your own Pizza"
          category.seo_metadescription = "Have your pizza the way you like it! At Pizzaiolo you can customize your pizza and we make it just for you! Order today!"
          category.seo_keywords = "Pizzaiolo, Pizza, Custom Pizza, Takeout, Delivery, Build your Own, Online Ordering"
          puts "####### Ending updating metadata for pizza category: #{category.slug.strip} ########"
        when "gluten-free"
          puts "####### Starting updating metadata for pizza category: #{category.slug.strip} ########"
          category.seo_title = "Pizzaiolo | Toronto and GTA's Gluten Free Pizzas"
          category.seo_metadescription = "Order your favourite today!"
          category.seo_keywords = "Pizzaiolo, Gluten Free Pizza, Online Ordering"
          puts "####### Ending updating metadata for pizza category: #{category.slug.strip} ########"
      end
      category.save
    end
    puts "####### Ending updating metadata ######"
  end
end