class Group < ActiveRecord::Base
  has_many :permissions, :dependent => :destroy
  has_and_belongs_to_many :users

  validates_uniqueness_of :name
  validates_presence_of :name

  after_create :create_admin_permissions, :if => :admins_group?
  after_create :create_permissions, :unless => :admins_group?
  before_destroy :dont_destroy_admins

  def admins_group?
    name == 'Admins'
  end

  def self.admins_group
    where(:name => 'Admins').first
  end

  def self.all_except_admins
    where.not(:name => 'Admins')
  end

  private

  def create_admin_permissions
    Folder.find_each do |folder|
      Permission.create! do |p|
        p.group = self
        p.folder = folder
        p.can_create = true
        p.can_read = true
        p.can_update = true
        p.can_delete = true
      end
    end
  end

  def create_permissions
    Folder.find_each do |folder|
      Permission.create! do |p|
        p.group = self
        p.folder = folder
        p.can_create = false
        p.can_read = folder.is_root? # New groups can read the root folder
        p.can_update = false
        p.can_delete = false
      end
    end
  end

  def dont_destroy_admins
    raise "Can't delete admins group" if admins_group?
  end
end
