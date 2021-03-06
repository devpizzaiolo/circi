class CustomerServiceMailer < ActionMailer::Base

  helper :application

  default from: "notifications@pizzaiolo.ca"

  def service_request_email(id)

    @customer_service = CustomerService.find(id)

    if Rails.env.production?
      # email_to = 'online@pizzaiolo.ca'

      email_to = "customercare@pizzaiolo.ca"
      #email_to = 'Rachel@pizzaiolo.ca'
    else
      email_to = 'mroby@colorshadow.com'
    end

    mail(:to => email_to, :subject => "Customer Support Request")

  end

end