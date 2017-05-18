class CurriculumManagementsController < ApplicationController
	before_filter :login_required
	layout "mindcom"
  def index
  end
  

  def unit_index
  	
  end

  def topic_index
  	
  end

  def batchsubject_index
  	@id=params[:mg_batch_id]

  end

  def curriculum_index
  	puts "session................userid.................."
  	puts session[:user_id]

  	puts "=========================9999999999999999"
  	@studentuserid=session[:user_id]
  	@guardianuserid=session[:user_id]
  	@studentuserid=MgStudent.where(:mg_user_id =>session[:user_id])
  	@guardianuserid=MgGuardian.where(:mg_user_id => session[:user_id])
		  	if  (!(@studentuserid[0].to_s.empty?))
		  	@studentbatchid=MgStudent.where(:mg_user_id => session[:user_id]).pluck(:mg_batch_id)
		    elsif (!(@guardianuserid[0].to_s.empty?))
		  	  @guardian=MgGuardian.where(:mg_user_id => session[:user_id]).pluck(:mg_student_id)
		  	  @studentbatchid=MgStudent.where(:mg_student_id => @guardian).pluck(:mg_batch_id)
  	        end
  end
def create
	@curriculum_managements=Syllabus.new(curr_params)
	@curriculum_managements.save
    redirect_to :action => "class_show"
end
def unit_create
	@curriculum_managements=Unit.new(unit_params)
	@curriculum_managements.save
    redirect_to :action => "unit_show"
end

def topic_create
	@curriculum_managements=Topic.new(topic_params)
	@curriculum_managements.save
    redirect_to :action => "topic_show"
end
def batch_syllabus_create
	puts params[:mg_batch_id].inspect
	@curriculum_managements=MgBatchSyllabus.new(batchsyllabus_params)
	@curriculum_managements.save
	#params[:topic_name]=Topic.where(:id => params[:topic_name]).pluck(:name)
	@curriculum_managements.update(
					:mg_batch_id => params[:mg_batch_id],
					:mg_subject_id => params[:mg_subject_id],
					:topic_name => params[:topic_name])
   redirect_to :back
   #redirect_to :action => "class_show"
end

def student_curriculum_create
	@curriculum_managements=MgCurriculum.new(curric_params)
	@curriculum_managements.save
	@curriculum_managements.update(
					:mg_subject_id => params[:mg_subject_id],
					:mg_topic_id => params[:mg_topic_id])
	#redirect_to :back
	redirect_to :action => "curriculum_index"
end

def subject_edit
	@curriculum_managements = Syllabus.find(params[:id])
	puts "params[:id]"
	puts params[:id]
	puts"==============================="
	render :layout => false
end

def unit_edit
	@curriculum_managements = Unit.find(params[:id])
	puts "params[:id]"
	puts params[:id]
	puts"==============================="
	#render :layout => false
end

def topic_edit
	@curriculum_managements = Topic.find(params[:id])
	puts "params[:id]"
	puts params[:id]
	puts"==============================="
	#render :layout => false
end

def batchsubject_new
	@demo=params[:mg_batch_id]
	puts "778888888888888888888888"
	puts @demo.inspect
	puts "778888888888888888888888"
	render :layout => false
end

def batchsubject_syllabus
	@value=params[:mg_subjects_id]
	puts "888888888888888888888"
	puts params[:mg_subjects_id]
	puts "8888888888888888"
	render :layout => false
	
end
def student_syllabus
	render :layout => false
end

def employee_subject
	render :layout => false
	
end

def employee_topic
	render :layout => false
	
end

# def update
# puts "update"
# puts params[:id]
# puts "8888888888888888888"
# 	@curriculum_managements = Syllabus.find(params[:id])
# 	puts"in only update method 888888888888885555555555555555555555"
		 
#  		  if @curriculum_managements.update(curr_params)
#  		    redirect_to :controller => "curriculum_managements" , :action => "class_show"
#  		  else
#  		    render 'edit'
#  		  end
 	
	
# end

def subject_update
	puts"in subject update method 888888888888885555555555555555555555"
 		  @curriculum_managements = Syllabus.find(params[:id])
		 
 		  if @curriculum_managements.update(curr_params)
 		    redirect_to :controller => "curriculum_managements" , :action => "class_show"
 		  else
 		    render 'subject_edit'
 		  end
end

def unit_update
	puts"in subject update method 888888888888885555555555555555555555"
 		  @curriculum_managements = Unit.find(params[:id])
		 
 		  if @curriculum_managements.update(unit_params)
 		    redirect_to :controller => "curriculum_managements" , :action => "unit_show"
 		  else
 		    render 'unit_edit'
 		  end
end

def topic_update
	puts"in subject update method 888888888888885555555555555555555555"
 		  @curriculum_managements = Topic.find(params[:id])
		 
 		  if @curriculum_managements.update(topics_params)
 		    redirect_to :controller => "curriculum_managements" , :action => "topic_show"
 		  else
 		    render 'topic_edit'
 		  end
end

def  subject_delete
		@curriculum_managements = Syllabus.find(params[:id])
			
   		if @curriculum_managements.update(:is_deleted => 1)
   			render 'class_show'
	      else
	    
	    end
	end


	def  unit_delete
		@curriculum_managements = Unit.find(params[:id])
			
   		if @curriculum_managements.update(:is_deleted => 1)
   			render 'unit_show'
	      else
	    
	    end
	end


	def  topic_delete
		@curriculum_managements = Topic.find(params[:id])
			
   		if @curriculum_managements.update(:is_deleted => 1)
   			render 'topic_show'
	      else
	    
	    end
	end


private
   def curr_params
     params.require(:curriculum_managements).permit(:mg_subject_id, :class_name, :description, :is_deleted)
   end

   def unit_params
     params.require(:curriculum_managements).permit(:mg_syllabus_id, :name, :description, :hour, :min, :is_deleted)
   end
   
   def topic_params
     params.require(:curriculum_managements).permit(:mg_unit_id, :name, :description, :mg_subject_id, :is_deleted)
   end 
   def topics_params
   	 params.require(:curriculum_managements).permit(:mg_unit_id, :name, :description, :is_deleted)
   end
   def batchsyllabus_params
     params.require(:curriculum_managements).permit(:mg_batch_id, :mg_subject_id, :topic_name, :is_deleted)
   end
   def curric_params
   	 params.require(:curriculum_managements).permit(:mg_user_id, :mg_subject_id, :mg_topic_id, :is_deleted)
   	
   end
 end

