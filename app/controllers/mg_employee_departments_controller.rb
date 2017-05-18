class MgEmployeeDepartmentsController < ApplicationController
	#mg_employee_departments
  #com
    before_filter :login_required
    layout "mindcom"
    def index
       @employee_departments = MgEmployeeDepartment.where(:is_deleted => '0', :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    end

  	def new
      @employee_department = MgEmployeeDepartment.new
      render :layout => false
  	end

  	def create
      puts employee_department_params

      @emp_dep = MgEmployeeDepartment.new(employee_department_params)
      @emp_dep.save
      redirect_to '/mg_employee_departments'

	end

    def show
	   @art = MgEmployeeDepartment.where(:is_deleted => '0', :mg_school_id=>session[:current_user_school_id])
    end




    def edit
      @employee_department = MgEmployeeDepartment.find(params[:id])
      render :layout => false
    end
        

    def update
        @employee_department = MgEmployeeDepartment.find(params[:id])
        @employee_department.update(employee_department_params)
        redirect_to '/mg_employee_departments' 
    end



    def delete
      @employee_department = MgEmployeeDepartment.find(params[:id])
      #  @employee.destroy
 
       # redirect_to '/employees/show'

        if @employee_department.update(:is_deleted => 1)
          redirect_to '/mg_employee_departments'
          else
        
        end
    end
    
      def destroy
          @article = MgEmployeeDepartment.find(params[:id])
          @article.destroy
   
          redirect_to '/mg_employee_departments/show'
   end



    private
    def employee_department_params
       params.require(:mg_employee_department).permit(:department_name, :department_code, :status, :is_deleted,:mg_school_id)
    end

    def update_param
       params.require(:article).permit(:department_name, :department_code, :status)
    end
end
