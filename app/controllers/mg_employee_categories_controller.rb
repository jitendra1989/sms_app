class MgEmployeeCategoriesController < ApplicationController

  #com
  layout "mindcom"
      before_filter :login_required
	def index

     @employee_categories = MgEmployeeCategory.where(:is_deleted => '0', :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    # @employee_categories = MgEmployeeCategory.all 
    # render :layout => false

  end

  def new
      @mg_employee_category = MgEmployeeCategory.new
      render :layout => false
  end


  def create

   @emp_cat = MgEmployeeCategory.new(employee_category_params)
   @emp_cat.save
   redirect_to '/mg_employee_categories'
 #  render 'index'
   #mg_employee_category
 
  # respond_to do |format| 
  #   if @emp_cat.save
  #       # format.html { redirect_to @emp_cat, notice: 'Person was successfully created.' }
  #       # format.json { render :show, status: :created, location: @emp_cat }
  #  # added:
  #       format.js   { render action: 'show' }
   
  #     else
  #       format.html { render :new }
  #       format.json { render json: @emp_cat.errors, status: :unprocessable_entity }
  #    # added:
  #       format.js   { render json: @emp_cat.errors, status: :unprocessable_entity }
  
  #   end     
 # end     
  
  # render :action => 'show', :id => @article.id
end

def show
  puts "show is called"
	@articles = MgEmployeeCategory.where(:is_deleted => '0', :mg_school_id=>session[:current_user_school_id])
   
end




    def edit
      @mg_employee_category = MgEmployeeCategory.find(params[:id])
      render :layout => false
    end

    def update
        #puts "Updaate method"
        @mg_employee_category = MgEmployeeCategory.find(params[:id])
        @mg_employee_category.update(employee_category_params)
         redirect_to '/mg_employee_categories'
        #redirect_to '/employees'
        #render :layout => false
        # respond_to do |format|  dataType : 'html',
        #  if @mg_employee_category.update(employee_category_params)
        #     @mg_employee_list = MgEmployeeCategory.all
        #     format.js   { render action: 'table' }
    
        #   else
            
        #   end
        # end
    end

    def delete
      @employee = MgEmployeeCategory.find(params[:id])
      #  @employee.destroy
 
       # redirect_to '/employees/show'

        if @employee.update(:is_deleted => 1)
          redirect_to '/employees'
          else
        
        end
    end
    
    def destroy
        @employee = MgEmployeeCategory.find(params[:id])
        @employee.destroy
 
        redirect_to '/mg_employee_categories'
    end



 
private


  def employee_category_params
    params.require(:mg_employee_category).permit(:category_name, :prefix, :suffix ,:status,:is_deleted, :mg_school_id)
  end


  def update_employee_category_param
    params.require(:article).permit(:category_name, :prefix, :suffix ,:status)
  end
end
