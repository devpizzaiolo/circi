require 'csv'

CSV.foreach(Rails.root.join("db", "data", "salads.csv"), {headers: :first_row}) do |row|
  @salad = Salad.find_or_create_by_name(:name => row[0])
  @salad.update_attributes(:price_one_to_five => row[1], :price_six_to_nineteen => row[2], :price_twenty_plus => row[3])
end