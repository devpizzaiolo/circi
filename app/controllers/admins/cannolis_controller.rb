class Admins::CannolisController < ApplicationController

  before_filter :authenticate_admin!
  layout  "admin"

  def index
    @cannolis = Cannoli.all
  end

  def new
    @cannoli = Cannoli.new
  end

  def edit
    @cannoli = Cannoli.find_by_id(params[:id])
  end

  def create

    @cannoli = Cannoli.new(params[:cannoli])
    
    if @cannoli.save
      redirect_to admins_cannolis_path, :notice => "Saved Cannoli"
    else
      lash[:notice] = "There was a problem saving the Cannoli"
      render :new
    end
    
  end

  def update
    @cannoli = Cannoli.find_by_id(params[:id])
    
    if @cannoli.update_attributes(params[:cannoli])
      redirect_to admins_cannolis_path, :notice => "Cannoli Updated"
    else
      flash[:notice] = "There was a problem updating the Cannoli"
      render :edit
    end
    
  end

  def destroy
    
    @cannoli = Cannoli.find_by_id(params[:id])
    @cannoli.destroy
    redirect_to admins_cannolis_path, :notice => "Cannoli Deleted"

  end
  
end