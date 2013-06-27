class User < ActiveRecord::Base
  has_and_belongs_to_many :groups
  has_many :share_links  

  attr_accessor :password_confirmation, :password_required, :dont_clear_reset_password_token

  validates_confirmation_of :password
  validates_length_of :password, :in => 6..20, :allow_blank => true
  validates_presence_of :password, :if => :password_required
  validates_presence_of :name, :unless => :new_record?
  validates_presence_of :email
  validates_uniqueness_of :name, :unless => :new_record? && :name_is_blank?
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

  before_create :set_signup_token
  before_save :clear_reset_password_token, :unless => :dont_clear_reset_password_token
  before_update :clear_signup_token
  after_create :create_root_folder_and_admins_group, :if => :is_admin
  before_destroy :dont_destroy_admin

  %w{create read update delete}.each do |method|
    define_method "can_#{method}" do |folder|
      has_permission = false

      Permission.where(:group_id => groups, :folder_id => folder.id).each do |permission|
        has_permission = permission.send("can_#{method}")
        break if has_permission
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
    groups.admins_group.present?
  end

  def refresh_reset_password_token
    self.reset_password_token = SecureRandom.hex(10)
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

  def name_is_blank?
    self.name.blank?
  end

  def self.authenticate(name, password)
    return nil if name.blank? || password.blank?
    user = find_by_name(name) or return nil
    hash = Digest::SHA256.hexdigest(user.password_salt + password)
    hash == user.hashed_password ? user : nil
  end

  def self.no_admin_yet?
    find_by_is_admin(true).blank?
  end

  private

  def set_signup_token
    self.signup_token = SecureRandom.hex(10)
    self.signup_token_expires_at = 2.weeks.from_now
  end

  def clear_signup_token
    unless self.name.blank?
      self.signup_token = nil
      self.signup_token_expires_at = nil
    end
  end

  def clear_reset_password_token
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
  end

  def create_root_folder_and_admins_group
    Folder.create(:name => 'Root folder')
    groups << Group.create(:name => 'Admins')
  end

  def dont_destroy_admin
    raise "Can't delete original admin user" if is_admin
  end
end
