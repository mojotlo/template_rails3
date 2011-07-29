class UserMailer < ActionMailer::Base
  default :from  => "mashedcards@gmail.com" 
  def registration_confirmation(user)
    @user=user
    mail(:to  => @user.email, :subject  => "Registered") 
  end
  def forgot_password(user)
    @user=user
    email=@user.email
    @reset_password_code=user.reset_password_code
    mail(:to  => user.email, :subject  => "Reset Password")
  end
end

