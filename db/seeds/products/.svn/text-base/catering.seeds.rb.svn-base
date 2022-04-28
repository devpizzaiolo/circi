require 'csv'

CSV.foreach(Rails.root.join("db", "data", "catering_group_size.csv"), {headers: :first_row}) do |row|
  @catering_group_size = CateringGroupSize.find_or_create_by_name(:name => row[0])
end