namespace :update do
  desc 'Update Product combos metadata'
  task product_combos_metadata: :environment do
    puts "####### Starting updating metadata ######"
    product_combos = ProductCombo.find(:all)
    product_combos.each do |product_combo|
      case product_combo.slug.try(:strip)
        when "delivery-special"
          puts "####### Starting updating metadata for product combo: #{product_combo.slug.strip} ########"
          product_combo.seo_title = "Pizzaiolo | Gourmet Pizzeria | Delivery Special"
          product_combo.seo_metadescription = "Looking for great pizza and free drinks? Order our Delivery special and get 2 pizzas, 2 drinks and 2 dips!"
          product_combo.seo_keywords = "Pizzaiolo, Online Ordering, Delivery, Pizza Delivery, Gourmet Pizza, Delivery special, offers and deals"
          puts "####### Ending updating metadata for product combo: #{product_combo.slug.strip} ########"
        when "pickup-special"
          puts "####### Starting updating metadata for product combo: #{product_combo.slug.strip} ########"
          product_combo.seo_title = "Pizzaiolo | Toronto and GTA's Gourmet Pizza | Pick Up Special"
          product_combo.seo_metadescription = "Create your own pizza at Pizzaiolo with our Pick Up Special. 1 Medium Gourmet Pizza with 2 toppings, made ready to order. Order yours today!"
          product_combo.seo_keywords = "Pizzaiolo, Pick Your Favourite, Pizza, Takeout, Toronto's Best Gourmet Pizza, Create your Own, Pizza Specials, Offers and Deals, Online Ordering"
          puts "####### Ending updating metadata for product combo: #{product_combo.slug.strip} ########"
        when "pepperoni-special"
          puts "####### Starting updating metadata for product combo: #{product_combo.slug.strip} ########"
          product_combo.seo_title = "Pizzaiolo | Toronto and GTA's Gourmet Pizza | Pepperoni Special"
          product_combo.seo_metadescription = "At Pizzaiolo, we love pepperoni as much as you! Order our Pepperoni special for not one, but two types of pepperoni pizzas! Order today!"
          product_combo.seo_keywords = "Pizzaiolo, Pepperoni Pizza, Gourmet Pepperoni, Online Ordering, Toronto's best Pepperoni Pizza, Pizza Specials, Offers and Deals, Online Ordering"
          puts "####### Ending updating metadata for product combo: #{product_combo.slug.strip} ########"
      end
      product_combo.save
    end
    puts "####### Ending updating metadata ######"
  end
end