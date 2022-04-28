require 'csv'

CSV.foreach(Rails.root.join("db", "data", "pizza_sizes.csv"), {headers: :first_row}) do |row|
  @pizza_size = PizzaSize.find_or_create_by_name(:name => row[0])
  if row[3] == 'y'
    ddo = true
  else
    ddo = false
  end
  @pizza_size.update_attributes(:topping_price => row[1], :deep_dish_option_price => row[2], :has_deep_dish_option => ddo, :price => row[4])
end