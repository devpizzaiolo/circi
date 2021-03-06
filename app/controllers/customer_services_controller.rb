class CustomerServicesController < ApplicationController  
  before_filter :set_page_title
  
  def new
    @customer_service = CustomerService.new
  end
  
  def create
    
    @customer_service = CustomerService.new(params[:customer_service])
    
    if @customer_service.save_with_captcha
      CustomerServiceMailer.service_request_email(@customer_service.id).deliver
      redirect_to customer_service_path(1)
    else
      puts "NOT SAVED!!!!!"
      flash[:error] = "<strong>There was a problem sending your comment</strong><br />Please verify your info below and try again."
      render :new
    end
    
  end
  
  def show
    # show the thank-you message
  end
  
  private
    def set_page_title
      content_for :title, "Customer Service"
      @heading = "customer_service"
      @header = "customer_service"
    end
  
  
end
