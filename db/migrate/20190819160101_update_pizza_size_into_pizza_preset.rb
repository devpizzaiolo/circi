class UpdatePizzaSizeIntoPizzaPreset < ActiveRecord::Migration
  def up
    @pizza_presets = PizzaPreset.find(:all)
    @pizza_presets.each do |pizza_preset|
      case pizza_preset.product_info['pizza_size']
       when "medium"
        pizza_preset.product_info['pizza_size'] = "large"
      end
      pizza_preset.save
    end
  end

  def down
    @pizza_presets = PizzaPreset.find(:all)
    @pizza_presets.each do |pizza_preset|
      case pizza_preset.product_info['pizza_size']
       when "large"
        pizza_preset.product_info['pizza_size'] = "medium"
      end
      pizza_preset.save
    end
  end
end
