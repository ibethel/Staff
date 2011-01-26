class UserMailer < ActionMailer::Base
  default :from => "accounts@bookfaery.com"
  
  def activation(user)
      @user = user
      @url  = user_activation_path(user)
      mail(:to => user.email,
           :subject => "You have been invited")
    end
end
