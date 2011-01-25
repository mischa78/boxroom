class AdminsController < ApplicationController
  skip_before_filter :require_admin_in_system, :require_login
  before_filter :require_no_admin

  # GET /admins/new
  def new
    @user = User.new
  end

  # POST /admins
  def create
    @user = User.new(params[:user])
    @user.password_required = true
    @user.is_admin = true

    if @user.save
      redirect_to new_session_url, :notice => 'The admin user was created successfully. You can now sign in.'
    else
      render :action => 'new'
    end
  end

  private

  def require_no_admin
    redirect_to new_session_url unless User.no_admin_yet?
  end
end
