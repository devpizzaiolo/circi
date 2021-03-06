class Admins::AdminsController < ApplicationController
  
  before_filter :authenticate_admin!
  before_filter :can_admin_admins
  layout  "admin"
  
  def index
    @admins = Admin.order(:first_name)
  end
  
  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(params[:admin])
    if @admin.save
      redirect_to admins_admins_path, :notice => "#{@admin.first_name} has been added to the system."
    else
      flash[:error] = "There was a problem creating the new admin. Please verify the information."
      render :new
    end
  end
  
  def edit
    @admin = Admin.find_by_id(params[:id])
  end
  
  def update
    if params[:admin][:password].blank?
      params[:admin].delete("password")
      params[:admin].delete("password_confirmation")
    end
    @admin = Admin.find_by_id(params[:id])
    if @admin.update_attributes(params[:admin])
      redirect_to admins_admins_path, :notice => "#{@admin.first_name} was successfully updated on the system."
    else
      flash[:error] = "There was a problem updating the admin on the system."
      render :edit
    end
  end
  
  def destroy
    @admin = Admin.find_by_id(params[:id])
    @admin.destroy
    redirect_to admins_admins_path, :notice => "#{@admin.first_name} was deleted from the system."
  end
  
  private
    
    def can_admin_admins
      unless current_admin && current_admin.edit_admins
        redirect_to admins_index_path
      end
    end
  
end
