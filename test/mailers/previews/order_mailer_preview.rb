class OrderMailerPreview < ActionMailer::Preview
  
  # helper :application
  
  # emails for the ordering customers
  def order_confirmation_email
    OrderMailer.order_confirmation_email(Order.last)
  end
  
  # emails for admins (setup to receive alerts)
  def admin_order_confirmation_email(order_id,admin_id)
    @order = Order.find(order_id)
    @admin = Admin.find(admin_id)
    mail(:to => @admin.email, :subject => "Pizzaiolo.ca Order Information")
  end
  
  # emails for franchise locations (setup to receive alerts)
  def franchise_location_order_confirmation_email(id)
    @order = Order.find(id)
    if @order.franchise_location.receive_order_confirmation_emails?
      mail(:to => @order.franchise_location.email, :subject => "Pizzaiolo.ca Order Information")
    end
  end
  
end


