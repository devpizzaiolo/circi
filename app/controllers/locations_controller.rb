class LocationsController < ApplicationController
  
  before_filter :set_heading
  
  def index
    @all_active_locations = FranchiseLocation.where(:active => true)
    if !params[:find_location_in_area].blank?
      @title = " | Find | " + params[:find_location_in_area] 
      @description = "Check out Pizzaiolo's menu of gourmet pizzas made with fresh, never frozen ingredients. A wide selection of gourmet meat, veggie, vegan and Gluten-Free pizzas. Order today!"
    else 
      @description = "Find your closest Pizzaiolo and get your gourmet pizza made with fresh ingredients daily. Order your favourite today!"
    end
    if (params[:find_location_near_me].blank? || params[:find_location_near_me] == "") && params[:find_location_in_area].blank?
      @locations = FranchiseLocation.where(:active => true).order("created_at DESC")
    else
      @locations = @all_active_locations
      if !params[:find_location_near_me].blank?
        myloc = ApplicationController.helpers.geo_code(params[:find_location_near_me])
        @locations = @locations.near(myloc, 10)
      end
      if !params[:find_location_in_area].blank?
        @locations = @locations.where(area_name: params[:find_location_in_area])
      end
    end
    @all_areas = [["Show All", ""]] + @all_active_locations.map(&:area_name).uniq.map{|x| [x, x] }
  end

  def late_night_index
    @locations = FranchiseLocation.late_night_locations
  end

  def show
    @location = FranchiseLocation.find_by_slug(params[:id]) || FranchiseLocation.find_by_id(params[:id])
    if @location.present? && @location.active
      @seo_metadescription = @location.seo_metadescription
      @seo_title = @location.seo_title
      @seo_keywords = @location.seo_keywords
    else
      redirect_to "/locations"
    end
    
  end
  
  def set_location
    
    unless params[:id] == "choose"
      @location = FranchiseLocation.find_by_id(params[:id])
    else
      @location = nil
    end
    
    if @location
      session[:franchise_location_id] = @location.id
      redirect_to orders_path, :notice => "Location has been set."
    else
      session.delete(:franchise_location_id)
      redirect_to :back, :notice => "Please select a location."
    end
    
  end
  
  def clear_location
    session.delete(:franchise_location_id)
    redirect_to orders_path, :notice => "Please select a location."
  end
  
  private
    def set_heading
      # content_for :title, "Locations"
      @heading = "locations"
      @header = "locations"
    end
end
