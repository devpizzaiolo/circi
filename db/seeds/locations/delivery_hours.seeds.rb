require 'csv'
n = 1
CSV.foreach(Rails.root.join("db", "data", "delivery_hours.csv"), {headers: :first_row}) do |row|
  @franchise_location = FranchiseLocation.find(n)
  @franchise_location.update_attributes(
  
    :address => row[0],
    :address_details => row[1],
    :phone => row[2],
    
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
  
    :delivery_mon_open => row[17],
    :delivery_mon_closed => row[18],
    :delivery_tue_open => row[19],
    :delivery_tue_closed => row[20],
    :delivery_wed_open => row[21],
    :delivery_wed_closed => row[22],
    :delivery_thu_open => row[23],
    :delivery_thu_closed => row[24],
    :delivery_fri_open => row[25],
    :delivery_fri_closed => row[26],
    :delivery_sat_open => row[27],
    :delivery_sat_closed => row[28],
    :delivery_sun_open => row[29],
    :delivery_sun_closed => row[30]
    
  )
  n +=1
end