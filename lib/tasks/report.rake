namespace :reports do
  
  desc "generate orders reports count"
  task :orders => :environment do
    reports_enabled?
    start_time = Time.parse("2020-01-05").beginning_of_day
    end_time = Time.parse("2020-02-01").end_of_day
    ranges = get_ranges_new(start_time,end_time)
    order_export = {}
    date_ranges = []
    franchisees = FranchiseLocation.where(active: true)
    ranges.each_with_index do |range, index|
      date_ranges << "Week #{index+1} (#{range.first.strftime('%d %b')} - #{range.last.strftime('%d %b')})"
      franchisees.each do |fl|
        order_export[fl.address] = [] if order_export[fl.address].nil?
        order_export[fl.address] << Order.where(ordered: true, ordered_at: range, franchise_location_id: fl.id).count
      end
    end
    file_name = "order_export_#{Time.now.strftime("%m_%d_%Y")}.csv"
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv <<  ([""] + date_ranges)
      order_export.each do |key, val|
        csv << [key] + val
      end
    end
    OrderMailer.send_orders_report(file_name).deliver
  end

  desc "generate online transaction reports"

  task :orders_report => :environment do
    include ActionView::Helpers::NumberHelper
    date = Time.now
    payment_transaction_by_store = PaymentTransaction.where(status: "success", created_at: date.beginning_of_day..date.end_of_day).group_by{|pt| pt.franchise_location_id}
    payment_transaction_by_store.each do |franchise_location_id, payment_transactions|
      total_sales = 0
      total_delivery = 0
      total_tax = 0
      total_tips = 0
      total_subtotal = 0
      transactions = []
      content = ""
      franchise_location = FranchiseLocation.find(franchise_location_id)
      payment_transactions.each do |payment_transaction|
        order = payment_transaction.order
        transactions << {
          order_id: order.ordered_at.to_i,
          id: order.id,
          tip_amount: number_to_currency(order.tip_amount),
          delivery_amount: number_to_currency(order.delivery),
          tax: number_to_currency((order.for_pickup ? order.sales_tax : order.sales_tax_inc_delivery)),
          subtotal: number_to_currency(order.total_price),
          total: number_to_currency(order.total_price_including_sales_tax_inc_delivery)
        }
        total_sales += order.total_price_including_sales_tax_inc_delivery
        total_delivery += order.delivery
        total_tax += (order.for_pickup ? order.sales_tax : order.sales_tax_inc_delivery)
        total_tips += order.tip_amount
        total_subtotal += order.total_price
      end
      content = %{
        <p><b>#{franchise_location.address}</b></p>
        <ul>
          <li><b>Total Tax:</b> #{number_to_currency(total_tax)}</li>
          <li><b>Total Delivery:</b> #{number_to_currency(total_delivery)}</li>
          <li><b>Total Tips:</b> #{number_to_currency(total_tips)}</li>
          <li><b>Total Subtotal:</b> #{number_to_currency(total_subtotal)}
          <li><b>Total Sales:</b> #{number_to_currency(total_sales)}</li>
        </ul>
      }
      transactions.each do |transaction|
        content += transaction.to_yaml.indent(4) + "\n<br />"
      end
      ActionMailer::Base.mail(
        content_type: "text/html",
        from: "info@pizzaiolo.ca",
        to: franchise_location.email,
        cc: "manpreet@metawarelabs.com, luigi@pizzaiolo.ca, patfinelli@pizzaiolo.ca",
        subject: "Online Transaction Payment Summary - #{franchise_location.address} - #{date.strftime(DATE_ONLY_FORMAT)}",
        body: content.html_safe
      ).deliver
    end
  end

  desc "generate orders reports total"
  task :orders_revenue => :environment do
    reports_enabled?
    start_time = Time.parse("2020-01-05").beginning_of_day
    end_time = Time.parse("2020-02-01").end_of_day
    ranges = get_ranges_new(start_time,end_time)
    order_export = {}
    date_ranges = []
    franchisees = FranchiseLocation.where(active: true)
    ranges.each_with_index do |range, index|
      date_ranges << "Week #{index+1} (#{range.first.strftime('%d %b')} - #{range.last.strftime('%d %b')})"
      franchisees.each do |fl|
        order_export[fl.address] = [] if order_export[fl.address].nil?
        order_export[fl.address] << Order.includes(:order_items).where(ordered: true, ordered_at: range, franchise_location_id: fl.id).map(&:total_price).sum.to_f
      end
    end
    file_name = "order_export_revenue_#{Time.now.strftime("%m_%d_%Y")}.csv"
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv <<  ([""] + date_ranges)
      order_export.each do |key, val|
        csv << [key] + val
      end
    end
    OrderMailer.send_orders_revenue_report(file_name).deliver
  end

  desc "generate orders report by delivery method"
  task :delivery_method => :environment do
    reports_enabled?
    start_time = Time.parse("2020-01-05").beginning_of_day
    end_time = get_ranges(start_time).last(2).first.end
    franchisees = FranchiseLocation.where(active: true)
    file_name = "delivery_report_#{Time.now.strftime("%m_%d_%Y")}.csv"
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv << ["Restaurant Location", "Pick Up", "Delivery"]
      franchisees.each do |franchisee|
        pickup_count = franchisee.orders.where(for_pickup: true, ordered_at: start_time..(end_time)).count
        delivery_count = franchisee.orders.where(for_pickup: false, ordered_at: start_time..(end_time)).count
        csv << [franchisee.address, pickup_count, delivery_count]
      end
    end

    OrderMailer.send_delivery_report(file_name).deliver
  end

  desc 'generate customer data'
  task :customer_data => :environment do
    reports_enabled?
    franchise_location = FranchiseLocation.find(ENV['location_id'] || 26)
    orders = Order.where(ordered: true, franchise_location_id: ENV['location_id'] || 26)
    file_name = "customer_data_#{franchise_location.address.parameterize.underscore}_#{Time.now.strftime("%m_%d_%Y")}.csv"
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv << ["customer name", "phone number", "address_1", "address_2", "city", "postal_code", "email", "created_at"]
      orders.each do |order|
        csv << ["#{order.first_name} #{order.last_name}", "#{order.phone_number}", "#{order.address_1}", "#{order.address_2}", "#{order.city}", "#{order.postal_code}", "#{order.email}", "#{order.created_at}"]
      end
    end
    OrderMailer.send_delivery_report(file_name).deliver
  end

  desc 'generate all customer data'
  task :all_customer_data => :environment do
    reports_enabled?
    franchise_locations = FranchiseLocation.where(active: true)
    file_name = "all_customer_data_#{Time.now.strftime("%m_%d_%Y")}.csv"
    start_date = Time.parse("15-12-2017").beginning_of_day
    end_date = Time.parse("15-12-2019").end_of_day
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv << ["customer name", "phone number", "address_1", "address_2", "city", "postal_code", "email", "created_at", "franchise location"]
      franchise_locations.each do |franchise_location|
        orders = Order.where(ordered: true, franchise_location_id: franchise_location.id, created_at: start_date..end_date)
        orders.each do |order|
          csv << ["#{order.first_name} #{order.last_name}", "#{order.phone_number}", "#{order.address_1}", "#{order.address_2}", "#{order.city}", "#{order.postal_code}", "#{order.email}", "#{order.created_at}", "#{franchise_location.address}"]
        end
      end
    end
    OrderMailer.send_customers_report(file_name).deliver
  end

  desc 'generate all locations delivery hours'
  task :locations_delivery_hours => :environment do
    franchisees = FranchiseLocation.where(active: true)
    file_name = "locations_delivery_hours_#{Time.now.strftime("%m_%d_%Y")}.csv"
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv << ["Address", "Phone","Area Name", "Monday Delivery Open","Monday Delivery Close", "Tuesday Delivery Open","Tuesday Delivery Close", "Wednesday Delivery Open","Wednesday Delivery Close", "Thursday Delivery Open","Thursday Delivery Close", "Friday Delivery Open","Friday Delivery Close", "Saturday Delivery Open","Saturday Delivery Close", "Sunday Delivery Open","Sunday Delivery Close"]
      franchisees.each do |fl|
        csv << [
          fl.address,
          fl.phone,
          fl.area_name,
          fl.send("mon_full_day_close") ? 'CLOSED' : fl.delivery_mon_open.to_s(:time),
          fl.send("mon_full_day_close") ? 'CLOSED' : fl.delivery_mon_closed.to_s(:time),
          fl.send("tue_full_day_close") ? 'CLOSED' : fl.delivery_tue_open.to_s(:time),
          fl.send("tue_full_day_close") ? 'CLOSED' : fl.delivery_tue_closed.to_s(:time),
          fl.send("wed_full_day_close") ? 'CLOSED' : fl.delivery_wed_open.to_s(:time),
          fl.send("wed_full_day_close") ? 'CLOSED' : fl.delivery_wed_closed.to_s(:time),
          fl.send("thu_full_day_close") ? 'CLOSED' : fl.delivery_thu_open.to_s(:time),
          fl.send("thu_full_day_close") ? 'CLOSED' : fl.delivery_thu_closed.to_s(:time),
          fl.send("fri_full_day_close") ? 'CLOSED' : fl.delivery_fri_open.to_s(:time),
          fl.send("fri_full_day_close") ? 'CLOSED' : fl.delivery_fri_closed.to_s(:time),
          fl.send("sat_full_day_close") ? 'CLOSED' : fl.delivery_sat_open.to_s(:time),
          fl.send("sat_full_day_close") ? 'CLOSED' : fl.delivery_sat_closed.to_s(:time),
          fl.send("sun_full_day_close") ? 'CLOSED' : fl.delivery_sun_open.to_s(:time),
          fl.send("sun_full_day_close") ? 'CLOSED' : fl.delivery_sun_closed.to_s(:time)
        ]
      end
    end
    OrderMailer.send_locations_delivery_hours_report(file_name).deliver!
  end

  desc "generate pickup orders counts for specifice franchise loction"
  task :pickup_orders_count => :environment do
    reports_enabled?
    start_time = (Time.now - 24.months).beginning_of_day
    end_time = Time.now.end_of_day
    
    franchisee = FranchiseLocation.where(address: "550 Yonge Street", active: true).first
    if franchisee.present?
      file_name = "#{franchisee.address}_pickup_orders_count_#{Time.now.strftime("%m_%d_%Y")}.csv"
      CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
        csv << ["Franchisee Location", "Pick Up Order Count"]
        pickup_count = franchisee.orders.where(for_pickup: true, ordered_at: start_time..(end_time)).count
        csv << [franchisee.address, pickup_count]
      end
    end
    OrderMailer.send_pickup_orders_count(file_name).deliver
  end

  desc "generate all customer data 01-12-2017_to_01-12-2019"  
  task :generate_customer_data_last_two_year => :environment do
    reports_enabled?
    start_date = Time.parse("01-01-2018").beginning_of_day
    end_date = Time.parse("11-02-2020").end_of_day
    file_name = "all_customer_data_01-01-2018_to_11-02-2020.csv"
    customers_data = Customer.where(active: true, created_at: start_date..end_date)
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv << ["customer name", "phone number", "address_1", "address_2", "city", "postal_code", "email", "created_at", "last_sign_in_at"]
      customers_data.each do |customer|
        csv << ["#{customer.first_name} #{customer.last_name}", "#{customer.phone_number}", "#{customer.address_1}", "#{customer.address_2}", "#{customer.city}", "#{customer.postal_code}", "#{customer.email}", "#{customer.created_at}", "#{customer.last_sign_in_at}"]
      end
    end
    OrderMailer.send_customers_report(file_name).deliver
  end

  desc "generate orders email for specifice franchise loction"
  task :loction_email_export => :environment do
    reports_enabled?
    start_date = (Time.now - 24.months).beginning_of_day
    end_date = Time.now.end_of_day
    
    franchise_locations = FranchiseLocation.where(address: "550 Yonge Street", active: true)
    if franchise_locations.present?
      file_name = "550 Yonge Street_orders_email.csv"
      CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
        csv << ["customer name", "phone number", "address_1", "address_2", "city", "postal_code", "email", "created_at", "franchise location"]
        franchise_locations.each do |franchise_location|
          orders = Order.where(ordered: true, franchise_location_id: franchise_location.id, created_at: start_date..end_date)
          orders.each do |order|
            csv << ["#{order.first_name} #{order.last_name}", "#{order.phone_number}", "#{order.address_1}", "#{order.address_2}", "#{order.city}", "#{order.postal_code}", "#{order.email}", "#{order.created_at}", "#{franchise_location.address}"]
          end
        end
      end
    end
    OrderMailer.send_customers_report(file_name).deliver
  end

