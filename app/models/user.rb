class User < ActiveRecord::Base
  has_and_belongs_to_many :groups

  attr_accessor :password_confirmation, :password_required, :dont_clear_reset_password_token
  attr_accessible :name, :email, :password, :password_confirmation, :password_required

  validates_confirmation_of :password
  validates_length_of :password, :in => 6..20, :allow_blank => true
  validates_presence_of :password, :if => :password_required
  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/

  before_save :clear_reset_password_token, :unless => :dont_clear_reset_password_token
  after_create :create_root_folder_and_admins_group, :if => :is_admin

  ['create', 'read', 'update', 'delete'].each do |method|
    define_method "can_#{method}" do |folder|
      has_permission = false
      groups.each do |group|
        unless group.permissions.send("find_by_folder_id_and_can_#{method}", folder.id, true).blank?
          has_permission = true
          break
        end
      end
      has_permission
    end
  end

  def password
    @password
  end

  def password=(new_password)
    @password = new_password
    unless @password.blank?
      self.password_salt = SecureRandom.base64(32)
      self.hashed_password = Digest::SHA256.hexdigest(password_salt + password)
    end
  end

  def member_of_admins?
    !groups.find_by_name('Admins').blank?
  end

  def refresh_reset_password_token
    self.reset_password_token = SecureRandom.hex(16)
    self.reset_password_token_expires_at = 1.hour.from_now
    self.dont_clear_reset_password_token = true
    save(:validate => false)
  end

  def refresh_remember_token
    self.remember_token = SecureRandom.base64(32)
    save(:validate => false)
  end

  def forget_me
    self.remember_token = nil
    save(:validate => false)
  end

  def self.authenticate(name, password)
    user = find_by_name(name) or return nil
    hash = Digest::SHA256.hexdigest(user.password_salt + password)
    hash == user.hashed_password ? user : nil
  end

  def self.no_admin_yet?
    find_by_is_admin(true).blank?
  end

  private

  def clear_reset_password_token
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
  end

  def create_root_folder_and_admins_group
    Folder.create(:name => 'Root folder')
    groups << Group.create(:name => 'Admins')
  end
end

# == Schema Information
#
# Table name: users
#
#  id                              :integer         not null, primary key
#  name                            :string(255)
#  email                           :string(255)
#  hashed_password                 :string(255)
#  password_salt                   :string(255)
#  is_admin                        :string(255)
#  access_key                      :string(255)
#  remember_token                  :string(255)
#  reset_password_token            :string(255)
#  reset_password_token_expires_at :datetime
#  created_at                      :datetime
#  updated_at                      :datetime
#

