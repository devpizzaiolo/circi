class CustomersController < ApplicationController
  
  before_filter :authenticate_customer!
  
  def index
    
    # show orders
    @orders = current_customer.orders.where(:ordered => true).order("ordered_at DESC")
    
  end
  
  
end
