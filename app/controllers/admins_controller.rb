class AdminsController < ApplicationController
  skip_before_filter :require_admin_in_system, :require_login
  before_filter :require_no_admin

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.password_required = true
    @user.is_admin = true

    if @user.save
      redirect_to new_session_url, :notice => t(:admin_user_created_successfully)
    else
      render :action => 'new'
    end
  end

  private

  def require_no_admin
    redirect_to new_session_url unless User.no_admin_yet?
  end
end
