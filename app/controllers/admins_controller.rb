class AdminsController < ApplicationController
  
  before_filter :authenticate_admin!
  layout  "admin"
  def index
      
  end
  
end
