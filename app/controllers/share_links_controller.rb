class ShareLinksController < ApplicationController
  before_action :require_admin, :only => [:index, :destroy]
  before_action :require_existing_file, :except => [:index, :destroy]
  before_action :require_existing_share_link, :only => :destroy
  before_action :require_read_permission, :only => [:new, :create]
  skip_before_action :require_login, :only => :show

  rescue_from ActiveRecord::RecordNotFound, NoMethodError, RuntimeError, :with => :redirect_to_root_or_signin_and_show_alert

  def index
    @share_links = ShareLink.active_share_links
  end

  # Note: @file is set in require_existing_file
  def show
    send_file @file.attachment.path, :filename => @file.attachment_file_name unless @file.nil?
  end

  # Note: @file is set in require_existing_file
  def new
    @share_link = @file.share_links.build
  end

  # Note: @file and @folder are set in require_existing_file
  def create
    @share_link = @file.share_links.build(permitted_params.share_link)
    @share_link.user = current_user

    if @share_link.save
      UserMailer.share_link_email(@share_link).deliver_now
      redirect_to @folder, :notice => t(:shared_successfully)
    else
      render :action => 'new'
    end
  end

  # Note: @share_link is set in require_existing_share_link
  def destroy
    @share_link.destroy
    redirect_to share_links_url
  end

  private

  def require_existing_file
    @file = params[:file_id].blank? ? ShareLink.file_for_token(params[:id]) : UserFile.find(params[:file_id])
    @folder = @file.folder
  end

  def require_existing_share_link
    @share_link = ShareLink.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to share_links_url, :alert => t(:already_deleted, :type => t(:this_share_link))
  end

  def redirect_to_root_or_signin_and_show_alert
    if signed_in?
      redirect_to Folder.root, :alert => t(:already_deleted, :type => t(:this_file))
    else
      redirect_to signin_url, :alert => t(:already_deleted, :type => t(:this_file))
    end
  end
end
