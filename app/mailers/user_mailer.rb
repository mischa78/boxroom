class UserMailer < ActionMailer::Base
  def reset_password_email(user)
    @user = user
    mail(:to => user.email, :subject => t(:password_reset_subject)) 
  end
end
