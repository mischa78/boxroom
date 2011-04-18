class ClipboardController < ApplicationController
  before_filter :require_existing_item
  before_filter :require_existing_target_folder, :only => [:copy, :move]
  before_filter :require_target_is_not_child, :only => :move
  before_filter :require_create_permission, :only => [:copy, :move]
  before_filter :require_read_permission, :only => :create
  before_filter :require_delete_permission, :only => :move

  def create
    clipboard.add(@item)
    redirect_to folder_url(params[:folder_id]), :notice => 'Successfully added to clipboard.'
  end

  def destroy
    clipboard.remove(@item)
    redirect_to folder_url(params[:folder_id])
  end

  def copy
    @item.copy(@target_folder)
    clipboard.remove(@item)
    redirect_to folder_url(params[:folder_id])
  rescue ActiveRecord::RecordInvalid
    redirect_to folder_url(params[:folder_id]), :alert => "Couldn't copy. A #{params[:type]} with the same name exists already."
  end

  def move
    @item.move(@target_folder)
    clipboard.remove(@item)
    redirect_to folder_url(params[:folder_id])
  rescue ActiveRecord::RecordInvalid
    redirect_to folder_url(params[:folder_id]), :alert => "Couldn't move. A #{params[:type]} with the same name exists already."
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
    redirect_to folder_url(params[:folder_id]), :alert => "Someone else deleted this #{params[:type]}. Your action was cancelled."
  end

  def require_target_is_not_child
    if params[:type] == 'folder'
      if @folder == @target_folder || @folder.parent_of?(@target_folder)
        redirect_to folder_url(params[:folder_id]), :alert => 'You cannot move a folder to its own sub-folder.'
      end
    end
  end

  ['read', 'delete'].each do |method|
    define_method "require_#{method}_permission" do
      unless current_user.send("can_#{method}", @folder)
        redirect_to folder_url(params[:folder_id]), :alert => "You don't have #{method} permissions for this #{params[:type]}."
      end
    end
  end
end