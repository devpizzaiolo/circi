class FranchiseEnquiriesController < ApplicationController
  
  def create
    @fe_ok = false
    @franchise_enquiry = FranchiseEnquiry.new(params[:franchise_enquiry])
    if @franchise_enquiry.save_with_captcha
      @fe_ok = true
      FranchiseEnquiryMailer.franchise_enquiry_email(@franchise_enquiry.id).deliver
    else
      @fe_ok = false
    end
  end
  
end
