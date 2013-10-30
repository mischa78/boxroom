class GroupsController < ApplicationController
  before_action :require_admin
  before_action :require_existing_group, :only => [:edit, :update, :destroy]
  before_action :require_group_isnt_admins_group, :only => [:edit, :update, :destroy]

  def index
    @groups = Group.order(:name)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(permitted_params.group)

    if @group.save
      redirect_to groups_url
    else
      render :action => 'new'
    end
  end

  # Note: @group is set in require_existing_group
  def edit
  end

  # Note: @group is set in require_existing_group
  def update
    if @group.update_attributes(permitted_params.group)
      redirect_to edit_group_url(@group), :notice => t(:your_changes_were_saved)
    else
      render :action => 'edit'
    end
  end

  # Note: @group is set in require_existing_group
  def destroy
    @group.destroy
    redirect_to groups_url
  end

  private

  def require_existing_group
    @group = Group.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_url, :alert => t(:group_already_deleted)
  end

  def require_group_isnt_admins_group
    if @group.admins_group?
      redirect_to groups_url, :alert => t(:admins_group_cannot_be_deleted)
    end
  end
end
