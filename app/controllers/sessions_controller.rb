class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    if user = User.find_by_email(auth["user_info"]["email"])
      log_user_in(auth)
    else
      create_new_user(auth)
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "You are now logged out"
  end
  
  
  private
    
    def create_new_user(auth)
      user = User.create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to edit_user_path(user), :notice => "You have been signed in!  Please create your profile."
    end
    
    def log_user_in(auth)
      user = user = User.find_by_email(auth["user_info"]["email"]) 
      session[:user_id] = user.id
      redirect_to root_path, :notice => "You have been signed in!"
    end

end