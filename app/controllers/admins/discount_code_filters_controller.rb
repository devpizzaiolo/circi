class Admins::DiscountCodeFiltersController < ApplicationController

  before_filter :authenticate_admin!
  layout  "admin"

  def index
    @discount_code_filters = DiscountCodeFilter.all
  end

  def new
    @discount_code_filter = DiscountCodeFilter.new
  end

  def create

    @discount_code_filter = DiscountCodeFilter.new(params[:discount_code_filter])

    if @discount_code_filter.save
      redirect_to admins_discount_code_filters_path, :notice => "Saved Discount Code Filter"
    else
      flash[:notice] = "There was a problem saving the Discount Code Filter:  #{@discount_code_filter.errors.full_messages.join(',')}"
      render :new
    end
  
  end

  def edit
    @discount_code_filter = DiscountCodeFilter.find_by_id(params[:id])
  end

  def update

    @discount_code_filter = DiscountCodeFilter.find_by_id(params[:id])

    if @discount_code_filter.update_attributes(params[:discount_code_filter])
      redirect_to admins_discount_code_filters_path, :notice => "Discount Code Filter Updated"
    else
      flash[:notice] = "There was a problem updating the Discount Code Filter:  #{@discount_code_filter.errors.full_messages.join(',')}"
      render :edit
    end
    
  end

  def destroy
    
    @discount_code_filter = DiscountCodeFilter.find_by_id(params[:id])
    @discount_code_filter.destroy
    redirect_to admins_discount_code_filters_path, :notice => "Discount Code Filter Deleted"

  end

end