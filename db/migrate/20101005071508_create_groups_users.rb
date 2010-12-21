class CreateGroupsUsers < ActiveRecord::Migration
  def self.up
    create_table :groups_users, :id => false do |t|
      t.references :group
      t.references :user
    end
  end

  def self.down
    drop_table :groups_users
  end
end
