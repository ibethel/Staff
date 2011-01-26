class UsersController < ApplicationController
  
  before_filter :validate_correct_user, only: [:edit, :update]
  before_filter :require_login
  
  # GET /users
  # GET /users.xml
  def index
    @users = @organization.users.active.paginate(:page => params[:page], :per_page => 50, order: "updated_at DESC")
    @title = "Staff"
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.active.find(params[:id])
    @title = @user.name
  end

  # GET /users/1/edit
  def edit
    @user = current_user
    @title = @user.name
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.active.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(profile_path(@user), :notice => "Your profile has been updated") }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  
  def destroy
    @user = User.find(params[:id])
    
    respond_to do |format|
      if current_user.is_admin?
        @user.deleted = true
        @user.save
        format.html { redirect_to root_path, notice: "The account has been removed" }
      else
        format.html { redirect_to @user, notice: "You cannot delete this account" }
      end
    end
  end
  
  
  private 
    
    def validate_correct_user
      redirect_to root_path unless current_user.to_param == params[:id]
    end
end