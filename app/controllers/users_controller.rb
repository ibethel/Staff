class UsersController < ApplicationController
  
  before_filter :validate_correct_user, only: [:edit, :update]
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
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
        format.html { redirect_to(profile_path(@user), :notice => 'Your profile has been updated') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  
  private 
    
    def validate_correct_user
      redirect_to root_path unless current_user.to_param == params[:id]
    end
end