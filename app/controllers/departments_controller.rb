class DepartmentsController < ApplicationController
  # GET /departments
  # GET /departments.xml
  def index
    @departments = @organization.departments
    @title = "Departments"
  end

  # GET /departments/1
  # GET /departments/1.xml
  def show
    @department = Department.find(params[:id])
    @title = @department.name
  end

  # GET /departments/new
  # GET /departments/new.xml
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.xml
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

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to(@department, :notice => 'Department was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
end
