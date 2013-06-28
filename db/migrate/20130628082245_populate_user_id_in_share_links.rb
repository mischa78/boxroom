class PopulateUserIdInShareLinks < ActiveRecord::Migration
  def change
    active_users = User.where.not(:name => nil)

    if active_users.any? && ShareLink.any?
      ShareLink.where(:user_id => nil).update_all(:user_id => active_users.first.id)
    end
  end
end
