class Folder < ActiveRecord::Base
  acts_as_tree :order => 'name'

  has_many :user_files, -> { order :attachment_file_name }, :dependent => :destroy
  has_many :permissions, :dependent => :destroy

  attr_accessor :is_copied_folder

  validates_uniqueness_of :name, :scope => :parent_id
  validates_presence_of :name

  before_save :check_for_parent
  after_create :create_permissions, :unless => :is_copied_folder
  before_destroy :dont_destroy_root_folder

  def copy(target_folder, originally_copied_folder = nil)
    new_folder = self.dup
    new_folder.is_copied_folder = true
    new_folder.parent = target_folder
    new_folder.save!

    originally_copied_folder = new_folder if originally_copied_folder.nil?

    # Copy original folder's permissions
    self.permissions.each do |permission|
      new_permission = permission.dup
      new_permission.folder = new_folder
      new_permission.save!
    end

    self.user_files.each do |file|
      file.copy(new_folder)
    end

    # Copy sub-folders recursively
    self.children.each do |folder|
      folder.copy(new_folder, originally_copied_folder) unless folder == originally_copied_folder
    end

    new_folder
  end

  def move(target_folder)
    unless target_folder == self || self.parent_of?(target_folder)
      self.parent = target_folder
      save!
    else
      raise 'You cannot move a folder to its own sub-folder.'
    end
  end

  def copy_permissions_to_children(permissions_to_copy)
    permissions_to_copy.each do |permission|
      attributes = permission.attributes.except('id', 'folder_id', 'group_id')
      Permission.where(:folder_id => children, :group_id => permission.group_id).update_all(attributes)
    end

    # Copy permissions recursively
    children.each do |child|
      child.copy_permissions_to_children(permissions_to_copy) if child.has_children?
    end
  end

  def parent_of?(folder)
    self.children.each do |child|
      if child == folder
        return true
      else
        return child.parent_of?(folder)
      end
    end
    false
  end

  def is_root?
    parent.nil? && !new_record?
  end

  def has_children?
    children.count > 0
  end

  def self.root
    @root_folder ||= find_by_name_and_parent_id('Root folder', nil)
  end

  private

  def check_for_parent
    raise 'Folders must have a parent.' if parent.nil? && name != 'Root folder'
  end

  def create_permissions
    unless is_root?
      parent.permissions.each do |permission|
        Permission.create! do |p|
          p.group = permission.group
          p.folder = self
          p.can_create = permission.can_create
          p.can_read = permission.can_read
          p.can_update = permission.can_update
          p.can_delete = permission.can_delete
        end
      end
    end
  end

  def dont_destroy_root_folder
    raise "Can't delete Root folder" if is_root?
  end
end
