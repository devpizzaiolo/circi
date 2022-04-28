require 'csv'

namespace :check_orders do
  
  desc "Check orders if they belong to 550 Yonge Street"
  task :check => :environment do
    kml_file = "/Users/manpreetnarang/Downloads/550YongeStreet.kml"
    csv_file = "/Users/manpreetnarang/Downloads/orders.csv"
    CSV.foreach("/Users/manpreetnarang/Downloads/orders.csv") do |row|
      postal_code = row[1]
      myloc = ApplicationController.helpers.geo_code(postal_code)
      contains_in_this_location = false
      if myloc
        lat = myloc[1]
        lon = myloc[0]
        region = BorderPatrol.parse_kml(File.read( kml_file ))
        point = BorderPatrol::Point.new(lat, lon)
        if region.contains_point?(point)
          contains_in_this_location = true
        end
      end
      row << contains_in_this_location
      puts row.join(", ")
    end
  end
  
end