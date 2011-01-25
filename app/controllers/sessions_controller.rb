class SessionsController < ApplicationController
  skip_before_filter :require_login

  # GET /sessions/new
  def new
  end

  # POST /sessions
  def create
    user = User.authenticate(params[:username], params[:password])

    unless user.nil?
      if params[:remember_me] == 'true'
        user.refresh_remember_token
        cookies[:auth_token] = { :value => user.remember_token, :expires => 2.weeks.from_now }
      end

      session[:user_id] = user.id
      redirect_to(session[:return_to] || folders_url)
      session[:return_to] = nil
    else
      log_failed_sign_in_attempt(Time.now, params[:username], request.remote_ip)
      redirect_to new_session_url, :alert => 'Username and/or password were incorrect. Try again.'
    end
  end

  def destroy
    current_user.forget_me
    cookies.delete :auth_token
    reset_session
    session[:user_id] = nil
    redirect_to new_session_url
  end

  private

  def log_failed_sign_in_attempt(date, username, ip)
    Rails.logger.error(
      "\nFAILED SIGN IN ATTEMPT:\n" +
      "=======================\n" +
      " Date: #{date}\n" +
      " Username: #{username}\n" +
      " IP address: #{ip}\n\n"
    )
  end
end
