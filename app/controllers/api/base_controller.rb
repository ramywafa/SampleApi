# parent of all API controller
class Api::BaseController < ApplicationController
  # to skip protection from forgery added to application controller
  skip_before_action :verify_authenticity_token

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
end
