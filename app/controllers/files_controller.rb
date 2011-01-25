class FilesController < ApplicationController
  before_filter :require_existing_file, :only => [:show, :edit, :update, :destroy]
  before_filter :require_existing_parent_folder, :only => [:new, :create]

  before_filter :require_create_permission, :only => [:new, :create]
  before_filter :require_read_permission, :only => :show
  before_filter :require_update_permission, :only => [:edit, :update]
  before_filter :require_delete_permission, :only => :destroy

  # GET /files/:id
  # Note: @file and @folder are set in require_existing_file
  def show
    send_file @file.attachment.path, :filename => @file.attachment_file_name
  end

  # GET /folders/:id/files/new
  # Note: @parent_folder is set in require_existing_parent_folder
  def new
    @file = @parent_folder.user_files.build
  end

  # POST /folders/:id/files
  # Note: @parent_folder is set in require_existing_parent_folder
  def create
    @file = @parent_folder.user_files.build(params[:user_file])

    if @file.save
      redirect_to folder_url(@parent_folder)
    else
      render :action => 'new'
    end
  end

  # GET /files/:id/edit
  # Note: @file and @folder are set in require_existing_file
  def edit
  end

  # PUT /files/:id
  # Note: @file and @folder are set in require_existing_file
  def update
    if @file.update_attributes(params[:user_file])
      redirect_to edit_file_url(@file), :notice => 'Your changes were saved successfully.'
    else
      render :action => 'edit'
    end
  end

  # DELETE /files/:id
  # Note: @file and @folder are set in require_existing_file
  def destroy
    @file.destroy
    redirect_to folder_url(@folder)
  end

  private

  def require_existing_file
    @file = UserFile.find(params[:id])
    @folder = @file.folder
  rescue ActiveRecord::RecordNotFound
    redirect_to folder_url(Folder.root), :alert =>'Someone else deleted this file. Your action was cancelled.'
  end
end
