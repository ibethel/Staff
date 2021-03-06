class Admin::DepartmentsController < AdminController
  
  
  def index
    @departments = @organization.departments.paginate(page: params[:page], per_page: params[:count] || 25)
    @title = "Departments"
  end


  def show
    @department = Department.within_organization(@organization).find(params[:id])
    @title = @department.name
  end


  def new
    @department = Department.new
  end


  def edit
    @department = Department.within_organization(@organization).find(params[:id])
  end


  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        format.html { redirect_to(@department, :notice => 'Department was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end


  def update
    @department = Department.within_organization(@organization).find(params[:id])
    @department.organization = @organization
    
    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to(admin_departments_path, :notice => 'Department was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  
end