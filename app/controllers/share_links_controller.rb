class ShareLinksController < ApplicationController
  before_filter :require_admin, :only => [:index, :destroy]
  before_filter :require_existing_file, :except => :index
  before_filter :require_existing_share_link, :only => :destroy
  before_filter :require_read_permission, :only => [:new, :create]
  skip_before_filter :require_login, :only => :show

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

  # Note: @file is set in require_existing_file
  def create
    @share_link = @file.share_links.build(params[:share_link])

    if @share_link.save
      UserMailer.download_link_email(current_user, @share_link).deliver
      redirect_to folder_url(@folder), :notice => t(:shared_successfully)
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
  rescue ActiveRecord::RecordNotFound
    redirect_to folder_url(Folder.root), :alert => t(:already_deleted, :type => t(:this_file))
  rescue NoMethodError
    flash[:alert] = t(:already_deleted, :type => t(:this_file))
  rescue RuntimeError => e
    if e.message == 'This share link expired.'
      flash[:alert] = t(:share_link_expired)
    else
      raise e
    end
  end

  def require_existing_share_link
    @share_link = ShareLink.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to share_links_url, :alert => t(:already_deleted, :type => t(:this_share_link))
  end
end
