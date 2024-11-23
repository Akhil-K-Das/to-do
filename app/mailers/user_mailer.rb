class UserMailer < ApplicationMailer
  def signup_confirmation(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Todo List API', body: "Hello #{@user.email},\n\nThank you for signing up!")
  end

  def otp_email(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: 'Your OTP Code')
  end
end
