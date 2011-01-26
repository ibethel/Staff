class AdminController < ApplicationController
  layout 'admin'
  
  before_filter :require_authentication
  
  private
  
    def require_authentication
      redirect_to root_path unless current_user && current_user.is_admin?
    end
  
end