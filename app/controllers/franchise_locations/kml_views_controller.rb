class FranchiseLocations::KmlViewsController < ApplicationController
  
  def show
    @franchise_locations = FranchiseLocation.find(params[:id])
  end

  def index
  end

 
  
end
