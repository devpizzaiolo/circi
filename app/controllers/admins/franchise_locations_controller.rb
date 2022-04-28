class Admins::FranchiseLocationsController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    @franchise_locations = FranchiseLocation.all
  end
  
  def new
    @franchise_location = FranchiseLocation.new
  end
  
  def create
    @franchise_location = FranchiseLocation.new(params[:franchise_location])
    if @franchise_location.save
      redirect_to admins_franchise_locations_path, :notice => "Franchise Location Saved."
    else
      flash[:notice] = "There was a problem creating the location."
      render :new
    end
  end
  
  def edit
    @franchise_location = FranchiseLocation.find(params[:id])
  end
  
  def update
    @franchise_location = FranchiseLocation.find(params[:id])
    
    if @franchise_location.update_attributes(params[:franchise_location])
      redirect_to admins_franchise_locations_path, :notice => "Franchise Location Updated."
    else
      flash[:notice] = "There was a problem editing the location."
      render :edit
    end
  end
  
  
end
