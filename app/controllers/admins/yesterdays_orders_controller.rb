class Admins::YesterdaysOrdersController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    
    if params[:end_date] && params[:end_date]
      @start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      @end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
      @orders = Order.where("ordered = ? AND ordered_at > ? AND ordered_at < ?", true, @start_date.beginning_of_day, @end_date.end_of_day)
    else
      @orders = Order.where("ordered = ? AND ordered_at > ? AND ordered_at < ?", true, Date.yesterday.beginning_of_day, Date.yesterday.end_of_day)
    end
    
  end
  
  def download
    
    if params[:end_date] && params[:end_date]
      @start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      @end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
      @orders = Order.where("ordered = ? AND ordered_at > ? AND ordered_at < ?", true, @start_date.beginning_of_day, @end_date.end_of_day)
    else
      @orders = Order.where("ordered = ? AND ordered_at > ? AND ordered_at < ?", true, Date.yesterday.beginning_of_day, Date.yesterday.end_of_day)
    end
    
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
    
    timestamp = Time.now.strftime('%Y-%m-%d_%H:%M:%S')
    send_data csv_string,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=yesterdays_orders_#{timestamp}.csv"
        
  end

  def download_date
    @start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
    @end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)

    # ExportWorker.perform_async(@start_date, @end_date)

    redirect_to admins_yesterdays_orders_path, :notice => "You will receive an e-mail when your request is finished."
        
  end
  
end
