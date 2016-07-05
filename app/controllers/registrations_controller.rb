class Api::V1::RegistrationsController < Devise::RegistrationsController  
  respond_to :json
  skip_before_action :verify_authenticity_token
end  
