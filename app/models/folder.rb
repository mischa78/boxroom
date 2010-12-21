class Folder < ActiveRecord::Base
  acts_as_tree :order => 'name'

  belongs_to :user
  has_many :user_files, :dependent => :destroy
  has_many :permissions, :dependent => :destroy

  attr_accessible :name, :user_id

  validates_uniqueness_of :name, :scope => :parent_id
  validates_presence_of :name

  before_save :check_for_parent
  after_create :create_permissions

  def readonly?
    true if is_root? && !new_record?
  end

  def is_root?
    parent.nil?
  end

  def has_children?
    children.count > 0
  end

  def self.root
    find_by_name_and_parent_id('Root folder', nil)
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
end
