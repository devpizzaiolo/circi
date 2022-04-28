class OrdersForDeliveryController < ApplicationController
  
  def index
    @order = Order.find_by_id(session[:order_id])
    session[:goto_url] = orders_for_delivery_path
  end
  
  
  
  
  
end
