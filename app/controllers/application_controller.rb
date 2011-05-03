class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_admin_in_system
  before_filter :require_login

  helper_method :clipboard, :current_user, :signed_in?

  protected

  def clipboard
    session[:clipboard] ||= Clipboard.new
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  def require_admin_in_system
    redirect_to new_admin_url if User.no_admin_yet?
  end

  def require_admin
    redirect_to :root unless current_user.member_of_admins?
  end

  def require_login
    if current_user.nil?
      user = User.find_by_remember_token(cookies[:auth_token]) unless cookies[:auth_token].blank?

      if user.nil?
        reset_session
        session[:user_id] = nil
        session[:return_to] = request.fullpath
        redirect_to new_session_url
      else
        user.refresh_remember_token
        session[:user_id] = user.id
        cookies[:auth_token] = user.remember_token
      end
    end
  end

  def require_existing_target_folder
    @target_folder = Folder.find(params[:folder_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to folder_url(Folder.root), :alert =>'Someone else deleted this folder. Your action was cancelled.'
  end

  def require_create_permission
    unless current_user.can_create(@target_folder)
      redirect_to folder_url(@target_folder), :alert =>"You don't have create permissions for this folder."
    end
  end

  ['read', 'update', 'delete'].each do |method|
    define_method "require_#{method}_permission" do
      unless current_user.send("can_#{method}", @folder) || @folder.is_root?
        redirect_to folder_url(@folder.parent), :alert =>"You don't have #{method} permissions for this folder."
      end
    end
  end
end
