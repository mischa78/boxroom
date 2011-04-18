class UserFile < ActiveRecord::Base
  has_attached_file :attachment, :path => ':rails_root/uploads/:id/:style/:id'

  belongs_to :folder

  validates_attachment_presence :attachment, :message => "can't be blank"
  validates_uniqueness_of :attachment_file_name, :scope => 'folder_id', :message => 'exists already'
  validates_format_of :attachment_file_name, :with => /^[^\/\\\?\*:|"<>]+$/, :message => 'cannot contain any of these characters: < > : " / \ | ? *'

  def copy(target_folder)
    new_file = self.clone
    new_file.folder = target_folder
    new_file.save!

    path = "#{Rails.root}/uploads/#{new_file.id}/original"
    FileUtils.mkdir_p path
    FileUtils.cp_r self.attachment.path, "#{path}/#{new_file.id}"
  end

  def move(target_folder)
    self.folder = target_folder
    save!
  end

  def extension
    File.extname(attachment_file_name)[1..-1]
  end
end
