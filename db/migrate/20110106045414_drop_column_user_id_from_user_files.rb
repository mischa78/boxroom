class DropColumnUserIdFromUserFiles < ActiveRecord::Migration
  def self.up
    remove_column :user_files, :user_id
  end

  def self.down
    add_column :user_files, :user_id, :integer
  end
end
