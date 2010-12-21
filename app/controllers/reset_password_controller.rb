class ResetPasswordController < ApplicationController
  before_filter :require_valid_token, :only => [:edit, :update]
  skip_before_filter :require_login

  # GET /reset_password/new
  def new
  end

  # POST /reset_password
  def create
    user = User.find_by_email(params[:email])

    unless user.nil?
      user.refresh_reset_password_token
      UserMailer.reset_password_email(user).deliver 
      flash[:notice] = 'Email with instructions sent successfully. Please check your email.'
    else
      flash[:error] = "There is no user with email address '#{params[:email]}'. Please try again."
    end

    redirect_to new_reset_password_url
  end

  # GET /reset_password/:id/edit
  def edit
    @user.password_required = true
  end

  # PUT /reset_password/:id
  def update
    if @user.update_attributes(params[:user].merge({ :password_required => true }))
      flash[:notice] = 'Your password was reset successfully. You can now sign in.'
      redirect_to new_session_url
    else
      render :action => 'edit'
    end
  end

  private

  def require_valid_token
    @user = User.find_by_reset_password_token(params[:id])

    if @user.nil? || @user.reset_password_token_expires_at < Time.now
      flash[:error] = 'The URL for resetting your password expired. Please try again.'
      redirect_to new_reset_password_url
    end
  end
end
