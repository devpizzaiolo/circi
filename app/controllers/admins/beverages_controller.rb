class Admins::BeveragesController < ApplicationController
	before_filter :authenticate_admin!
	layout  "admin"
	
	def index
	  @beverages = Beverage.all
	end
	
	def edit
	  @beverage = Beverage.find_by_id(params[:id])
	end
	
	def update
	  @beverage = Beverage.find_by_id(params[:id])
	  
	  if @beverage.update_attributes(params[:beverage])
	    redirect_to admins_beverages_path, :notice => "Beverage Updated"
	  else
	    flash[:notice] = "There was a problem updating the Beverage"
	    render :edit
	  end
	  
	end
	
	def new
	  @beverage = Beverage.new
	end
	
	def create

	  @beverage = Beverage.new(params[:beverage])
	  
	  if @beverage.save
	    redirect_to admins_beverages_path, :notice => "Saved Beverage"
	  else
	    lash[:notice] = "There was a problem saving the Beverage"
	    render :new
	  end
	  
	end
	
	def destroy
	  
	  @beverage = Beverage.find_by_id(params[:id])
	  @beverage.destroy
	  redirect_to admins_beverages_path, :notice => "Beverage Deleted"

	end
end
