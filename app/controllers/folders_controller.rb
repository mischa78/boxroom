class FoldersController < ApplicationController
  before_filter :require_existing_folder, :only => [:show, :edit, :update, :destroy]
  before_filter :require_existing_parent_folder, :only => [:new, :create]
  before_filter :require_folder_isnt_root_folder, :only => [:edit, :update, :destroy]

  before_filter :require_create_permission, :only => [:new, :create]
  before_filter :require_read_permission, :only => :show
  before_filter :require_update_permission, :only => [:edit, :update]
  before_filter :require_delete_permission, :only => :destroy

  # GET /folder
  def index
    redirect_to folder_url(Folder.root)
  end

  # GET /folders/:id
  # Note: @folder is set in require_existing_folder
  def show
  end

  # GET /folders/:id/folders/new
  # Note: @parent_folder is set in require_existing_parent_folder
  def new
    @folder = @parent_folder.children.build
  end

  # POST /folders/:id/folders
  # Note: @parent_folder is set in require_existing_parent_folder
  def create
    @folder = @parent_folder.children.build(params[:folder])

    if @folder.save
      redirect_to folder_url(@parent_folder)
    else
      render :action => 'new'
    end
  end

  # GET /folders/:id/edit
  # Note: @folder is set in require_existing_folder
  def edit
  end

  # PUT /folders/:id
  # Note: @folder is set in require_existing_folder
  def update
    if @folder.update_attributes(params[:folder])
      flash[:notice] = 'Your changes were saved successfully.'
      redirect_to edit_folder_url(@folder)
    else
      render :action => 'edit'
    end
  end

  # DELETE /folder/:id
  # Note: @folder is set in require_existing_folder
  def destroy
    parent_folder = @folder.parent
    @folder.destroy
    redirect_to folder_url(parent_folder)
  end

  private

  def require_existing_folder
    @folder = Folder.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Someone else deleted this folder. Your action was cancelled.'
    redirect_to folder_url(Folder.root)
  end

  def require_folder_isnt_root_folder
    if @folder.is_root?
      flash[:error] = 'The root folder cannot be deleted or renamed.'
      redirect_to folder_url(Folder.root)
    end
  end

  # Overrides require_delete_permission in ApplicationController
  def require_delete_permission
    unless current_user.can_delete(@folder) || @folder.is_root?
      flash[:error] = "You don't have delete permissions for this folder."
      redirect_to folder_url(@folder.parent)
    else
      require_delete_permissions_for(@folder.children)
    end
  end

  def require_delete_permissions_for(folders)
    folders.each do |folder|
      unless current_user.can_delete(folder)
        flash[:error] = "You don't have delete permissions for one of the subfolders."
        redirect_to folder_url(@folder.parent)
      else
        # Recursive...
        require_delete_permissions_for(folder.children)
      end
    end
  end
end

