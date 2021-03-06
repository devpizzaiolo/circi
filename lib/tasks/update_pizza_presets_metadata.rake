namespace :update do

  desc 'Update Pizza Presets meta data'
  task pizza_presets_metadata: :environment do
    puts "####### Starting updating metadata ######"
    pizza_presets = PizzaPreset.find(:all)
    pizza_presets.each do |pizza_preset|
      case pizza_preset.slug.try(:strip)
        when "bianca", "10-bianca"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Bianca"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Bianca pizza around! Marinated artichoke, marinated zucchini, feta cheese, parmigiano cheese, mozzarella cheese, extra virgin olive oil."
          pizza_preset.seo_keywords = "Pizzaiolo, Bianca Pizza, Gourmet Pizza, Toronto's finest pizza, artichoke, zucchini, feta cheese, mozzarella cheese, olive oil"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "americana", "10-americana"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Americana"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Americana pizza around! With real canadian bacon, fresh mushrooms, parmigiano cheese, mozzarella cheese and Pizzaiolo's tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Americana Pizza, Gourmet Pizza, Toronto's finest pizza, bacon, mushrooms, mozzarella cheese"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "bomba", "10-bomba"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Bomba"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Bomba pizza around! Nothing but Cheese! Feta cheese, gorgonzola cheese, parmigiano cheese, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Bomba Pizza, Gourmet Pizza, Toronto's finest pizza, Feta cheese, gorgonzola, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########" 
        when "brando", "10-brando"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Brando"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Brando pizza around! Ground beef, hot banana peppers, fresh mushrooms, red onions, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Brando Pizza, Gourmet Pizza, Toronto's finest pizza, ground beef, banana peppers, mushrooms, red onion, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "canadiana", "10-canadiana"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Canadiana"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Canadiana pizza around! Green peppers, fresh mushrooms, dry cured pepperoni, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Canadiana Pizza, Gourmet Pizza, Toronto's finest pizza, peppers, mushrooms, pepperoni, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "capone", "10-capone"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Capone"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Capone pizza around! Oven-roasted chicken breast, fresh mushrooms, roasted red peppers, parmigiano cheese, mozzarella cheese and pesto sauce (Nut Free)."
          pizza_preset.seo_keywords = "Pizzaiolo, Capone Pizza, Gourmet Pizza, Toronto's finest pizza, chicken, mushrooms, red peppers, mozzarella, Nut Free Pesto"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "capri", "10-capri"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Capri"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Capri pizza around! Goat cheese, roasted red peppers, pesto sauce (Nut Free), mozzarella cheese, Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Capri Pizza, Gourmet Pizza, Toronto's finest pizza, goat cheese, red peppers, Nut Free Pesto, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "casino", "10-casino" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Casino"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Casino pizza around! Black olives, green olives, roasted red peppers, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Casino Pizza, Gourmet Pizza, Toronto's finest pizza, olives, red peppers, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "diana", "10-diana" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Diana"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Diana pizza around! Fresh mushrooms, roasted red peppers, herbed tomatoes, marinated zucchini, pesto sauce (Nut Free)."
          pizza_preset.seo_keywords = "Pizzaiolo, Diana Pizza, Gourmet Pizza, Toronto's finest pizza, mushrooms, red peppers, herbed tomatoes, zucchini, Nut Free Pesto"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "fredo", "10-fredo" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Fredo"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Fredo pizza around! Double Yukon Gold potatoes, oregano, rosemary, sea salt and extra virgin olive oil."
          pizza_preset.seo_keywords = "Pizzaiolo, Fredo Pizza, Gourmet Pizza, Toronto's finest pizza, Yukon Gold Potatoes, Orgeano, Rosemary, Sea Salt, Olive Oil"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "gianni-ola", "10-gianni-ola" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Gianni Ola"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Gianni Ola pizza around! Real Canadian bacon, fresh mushrooms, dry cured pepperoni, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Gianni Ola Pizza, Gourmet Pizza, Toronto's finest pizza, bacon, mushrooms, pepperoni, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "honolulu", "10-honolulu" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Honolulu"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Honolulu pizza around! Real Canadian bacon, ham, pineapple, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Honolulu Pizza, Gourmet Pizza, Toronto's finest pizza, Hawaiian Pizza, Pineapple, Ham, Bacon, Mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "mafioso", "10-mafioso" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Mafioso"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Mafioso pizza around! Black olives, green olives, hot banana peppers, Italian sausage, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Mafioso Pizza, Gourmet Pizza, Toronto's finest pizza, Olives, Italian Sausage, banana peppers, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "meat-lover", "10-meat-lover" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Meat Lovers"
          pizza_preset.seo_metadescription = "Meat your Pizza! If you love meat on your pizza, we have you covered.  Pizzaiolo makes the best Meat Lovers pizza around! Real Canadian bacon, ground beef, ham, dry cured pepperoni, Italian sausage, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Meat Lovers Pizza, Gourmet Pizza, Toronto's finest pizza, bacon, ground beef, ham, pepperoni, Italian Sausage, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "mediterranean", "10-mediterranean" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Mediterranean"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Mediterranean pizza around! Black olives, green peppers, herbed tomatoes, feta cheese, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Mediterranean Pizza, Gourmet Pizza, Toronto's finest pizza, olives, peppers, herbed tomatoes, feta, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "primavera", "10-primavera"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Primavera"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Primavera pizza around! Roasted red peppers, herbed tomatoes, marinated zucchini, parmigiano cheese, mozzarella cheese, extra virgin olive oil."
          pizza_preset.seo_keywords = "Pizzaiolo, Primavera Pizza, Gourmet Pizza, Toronto's finest pizza, red peppers, herbed tomatoes, zucchini, mozzarella olive oil"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "sicilian", "10-sicilian"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Sicilian"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Sicilian pizza around! Real Canadian bacon, red onions, Italian sausage, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Sicilian Pizza, Gourmet Pizza, Toronto's finest pizza, bacon, red onions, Italian Sausage, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "sofia", "10-sofia" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Sofia"
          pizza_preset.seo_metadescription = "Keeping it simple and fantastic! Pizzaiolo makes the best Cheese pizza around! Mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Sofia Pizza, Gourmet Pizza, Toronto's finest pizza, Cheese Pizza, Mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "soprano", "10-soprano" 
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Soprano"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Soprano pizza around! Sopressata, sun dried tomatoes, gorgonzola cheese, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Soprano Pizza, Gourmet Pizza, Toronto's finest pizza, Sopressata, sun drieed tomatoes, gorgonzola, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "spinotta", "10-spinotta"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Spinotta"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Spinotta pizza around! Spinach, herbed tomatoes, ricotta cheese, parmigiano cheese, mozzarella cheese and extra virgin olive oil."
          pizza_preset.seo_keywords = "Pizzaiolo, Spinotta Pizza, Gourmet Pizza, Toronto's finest pizza, spinach, herbed tomatoes, ricotta, mozzarella, olive oil"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "thai-pie", "10-thai-pie"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Thai Pie"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Thai inspired pizza around! Oven-roasted chicken breast, fresh mushrooms, red onions, mozzarella cheese, BBQ sauce and Satay sauce (Nut Free)."
          pizza_preset.seo_keywords = "Pizzaiolo, Thai Pie Pizza, Gourmet Pizza, Toronto's finest pizza, Nut Free Satay Sauce, chicken, mushrooms, red onions, BBQ sauce, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "new-toni-roni", "10-new-toni-roni", "toni-roni", "10-toni-roni"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Toni Roni"
          pizza_preset.seo_metadescription = "Keeping it simple and fantastic! Pizzaiolo makes the best Pepperoni pizza around! Tiny cup & char pepperoni, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Toni Roni Pizza, Gourmet Pizza, Toronto's finest pizza, Pepperoni Pizza"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "veggie-lover", "10-veggie-lover"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Veggie Lover"
          pizza_preset.seo_metadescription = "No Meat? No Problem! We have our Veggie Lovers covered with our Gourmet Veggie Lovers Pizza. Green peppers, fresh mushrooms, spinach, herbed tomatoes, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Veggie Lover Pizza, Gourmet Pizza, Toronto's finest pizza, peppers, mushrooms, spinach, herbed tomatoes, mozzarella"
          puts "####### Ending updating metadata for location: #{pizza_preset.slug.strip} ########"
        when "vittoria", "10-vittoria"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Vittoria"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Vittoria pizza around! Roasted red peppers, herbed tomatoes, marinated zucchini and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Vittoria Pizza, Gourmet Pizza, Toronto's finest pizza, peppers, herbed tomatoes, zucchini"
          puts "####### Ending updating metadata for location: #{pizza_preset.slug.strip} ########"
        when "whole-wheat-diana", "10-whole-wheat-diana"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Whole Wheat Diana"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best Diana pizza around! Whole wheat crust, fresh mushrooms, roasted red peppers, herbed tomatoes, marinated zucchini, pesto sauce (Nut Free)."
          pizza_preset.seo_keywords = "Pizzaiolo, Diana Pizza, Gourmet Pizza, Toronto's finest pizza, mushrooms, red peppers, herbed tomatoes, zucchini, Nut Free Pesto, Whole Wheat"
          puts "####### Ending updating metadata for location: #{pizza_preset.slug.strip} ########"
        when "whole-wheat-meat", "10-whole-wheat-meat"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Whole Wheat Meat Lovers"
          pizza_preset.seo_metadescription = "Meat your Pizza! If you love meat on your pizza, we have you covered. Pizzaiolo makes the best Meat Lovers pizza around! Whole wheat crust, real Canadian bacon, ground beef, ham, dry cured pepperoni, Italian sausage, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Meat Lovers Pizza, Gourmet Pizza, Toronto's finest pizza, bacon, ground beef, ham, pepperoni, Italian Sausage, mozzarella, Whole Wheat"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "whole-wheat-veggie", "10-whole-wheat-veggie"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Whole Wheat Veggie Lovers"
          pizza_preset.seo_metadescription = "No Meat? No Problem! We have our Veggie Lovers covered with our Gourmet Veggie Lovers Pizza. Whole wheat crust green peppers, fresh mushrooms, spinach, herbed tomatoes, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Veggie Lover Pizza, Gourmet Pizza, Toronto's finest pizza, peppers, mushrooms, spinach, herbed tomatoes, mozzarella, Whole Wheat"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "create-your-own-pizza"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizzeria | Create your own Pizza"
          pizza_preset.seo_metadescription = "Have your pizza the way you like it! At Pizzaiolo you can customize your pizza and we make it just for you! Order today!"
          pizza_preset.seo_keywords = "Pizzaiolo, Pizza, Custom Pizza, Build your Own, Takeout, Delivery, Online Ordering"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "original-toni-pepperoni", '10-original-toni-pepperoni'
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Toni Roni"
          pizza_preset.seo_metadescription = "Keeping it simple and fantastic! Pizzaiolo makes the best Pepperoni pizza around! Tiny cup & char pepperoni, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Toni Roni Pizza, Gourmet Pizza, Toronto's finest pizza, Pepperoni Pizza"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "the-godfather", "10-the-godfather"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | The Godfather"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best The Godfather pizza around! Real Canadian bacon, dry cured pepperoni, Italian sausage, parmigiano cheese, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, The Godfather Pizza, Gourmet Pizza, Toronto's finest pizza, Meat Lovers Pizza, bacon, Italian Sausage, Italian Pizza, pepperoni, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "toni-pepperoni", "10-toni-pepperoni"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | Toni Perpperoni"
          pizza_preset.seo_metadescription = "Keeping it simple and fantastic! Pizzaiolo makes the best Pepperoni pizza around! Dry Cured Pepperoni, Mozzarella Cheese and Pizzaiolo Tomato Sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, Toni Pepperoni Pizza, Gourmet Pizza, Toronto's finest pizza, Pepperoni Pizza"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "the-sonny-like-it-hot", "10-the-sonny-like-it-hot"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizza | The Sonny"
          pizza_preset.seo_metadescription = "Pizzaiolo makes the best hot and spicy pizza around! If you like it hot, this pizza is for you! Hot banana peppers, Jalapeno peppers, herbed tomatoes, mozzarella cheese and Pizzaiolo tomato sauce."
          pizza_preset.seo_keywords = "Pizzaiolo, The Sonny Pizza, Gourmet Pizza, Toronto's finest pizza, banana peppers, jalapeno peppers, herbed tomatoes, mozzarella"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "delivery-special"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Gourmet Pizzeria | Delivery Special"
          pizza_preset.seo_metadescription = "Looking for great pizza and free drinks? Order our Delivery special and get 2 pizzas, 2 drinks and 2 dips!"
          pizza_preset.seo_keywords = "Pizzaiolo, Online Ordering, Delivery, Pizza Delivery, Gourmet Pizza, offers and deals"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
        when "pickup-special"
          puts "####### Starting updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
          pizza_preset.seo_title = "Pizzaiolo | Toronto and GTA's Gourmet Pizza | Pick Up Special"
          pizza_preset.seo_metadescription = "Create your own pizza at Pizzaiolo with our Pick Up Special. 1 Medium Gourmet Pizza with 2 toppings, made ready to order. Order yours today!"
          pizza_preset.seo_keywords = "Pizzaiolo, Pick Your Favourite, Pizza, Takeout, Toronto's Best Gourmet Pizza, Create your Own, Pizza Specials, Offers and Deals, Online Ordering"
          puts "####### Ending updating metadata for pizza_preset: #{pizza_preset.slug.strip} ########"
      end
      pizza_preset.save
    end
    puts "####### Ending updating metadata ######"
  end

end