require 'csv'

CSV.foreach(Rails.root.join("db", "data", "beverages.csv"), {headers: :first_row}) do |row|
  
  if row[1] == "y"
    pop_and_spring_water = true
  else
    pop_and_spring_water = false
  end
  
  if row[2] == "y"
    bottles_and_premium_drinks = true
  else
    bottles_and_premium_drinks = false
  end

  Beverage.find_or_create_by_name(:name => row[0], :pop_and_spring_water => pop_and_spring_water, :bottles_and_premium_drinks => bottles_and_premium_drinks, :price => row[3])
  
end
