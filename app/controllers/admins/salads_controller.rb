class Admins::SaladsController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    @salads = Salad.all
  end
  
  def edit
    @salad = Salad.find_by_id(params[:id])
  end
  
  def update
    @salad = Salad.find_by_id(params[:id])
    
    if @salad.update_attributes(params[:salad])
      redirect_to admins_salads_path, :notice => "Salad Updated"
    else
      flash[:notice] = "There was a problem updating the Salad"
      render :edit
    end
    
  end
  
  def new
    @salad = Salad.new
  end
  
  def create

    @salad = Salad.new(params[:salad])
    
    if @salad.save
      redirect_to admins_salads_path, :notice => "Saved Salad"
    else
      lash[:notice] = "There was a problem saving the Salad"
      render :new
    end
    
  end
  
  def destroy
    
    @salad = Salad.find(params[:id])
    @salad.destroy
    redirect_to admins_salads_path, :notice => "Salad Deleted"

  end
  
  
end
