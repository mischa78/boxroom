class DropColumnUserIdFromFolders < ActiveRecord::Migration
  def self.up
    remove_column :folders, :user_id
  end

  def self.down
    add_column :folders, :user_id, :integer
  end
end
