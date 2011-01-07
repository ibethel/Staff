class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    if user = User.find_by_email(auth["user_info"]["email"])
      log_user_in(auth)
    else
      redirect_to root_path, :notice => "That login could not be found"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "You are now logged out"
  end
  
  
  private
    
    def log_user_in(auth)
      user = User.find_by_email(auth["user_info"]["email"])
      session[:user_id] = user.id
      redirect_to root_path, :notice => "You have been signed in!"
    end

end