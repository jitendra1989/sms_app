class MyQuestionsController < ApplicationController

	before_filter :login_required
   #com
 layout "mindcom"
	def index
	id=session[:user_id]
  mg_school_id=session[:current_user_school_id]
    @employee = MgEmployee.where(:mg_user_id =>id, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:id)
    @my_questions = MgMyQuestion.where(:mg_employee_id=>@employee[0], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)#.order("created_at DESC")
    @batchs=MgBatch.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    @shared=MgBatchContent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>@employee[0]).order('mg_batch_id ASC')#.paginate(page: params[:page], per_page: 10)#.pluck(:mg_my_question_id)
   
  end

  def show
    @my_questions = MgMyQuestion.find(params[:id])
    render :layout => false

  end

  def new
    @my_questions = MgMyQuestion.new
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
  end

  def create
    @my_questions = MgMyQuestion.new(my_questions_params)
    if @my_questions.save
      redirect_to action:'index', notice: "The Content has been successfully created."
    else
      render action: "new"
    end
  end

  def edit
    @my_questions = MgMyQuestion.find(params[:id])
    render :layout => false


  end

  def update
    @my_questions = MgMyQuestion.find(params[:id])
    if @my_questions.update_attributes(my_questions_params)
      redirect_to action:'index', notice: "The Content has been successfully updated."
    else
      render action: "edit"
    end
  end

  def delete
    if  params[:shared]=="shared_file"
      @my_questions=MgBatchContent.find_by_id(params[:id])
      @my_questions.is_deleted =1
      @my_questions.save
    else
      @my_questions=MgMyQuestion.find_by_id(params[:id])
      @my_questions.is_deleted =1
      @my_questions.save

      @batchDocument=MgBatchContent.where(:mg_my_question_id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
      @batchDocument.each do |delete|
      @object=MgBatchContent.find(delete.id)
      @object.is_deleted=1
      @object.save
      end
    end
      redirect_to action:'index'

    end

  def share_to_bach
    mg_school_id=session[:current_user_school_id]
    # @batchs_list=MgBatch.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
       @course_list=MgCourse.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
    puts "batch id"
    # puts @batchs.inspect
    @my_questions_id=params[:id]
   
    
    render :layout => false

  end

  def select_batch
    @batch=MgBatch.where(:is_deleted=>0, :mg_course_id=>params[:course_id], :mg_school_id=>session[:current_user_school_id]).pluck(:name, :id)
        render :layout => false
  end

  def share_to_bach_save
     @mg_employee_id=MgEmployee.find_by_mg_user_id(session[:user_id])
    @batch_content=MgBatchContent.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>params[:contents][:mg_school_id],  :mg_my_question_id=>params[:contents][:mg_my_question_id] )
    if @batch_content.present?   
      @batch_content[0].update(contents_params)
      @batch_content[0].mg_employee_id= @mg_employee_id.id
      @batch_content[0].mg_batch_id=params[:mg_batch_id]
      @batch_content[0].save
      @notice ="Shared content updated successfully."
    else
      @batch_content=MgBatchContent.new(contents_params)
      @batch_content.mg_employee_id=@mg_employee_id.id
       @batch_content.mg_batch_id=params[:mg_batch_id]
      @batch_content.save
      @notice ="Content shared successfully."

    end

    redirect_to action:'index', notice: @notice
  end


private
  def contents_params
    params.require(:contents).permit(:mg_batch_id, :mg_employee_id, :mg_my_question_id, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end
  def my_questions_params
    params.require(:my_questions).permit(:title, :content, :is_deleted, :mg_employee_id, :mg_school_id, :created_by, :updated_by)
  end
end
