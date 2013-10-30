class FoldersController < ApplicationController
  before_action :require_existing_folder, :only => [:show, :edit, :update, :destroy]
  before_action :require_existing_target_folder, :only => [:new, :create]
  before_action :require_folder_isnt_root_folder, :only => [:edit, :update, :destroy]

  before_action :require_create_permission, :only => [:new, :create]
  before_action :require_read_permission, :only => :show
  before_action :require_update_permission, :only => [:edit, :update]
  before_action :require_delete_permission, :only => :destroy

  def index
    redirect_to Folder.root
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
    @folder = @target_folder.children.build(permitted_params.folder)

    if @folder.save
      redirect_to @target_folder
    else
      render :action => 'new'
    end
  end

  # Note: @folder is set in require_existing_folder
  def edit
  end

  # Note: @folder is set in require_existing_folder
  def update
    if @folder.update_attributes(permitted_params.folder)
      redirect_to edit_folder_url(@folder), :notice => t(:your_changes_were_saved)
    else
      render :action => 'edit'
    end
  end

  # Note: @folder is set in require_existing_folder
  def destroy
    target_folder = @folder.parent
    @folder.destroy
    redirect_to target_folder
  end

  private

  # get_folder_or_redirect is defined in ApplicationController
  def require_existing_folder
    @folder = get_folder_or_redirect(params[:id])
  end

  def require_folder_isnt_root_folder
    if @folder.is_root?
      redirect_to Folder.root, :alert => t(:cannot_delete_root_folder)
    end
  end

  # Overrides require_delete_permission in ApplicationController
  def require_delete_permission
    unless @folder.is_root? || current_user.can_delete(@folder)
      redirect_to @folder.parent, :alert => t(:no_permissions_for_this_type, :method => t(:delete), :type =>t(:this_folder))
    else
      require_delete_permissions_for(@folder.children)
    end
  end

  def require_delete_permissions_for(folders)
    folders.each do |folder|
      unless current_user.can_delete(folder)
        redirect_to @folder.parent, :alert => t(:no_delete_permissions_for_subfolder)
      else
        # Recursive...
        require_delete_permissions_for(folder.children)
      end
    end
  end
end
