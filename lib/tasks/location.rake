
namespace :location do
  task export_delivery_hours: :environment do
		franchisees = FranchiseLocation.find(:all)
		file_name = "location_#{Time.now.strftime("%m_%d_%Y")}.csv"

    CSV.open(Rails.root + "public/#{file_name}", "wb") do |csv|
			csv << ["ID", "Address", "Phone","Area Name", "Monday Delivery Open","Monday Delivery Close", "Tuesday Delivery Open","Tuesday Delivery Close", "Wednesday Delivery Open","Wednesday Delivery Close", "Thursday Delivery Open","Thursday Delivery Close", "Friday Delivery Open","Friday Delivery Close", "Saturday Delivery Open","Saturday Delivery Close", "Sunday Delivery Open","Sunday Delivery Close"]
			franchisees.each do |fl|
				csv << [fl.id,fl.address,fl.phone,fl.area_name,fl.delivery_mon_open.to_s(:time),fl.delivery_mon_closed.to_s(:time),fl.delivery_tue_open.to_s(:time),fl.delivery_tue_closed.to_s(:time),fl.delivery_wed_open.to_s(:time),fl.delivery_wed_closed.to_s(:time),fl.delivery_thu_open.to_s(:time),fl.delivery_thu_closed.to_s(:time),fl.delivery_fri_open.to_s(:time),fl.delivery_fri_closed.to_s(:time),fl.delivery_sat_open.to_s(:time),fl.delivery_sat_closed.to_s(:time),fl.delivery_sun_open.to_s(:time),fl.delivery_sun_closed.to_s(:time)]
			end
    end
		puts "Export Done : #{file_name}"
	end
	task export_pickup_hours: :environment do
		franchisees = FranchiseLocation.find(:all)
		file_name = "location_pickup_#{Time.now.strftime("%m_%d_%Y")}.csv"

    CSV.open(Rails.root + "public/#{file_name}", "wb") do |csv|
			csv << ["ID", "Address", "Phone","Area Name", "Monday Open","Monday Close", "Tuesday Open","Tuesday Close", "Wednesday Open","Wednesday Close", "Thursday Open","Thursday Close", "Friday Open","Friday Close", "Saturday Open","Saturday Close", "Sunday Open","Sunday Close"]
			franchisees.each do |fl|
				csv << [fl.id,fl.address,fl.phone,fl.area_name,fl.mon_open.to_s(:time),fl.mon_closed.to_s(:time),fl.tue_open.to_s(:time),fl.tue_closed.to_s(:time),fl.wed_open.to_s(:time),fl.wed_closed.to_s(:time),fl.thu_open.to_s(:time),fl.thu_closed.to_s(:time),fl.fri_open.to_s(:time),fl.fri_closed.to_s(:time),fl.sat_open.to_s(:time),fl.sat_closed.to_s(:time),fl.sun_open.to_s(:time),fl.sun_closed.to_s(:time)]
			end
    end
		puts "Export Done : #{file_name}"
	end
	
	desc 'Update Delivery Hours'
	task update_delivery_hours: :environment do
		franchisees = FranchiseLocation.find(:all)
		
		weekdays_delivery_open_time = '11:00:00'	
		weekdays_delivery_closed_time = '21:00:00'

		weekends_delivery_open_time = '11:00:00'
		weekends_delivery_closed_time = '22:00:00'

		franchisees.each do |fl|
			fl.delivery_mon_open  = weekdays_delivery_open_time
			fl.delivery_mon_closed = weekdays_delivery_closed_time
			fl.delivery_tue_open	= weekdays_delivery_open_time
			fl.delivery_tue_closed	= weekdays_delivery_closed_time
			fl.delivery_wed_open	= weekdays_delivery_open_time
			fl.delivery_wed_closed	= weekdays_delivery_closed_time
			fl.delivery_thu_open	= weekdays_delivery_open_time
			fl.delivery_thu_closed	= weekdays_delivery_closed_time
			fl.delivery_sun_open	= weekdays_delivery_open_time
			fl.delivery_sun_closed	= weekdays_delivery_closed_time

			fl.delivery_fri_open = weekends_delivery_open_time
			fl.delivery_fri_closed = weekends_delivery_closed_time
			fl.delivery_sat_open = weekends_delivery_open_time
			fl.delivery_sat_closed = weekends_delivery_closed_time

			fl.save
		end
		puts "Update Done"
	end
	desc 'Update Pickup Hours'
	task update_pickup_hours: :environment do
		franchisees = FranchiseLocation.find(:all)

		weekdays_open_time = '11:00:00'	
		weekdays_closed_time = '21:00:00'

		weekends_open_time = '11:00:00'
		weekends_closed_time = '22:00:00'

		franchisees.each do |fl|
			fl.mon_open = weekdays_open_time
			fl.mon_closed = weekdays_closed_time
			fl.tue_open = weekdays_open_time
			fl.tue_closed = weekdays_closed_time
			fl.wed_open = weekdays_open_time
			fl.wed_closed = weekdays_closed_time
			fl.thu_open = weekdays_open_time
			fl.thu_closed = weekdays_closed_time
			fl.sun_open = weekdays_open_time
			fl.sun_closed = weekdays_closed_time

			fl.fri_open = weekends_open_time
			fl.fri_closed = weekends_closed_time
			fl.sat_open = weekends_open_time
			fl.sat_closed = weekends_closed_time

			fl.save
		end
		puts "Update Done"
	end

	desc 'Update location city, province and postal_code '
	task update_location_city_province_postal_code: :environment do
		franchiseLocations = FranchiseLocation.find(:all)
		franchiseLocations.each do |location|
			case location.address.strip
				when "550 Yonge Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4Y 1Y8"
				when "3 Rees Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5V 3J2"
				when "461 Church Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4Y 2C5"	
				when "707 Yonge Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4Y 2B2"
				when "270 Adelaide Street West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5V 2E2"
				when "454 Bloor Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5S 1X8"
				when "624 Queen Street West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M6J 1E4"
				when "609 Queen Street West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5V 2B7"
				when "615 King Street West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5V 1M5"
				when "834 Yonge Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4W 2H1"
				when "722 Queen Street East"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4M 1H1"
				when "1 Toronto Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5C 2V6"
				when "104 Yonge Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5C 2Y6"
				when "289 Dundas Street West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5T 1G2"
				when "346 Bloor Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5S 2J2"
				when "1528 Danforth Avenue"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4J 1N4"
				when "953 Eglinton Avenue West"
					location.city = "York"
					location.province = "ON"
					location.postal_code = "M6C 2C4"
				when "13 St. Clair Avenue West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4V 1K6"
				when "3369 Yonge Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4N 2M6"
				when "745 Mount Pleasant"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4S 2N4"
				when "2221 Yonge Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4S 2B4"
				when "865 York Mills Road"
					location.city = "North York"
					location.province = "ON"
					location.postal_code = "M3B 1Y6"
				when "4920 Yonge Street"
					location.city = "North York"
					location.province = "ON"
					location.postal_code = "M2N 5N5"
				when "66 Kingston Road"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4L 1S4"
				when "2425 Bloor Street West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M6S 1P9"
				when "3339 Bloor Street West"
					location.city = "Etobicoke"
					location.province = "ON"
					location.postal_code = "M8X 1E9"
				when "56 Lakeshore Road East"
					location.city = "Mississauga"
					location.province = "ON"
					location.postal_code = "L5G 1E1"
				when "37 Eglinton Avenue East"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4P 1A1"
				when "123 Spadina Avenue"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5V 2K8"
				when "341 Lakeshore Road East"
					location.city = "Oakville"
					location.province = "ON"
					location.postal_code = "L6J 1J4"
				when "3180 Lake Shore Blvd West"
					location.city = "Etobicoke"
					location.province = "ON"
					location.postal_code = "M8V 1L7"
				when "1172 Queen Street West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M6J 1J5"
				when "3480 Fairview Street"
					location.city = "Burlington"
					location.province = "ON"
					location.postal_code = "L7N 2R5"
				when "3480 Fairview Street"
					location.city = "Burlington"
					location.province = "ON"
					location.postal_code = "L7N 2R5"
				when "383 Roncesvalles Ave."
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M6R 2M8"
				when "130 Guelph Street"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "L7G 1T9"
				when "115 York Boulevard"
					location.city = "Richmond Hill"
					location.province = "ON"
					location.postal_code = "L4B 3B4"
				when "110 Danforth Avenue"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4K 1N1"
				when "5130 Dixie Road"
					location.city = "Mississauga"
					location.province = "ON"
					location.postal_code = "L4W 4K2"
				when "182 Main Street East"
					location.city = "Milton"
					location.province = "ON"
					location.postal_code = "L9T 1N8"
				when "1477 Lakeshore Rd"
					location.city = "Burlington"
					location.province = "ON"
					location.postal_code = "L7S 1B5"
				when "1160 St. Clair Avenue West"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M6E 1B3"
				when "7040 Airport Road"
					location.city = "Mississauga"
					location.province = "ON"
					location.postal_code = "L4T 2G8"
				when "10211 Keele Street"
					location.city = "Maple"
					location.province = "ON"
					location.postal_code = "L6A 4R7"
				when "229 Queen St. S."
					location.city = "Mississauga"
					location.province = "ON"
					location.postal_code = "L5M 1L7"
				when "2335 Trafalgar Rd."
					location.city = "Oakville"
					location.province = "ON"
					location.postal_code = "L6H 6N9"
				when "2253 Queen St. E"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4E 1G3"
				when "416 Bloor St. W"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M5S 1X5"
				when "366 Bloor St. East"
					location.city = "Toronto"
					location.province = "ON"
					location.postal_code = "M4W 1H4"
			end
			location.save
		end
		puts "Update Done"
	end
end 

#rake location:update_delivery_hours
#rake location:update_pickup_hours