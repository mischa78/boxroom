class UsersController < ApplicationController
  before_filter :require_admin, :except => [:edit, :update]
  before_filter :require_existing_user, :only => [:edit, :update, :destroy]
  before_filter :require_deleted_user_isnt_admin, :only => :destroy

  def index
    @users = User.all(:order => 'name')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user].merge({ :password_required => true }))

    if @user.save
      set_groups
      redirect_to users_url
    else
      render :action => 'new'
    end
  end

  # Note: @user is set in require_existing_user
  def edit
  end

  # Note: @user is set in require_existing_user
  def update
    if @user.update_attributes(params[:user].merge({ :password_required => false }))
      set_groups
      redirect_to edit_user_url(@user), :notice => t(:your_changes_were_saved)
    else
      render :action => 'edit'
    end
  end

  # Note: @user is set in require_existing_user
  def destroy
    @user.destroy
    redirect_to users_url
  end

  private

  def require_existing_user
    if current_user.member_of_admins? && params[:id] != current_user.id.to_s
      @title = t(:edit_user)
      @user = User.find(params[:id])
    else
      @title = t(:account_settings)
      @user = current_user
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, :alert => t(:user_already_deleted)
  end

  def require_deleted_user_isnt_admin
    if @user.is_admin
      redirect_to users_url, :alert => t(:admin_user_cannot_be_deleted)
    end
  end

  def set_groups
    if current_user.member_of_admins?
      @user.group_ids = params[:user][:group_ids]
      @user.groups << Group.find_by_name('Admins') if @user.is_admin
    end
  end
end
