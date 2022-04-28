namespace :update do

  desc 'Update Pizza Special Instructions into pizza_presets'
  task special_instructions: :environment do
    puts "####### Starting updating pizza special instructions into pizza presets ######"
    pizza_presets = PizzaPreset.find(:all)
    pizza_presets.each do |pizza_preset|
      if pizza_preset.product_info['special_instructions'].blank?
        pizza_preset.product_info['special_instructions'] = "regular"
        pizza_preset.save
        puts "####### Pizza Presets: #{pizza_preset.product_name} updated and special_instructions set to: #{pizza_preset.product_info['special_instructions']}"
      end
    end
    puts "####### Starting updating pizza special instructions into pizza presets ######"
  end
end