class ClipboardController < ApplicationController
  before_filter :require_existing_item, :except => :reset
  before_filter :require_existing_target_folder, :only => [:copy, :move]
  before_filter :require_target_is_not_child, :only => :move
  before_filter :require_create_permission, :only => [:copy, :move]
  before_filter :require_read_permission, :only => :create
  before_filter :require_delete_permission, :only => :move

  # @item is set in require_existing_item
  def create
    clipboard.add(@item)
    redirect_to folder_url(params[:folder_id]), :notice => t(:added_to_clipboard)
  end

  # @item is set in require_existing_item
  def destroy
    clipboard.remove(@item)
    redirect_to folder_url(params[:folder_id])
  end

  def reset
    clipboard.reset
    redirect_to folder_url(params[:folder_id])
  end

  # @item is set in require_existing_item
  # @target_folder is set in require_existing_target_folder
  def copy
    @item.copy(@target_folder)
    clipboard.remove(@item)
    redirect_to folder_url(params[:folder_id])
  rescue ActiveRecord::RecordInvalid
    redirect_to folder_url(params[:folder_id]), :alert => t(:could_not_copy, :type => params[:type])
  end

  # @item is set in require_existing_item
  # @target_folder is set in require_existing_target_folder
  def move
    @item.move(@target_folder)
    clipboard.remove(@item)
    redirect_to folder_url(params[:folder_id])
  rescue ActiveRecord::RecordInvalid
    redirect_to folder_url(params[:folder_id]), :alert => t(:could_not_move, :type => params[:type])
  end

  private

  def require_existing_item
    if params[:type] == 'folder'
      @item = @folder = Folder.find(params[:id])
    else
      @item = UserFile.find(params[:id])
      @folder = @item.folder
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to folder_url(params[:folder_id]), :alert => t(:could_not_delete, :type => params[:type])
  end

  def require_target_is_not_child
    if params[:type] == 'folder'
      if @folder == @target_folder || @folder.parent_of?(@target_folder)
        redirect_to folder_url(params[:folder_id]), :alert => t(:cannot_move_to_own_subfolder)
      end
    end
  end

  ['read', 'delete'].each do |method|
    define_method "require_#{method}_permission" do
      unless current_user.send("can_#{method}", @folder)
        redirect_to folder_url(params[:folder_id]), :alert => t(:no_permissions_for_this_type, :method => method, :type => params[:type])
      end
    end
  end
end
