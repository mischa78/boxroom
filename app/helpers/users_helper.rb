module UsersHelper
  def user_belongs_to_group(group)
    unless @user.nil?
      @user.groups.include?(group)
    end
  end
end
