class UserMailer < ActionMailer::Base

  def reset_password_email(user)
    @user = user
    mail(:to => user.email, :subject => '[Boxroom] Password reset instructions')
  end

end

