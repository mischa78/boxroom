class PermissionsController < ApplicationController
  before_action :require_admin

  def update_multiple
    if params[:permissions]
      permissions = Permission.update(params[:permissions].keys, params[:permissions].values)
      folder = permissions.first.folder
      folder.copy_permissions_to_children(permissions) if params[:recursive] && folder.has_children?
    end

    redirect_to :back
  rescue ActiveRecord::RecordNotFound # Folder was deleted, so permissions are gone too
    redirect_to Folder.root, :alert => t(:already_deleted, :type => t(:this_folder))
  end
end
