class FoldersController < ApplicationController
  before_filter :require_existing_folder, :only => [:show, :edit, :update, :destroy]
  before_filter :require_existing_target_folder, :only => [:new, :create]
  before_filter :require_folder_isnt_root_folder, :only => [:edit, :update, :destroy]

  before_filter :require_create_permission, :only => [:new, :create]
  before_filter :require_read_permission, :only => :show
  before_filter :require_update_permission, :only => [:edit, :update]
  before_filter :require_delete_permission, :only => :destroy

  def index
    redirect_to folder_url(Folder.root)
  end

  # Note: @folder is set in require_existing_folder
  def show
  end

  # Note: @target_folder is set in require_existing_target_folder
  def new
    @folder = @target_folder.children.build
  end

  # Note: @target_folder is set in require_existing_target_folder
  def create
    @folder = @target_folder.children.build(params[:folder])

    if @folder.save
      redirect_to folder_url(@target_folder)
    else
      render :action => 'new'
    end
  end

  # Note: @folder is set in require_existing_folder
  def edit
  end

  # Note: @folder is set in require_existing_folder
  def update
    if @folder.update_attributes(params[:folder])
      redirect_to edit_folder_url(@folder), :notice => 'Your changes were saved successfully.'
    else
      render :action => 'edit'
    end
  end

  # Note: @folder is set in require_existing_folder
  def destroy
    target_folder = @folder.parent
    @folder.destroy
    redirect_to folder_url(target_folder)
  end

  private

  def require_existing_folder
    @folder = Folder.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to folder_url(Folder.root), :alert => 'Someone else deleted this folder. Your action was cancelled.'
  end

  def require_folder_isnt_root_folder
    if @folder.is_root?
      redirect_to folder_url(Folder.root), :alert => 'The root folder cannot be deleted or renamed.'
    end
  end

  # Overrides require_delete_permission in ApplicationController
  def require_delete_permission
    unless current_user.can_delete(@folder) || @folder.is_root?
      redirect_to folder_url(@folder.parent), :alert => "You don't have delete permissions for this folder."
    else
      require_delete_permissions_for(@folder.children)
    end
  end

  def require_delete_permissions_for(folders)
    folders.each do |folder|
      unless current_user.can_delete(folder)
        redirect_to folder_url(@folder.parent), :alert => "You don't have delete permissions for one of the subfolders."
      else
        # Recursive...
        require_delete_permissions_for(folder.children)
      end
    end
  end
end
