namespace :type_of_topping do

  desc "Create new type of toppings - Plant Based"
  task :create_plant_based => :environment do
    puts "###### Creating new Type of Toppings - Plant Based ######"
    type_of_topping = TypeOfTopping.new(
      name: "Plant Based",
      preference_light: true,
      preference_extra: true,
      preference_double: false,
      preference_normal: true,
      position: 6
    )
    if type_of_topping.save
      puts "###### Created new Type of Toppings - Plant Based ######"
    else
      puts "###### Failed to create Type of Toppings - Plant Based error: #{type_of_topping.errors.full_messages.join(', ')} ######"
    end
  end

end