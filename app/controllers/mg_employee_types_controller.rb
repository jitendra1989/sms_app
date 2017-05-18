class MgEmployeeTypesController < ApplicationController
  layout "mindcom"
  before_filter :login_required
  def index
    @employeeType=MgEmployeeType.all
    puts @employeeType.inspect

  end

  def create
    @emptypeData=MgEmployeeType.new(employeeType)
     @emptypeData.save
     redirect_to :action=>'index'
  end

  def edit
    @employee_types=MgEmployeeType.find(params[:id])
    puts params[:id]
    #loggweer.infuyfuy
    render :layout=>false
  end

  def type_update
     @employee_types=MgEmployeeType.find(params[:id])
       @employee_types.update(employeeType)
       redirect_to :action=>'index'
  end

  def show
  end

  def new
  end
def destroy
  @employee_types=MgEmployeeType.find(params[:id])
  @employee_types.is_deleted =1
  @employee_types.save
  redirect_to :action=>'index'
end



  def employeeType
    params.require(:employee_types).permit(:employee_type,:is_deleted,:mg_school_id)
  end
end
