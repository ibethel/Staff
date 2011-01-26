class Admin::UsersController < AdminController


  def index
    @users = @organization.users.active.paginate(:page => params[:page], :per_page => 50)
    @title = "Staff"
  end
  
  
  def new
    @user = User.new
  end


  def show
    @user = User.active.find(params[:id])
    @title = @user.name
  end


  def edit
    @user = current_user
    @title = @user.name
  end
  
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_path, notice: "The user was removed") }
    end
  end
  
end