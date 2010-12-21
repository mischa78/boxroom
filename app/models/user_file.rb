class UserFile < ActiveRecord::Base
  has_attached_file :attachment, :path => ':rails_root/uploads/:id/:style/:id'

  belongs_to :folder
  belongs_to :user

  validates_attachment_presence :attachment, :message => "can't be blank"
  validates_uniqueness_of :attachment_file_name, :scope => 'folder_id', :message => 'exists already'
  validates_format_of :attachment_file_name, :with => /^[^\/\\\?\*:|"<>]+$/, :message => 'cannot contain any of these characters: < > : " / \ | ? *'
end
