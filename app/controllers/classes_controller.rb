class ClassesController < ApplicationController
	 layout "mindcom"
	   before_filter :login_required
	# helper_method :user_signed_in?

 #com
  #    before_filter :user_signed_in?

	 # def user_signed_in?
	 # 	# check user is logged in or not
	 # 	logger.info "Step -- 1"

	 # 	logger.info session[:user_id]
	 # 	logger.info "Step -- 2"
	 # end
	# layout false


	def index
	
		@batches = MgBatch.find_by(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)

		# logger.info " index page "+ @batches.name
	end

	def new
	@courses = MgCourse.new
	@grades=MgExamSystem.where(:is_enabled=>0).pluck(:grading_name,:grading_system)
	@schoolWing=MgWing.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:wing_name,:id)


    # render :layout => false
	end
	def course_by_admin
		@courses = MgCourse.new
		#render :layout => false
	end

	 def edit
	 	@schoolWing=MgWing.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:wing_name,:id)
	    @course = MgCourse.find(params[:id])
	    @grades=MgExamSystem.where(:is_enabled=>0).pluck(:grading_name,:grading_system)
	    @schoolWings=MgWing.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:wing_name,:id)
	     render :layout => false
	  end


	def create
		logger.info "Course Create Method"
	MgCourse.transaction do
	  	@course = MgCourse.new(course_params)

	   @batch = @course.mg_batches.build(batch_params)

	  	if @course.save
			
	    puts "Batch Saving data"
	    puts @batch.inspect
	  	 
	  	@timeformat=MgSchool.find_by_id(@batch.mg_school_id)

	    @startSaveDate = Date.strptime(params[:batch][:start_date],@timeformat.date_format)
		@endSaveDate = Date.strptime(params[:batch][:end_date],@timeformat.date_format)

		@batch.update(:start_date => @startSaveDate,:end_date => @endSaveDate)
	


	  		render 'index'
	  	else
	  		redirect_to 'new'
	  	end
	  end
	end

def check
	add_breadcrumb "modeltest-check", courses_check_path
end

def modeltest
	add_breadcrumb "modeltest", courses_modeltest_path
end

	def show
		
	end

	def addBatch
		logger.info "Batch will going to create"
	end

	def delete
		puts "inside delete"
		@course = MgCourse.find(params[:id])
			
   		 @course.is_deleted=1
   		  @course.save
   		  #Added By Bindhu
		batches_in_class=MgBatch.where(:mg_course_id=>params[:id])
		batches_in_class.each do |batch|
			batch.update(:is_deleted=>1)
		end

   	render 'index'
	end

	def grouped_batches

     @course = MgCourse.find(params[:id])
    @batch_groups = @course.mg_batch_groups
    @batches = @course.active_batches
    @batch_group = MgBatchGroup.new
	end	

	def create_batch_group
		@name=params[:batch_group]
		@batch_group = MgBatchGroup.new(:name=>@name)
		 
		
     @course = MgCourse.find(params[:course_id])
     @batch_group.mg_course_id = @course.id
     @error=false
    if params[:batch_ids].blank?
       @error=true
     end
     if @batch_group.valid? and @error==false
       @batch_group.save
       batches = params[:batch_ids]
       batches.each do|batch|
       MgGroupedBatch.create(:mg_batch_group_id=>@batch_group.id,:mg_batch_id=>batch)
      end
      
    else
      
     end
	end


	def update
		MgCourse.transaction do
		 @course = MgCourse.find(params[:id])
		
	      if @course.update(mg_course_params)
	      	logger.info " index page "
	      #	flash[:notice] = "Course updated successfully!"
	      	render 'index'

	      else
	       # render :layout => false
	      end
	    end
	end

  private

   def mg_course_params
    params.require(:course).permit(:course_name,:section_name,:code,:grading_type,:mg_wing_id)
  end
  
  def course_params

    params.require(:mg_course).permit(:course_name,:section_name,:code,:is_deleted,:grading_type,:mg_school_id,:mg_wing_id)

  end

  def batch_params
  	# date is not saving
     #params.require(:batch).permit( :name,:start_date,:end_date,:is_deleted,:mg_school_id)
     params.require(:batch).permit( :name,:is_deleted,:mg_school_id)
  end
end
