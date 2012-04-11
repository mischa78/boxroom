class UserMailer < ActionMailer::Base
  def signup_email(user)
    @user = user
    mail(:to => user.email, :subject => t(:signup_email_subject))
  end

  def reset_password_email(user)
    @user = user
    mail(:to => user.email, :subject => t(:reset_password_email_subject))
  end

  def share_link_email(user, share_link)
    @user, @share_link = user, share_link
    mail(:to => user.email, :bcc => share_link.emails, :subject => t(:share_link_email_subject))
  end
end
