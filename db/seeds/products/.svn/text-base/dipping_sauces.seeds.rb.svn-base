require 'csv'

CSV.foreach(Rails.root.join("db", "data", "dipping_sauces.csv"), {headers: :first_row}) do |row|
  @dipping_sauce = DippingSauce.find_or_create_by_name(:name => row[0])
  @dipping_sauce.update_attributes(:price => row[1])
end