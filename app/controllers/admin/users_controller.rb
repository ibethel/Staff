class Admin::UsersController < AdminController


  def index
    @users = @organization.users.active.order("admin DESC, name ASC").paginate(page: params[:page], per_page: params[:count] || 25)
    @title = "Staff"
  end
  
  
  def new
    @user = User.new
  end
  
  
  def create
    @user = User.new(params[:user])
    @user.organization = @organization
    
    respond_to do |format|
      if @user.save(validate: false)
        UserMailer.activation(@user).deliver
        format.html { redirect_to(admin_users_path, :notice => "The user has been created and notified") }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  
  def update
    @user = User.within_organization(@organization).find(params[:id])
    @user.admin = !@user.admin if current_user.is_admin?
    
    respond_to do |format|
      if @user.save(validate: false)
        format.html { redirect_to(admin_users_path, notice: "The user has been updated") }
      else
        format.html { redirect_to(admin_users_path, notice: "Unable to update the user") }
      end
    end
  end
  
  
  def destroy
    @user = User.within_organization(@organization).find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_path, notice: "The user was removed") }
    end
  end
  
end