class Admins::GarlicBreadsController < ApplicationController

  before_filter :authenticate_admin!
  layout  "admin"

  def index
    @garlic_breads = GarlicBread.all
  end

  def new
    @garlic_bread = GarlicBread.new
  end

  def edit
    @garlic_bread = GarlicBread.find_by_id(params[:id])
  end

  def create

    @garlic_bread = GarlicBread.new(params[:garlic_bread])
    
    if @garlic_bread.save
      redirect_to admins_garlic_breads_path, :notice => "Saved Garlic Bread"
    else
      lash[:notice] = "There was a problem saving the Garlic Bread"
      render :new
    end
    
  end

  def update
    @garlic_bread = GarlicBread.find_by_id(params[:id])
    
    if @garlic_bread.update_attributes(params[:garlic_bread])
      redirect_to admins_garlic_breads_path, :notice => "Garlic Bread Updated"
    else
      flash[:notice] = "There was a problem updating the Garlic Bread"
      render :edit
    end
    
  end

  def destroy
    
    @garlic_bread = GarlicBread.find_by_id(params[:id])
    @garlic_bread.destroy
    redirect_to admins_garlic_breads_path, :notice => "Garlic Bread Deleted"

  end
  
end