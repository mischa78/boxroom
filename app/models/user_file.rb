class UserFile < ActiveRecord::Base
  has_attached_file :attachment, :path => ':rails_root/uploads/:id/:style/:id'

  belongs_to :folder

  validates_attachment_presence :attachment, :message => "can't be blank"
  validates_uniqueness_of :attachment_file_name, :scope => 'folder_id', :message => 'exists already'
  validates_format_of :attachment_file_name, :with => /^[^\/\\\?\*:|"<>]+$/, :message => 'cannot contain any of these characters: < > : " / \ | ? *'

  def extension
    File.extname(attachment_file_name)[1..-1]
  end
end


# == Schema Information
#
# Table name: user_files
#
#  id                      :integer         not null, primary key
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  folder_id               :integer
#  created_at              :datetime
#  updated_at              :datetime
#

