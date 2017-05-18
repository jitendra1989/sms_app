class MgEmployeeHierarchiesController < ApplicationController
  #com
	    before_filter :login_required
  layout "mindcom"
  def index
  	@departments = MgEmployeeDepartment.pluck(:department_name,:id)
  	@employee=MgEmployee.pluck(:first_name)
  	@employeelist=MgEmployee.all
    @employeeUnderManager=MgEmployee.all
  end

  def new
  end

  def create

     @managerId=params[:managerId]
     @checked=params[:selected_employee_id]
     
     
     if @checked.length>0 
      for i in 0...@checked.size
        @manager=MgEmployee.find(@checked[i])
        @manager.update(:mg_manager_id=>@managerId)
      end
    end
    
    employee_under_manager
  end
  
  def show
   
  end

  def remove_employee
    @employee=MgEmployee.find(params[:empId])
    @res =  @employee.update(:mg_manager_id => 0)
    employee_under_manager
  end

  def mg_employee_list
  	@employee=MgEmployee.where(:mg_employee_department_id=>params[:departmentId]).pluck(:first_name,:id)
  	render :partial => "employee_list", :object =>@employee
  end

  def list_of_employee
    @emploeeNotUnderManager=MgEmployee.where.not(mg_manager_id: params[:managerListId],id:params[:managerListId])
   
  	@employeelist=@emploeeNotUnderManager.where(:mg_employee_department_id=>params[:add_departmentId],:is_deleted => '0').pluck(:first_name,:mg_employee_position_id,:mg_employee_category_id,:id)
  	render :partial => "employee_list_table", :object =>@employeelist
  end

  def employee_under_manager
    @employeeUnderManager=MgEmployee.where(:mg_manager_id=>params[:managerId]).pluck(:first_name,:mg_employee_position_id,:mg_employee_category_id,:mg_employee_department_id,:id)
   render :partial => "employee_under_manager", :object =>@employeeUnderManager
   
  end

  
end
