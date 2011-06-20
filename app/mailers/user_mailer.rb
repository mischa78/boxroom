class UserMailer < ActionMailer::Base
  def reset_password_email(user)
    @user = user
    mail(:to => user.email, :subject => t(:reset_password_email_subject))
  end

  def download_link_email(user, share_link)
    @user = user
    @share_link = share_link
    mail(:to => user.email, :bcc => share_link.emails, :subject => t(:download_link_email_subject))
  end
end
