class ShareLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_file

  validates_presence_of :emails, :link_expires_at
  validates_length_of :emails, :maximum => 255
  validate :format_of_emails

  before_save :generate_token

  def self.active_share_links
    where('link_expires_at >= ?', DateTime.now).order(:link_expires_at)
  end

  def self.file_for_token(token)
    share_link = find_by_link_token(token)

    if share_link.link_expires_at < DateTime.now
      raise 'This share link expired.'
    else
      share_link.user_file
    end
  end

  private

  def format_of_emails
    emails.split(/,\s*/).each do |email|
      unless email.strip =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
        errors.add(:emails, I18n.t(:are_invalid_due_to, :email => email))
      end
    end
  end

  def generate_token
    self.link_token = SecureRandom.hex(10)
  end
end
