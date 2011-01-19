class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from AbstractController::ActionNotFound, with: :render_404
  helper_method :current_user
  
  private 
  
    def render_404
      render template: "errors/render_404", status: 404
    end
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    def require_login
      redirect_to "/auth/google_apps" unless current_user
    end
end