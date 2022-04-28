require 'csv'

CSV.foreach(Rails.root.join("db", "data", "utensils.csv"), {headers: :first_row}) do |row|
  
  Utensil.create(:name => row[0])
  
end
