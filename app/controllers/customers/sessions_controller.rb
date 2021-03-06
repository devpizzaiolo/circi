class Customers::SessionsController < DeviseController
  
    prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
    prepend_before_filter :allow_params_authentication!, :only => :create
    prepend_before_filter { request.env["devise.skip_timeout"] = true }

    # GET /resource/sign_in
    def new
      self.resource = build_resource(nil, :unsafe => true)
      clean_up_passwords(resource)
      respond_with(resource, serialize_options(resource))
      
      puts "EXTENDED BITCHES!"
    end

    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    end

    # DELETE /resource/sign_out
    def destroy
      
      redirect_path = after_sign_out_path_for(resource_name)
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message :notice, :signed_out if signed_out && is_navigational_format?
      
      
      # clean up the cart and reset to be not attached to customer account...
      if session[:order_id]
        @order = Order.find_by_id(session[:order_id])
      end
      
      if @order
        unless @order.ordered?
          @order.update_attributes(:customer_id => nil)
        end
      end
      
      # delete the session variable for the order...
      session.delete(:order_id)
      
      

      # We actually need to hardcode this as Rails default responder doesn't
      # support returning empty response on GET request
      respond_to do |format|
        format.all { head :no_content }
        format.any(*navigational_formats) { redirect_to redirect_path }
      end
      
    end

    protected

    def serialize_options(resource)
      methods = resource_class.authentication_keys.dup
      methods = methods.keys if methods.is_a?(Hash)
      methods << :password if resource.respond_to?(:password)
      { :methods => methods, :only => [:password] }
    end

    def auth_options
      { :scope => resource_name, :recall => "#{controller_path}#new" }
    end
    
end