class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end


  def create
    permitted_params = params.permit(:email_address, :password)
    email = permitted_params[:email_address].to_s.strip.downcase
    password = permitted_params[:password]

    if user = User.authenticate_by(email_address: email, password: password)
      start_new_session_for(user)
      redirect_to after_authentication_url
    elsif user = User.find_by(email_address: email)
      redirect_to new_session_path, alert: "Try another email address or password."
    else
      user = User.new(
        email_address: email,
        password: password,
        password_confirmation: password
      )

      if user.save
        start_new_session_for(user)
        redirect_to after_authentication_url
      else
        redirect_to new_session_path, alert: "Impossible to create account."
      end
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
