class Admins::ToppingsController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    @toppings = Topping.order("name ASC")
  end
  
  def edit
    @topping = Topping.find_by_id(params[:id])
  end
  
  def update
    @topping = Topping.find_by_id(params[:id])
    
    if @topping.update_attributes(params[:topping])
      redirect_to admins_toppings_path, :notice => "Topping Updated"
    else
      flash[:notice] = "There was a problem updating the Topping"
      render :edit
    end
    @topping.update_attributes(params[:topping])
    
    # expire_fragment("calzone_selection")
    
  end
  
  def new
    @topping = Topping.new
  end
  
  def create

    @topping = Topping.new(params[:topping])
    
    if @topping.save
      redirect_to admins_toppings_path, :notice => "Saved Topping"
    else
      lash[:notice] = "There was a problem saving the Topping"
      render :new
    end
    
  end
  
  def destroy
    
    @topping = Topping.find_by_id(params[:id])
    @topping.destroy
    redirect_to admins_toppings_path, :notice => "Topping Deleted"

  end
  
end