end

def get_ranges(start_time)
  ranges = []
  date = start_time
  while date < Time.now
    next_date = (date+7.days).end_of_day
    days_until_end_of_month = ((next_date - next_date.end_of_month) / 86400).abs
    # if days_until_end_of_month >= 6
      ranges << ((date.beginning_of_day)..(next_date-1.day))
      date = next_date.end_of_day
    # else
    #   ranges << ((date.beginning_of_day)..(next_date.end_of_month))
    #   date = (next_date.end_of_month + 1.day).end_of_day
    # end
  end
  return ranges
end

def get_ranges_new(start_time,end_time)
  ranges = []
  date = start_time
  while date < end_time
    next_date = (date+7.days).end_of_day
    days_until_end_of_month = ((next_date - next_date.end_of_month) / 86400).abs
    # if days_until_end_of_month >= 6
      ranges << ((date.beginning_of_day)..(next_date-1.day))
      date = next_date.end_of_day
    # else
    #   ranges << ((date.beginning_of_day)..(next_date.end_of_month))
    #   date = (next_date.end_of_month + 1.day).end_of_day
    # end
  end
  return ranges
end

def reports_enabled?
  if !ENV['REPORTS_ENABLED']
    puts "reports are not enabled on this image"
    return 
  end
end




# nohup bundle exec rake reports:orders --trace > /tmp/order.out 2>&1 &
# nohup bundle exec rake reports:orders_revenue --trace > /tmp/orders_revenue.out 2>&1 &
# nohup bundle exec rake reports:delivery_method --trace > /tmp/delivery_method.out 2>&1 &



# nohup bundle exec rake reports:loction_email_export --trace > /tmp/loction_email_export.out 2>&1 &



# nohup bundle exec rake reports:customer_data --trace > /tmp/customer_data.out 2>&1 &
