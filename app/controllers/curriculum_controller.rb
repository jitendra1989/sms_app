#class CurriculumManagementsController < ApplicationController
class CurriculumController < ApplicationController
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
  	# puts "session................userid.................."
  	# puts session[:user_id]

  	# puts "=========================9999999999999999"
  	# @studentuserid=session[:user_id]
  	# @guardianuserid=session[:user_id]
  	
  	# @studentuserid=MgStudent.where(:mg_user_id =>session[:user_id])
  	# @guardianuserid=MgGuardian.where(:mg_user_id => session[:user_id])
  	
		 #  	if  (!(@studentuserid[0].to_s.empty?))
		 #  	@studentbatchid=MgStudent.where(:mg_user_id => session[:user_id]).pluck(:mg_batch_id)
		 #    elsif (!(@guardianuserid[0].to_s.empty?))
		 #  	  @guardian=MgGuardian.where(:mg_user_id => session[:user_id]).pluck(:mg_student_id)
		 #  	  @studentbatchid=MgStudent.where(:mg_student_id => @guardian).pluck(:mg_batch_id)
		 #  	  else 
		 #  	  @studentbatchid=MgBatch.where(:is_deleted=0).pluck(:mg_batch_id)
  	#         end
  end
def create
	@curriculum=MgSyllabus.new(curr_params)
	@curriculum.save
	
    redirect_to :action => "class_show"
end
def unit_create
	@curriculum=MgUnit.new(unit_params)
	@curriculum.save
    redirect_to :action => "unit_show"
end

def topic_create
	@curriculum=MgTopic.new(topic_params)
	@curriculum.save
    redirect_to :action => "topic_show"
end
def batch_syllabus_create
	puts params[:mg_batch_id].inspect
	@curriculum=MgBatchSyllabus.new(batchsyllabus_params)
	@curriculum.save
	#params[:topic_name]=Topic.where(:id => params[:topic_name]).pluck(:name)
	@curriculum.update(
					:mg_batch_id => params[:mg_batch_id],
					:mg_subject_id => params[:mg_subject_id],
					:topic_name => params[:topic_name])
   redirect_to :back
   #redirect_to :action => "class_show"
end

def student_curriculum_create
	@curriculum=MgCurriculum.new(curric_params)
	@curriculum.save
	@curriculum.update(
					:mg_subject_id => params[:mg_subject_id],
					:mg_topic_id => params[:mg_topic_id])
	#redirect_to :back
	redirect_to :action => "curriculum_index"
end

def batch_syllabus_edit
	@curriculum = MgBatchSyllabus.find(params[:id])
end

def subject_edit
	@curriculum = MgSyllabus.find(params[:id])
	puts "params[:id]"
	puts params[:id]
	puts"==============================="
	#render :layout => false
end

def unit_edit
	@curriculum = MgUnit.find(params[:id])
	puts "params[:id]"
	puts params[:id]
	puts"==============================="
	#render :layout => false
end

def topic_edit
	@curriculum = MgTopic.find(params[:id])
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
 		  @curriculum = MgSyllabus.find(params[:id])
		 
 		  if @curriculum.update(curr_params)
 		    redirect_to :controller => "curriculum" , :action => "class_show"
 		  else
 		    render 'subject_edit'
 		  end
end



def batch_syllabus_update
	
	 @curriculum = MgBatchSyllabus.find(params[:id])
		 
 		  if @curriculum.update(batc_params)
 		    redirect_to :controller => "curriculum" , :action => "batch_syllabus_show"
 		  else
 		    render 'subject_edit'
 		  end





end





def unit_update
	puts"in subject update method 888888888888885555555555555555555555"
 		  @curriculum = MgUnit.find(params[:id])
		 
 		  if @curriculum.update(unit_params)
 		    redirect_to :controller => "curriculum" , :action => "unit_show"
 		  else
 		    render 'unit_edit'
 		  end
end

def topic_update
	puts"in subject update method 888888888888885555555555555555555555"
 		  @curriculum = MgTopic.find(params[:id])
		 
 		  if @curriculum.update(topics_params)
 		    redirect_to :controller => "curriculum" , :action => "topic_show"
 		  else
 		    render 'topic_edit'
 		  end
end

def  subject_delete
		@curriculum = MgSyllabus.find(params[:id])
			
   		if @curriculum.update(:is_deleted => 1)
   			render 'class_show'
	      else
	    
	    end
	end


	def  unit_delete
		@curriculum = MgUnit.find(params[:id])
			
   		if @curriculum.update(:is_deleted => 1)
   			render 'unit_show'
	      else
	    
	    end
	end


	def batch_syllabus_delete
		@curriculum = MgBatchSyllabus.find(params[:id])
			
   		if @curriculum.update(:is_deleted => 1)
   			render 'batch_syllabus_show'
	      else
	    
	    end
	end


	def  topic_delete
		@curriculum = MgTopic.find(params[:id])
			
   		if @curriculum.update(:is_deleted => 1)
   			render 'topic_show'
	      else
	    
	    end
	end
def batch_syllabus_show
 
end


	def saveBatch

    @selected_batches1 = params[:selected_batches1]
    puts "8888888888888888"
     
    @aa = params[:curriculum]
    puts @aa[:mg_syllabus_id]
    puts "88888888888888"
        for i in 0...@selected_batches1.size
          @batchsyllabus=MgBatchSyllabus.new(batch_params)
           @batchsyllabus.mg_batch_id=@selected_batches1[i]
			@batchsyllabus.mg_syllabus_id=params[:curriculum][:mg_syllabus_id]
			@batchsyllabus.is_deleted=params[:curriculum][:is_deleted]
           
          @batchsyllabus.save
        end

   render 'batch_syllabus_show'
   

  end









private
   def curr_params
     params.require(:curriculum).permit(:mg_subject_id, :name, :description, :is_deleted, :mg_school_id)
   end

   def unit_params
     params.require(:curriculum).permit(:mg_syllabus_id, :unit_name, :description, :hour, :min, :is_deleted, :time, :mg_school_id)
   end
   
   def topic_params
     params.require(:curriculum).permit(:mg_unit_id, :mg_syllabus_id, :topic_name, :description, :is_deleted, :mg_school_id)
   end 
   def topics_params
   	 params.require(:curriculum).permit(:mg_unit_id, :mg_syllabus_id, :topic_name, :description, :is_deleted, :mg_school_id)
   end
   def batchsyllabus_params
     params.require(:curriculum).permit(:mg_batch_id, :mg_subject_id, :topic_name, :is_deleted, :mg_school_id)
   end
   def curric_params
   	 params.require(:curriculum).permit(:mg_user_id, :mg_subject_id, :mg_topic_id, :is_deleted, :mg_school_id)
   	
   end

   def batch_params
   	 params.require(:curriculum).permit(:mg_batch_id, :mg_syllabus_id, :is_deleted, :mg_school_id)
   	
   end

   def batc_params
   	params.require(:curriculum).permit(:mg_batch_id, :mg_syllabus_id, :is_deleted, :mg_school_id)
   end
 end

