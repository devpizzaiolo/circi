class Customers::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    "/customers?registered=true"
  end
end