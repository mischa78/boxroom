class PermissionsController < ApplicationController
  before_filter :require_admin

  # PUT /permissions/update_multiple
  def update_multiple
    permissions = Permission.update(params[:permissions].keys, params[:permissions].values)
    folder = permissions.first.folder
    update_children(folder.children, permissions) if params[:recursive] && folder.has_children?
    redirect_to folder_url(folder)
  rescue ActiveRecord::RecordNotFound # Folder was deleted, so permissions are gone too
    flash[:error] = 'Someone else deleted this folder. Your action was cancelled.'
    redirect_to folder_url(Folder.root)
  end

  private

  def update_children(folders, permissions)
    folders.each do |folder|
      permissions.each do |parent|
        folder.permissions.find_all_by_group_id(parent.group_id).each do |child|
          child.can_create = parent.can_create
          child.can_read = parent.can_read
          child.can_update = parent.can_update
          child.can_delete = parent.can_delete
          child.save!
        end
      end

      # Recursive...
      update_children(folder.children, permissions) if folder.has_children?
    end
  end
end

