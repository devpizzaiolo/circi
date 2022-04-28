require 'csv'

CSV.foreach(Rails.root.join("db", "data", "fruits_and_desserts.csv"), {headers: :first_row}) do |row|
  
  if row[2] == "y"
    truefalse = true
  else
    truefalse = false
  end
  
  Dessert.create(:name => row[0], :price => row[1], :multiple_of_12 => truefalse)
  
end
