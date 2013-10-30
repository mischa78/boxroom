class SignupController < ApplicationController
  before_action :require_valid_token, :only => [:edit, :update]
  skip_before_action :require_login

  # Note: @user is set in require_valid_token
  def edit
  end

  # Note: @user is set in require_valid_token
  def update
    if @user.update_attributes(permitted_params.user.merge({ :password_required => true }))
      redirect_to new_session_url, :notice => t(:signed_up_successfully)
    else
      render :action => 'edit'
    end
  end

  private

  def require_valid_token
    @user = User.find_by_signup_token(params[:id])

    if @user.nil? || @user.signup_token_expires_at < Time.now
      redirect_to new_session_url, :alert => t(:sign_url_expired)
    end
  end
end
