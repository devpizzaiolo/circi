require 'csv'

CSV.foreach(Rails.root.join("db", "data", "crusts.csv"), {headers: :first_row}) do |row|
  @crust = PizzaCrust.find_or_create_by_name(:name => row[0])
end