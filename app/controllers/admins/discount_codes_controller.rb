class Admins::DiscountCodesController < ApplicationController

  before_filter :authenticate_admin!
  layout  "admin"

  def index
    @discount_codes = DiscountCode.all
  end

  def new
    @discount_code = DiscountCode.new
    @discount_code.discount_code_filters.build
  end

  def create

    @discount_code = DiscountCode.new(params[:discount_code])
    
    if @discount_code.save
      redirect_to admins_discount_codes_path, :notice => "Saved Discount Code"
    else
      flash[:notice] = "There was a problem saving the Discount Code: #{@discount_code.errors.full_messages.join(',')}"
      render :new
    end
  
  end

  def edit
    @discount_code = DiscountCode.find_by_id(params[:id])
  end

  def update
    @discount_code = DiscountCode.find_by_id(params[:id])
    
    if @discount_code.update_attributes(params[:discount_code])
      redirect_to admins_discount_codes_path, :notice => "Discount Code Updated"
    else
      flash[:notice] = "There was a problem updating the Discount Code: #{@discount_code.errors.full_messages.join(',')}"
      render :edit
    end
    
  end

  def destroy
    
    @discount_code = DiscountCode.find_by_id(params[:id])
    @discount_code.destroy
    redirect_to admins_discount_codes_path, :notice => "Discount Code Deleted"

  end

end