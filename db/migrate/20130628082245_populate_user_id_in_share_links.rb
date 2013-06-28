class PopulateUserIdInShareLinks < ActiveRecord::Migration
  def change
    user = User.where.not(:name => nil).first
    ShareLink.where(:user_id => nil).update_all(:user_id => user.id)
  end
end
