class PreviousEducationsController < ApplicationController
	#com
layout "mindcom"
before_filter :login_required

  def new 
		@previous_educations=MgPreviousEducation.new
		@last_guardian=MgGuardian.last
		@last_studentId=@last_guardian.mg_student_id
		puts "sssssssssssss"
		puts @last_studentId
		puts "sssssssssssssssssssssss"
		end
	
		def index
	
		  	@previous_educations = MgPreviousEducation.all


		end

		def create
		  	@previous_educations=MgPreviousEducation.new(edu_params)
		  	puts "555555555555555"
		  	@previous_educations.save
		  	redirect_to '/students'
			  	#if @previous_educations.save
			  	#	redirect_to '/students_path'
			    #redirect_to :action => "show", :id => @previous_educations.id
			  #	else
			  		#redirect_to students_path
			   # render 'new'
			  	#end
		end

		def newdetail 
			@previous_educations=MgPreviousEducation.find_by_id(params[:id])
			puts "fdsafsdfasdfsadfasdfdsafasdfsda"
			@id= params[:id]
			puts params[:id]
			render :layout => false
		end

		def show
			puts "6666666666666666666666"
			puts params[:id]
			puts "666666666666666666666"
			@previous_educations=MgPreviousEducation.find_by_mg_student_id(params[:id])
puts "1111111111111111111111111111111111"
			
			 if(!(@previous_educations!=nil))
			 	puts "22222222222222222222222222222222"
			
			@previous_educations=MgPreviousEducation.new
			#@previous_educations = MgPreviousEducation.find(params[:id])
			@last_studentId=params[:id]

		  	puts "step --1 "
		  	puts @previous_educations.inspect
		  	
		  	puts "step --1 "
		  	#render :layout => false
				
				redirect_to :controller => "previous_educations" , :action => "new_pre_education" , :id => @last_studentId 
			
		  else
		  puts "333333333333333333333"	
		  render :layout => false
		end
		end

		def new_pre_education
			@inputId=params[:id]
			logger.info(@inputId)
			render :layout=>false
		end


	  	def edit
	 	@previous_educations = MgPreviousEducation.find(params[:id])
	 	render :layout => false

		end

		def update
		  @previous_educations = MgPreviousEducation.find(params[:id])
		 
		  if @previous_educations.update(edu_params)
		    redirect_to :controller => "students" , :action => "index"
		  else
		    render 'edit'
		  end
		end
		def delete
			@previous_educations=MgPreviousEducation.find_by_id(params[:id])
		     @previous_educations.destroy
		     redirect_to '/previous_educations_path'
		end

		def destroy
			@previous_educations=MgPreviousEducation.find_by_id(params[:id])
		     @previous_educations.destroy
		     redirect_to '/previous_educations_path'
    			# @subjects.update_attribute(:is_deleted=>false)
			# @subjects = MgSubject.find(params[:id])
			
		  # @previous_educations = MgPreviousEducations.find(params[:id])
		  # @previous_educations =MgPreviousEducations.connection.execute("update mg_previous_educations set is_deleted=0")
		  # @previous_educations.destroy
		 
		  
		end

  private
  def edu_params
    params.require(:previous_educations).permit(:school_name, :course, :year, :total_marks, :marks_obtained, :grade, :mg_student_id, :mg_school_id, :is_deleted)
  end
end