class Customers::CustomersController < ApplicationController
  
  before_filter :authenticate_customer!
  
  def index
    # show the account details
  end
  
  def edit
    @customer = current_customer
  end
  
  def update
    @customer = current_customer
    
    if params[:customer][:password].blank?
      params[:customer].delete("password")
      params[:customer].delete("password_confirmation")
    end
    
    if @customer.update_attributes(params[:customer])
      sign_in @customer, :bypass => true
      redirect_to customers_customers_path, :notice => "Your Account Profile has been updated."
    else
      flash[:notice] = "There was a problem updating your Account Profile"
      render :edit
    end
  end

end
