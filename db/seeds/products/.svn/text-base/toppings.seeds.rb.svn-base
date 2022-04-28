require 'csv'

CSV.foreach(Rails.root.join("db", "data", "toppings.csv"), {headers: :first_row}) do |row|
  
  @type_of_topping = TypeOfTopping.find_or_create_by_name(:name => row[0])
  
  if row[4] == 'y'
    light = true
  else
    light = false
  end
  
  if row[5] == 'y'
    extra = true
  else
    extra = false
  end
  
  if row[6] == 'y'
    double = true
  else
    double = false
  end
  
  @type_of_topping.update_attributes(:preference_light => light, :preference_extra => extra, :preference_double => double)
  
  @topping = Topping.find_or_create_by_name_and_type_of_topping_id(:name => row[1], :type_of_topping_id => @type_of_topping.id)
  
  if row[2] == 'y'
    free = true
  else
    free = false
  end
  
  if row[3] == 'y'
    non_gluten_free = true
  else
    non_gluten_free = false
  end
  
  
  @topping.update_attributes(:free_topping => free, :non_gluten_free => non_gluten_free)
  
end