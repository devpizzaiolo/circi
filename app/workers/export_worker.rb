class ExportWorker
  include Sidekiq::Worker

  sidekiq_options :queue => "low", :retry => false

  def perform(start_date, end_date)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    
    @orders = Order.where("ordered = ? AND ordered_at > ? AND ordered_at < ?", true, @start_date.beginning_of_day, @end_date.end_of_day)
    
    require 'csv'
    
    csv_string = CSV.generate do |csv|
      
      csv << ["Order ID", "Has Account", "Ordered At", "Type Of Order", "First Name", "Last Name", "Address 1", "Address 2", "Postal Code", "Phone", "Pizzaiolo Location", "Total Price", "Delivery", "Tax" ,"Order Total"]
      
      @orders.each do |order|
        if order.for_pickup?
          delivery_type = "Pickup"
        else
          delivery_type = "Delivery"
        end
        
        if order.has_account == true
          has_account = "Yes"
        else
          has_account = "No"
        end
        
        csv << [order.order_number, has_account, order.ordered_at.strftime("%B %d, %Y %I:%M %p"), delivery_type, order.first_name, order.last_name, order.delivery_address_1, order.delivery_address_2, order.delivery_postal_code, order.phone_number, order.franchise_location.address, order.total_price_formatted, order.delivery_formatted, order.sales_tax_inc_delivery_formatted, order.total_price_including_sales_tax_inc_delivery_formatted]
      
      end
    end

    
    timestamp_start = @start_date.strftime('%Y-%m-%d')
    timestamp_end = @end_date.strftime('%Y-%m-%d')
    date_string = "orders_" + timestamp_start + "_" + timestamp_end

    OrderMailer.send_csv(date_string, csv_string).deliver
    # send_data csv_string, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=orders_#{timestamp_start}_#{timestamp_end}.csv"

  end

end