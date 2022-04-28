class SessionsController < Devise::SessionsController

    def destroy
      
      if session[:order_id]
        @order = Order.find_by_id(session[:order_id])
      end
      
      if @order
        unless @order.ordered?
          @order.update_attributes(:customer_id => nil)
        end
      end
      
      # order_id = session[:order_id]
      # franchise_location_id = session[:franchise_location_id]
      # super  
      # session[:order_id] = order_id
      # session[:franchise_location_id] = franchise_location_id
      
    end

end