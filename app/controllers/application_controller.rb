require 'rack/turnout'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :franchise_location_set
  before_filter :session_order

  def session_order
    @order = Order.find_by_id(session[:order_id]) if session[:order_id]
  end
  def franchise_location_set
    unless session[:franchise_location_id]
      @location_set = false
    else
      @location_set = true
    end
    
    puts "location set? #{@location_set}"
    if session[:franchise_location_id]
      puts "location set to: #{session[:franchise_location_id]} "
    end
    
  end
  
  
  
  
  # devise custom redirects on login
  
  def after_sign_in_path_for(resource)
  
    
    # custom login pages depending on type and status
    
    if resource.class.name == 'Customer'
      
      puts params[:customer][:goto_pickup] if params[:customer] && params[:customer][:goto_pickup]
      
      if params[:customer] && params[:customer][:goto_pickup] == "1"
        return orders_pickup_path
      elsif params[:customer] && params[:customer][:goto_delivery] == "1"
        return orders_delivery_path
      else
        return customers_path
      end
      
    end
    
    
    if resource.class.name == 'Admin'
      return admins_path
    end
    
    
  end
  
  
  
  
  # FORCE to implement content_for in controller
    def view_context
      super.tap do |view|
        (@_content_for || {}).each do |name,content|
          view.content_for name, content
        end
      end
    end
    def content_for(name, content) # no blocks allowed yet
      @_content_for ||= {}
      if @_content_for[name].respond_to?(:<<)
        @_content_for[name] << content
      else
        @_content_for[name] = content
      end
    end
    def content_for?(name)
      @_content_for[name].present?
    end  
  
end
