class Admins::OrderPrinterStatusController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    @franchise_locations = FranchiseLocation.order('address ASC')
  end
  
  def send_test_to_printer
    
    # real time send.
    
		begin
		  timeout(1) do
        if Rails.env.development?
          # home printer ( on static IP )
          # printer = Rescpos::Printer.open("192.168.0.38", 9100)
           printer = Rescpos::Printer.open("192.168.2.29", 9100)
        end
    
        if Rails.env.production?
          @location = FranchiseLocation.find(params[:id])
          # store printer
          printer = Rescpos::Printer.open(@location.printer_ip.to_s, @location.printer_port.to_i)
        end
      
        report = PrintTestReport.new
    
        printer.print_report(report, :encoding => "UTF-8//IGNORE")
        printer.close
        
        redirect_to admins_order_printer_status_path, :notice => "Printer Test OK."
        
		  end
		rescue
      redirect_to admins_order_printer_status_path, :alert => "Printer Test Failed."
		  return false
		end
    
    
  end
  
end
