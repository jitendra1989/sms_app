class StudentCategoriesController < ApplicationController
   layout "mindcom"
   before_action :set_mg_student_category, only: [:show, :edit, :update, :destroy]
   before_filter :login_required

  # GET /mg_roles
  # GET /mg_roles.json
  #com
  def index
       if request.xhr?
        @index=params[:data]
      @mg_student_categories = MgStudentCategory.where(:is_deleted => '0',:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 5)
    render :layout => false
  else
    @mg_student_categories = MgStudentCategory.where(:is_deleted => '0',:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 5)
  end
  end

  # GET /mg_roles/1
  def show
  end

  # GET /mg_roles/new
  def new
    @mg_student_category = MgStudentCategory.new
    render :layout => false
   
  end

  # GET /mg_roles/1/edit
  def edit
    render :layout => false
  end

  # POST /mg_roles
  # POST /mg_roles.json
  def create
    @mg_student_category = MgStudentCategory.new(mg_create_student_category_params)
    @mg_student_category.save
    redirect_to '/student_categories'

    
  end

  # PATCH/PUT /mg_roles/1
  # PATCH/PUT /mg_roles/1.json
  def update
     @student_category.update(mg_student_category_params)
      redirect_to '/student_categories'

    # respond_to do |format|
    #   if @mg_action.update(mg_action_params)
    #     format.html { redirect_to @mg_action, notice: 'Mg action was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @mg_action }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @mg_action.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /mg_roles/1
  # DELETE /mg_roles/1.json
  def destroy
    @student_category.destroy
    respond_to do |format|
      format.html { redirect_to mg_student_categories_url, notice: 'successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def delete
    @student_category = MgStudentCategory.find(params[:id])


    if @student_category.update(:is_deleted => 1)
        redirect_to '/student_categories'
    else
        
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mg_student_category
      @student_category = MgStudentCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mg_student_category_params
      params.require(:mg_student_category).permit(:name, :is_deleted,:mg_school_id)
    end
    def mg_create_student_category_params
      params.require(:student_category).permit(:name, :is_deleted,:mg_school_id)
    end
end
