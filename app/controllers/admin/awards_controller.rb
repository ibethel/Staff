class Admin::AwardsController < AdminController


  def index
    @awards = @organization.awards.paginate(page: params[:page], per_page: params[:count] || 25)
  end
  
  
  def new
    @award = Award.new
  end


  def edit
    @award = Award.within_organization(@organization).find(params[:id])
  end
  
  
  def create
    @award = Award.new(params[:award])
    @award.organization = @organization
    
    respond_to do |format|
      if @award.save
        format.html { redirect_to(admin_award_path(@award), :notice => 'The award was created') }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  
  def destroy
    @award = Award.within_organization(@organization).find(params[:id])
    @award.destroy
    
    redirect_to(admin_awards_path, notice: "The award has been removed")
  end
  
  
end