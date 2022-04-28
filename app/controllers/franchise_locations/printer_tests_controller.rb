class FranchiseLocations::PrinterTestsController < ApplicationController
  
  def index
    @franchise_locations = FranchiseLocation.where(:active => true).order('address ASC')
  end
  
end
