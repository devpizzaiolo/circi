class OrderMailer < ActionMailer::Base
  
  helper :application

  default from: "notifications@pizzaiolo.ca"
  
  # emails for the ordering customers
  def order_confirmation_email(id)
    @order = Order.find(id)
    mail(:to => @order.email, :subject => "Pizzaiolo.ca : Order Confirmation")
  end
  
  # emails for admins (setup to receive alerts)
  def admin_order_confirmation_email(order_id,admin_id)
    @order = Order.find(order_id)
    @admin = Admin.find(admin_id)
    mail(:to => @admin.email, :subject => "Pizzaiolo.ca Order Information")
  end

  # email for alert when online payment fails
  # emails :  luigi@pizzaiolo.ca, pat@pizzaiolo.ca, manpreet@metawarelabs.com
  def order_online_payment_fails_email(order_id)
    @order = Order.find(order_id)
    mail(:to => ['luigi@pizzaiolo.ca', 'pat@pizzaiolo.ca', 'manpreet@metawarelabs.com'],  bcc: ['sandeep@metawarelabs.com'], :subject => "Pizzaiolo.ca Order - Online Payment Failure")
  end
  
  # emails for franchise locations (setup to receive alerts)
  def franchise_location_order_confirmation_email(id)
    @order = Order.find(id)
    if @order.franchise_location.receive_order_confirmation_emails?
      mail(:to => @order.franchise_location.email, :subject => "Pizzaiolo.ca Order Information")
    end
  end


  # export csv
  def send_csv(date_s, csv)
    attachments[date_s + '.csv'] = {mime_type: 'text/csv', content: csv}
    mail(to: 'tech@colorshadow.com', subject: 'Pizzaiolo CSV generated', body: 'The CSV is ready! See attachment:')
  end

  def send_orders_report(file_name)
    @file_name = file_name
    @file_path = Rails.root + "tmp/#{@file_name}"
    attachments[@file_name] = File.read(@file_path)
    mail(to: ['manpreet@metawarelabs.com'], bcc: ['sandeep@metawarelabs.com','manish@metawarelabs.com'], subject: 'Orders Report', body: 'The CSV is ready! See attachment:')
  end

  def send_orders_revenue_report(file_name)
    @file_name = file_name
    @file_path = Rails.root + "tmp/#{@file_name}"
    attachments[@file_name] = File.read(@file_path)
    mail(to: ['manpreet@metawarelabs.com'], bcc: ['sandeep@metawarelabs.com','manish@metawarelabs.com'], subject: 'Orders Revenue Report', body: 'The CSV is ready! See attachment:')
  end

  def send_delivery_report(file_name)
    @file_name = file_name
    @file_path = Rails.root + "tmp/#{@file_name}"
    attachments[@file_name] = File.read(@file_path)
    mail(to: ['manpreet@metawarelabs.com'], bcc: ['sandeep@metawarelabs.com','manish@metawarelabs.com'], subject: 'Orders Delivery Report', body: 'The CSV is ready! See attachment:')
  end

  def send_locations_delivery_hours_report(file_name)
    @file_name = file_name
    @file_path = Rails.root + "tmp/#{@file_name}"
    attachments[@file_name] = File.read(@file_path)
    mail(to: ['sandeep@metawarelabs.com', 'manpreet@metawarelabs.com','manish@metawarelabs.com'], subject: 'Locations Delivery Hours Report', body: 'The CSV is ready! See attachment:')
  end

  def send_customers_report(file_name)
    @file_name = file_name
    @file_path = Rails.root + "tmp/#{@file_name}"
    attachments[@file_name] = File.read(@file_path)
    mail(to: ['manpreet@metawarelabs.com'], bcc: ['sandeep@metawarelabs.com','manish@metawarelabs.com'], subject: 'Customers Report', body: 'The CSV is ready! See attachment:')
  end

  def send_pizza_preset_report(file_name)
    @file_name = file_name
    @file_path = Rails.root + "tmp/#{@file_name}"
    attachments[@file_name] = File.read(@file_path)
    mail(to: ['manpreet@metawarelabs.com'], bcc: ['sandeep@metawarelabs.com','manish@metawarelabs.com'], subject: 'Pizza presets reports by SKUs', body: 'The CSV is ready! See attachment:')
  end

  def send_pizza_name_report(file_name)
    @file_name = file_name
    @file_path = Rails.root + "tmp/#{@file_name}"
    attachments[@file_name] = File.read(@file_path)
    mail(to: ['manpreet@metawarelabs.com'], bcc: ['sandeep@metawarelabs.com','manish@metawarelabs.com'], subject: 'Pizza Names', body: 'The CSV is ready! See attachment:')
  end
  
  def send_pickup_orders_count(file_name)
    @file_name = file_name
    @file_path = Rails.root + "tmp/#{@file_name}"
    attachments[@file_name] = File.read(@file_path)
    mail(to: ['manpreet@metawarelabs.com'], bcc: ['sandeep@metawarelabs.com', 'manish@metawarelabs.com','manish@metawarelabs.com'], subject: 'Pickup orders counts', body: 'The CSV is ready! See attachment:')
  end
end