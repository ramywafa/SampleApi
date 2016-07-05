class Api::V1::Users::RegistrationsController < Api::V1::RegistrationsController
  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end  
