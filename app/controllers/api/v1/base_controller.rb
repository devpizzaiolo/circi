class Api::V1::BaseController < ApplicationController
  before_filter :authenticate_store

  def authenticate_store
    return if !params["controller"].include?("api/v1")
    if !current_store.present?
      render json: {
        error: "Authentication failed!!!"
      }, status: 422
    end
  end

  def current_store
    @store ||= FranchiseLocation.where(store_id: request.env["HTTP_X_STORE_ID"], api_key: request.env["HTTP_X_API_KEY"]).first
  end
end