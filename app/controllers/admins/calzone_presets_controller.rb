class Admins::CalzonePresetsController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    @calzone_presets = CalzonePreset.all
  end
  
  def edit
    @calzone_preset = CalzonePreset.find_by_id(params[:id])
  end
  
  def update
    @calzone_preset = CalzonePreset.find_by_id(params[:id])
    
    params[:calzone_preset][:product_info] = params[:product]
    params[:calzone_preset][:product_info][:product_name] = params[:calzone_preset][:product_name]
    params[:calzone_preset][:product_info][:product_type] = 'calzone'
    params[:calzone_preset][:product_info][:calzone_preset_id] = @calzone_preset.id
    
    if @calzone_preset.update_attributes(params[:calzone_preset])
      redirect_to admins_calzone_presets_path, :notice => "Calzone Preset Updated"
    else
      flash[:notice] = "There was a problem updating the preset"
      render :edit
    end
    @calzone_preset.update_attributes(params[:calzone_preset])
    
    # expire_fragment("calzone_selection")
    
  end
  
  
  def new
    @calzone_preset = CalzonePreset.new
  end
  
  def create

    @calzone_preset = CalzonePreset.new(params[:calzone_preset])
    @calzone_preset.save
    
    # save the setup of the calzone
    params[:calzone_preset][:product_info] = params[:product]
    params[:calzone_preset][:product_info][:product_name] = params[:calzone_preset][:product_name]
    params[:calzone_preset][:product_info][:product_type] = 'calzone'
    params[:calzone_preset][:product_info][:calzone_preset_id] = @calzone_preset.id
    
    if @calzone_preset.update_attributes(params[:calzone_preset])
      redirect_to admins_calzone_presets_path, :notice => "Saved the Calzone Preset"
    else
      render :new
    end
    
    # expire_fragment("calzone_selection")
    
  end
  
  def destroy
    @calzone_preset = CalzonePreset.find_by_id(params[:id])
    @calzone_preset.destroy
    
    # expire_fragment("calzone_selection")

    redirect_to admins_calzone_presets_path, :notice => "Calzone Presst Deleted"

  end
  
end
