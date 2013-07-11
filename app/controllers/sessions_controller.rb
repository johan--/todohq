class SessionsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]

  def create
    user = User.find_for_database_authentication(email: params[:session][:email])

    if user && user.valid_password?(params[:session][:password])
      user.reset_authentication_token!
      render json: { token: user.authentication_token }, status: :created
    else
      render json: {
        errors: {
          email: "invalid email or password"
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.update_attribute :authentication_token, nil
    render json: {}, status: :accepted
  end
end
