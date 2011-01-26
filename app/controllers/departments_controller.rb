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
    @department = Department.within_organization(@organization).find(params[:id])
    @title = @department.name
  end
end
