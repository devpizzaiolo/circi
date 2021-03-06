class PrintOrderWorker
  
  include Sidekiq::Worker
  sidekiq_options :retry => 4, :queue => "critical"
  
  def perform(id)
    
    @order = Order.find(id)
    
    unless @order.sent_to_printer?
    
      if Rails.env.development?
        # home printer ( on static IP )
        # printer = Rescpos::Printer.open("192.168.0.38", 9100)
        printer = Rescpos::Printer.open("192.168.2.29", 9100)
      end
      
      if Rails.env.production?
        # store printer
        printer = Rescpos::Printer.open(@order.franchise_location.printer_ip.to_s, @order.franchise_location.printer_port.to_i)
      end
        
      report = PrintOrderReport.new(id)
      printer.print_report(report, :encoding => "UTF-8//IGNORE")
      printer.close
      
      # Prevent further prints
      @order.update_attributes(:sent_to_printer => true)
    
    end
    
    unless @order.email_sent?
      
      # Send Email confirmations
      @order.email_confirmation_to_customer
      @order.email_confirmation_to_admins
      @order.email_confirmation_to_franchise_location
      
      # Prevent further sends
      @order.update_attributes(:email_sent => true)
      
    end
    
  end
  
end