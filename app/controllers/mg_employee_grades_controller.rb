class MgEmployeeGradesController < ApplicationController
  #com
layout "mindcom"
    before_filter :login_required
    # is_applicable
    def index
       @employee_grades = MgEmployeeGrade.where(:is_deleted => '0', :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    end
    
    def new
      mg_school_id=session[:current_user_school_id]
      @salary_components=MgSalaryComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
      @employee_grade = MgEmployeeGrade.new
      render :layout => false
    end

    def create
    #  render plain: params[:formname].inspect
      # begin
      # mg_salary_component_id
      puts params[:is_applicable]
      # puts frweigeruji
          MgEmployeeGrade.transaction do
            @emp_grade = MgEmployeeGrade.new(employee_grade_params)
           @emp_grades= @emp_grade.save
                if params[:salary_component_name].present?
                    params[:salary_component_name].each_with_index do |components,grade|
                      is_applicable_value=0
                      if params[:is_applicable].present?
                        is_applicable_value=params[:is_applicable].include?(components[0]) ? 1 :0
                      end
                      @grade_components=@emp_grade.mg_grade_components.build(:is_applicable=>is_applicable_value, :is_deleted=>0, :mg_salary_component_id=>components[0], :amount=>components[1], :mg_school_id=>params[:mg_employee_grade][:mg_school_id], :created_by=>params[:mg_employee_grade][:created_by], :updated_by=>params[:mg_employee_grade][:created_by])
                      @grade_components.save
                    end
                end
          end

       

        if @emp_grades
          flash[:notice] = "Grade created successfully"
        else
          flash[:error]="Error occured, please contact administrator"
        end
      # rescue Exception => e
      #   flash[:error]="Error occured, please contact administrator"
      # end
         redirect_to '/mg_employee_grades'
    end

    def edit
      mg_school_id=session[:current_user_school_id]
      @salary_components=MgSalaryComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
      @employee_grade = MgEmployeeGrade.find(params[:id])
      render :layout => false
    end


    def update
      updated_by=session[:user_id]
      mg_school_id=session[:current_user_school_id]
         begin
          MgEmployeeGrade.transaction do
            @employee_grade = MgEmployeeGrade.find(params[:id])
            @employee_grade.update(employee_grade_params)
            if params[:salary_component_name].present?
              params[:salary_component_name].each_with_index do |components,grade|
                @grade_components=@employee_grade.mg_grade_components.find_by(:is_deleted=>0, :mg_salary_component_id=>components[0], :mg_school_id=>params[:mg_employee_grade][:mg_school_id])
                 is_applicable_value=0
                      if params[:is_applicable].present?
                        is_applicable_value=params[:is_applicable].include?(components[0]) ? 1 :0
                      end
                     
                if  @grade_components.present? 
                @grade_components.amount=components[1]
                @grade_components.updated_by=updated_by
                @grade_components.is_applicable=is_applicable_value
                @grade_components.save
                else
                @grade_components=@employee_grade.mg_grade_components.build(:is_deleted=>0, :employee_coponent=>components[0], :amount=>components[1], :mg_school_id=>params[:mg_employee_grade][:mg_school_id], :created_by=>updated_by, :updated_by=>updated_by)
                @grade_components.save
                end
              end
            end
         
           @is_applicable=MgGradeComponent.where(:mg_employee_grade_id=>params[:id] ,:is_deleted=>0, :mg_school_id=>mg_school_id, :is_applicable=>1)#.pluck(:mg_salary_component_id)
           puts "------------------------------------step-1--------------------------------------------"
           puts @is_applicable.inspect
           @employee=MgEmployee.where(:is_deleted=>0, :mg_employee_grade_id=>params[:id], :mg_school_id=>mg_school_id)
           # grade_component=MgGradeComponent.where(:is_applicable=>1, :is_deleted=>0, :mg_school_id=>mg_school_id, :mg)
           @employee_coponent_arr=[]
          @employee.each do |emp|

          employee_coponent=MgEmployeeGradeComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>emp.id)

              employee_coponent.each do |component|
                update_object=MgEmployeeGradeComponent.where(:mg_employee_id=>emp.id,:mg_school_id=>mg_school_id, :is_deleted=>0)
                @employee_coponent_arr +=update_object.pluck(:id)
                update_object.update_all(:is_deleted=>1)

              end

              @is_applicable.each do |grade|
                object=MgEmployeeGradeComponent.find_by(:mg_employee_id=>emp.id,:mg_school_id=>mg_school_id, :mg_salary_component_id=>grade.mg_salary_component_id, :id=>@employee_coponent_arr)#.pluck(:mg_salary_component_id)
                if object.present?
                  object.update(:is_deleted=>0)
                  if !object.is_edited
                    object.update(:amount=>grade.amount)
                  end
                else
                  employee_coponent_new=MgEmployeeGradeComponent.new(:amount=>grade.amount,:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>emp.id, :mg_salary_component_id=>grade.mg_salary_component_id, :created_by=>updated_by, :updated_by=>updated_by)
                  employee_coponent_new.save
                end
              end
           end

           puts "------------------------------------step-2-------------------------------------------"

         end
         if @grade_components
          flash[:notice] = "Grade updated successfully"
         # else
         #  flash[:error]="Error occured, please contact administrator"
         end
      rescue Exception => e
        flash[:error]="Error occured, please contact administrator"
        puts e
      end

        redirect_to '/mg_employee_grades'
    
    end

     def delete
      mg_school_id=session[:current_user_school_id]
      @employee_grade = MgEmployeeGrade.find(params[:id])
      @employee=MgEmployee.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_grade_id=>params[:id])
       
     if  @employee.present?
      @value="not_deleted"
     else
        if @employee_grade.update(:is_deleted => 1)
          @value="deleted"
        end
     end

         respond_to do |format|
            format.json  { render :json => {'validation'=> @value } }
          end
    end

    def destroy
        @article = MgEmployeeGrade.find(params[:id])
        @article.destroy
 
        redirect_to '/mg_employee_grades/show'
end
def show
    mg_school_id=session[:current_user_school_id]
    @salary_components=MgSalaryComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
    @employee_grade = MgEmployeeGrade.find(params[:id])
    render :layout => false
  
end

def edit_employee_salary
  mg_school_id=session[:current_user_school_id]
  @employee=MgEmployee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).order(:first_name).paginate(page: params[:page], per_page: 10)
end

def edit_employee_salary_by_grade
 mg_school_id=session[:current_user_school_id]
  @mg_employee_grade_components=MgEmployeeGradeComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>params[:id])
  
  render :layout => false
  
end

def save_employee_salary
  @object=false
  if params[:salary_component_name].present?
      params[:salary_component_name].each do |key, value|
        object=MgEmployeeGradeComponent.find_by(:id=>key)
        if object.present?
            if object.amount.to_f==value.to_f
              if !object.is_edited
                object.is_edited=0
              end
            else
              object.is_edited=1
            end
            object.amount=value.to_f
            @object=object.save
        end
      end
      
  end
  if @object
    flash[:notice]="Salary Component updated successfully"
  else
    flash[:error]="Error occured, please contact administrator"
  end
  redirect_to :back
end




private
  def employee_grade_params
    params.require(:mg_employee_grade).permit(:priority, :grade_name,:status,:is_deleted, :mg_school_id, :created_by, :updated_by)
  end

  def update_param
    params.require(:article).permit(:mg_employee_category_id, :position_name,:status, :mg_school_id, :created_by, :updated_by)
  end

end
