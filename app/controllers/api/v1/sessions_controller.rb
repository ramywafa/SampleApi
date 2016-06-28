class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token

  prepend_before_action :allow_params_authentication!, only: :create

  def create
    self.resource = resource_class.find_by_email(sign_in_params[:email])
    if resource.present? && resource.valid_password?(sign_in_params[:password])
      sign_in(resource_name, resource)
      respond_with(:api, resource)
    else
      render status: :unauthorized, json: {error_messages_sentence: 'Email-password combination is invalid'} and return
    end
  end

  def sign_in_params
    params.require(:admin).permit(:email, :password)
  end
end  
