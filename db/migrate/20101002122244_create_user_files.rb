class CreateUserFiles < ActiveRecord::Migration
  def self.up
    create_table :user_files do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.references :folder
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :user_files
  end
end
