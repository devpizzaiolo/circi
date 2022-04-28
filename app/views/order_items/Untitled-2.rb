def custom
  
  custom = false
  
  if oi.product_info['product_type'] == "pizza"
    
    @preset = PizzaPreset.find_by_id(oi.product_info['pizza_preset_id'].to_i) || PizzaPreset.find_by_product_name(oi.product_info['product_name'].to_i)
    
    # if the pizza has been made Gluten Free from a normal base...
    if @preset.product_info['pizza_size'].include?("gluten-free") != oi.product_info['pizza_size'].include?("gluten-free")
      puts "the main pizza is not the same base..."
      custom = true
    end
    
    # if the toppings are different differently to the original...
    if oi.product_info['toppings'].sort.to_s != @preset.product_info['toppings'].sort.to_s
      puts "toppings are different..."
      custom = true
    end
    
    # if the crust and or style are different...
    if oi.product_info['pizza_crust'] != @preset.product_info['pizza_crust'] || oi.product_info['pizza_crust_style'] != @preset.product_info['pizza_crust_style']
      puts "crust or style are different..."
      custom = true
    end
    
  end
  
  if oi.product_info['product_type'] == "calzone"
    @preset = CalzonePreset.find(oi.product_info['calzone_preset_id'].to_i)
    if oi.product_info['toppings'].diff(@preset.product_info['toppings'])
      custom = true
    end
  end
  
  return custom
  
end