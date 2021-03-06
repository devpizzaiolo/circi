class Admins::AdBoxesController < ApplicationController
  
  before_filter :authenticate_admin!
  
  
  def index
    @ad_boxes = AdBox.all
  end
  
  def new
    @ad_box = AdBox.new
  end
  
  def create
    @ad_box = AdBox.new(params[:ad_box])
    if @ad_box.save
      redirect_to admins_ad_boxes_path, :notice => "The Ad Box was successfully uploaded to the system."
    else
      flash[:error] = "There was a problem uploading the Ad Box to the system."
      render :new
    end
  end
  
  def edit
    @ad_box = AdBox.find_by_id(params[:id])
  end
  
  def update
    @ad_box = AdBox.find_by_id(params[:id])
    if @ad_box.update_attributes(params[:ad_box])
      redirect_to admins_ad_boxes_path, :notice => "The ad_box was successfully updated on the system."
    else
      flash[:error] = "There was a problem updating the Ad Box to the system."
      render :edit
    end
  end
  
  def destroy
    @ad_box = AdBox.find_by_id(params[:id])
    @ad_box.destroy
    redirect_to admins_ad_boxes_path, :notice => "The Ad Box was deleted on the system."
  end
  
  
end
