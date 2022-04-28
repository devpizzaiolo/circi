namespace :customer_survey do

  CUSTOMER_SURVEY_PERCENTAGE = 10
  desc 'export'
  task :export => :environment do
    reports_enabled?
    start_date = (Time.now - 17.days).beginning_of_day  #2020-02-17
    end_date = (Time.now - 5.days).end_of_day          #2020-02-29
    week_number = Time.now.strftime("%U").to_i
    year = Time.now.strftime("%Y").to_i
    file_name = "customer_survey_export_#{start_date.strftime("%m_%d_%Y")}_#{end_date.strftime("%m_%d_%Y")}_#{week_number}_#{year}.csv"
    CSV.open(Rails.root + "tmp/#{file_name}", "wb") do |csv|
      csv << ["customer name", "phone number", "address_1", "address_2", "city", "postal_code", "email", "created_at"]
      survey_emails = SurveyEmail.where(customer_survey_email_exported_at: (Time.now - 12.months)..Time.now).pluck(:email)
      if survey_emails.count > 0
        orders = Order.where(ordered_at: start_date..end_date, ordered: true).where("email NOT IN (?)", survey_emails)
      else 
        orders = Order.where(ordered_at: start_date..end_date, ordered: true)
      end
      orders_count = orders.count
      number_of_records_to_export = orders_count * CUSTOMER_SURVEY_PERCENTAGE/100
      orders = orders.limit(number_of_records_to_export > 0 ? number_of_records_to_export : 1) ## 10 percent

      orders.each do |order|
        csv << ["#{order.first_name} #{order.last_name}", "#{order.phone_number}", "#{order.address_1}", "#{order.address_2}", "#{order.city}", "#{order.postal_code}", "#{order.email}", "#{order.created_at}"]
        SurveyEmail.create!(email: order.email, customer_survey_email_exported_at: Time.now, week_and_year: "#{week_number}_#{year}")
      end
    end
    OrderMailer.send_customers_report(file_name).deliver
  end

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
# nohup bundle exec rake reports:customer_data --trace > /tmp/customer_data.out 2>&1 &
