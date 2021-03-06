class Admins::TodaysOrdersController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    
    if params[:end_date] && params[:end_date]
      # filtered for colorshadow and tests
      
      start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
      
      @orders = Order.where("ordered = ? AND ordered_at > ? AND ordered_at < ? AND LOWER(email) NOT LIKE '%sdf%' AND LOWER(first_name) NOT LIKE '%test%' AND LOWER(last_name) NOT LIKE '%test%'", true, start_date.beginning_of_day, end_date.end_of_day)
    else
      # filtered for colorshadow and tests
      @orders = Order.where("ordered = ? AND ordered_at > ? AND ordered_at < ? AND LOWER(email) NOT LIKE '%sdf%' AND LOWER(first_name) NOT LIKE '%test%' AND LOWER(last_name) NOT LIKE '%test%'", true, Date.today.beginning_of_day, Date.today.end_of_day)
    end
    
  end
  
end
