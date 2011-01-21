class UsersController < ApplicationController
  
  before_filter :validate_correct_user, only: [:edit, :update]
  before_filter :require_login
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.paginate(:page => params[:page], :per_page => 50)
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    current_user.friendships.build(friend_id: @user.id).save if current_user
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        expire_fragment('all-staff-list')
        format.html { redirect_to(profile_path(@user), :notice => 'Your profile has been updated') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  
  def destroy
    @user = User.find(params[:id])
    @user.deleted = true
    @user.save
    
    respond_to do |format|
      format.html { redirect_to root_path, notice: "The account has been removed" }
    end
  end
  
  
  private 
    
    def validate_correct_user
      redirect_to root_path unless current_user.to_param == params[:id]
    end
end