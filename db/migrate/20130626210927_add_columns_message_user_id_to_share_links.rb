class AddColumnsMessageUserIdToShareLinks < ActiveRecord::Migration
  def change
    add_column  :share_links, :message, :text
    add_column  :share_links, :user_id, :integer
  end
end
