class Admins::FlyersController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    @flyers = Flyer.all
  end
  
  def new
    @flyer = Flyer.new
  end
  
  def create
    @flyer = Flyer.new(params[:flyer])
    if @flyer.save
      redirect_to admins_flyers_path, :notice => "The flyer was successfully uploaded to the system."
    else
      flash[:error] = "There was a problem uploading the flyer to the system."
      render :new
    end
  end
  
  def edit
    @flyer = Flyer.find_by_id(params[:id])
  end
  
  def update
    @flyer = Flyer.find_by_id(params[:id])
    if @flyer.update_attributes(params[:flyer])
      redirect_to admins_flyers_path, :notice => "The flyer was successfully updated on the system."
    else
      flash[:error] = "There was a problem updating the flyer to the system."
      render :edit
    end
  end
  
  def destroy
    @flyer = Flyer.find_by_id(params[:id])
    @flyer.destroy
    redirect_to admins_flyers_path, :notice => "The flyer was deleted on the system."
  end
  
end
