class Admins::PizzaPresetsController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  
  def index
    @pizza_presets = PizzaPreset.order("product_name ASC")
  end
  
  def edit
    @pizza_preset = PizzaPreset.find_by_slug(params[:id])
  end
  
  def update
    @pizza_preset = PizzaPreset.find_by_slug(params[:id])
    
    params[:pizza_preset][:product_info] = params[:product]
    params[:pizza_preset][:product_info][:product_name] = params[:pizza_preset][:product_name]
    params[:pizza_preset][:product_info][:product_type] = 'pizza'
    params[:pizza_preset][:product_info][:pizza_preset_id] = @pizza_preset.id
    
    if @pizza_preset.update_attributes(params[:pizza_preset])
      redirect_to admins_pizza_presets_path, :notice => "Pizza Prest Updated"
    else
      flash[:notice] = "There was a problem updating the preset"
      render :edit
    end
    # expire_fragment("pizza_selection")
    # @pizza_preset.update_attributes(params[:pizza_preset])
  end
  
  def new
    
    # use the create your own as a base pizza to generate the new one...
    @pizza_category = PizzaCategory.where(:direct_edit => true).first
    @base_pizza = @pizza_category.pizza_presets.first
    @pizza_preset = PizzaPreset.new
    @pizza_preset.product_info = @base_pizza.product_info
    
  end
  
  def create

    @pizza_preset = PizzaPreset.new(params[:pizza_preset])
    @pizza_preset.save
    
    # save the setup of the pizza
    params[:pizza_preset][:product_info] = params[:product]
    params[:pizza_preset][:product_info][:product_name] = params[:pizza_preset][:product_name]
    params[:pizza_preset][:product_info][:product_type] = 'pizza'
    params[:pizza_preset][:product_info][:pizza_preset_id] = @pizza_preset.id
    
    if @pizza_preset.update_attributes(params[:pizza_preset])
      redirect_to admins_pizza_presets_path, :notice => "Saved the Pizza Preset"
    else
      render :new
    end
    
    # expire_fragment("pizza_selection")
    
  end
  
  def destroy
    @pizza_preset = PizzaPreset.find_by_slug(params[:id])
    @pizza_preset.destroy
    # expire_fragment("pizza_selection")
    redirect_to admins_pizza_presets_path, :notice => "Pizza Preset Deleted"
  end
  
  
end
