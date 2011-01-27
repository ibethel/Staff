class UserMailer < ActionMailer::Base
  default :from => "accounts@bookfaery.com"
  
  def activation(user)
      @user = user
      @url  = user_activation_path(user.activation)
      mail(:to => user.email,
           :subject => "It's a party.  You are invited!")
    end
end
