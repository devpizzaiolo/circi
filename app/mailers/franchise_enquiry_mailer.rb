class FranchiseEnquiryMailer < ActionMailer::Base
  
  helper :application
  
  default from: "notifications@pizzaiolo.ca"
  
  # emails for the ordering customers
  def franchise_enquiry_email(id)
    @franchise_enquiry = FranchiseEnquiry.find(id)
    # mail(:to => 'alida@pizzaiolo.ca', :subject => "Pizzaiolo.ca : Franchise Enquiry")
    mail(:to => 'franchise@pizzaiolo.ca, mnarang@colorshadow.com, luigi@pizzaiolo.ca', :subject => "Pizzaiolo.ca : Franchise Enquiry")
  end
  
end
