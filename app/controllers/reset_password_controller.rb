class ResetPasswordController < ApplicationController
  before_action :require_valid_token, :only => [:edit, :update]
  skip_before_action :require_login

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    unless user.nil?
      user.refresh_reset_password_token
      UserMailer.reset_password_email(user).deliver_now
    end

    redirect_to new_reset_password_url, :notice => t(:instruction_email_sent, :email => params[:email])
  end

  # Note: @user is set in require_valid_token
  def edit
  end

  # Note: @user is set in require_valid_token
  def update
    if @user.update_attributes(permitted_params.user.merge({ :password_required => true }))
      redirect_to new_session_url, :notice => t(:password_reset_successfully)
    else
      render :action => 'edit'
    end
  end

  private

  def require_valid_token
    @user = User.find_by_reset_password_token(params[:id])

    if @user.nil? || @user.reset_password_token_expires_at < Time.now
      redirect_to new_reset_password_url, :alert => t(:reset_url_expired)
    end
  end
end
