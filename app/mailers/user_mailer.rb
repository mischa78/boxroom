class UserMailer < ActionMailer::Base

  default :from => "boxroom@example.com"

  def reset_password_email(user)
    @user = user
    mail(:to => user.email, :subject => '[Boxroom] Password reset instructions')
  end

end

