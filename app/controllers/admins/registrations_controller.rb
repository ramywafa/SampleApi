class Api::V1::Admins::RegistrationsController < Api::V1::RegistrationsController
  def sign_up_params
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end  
