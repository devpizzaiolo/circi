class OrdersForPickupController < ApplicationController
  
  def index
    
    # find the order
    @order = Order.find_by_id(session[:order_id])
    session[:goto_url] = orders_for_pickup_path
    
  end
  
  
  
  
end
