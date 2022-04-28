class Customers::OrdersController < ApplicationController
  
  before_filter :authenticate_customer!

  
  def index
    
  end
  
  def show
    @order = current_customer.orders.find(params[:id])
  end
  
  def new_order_from_old
    order = current_customer.orders.find(params[:id])
    if order.items_unavailable > 0 
      redirect_to customers_path, :alert => "There are a few items no longer available, please create a new order to proceed."
    else
      my_copy = order.duplicate
      if my_copy.order_additional && my_copy.order_additional["cannolis"] && my_copy.order_additional["cannolis"].count > 0
        my_copy.order_additional["cannolis"]["cannoli_1"] = 0
      end
      my_copy.save
      if my_copy.order_items.count > 0
        my_copy.order_items.each do |oi|
          if oi.product_info['special_instructions'].blank?
            oi.product_info['special_instructions'] = "regular"
            oi.save
          end
        end
        my_copy.save
      end
      my_copy.update_attributes(:created_at => Time.now, :updated_at => Time.now, :ordered_at => nil, :special_instructions => nil, :to_be_ready_at => nil, :payment_method => nil, :ordered => false, :sent_to_printer => nil, :email_sent => nil)
      session[:order_id] = my_copy.id
      redirect_to details_path, :notice => "Your new order has been created, please review and continue."
    end 
  end

  def remove_address
    @address = Address.find_by_id(params[:id])
    if @address
      @address.is_deleted = true
      @address.save
      render json: { 
        status: "success",
        message: "Address Deleted."
      }
    else
      render json: { 
        status: "faild",
        message: "Address Not Deleted."
      }
    end
end
  
end
