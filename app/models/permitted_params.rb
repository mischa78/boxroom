class PermittedParams < Struct.new(:params, :current_user)
  %w{folder group share_link user user_file}.each do |model_name|
    define_method model_name do
      params.require(model_name.to_sym).permit(*send("#{model_name}_attributes"))
    end
  end

  def folder_attributes
    [:name]
  end

  def group_attributes
    [:name]
  end

  def share_link_attributes
    [:emails, :link_expires_at, :message]
  end

  def user_attributes
    if current_user && current_user.member_of_admins?
      [:name, :email, :password, :password_confirmation, { :group_ids => [] }]
    else
      [:name, :email, :password, :password_confirmation]
    end
  end

  def user_file_attributes
    [:attachment, :attachment_file_name]
  end
end
