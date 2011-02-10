class GroupsController < ApplicationController
  before_filter :require_admin
  before_filter :require_existing_group, :only => [:edit, :update, :destroy]
  before_filter :require_group_isnt_admins_group, :only => [:edit, :update, :destroy]

  # GET /groups
  def index
    @groups = Group.all(:order => 'name')
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # POST /groups
  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to groups_url
    else
      render :action => 'new'
    end
  end

  # GET /groups/:id/edit
  # Note: @group is set in require_existing_group
  def edit
  end

  # PUT /groups/:id
  # Note: @group is set in require_existing_group
  def update
    if @group.update_attributes(params[:group])
      flash[:notice] = 'Your changes were saved successfully.'
      redirect_to edit_group_url(@group)
    else
      render :action => 'edit'
    end
  end

  # DELETE /group/:id
  # Note: @group is set in require_existing_group
  def destroy
    @group.destroy
    redirect_to groups_url
  end

  private

  def require_existing_group
    @group = Group.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Someone else deleted this group. Your action was cancelled.'
    redirect_to groups_url
  end

  def require_group_isnt_admins_group
    if @group.admins_group?
      flash[:error] = 'The admins group cannot be deleted or renamed.'
      redirect_to groups_url
    end
  end
end

