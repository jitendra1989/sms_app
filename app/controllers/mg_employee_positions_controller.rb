class MgEmployeePositionsController < ApplicationController
  # /mg_employee_positions
  #com
      before_filter :login_required
   layout "mindcom"
    def index
       @employee_positions = MgEmployeePosition.where(:is_deleted => '0',:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    end


    def new
      @employee_position = MgEmployeePosition.new
      render :layout => false
    end

    def create
    #  render plain: params[:formname].inspect

    	@emp_pos = MgEmployeePosition.new(employee_position_params)
      	@emp_pos.save
       redirect_to '/mg_employee_positions'
    end

    def edit
      @employee_position = MgEmployeePosition.find(params[:id])
      render :layout => false
    end


    def update
        @employee_position = MgEmployeePosition.find(params[:id])

        @employee_position.update(employee_position_params)
        redirect_to '/mg_employee_positions'
    
    end

     def delete
      @employee_position = MgEmployeePosition.find(params[:id])
      #  @employee.destroy
 
       # redirect_to '/employees/show'

        if @employee_position.update(:is_deleted => 1)
          redirect_to '/mg_employee_positions'
          else
        
        end
    end

    def destroy
        @article = MgEmployeePosition.find(params[:id])
        @article.destroy
 
        redirect_to '/mg_employee_positions/show'
end




private
  def employee_position_params
    params.require(:mg_employee_position).permit(:mg_employee_category_id, :position_name,:status,:is_deleted,:mg_school_id)
  end

  def update_param
    params.require(:article).permit(:mg_employee_category_id, :position_name,:status,:mg_school_id)
  end

end
