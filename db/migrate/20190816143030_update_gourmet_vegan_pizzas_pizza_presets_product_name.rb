class UpdateGourmetVeganPizzasPizzaPresetsProductName < ActiveRecord::Migration
  def up
    @pizza_category =  PizzaCategory.where(:active => true).find_by_slug("gourmet-vegan-pizzas")
    @pizza_category.pizza_presets.each do |pizza_preset|
      case pizza_preset.product_name 
      when 'Fredo "V"'
        pizza_preset.product_name = "Fredo"
      when 'Vittoria "V"'
        pizza_preset.product_name = "Vittoria"
      when 'Whole Wheat Diana "V"'
        pizza_preset.product_name = "Whole Wheat Diana" 
      end
      pizza_preset.save
    end
  end

  def down
    @pizza_category =  PizzaCategory.where(:active => true).find_by_slug("gourmet-vegan-pizzas")
    @pizza_category.pizza_presets.each do |pizza_preset|
      case pizza_preset.product_name 
      when "Fredo"
        pizza_preset.product_name = 'Fredo "V"'
      when "Vittoria"
        pizza_preset.product_name = 'Vittoria "V"'
      when "Whole Wheat Diana" 
        pizza_preset.product_name = 'Whole Wheat Diana "V"'
      end
      pizza_preset.save
    end
  end
end
