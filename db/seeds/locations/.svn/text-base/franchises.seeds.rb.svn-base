require 'csv'

CSV.foreach(Rails.root.join("db", "data", "locations.csv"), {headers: :first_row}) do |row|
  @franchise_location = FranchiseLocation.create(
    :address => row[0],
    :address_details => row[1],
    :phone => row[2],
    :area_name => row[19],
    :mon_open => row[3],
    :mon_closed => row[4],
    :tue_open => row[5],
    :tue_closed => row[6],
    :wed_open => row[7],
    :wed_closed => row[8],
    :thu_open => row[9],
    :thu_closed => row[10],
    :fri_open => row[11],
    :fri_closed => row[12],
    :sat_open => row[13],
    :sat_closed => row[14],
    :sun_open => row[15],
    :sun_closed => row[16],
    :latitude => row[17],
    :longitude => row[18]
  )
end