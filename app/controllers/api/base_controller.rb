# parent of all API controller
class Api::BaseController < ApplicationController
  # to skip protection from forgery added to application controller
  skip_before_action :verify_authenticity_token

  # make sure a signed in user/admin can create not guests
  before_action :authenticate_client!, only: [:create]


  respond_to :json

  rescue_from Exception do |e|
    case e
    when Unauthorized
      head :forbidden
    when ActiveRecord::RecordNotFound, ActionController::RoutingError
      head :not_found
    when ActiveRecord::RecordInvalid
      render status: 409, json: { errors: [e.message] }
    else
      render status: :bad_request, json: { errors: [e.message] }
    end
  end

  protected

  def page
    params[:page] || 1
  end

  def current_client
    current_api_admin || current_api_user
  end

  def current_client_signed_in?
    api_admin_signed_in? || api_user_signed_in?
  end

  def authenticate_client!
    if !current_client_signed_in?
      fail Unauthorized
    end
  end
end
