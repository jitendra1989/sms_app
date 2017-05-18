class EntranceExamDetailsController < ApplicationController
	before_filter :login_required
  layout "mindcom"

	def index
		@exam_detail = MgEntranceExamDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order(:mg_course_id).paginate(page: params[:page], per_page: 10)
	end

	def new		
		@entrance_exam = MgEntranceExamDetail.new
		@institute_name = MgEntranceExamVenue.where(:is_deleted=>0,:updated_by=>session[:user_id],:created_by=>session[:user_id],:mg_school_id=>session[:current_user_school_id])		
	end

	def create	
		@entrance_exam = MgEntranceExamDetail.new(params_exam_details)

		is_save=@entrance_exam.save
		if is_save
			if(params[:exam_detail][:start_date]).present?
  			current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
  			start_date =Date.strptime(params[:exam_detail][:start_date],current_school.date_format)
  			@entrance_exam.update(:start_date=>start_date)
        
        @selected_student_id = params[:selectedStudentID]

        if @selected_student_id.present?
          @selected_student_id.each do |id|
            @student=MgStudentAdmission.where(:id=>id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            @student.update_all(:mg_entrance_exam_details_id=>@entrance_exam.id)
          end
        end
			end
  			flash[:notice]="Exam created Successfully.."
  			redirect_to :controller=>'entrance_exam_details', :action=>'index'  
		else
			flash[:error]="There is some problem"
			redirect_to :controller=>'entrance_exam_details', :action=>'index'
		end		
	end
	
	def show
		@exam_details = MgEntranceExamDetail.find(params[:id])
		render :layout=>false
	end

	def edit
		@exam_detail = MgEntranceExamDetail.find_by(:id=>params[:id])
		@institute_name = MgEntranceExamVenue.where(:is_deleted=>0,:updated_by=>session[:user_id],:created_by=>session[:user_id],:mg_school_id=>session[:current_user_school_id])#.pluck(:institute_name,:id)
    @students=MgStudentAdmission.where(:mg_entrance_exam_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@exam_detail.mg_course_id) 
	
    @student_array=[]
    @students.each do|stu_obj|
      students_arr=[]
      key="#{stu_obj.first_name}(#{stu_obj.student_temporary_id})"+" "
      value=stu_obj.id
      students_arr.push(key,value)
      @student_array.push(students_arr)
    end
  end

	def update	
		@entrance_exam_details = MgEntranceExamDetail.find_by(:id=>params[:id])
        @all_student=MgStudentAdmission.where(:mg_entrance_exam_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:id)
		is_update=@entrance_exam_details.update(params_exam_details)
		if is_update
			if(params[:exam_detail][:start_date]).present?
				current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
				start_date = Date.strptime(params[:exam_detail][:start_date],current_school.date_format)
				@entrance_exam_details.update(:start_date=>start_date)

        @selected_student_id = params[:selectedEditStudentID]
        @student_array = @selected_student_id.map{|i| i.to_i}
        @unselect_student = @all_student-@student_array
        if @unselect_student.present?
          @unselect_student.each do |id|
            @student=MgStudentAdmission.where(:id=>id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            @student.update_all(:mg_entrance_exam_details_id=>0)
          end
        end

        if @selected_student_id.present?
          @selected_student_id.each do |id|
            @student=MgStudentAdmission.where(:id=>id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            @student.update_all(:mg_entrance_exam_details_id=>@entrance_exam_details.id)
          end
        end
			end
			flash[:notice]="Updated Successfully.."
			redirect_to :controller=>'entrance_exam_details', :action=>'index'
		else
			flash[:error]="Allready exam created for this class"
			redirect_to :controller=>'entrance_exam_details', :action=>'index'
		end		
	end

	def destroy	
		@entrance_exam_details = MgEntranceExamDetail.find(params[:id])
    @all_student=MgStudentAdmission.where(:mg_entrance_exam_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @entrance_exam_details.update(:is_deleted=>1)
    @all_student.each do |student|
      student.update(:mg_entrance_exam_details_id=>0)
    end   
    respond_to do |format|
 	 	  format.json {render :json=>@exam_detail}
    end
	end

	def exam_venue
		@exam_venue = MgEntranceExamVenue.where(:is_deleted=>0,:updated_by=>session[:user_id],:created_by=>session[:user_id],:mg_school_id=>session[:current_user_school_id]).paginate(page:params[:page],per_page:10)
	end

	def new_exam_venue
		exam_venue = MgEntranceExamVenue.new
		render :layout=>false
	end

	def create_exam_venue
		@venue_creat = MgEntranceExamVenue.new(:institute_name=>params[:exam_venue][:institute_name],:exam_venue=>params[:exam_venue][:exam_venue],:is_deleted=>params[:exam_venue][:is_deleted],:updated_by=>params[:exam_venue][:updated_by],:created_by=>params[:exam_venue][:created_by],:mg_school_id=>params[:exam_venue][:mg_school_id])
		@venue_created = @venue_creat.save
		if @venue_created
			flash[:notice]="Successfully Created"
			redirect_to :controller=>'entrance_exam_details',:action=>'exam_venue'
		else
			flash[:error]="Allready Venue created for this Institute"
			redirect_to :controller=>'entrance_exam_details',:action=>'exam_venue'
		end
	end

	def show_exam_venue
		@exam_venue = MgEntranceExamVenue.where(:is_deleted=>0,:updated_by=>session[:user_id],:created_by=>session[:user_id],:mg_school_id=>session[:current_user_school_id]).paginate(page:params[:page],per_page:10)
		@exam_venues = MgEntranceExamVenue.find(params[:id])
		render :layout=>false
	end

	def edit_exam_venue
		@exam_venue = MgEntranceExamVenue.find(params[:id])
		render :layout=>false
	end

	def update_exam_venue		
		@exams_venues = MgEntranceExamVenue.find(params[:id])
		@update_venue = @exams_venues.update(:institute_name=>params[:mg_entrance_exam_venue][:institute_name],:exam_venue=>params[:mg_entrance_exam_venue][:exam_venue],:is_deleted=>params[:mg_entrance_exam_venue][:is_deleted],:updated_by=>params[:mg_entrance_exam_venue][:updated_by],:created_by=>params[:mg_entrance_exam_venue][:created_by],:mg_school_id=>params[:mg_entrance_exam_venue][:mg_school_id])
		if @update_venue
			flash[:notice]="Successfully Updated.."
			redirect_to :controller=>'entrance_exam_details',:action=>'exam_venue'
		else
			flash[:error]="Allready Venue created for this Institute"
			redirect_to :controller=>'entrance_exam_details',:action=>'exam_venue'
		end		
	end

	def destroy_exam_venue	
		@exams_venues = MgEntranceExamVenue.where(:id=>params[:id])
		@exams_venues[0].update(:is_deleted=>1)
		respond_to do |format|
   	 	format.json {render :json=>@exams_venues}
     end
	end
	
	def center_name
		if request.xhr?
			@venue_detail = MgEntranceExamVenue.find_by(:id=>params[:institute_id])		
		 	render :json=>{:venue_detail=>@venue_detail}
   	end
	end

	def cut_off_index	
		@cours_id=MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_course_id).uniq
    @course_name =MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
		
	end

	def select_student_list
    search_index = params[:search_index]
    case search_index
    when "search_by_marks"
  		@student_list_count=0
      if params[:search_id].present?
  			@student_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and marks_obtained >= (?)",0,session[:current_user_school_id],params[:mg_course_id],params[:search_id]).order('marks_obtained DESC')
  			@student_list_count = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and marks_obtained >= (?)",0,session[:current_user_school_id],params[:mg_course_id],params[:search_id]).count
    	else
  			@student_list = MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_course_id]).order('marks_obtained DESC')
  			@student_list_count = MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_course_id]).count#.paginate(page: params[:page], per_page: 10)
     	end
    when "search_by_index"
      if params[:search_id].present? && params[:upper_index].present?
        @student_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and selection_index>=? and selection_index<=?",0,session[:current_user_school_id],params[:mg_course_id],params[:search_id],params[:upper_index]).order('selection_index DESC')
        @student_list_count = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and selection_index>=? and selection_index<=?",0,session[:current_user_school_id],params[:mg_course_id],params[:search_id],params[:upper_index]).count
      elsif !params[:search_id].present? && params[:upper_index].present?
        @student_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and selection_index<=?",0,session[:current_user_school_id],params[:mg_course_id],params[:upper_index]).order('selection_index DESC')
        @student_list_count = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and selection_index<=?",0,session[:current_user_school_id],params[:mg_course_id],params[:upper_index]).count
      elsif params[:search_id].present? && !params[:upper_index].present?
        @student_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and selection_index>=?",0,session[:current_user_school_id],params[:mg_course_id],params[:search_id]).order('selection_index DESC')
        @student_list_count = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and selection_index>=?",0,session[:current_user_school_id],params[:mg_course_id],params[:search_id]).count
      else
        @student_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=?",0,session[:current_user_school_id],params[:mg_course_id]).order('selection_index DESC')
        @student_list_count = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=?",0,session[:current_user_school_id],params[:mg_course_id]).count
      end
    else
      @student_list = MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_course_id]).order('marks_obtained DESC')
      @student_list_count = MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_course_id]).count#.paginate(page: params[:page], per_page: 10)
    end
    render :layout=>false 
	end

	def update_mg_student
		@school = MgSchool.where(:id=>session[:current_user_school_id],:is_deleted=>0)
    boolean_val = @school[0].disable_entrance_exam_test
		@appear_all_studentid = params[:appear_all_studentid]
		@shortlisted_for_exam = params[:shortlisted_for_exam]
		
		case boolean_val
		when true
			if params[:options_for_select_exam] == "selectentranceexam"
	   		if @shortlisted_for_exam.present?
					@shortlisted_for_exam.each do |stu_id|
						@mg_student = MgStudentAdmission.find_by(:id=>stu_id).update(:is_selected_for_entrance_test=>'accepted')
					end
				end
		 else
	     if @shortlisted_for_exam.present?
			   @shortlisted_for_exam.each do |stu_ids|
			     @mg_student = MgStudentAdmission.find_by(:id=>stu_ids).update(:is_selected_for_entrance_test=>'rejected')
				 end
			 end
			end
		when false 
    	@error_msg=false
			if params[:options_for_select_exam] == "selectentranceexam"
	   		if @shortlisted_for_exam.present?
					@shortlisted_for_exam.each do |stu_id|
						@mg_student = MgStudentAdmission.find_by(:id=>stu_id)
          	@mg_student.update(:is_selected_for_entrance_test=>'accepted',:is_shortlisted_for_admission=>'accepted')
					end
				end
		 else
	     if @shortlisted_for_exam.present?
			   @shortlisted_for_exam.each do |stu_ids|
        	 @mg_student = MgStudentAdmission.find_by(:id=>stu_ids).update(:is_selected_for_entrance_test=>'rejected',:is_shortlisted_for_admission=>'rejected')
         end
			 end
		 end
     flash[:notice]="Successfully Updated"
	  end
		redirect_to :controller=>'entrance_exam_details',:action=>'cut_off_index'		
	end

	def exam_marks
		@cours_id=MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_course_id).uniq
    @course_name =MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)		
	end

	def student_marks_obtain
		@student_marks_list = MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_course_id],:is_selected_for_entrance_test=>'accepted').order('marks_obtained DESC')
		render :layout=>false	
	end

	def update_student_marks
		@student_ids = params[:student_admisstion_id]
		if @student_ids.present?
			for i in 0...@student_ids.size					   
      	@mg_student = MgStudentAdmission.where(:id=>@student_ids[i],:mg_course_id=>params[:mg_course_id])
      	if @mg_student.present?
      		@mg_student.update_all(:exam_total_marks=>params[:exam_total_marks][i],:obtained_marks=>params[:obtained_marks][i])      	
				end
			end
		end
		flash[:notice]="Marks Updated Successfully!!"
		redirect_to :controller=>'entrance_exam_details',:action=>'exam_marks'		
	end

	def selection_for_exam
		@cours_id=MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_course_id).uniq
		@course_name =MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)		
	end

	def selection_for_admission_exam
		if params[:search_id].present? && params[:upper_index].present?
  		@students_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and is_selected_for_entrance_test=? and selection_index>=? and selection_index<=?",0,session[:current_user_school_id],params[:mg_course_id],'accepted',params[:search_id],params[:upper_index]).order('selection_index DESC')
    elsif !params[:search_id].present? && params[:upper_index].present?
      @students_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and is_selected_for_entrance_test=? and selection_index<=?",0,session[:current_user_school_id],params[:mg_course_id],'accepted',params[:upper_index]).order('selection_index DESC')
    elsif params[:search_id].present? && !params[:upper_index].present?
      @students_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and is_selected_for_entrance_test=? and selection_index>=?",0,session[:current_user_school_id],params[:mg_course_id],'accepted',params[:search_id]).order('selection_index DESC')
    else
  		@students_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and is_selected_for_entrance_test=?",0,session[:current_user_school_id],params[:mg_course_id],'accepted').order('selection_index DESC')
   	end
    render :layout=>false
	end

	def update_for_admission
		@student_admission_id = params[:student_admission_id]
    @shortlisted_for_admission = params[:shortlisted_for_admission]
    @mg_school_id = session[:current_user_school_id]
    @session_user = session[:user_id]
    
    if params[:option]=="1"
      if @shortlisted_for_admission.present?
        @shortlisted_for_admission.each do |stu_id|
          @mg_student = MgStudentAdmission.find_by(:id=>stu_id)
          @mg_student.update(:is_shortlisted_for_admission=>'accepted')
          #@mg_users = MgUser.find_by(:mg_student_admission_id=>stu_id)
         # if @mg_users.present?
         #   @mg_users.update(:is_deleted=>0)
         #   MgStudent.find_by(:mg_student_admission_id=>stu_id).update(:is_deleted=>0)
         # else
            # @subdomain = MgSchool.where(:id=>session[:current_user_school_id]).pluck(:subdomain)     
         #    user= MgUser.where(:mg_school_id=>session[:current_user_school_id],:user_type=>'student').last
         #    @user = user.user_name.split('S').last
         #    @users =(@user.to_i + 1 ).to_s
         #    @users_name = @subdomain[0]+'S'+@users
            
         #    @mg_user_id = MgUser.create(:password=>"student123", :user_type=>'student',:user_name=>@users_name,:first_name=>@mg_student.first_name,:middle_name=>@mg_student.middle_name,:last_name=>@mg_student.last_name,
         #                  :email=>@mg_student.mg_email_id,:mg_student_admission_id=>stu_id,:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:created_by=>session[:user_id],:updated_by=>session[:user_id])
         #    students = MgStudent.students(@users_name,@mg_user_id,@mg_student,@mg_school_id,@session_user)
         #  end
        end
      end
   else
     if @shortlisted_for_admission.present?
       @shortlisted_for_admission.each do |stu_ids|
         @mg_student = MgStudentAdmission.find_by(:id=>stu_ids).update(:is_shortlisted_for_admission=>'rejected')
         
        # @mg_user = MgUser.find_by(:mg_student_admission_id=>stu_ids)
        #  if @mg_user.present?
        #   @mg_user.update(:is_deleted=>1)
        #   MgStudent.find_by(:mg_student_admission_id=>stu_ids).update(:is_deleted=>1)
        # end
       end
      end
    end
    flash[:notice]="Successfully Updated"
    redirect_to :controller=>'entrance_exam_details',:action=>'selection_for_exam'  		
	end

	def exam_test_center
	end

	def show_center
		render :layout=>false
	end

	def update_center
		@school = MgSchool.where(:id=>session[:current_user_school_id],:is_deleted=>0)
		if @school.present?
			@school[0].update(:disable_entrance_exam_test=>params[:exam_center][:entrance_exam_test],:is_test_center=>params[:exam_center][:is_test_center])
		end
		redirect_to :controller=>'entrance_exam_details',:action=>'exam_test_center'
	end

  def students_index
    @cours_id=MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_course_id).uniq
    @course_name =MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)    
  end

  def students_index_list
    @student_marks_list = MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_course_id]).order('student_temporary_id ASC')
    render :layout=>false 
  end

  def update_student_index
    puts params[:index]
    if params[:index].present?
      params[:index].each do |key, value|
        @mg_student = MgStudentAdmission.find_by(:id=>key)
        @mg_student.update(:selection_index=>value)
      end
    end
    redirect_to :controller=>'entrance_exam_details',:action=>'students_index'
  end
  
  def print_list
    @session_id = session[:current_user_school_id]
    @students_id = params[:students_id]
    @mg_course_id = params[:mg_course_id]
    @school=MgSchool.find(session[:current_user_school_id])
    @school_logo=@school.logo.url(:medium,:timestamp=>false)
    @date_format = MgSchool.find_by(:id=>session[:current_user_school_id]).date_format

    respond_to do |format|
      format.html
      format.pdf do
        pdf = SelectedStudentList.new(@session_id,@students_id,@mg_course_id,@school,@school_logo,@date_format)
        send_data pdf.render, filename: 
        "selected_student_list_#{DateTime.now.strftime(@date_format)}.pdf",
        type: "application/pdf", :disposition => 'inline'
      end
    end
  end

  def show_students
    
    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
    start_date =Date.strptime(params[:exam_date],current_school.date_format)

    @exam_detail = MgEntranceExamDetail.where(:mg_course_id=>params[:mg_course_id],:start_date=>start_date,:is_deleted=>0).pluck(:id)
    if @exam_detail.present?
      @students = MgStudentAdmission.where('is_selected_for_entrance_test=? and mg_course_id=? and is_deleted=? and mg_school_id=? and mg_entrance_exam_details_id NOT IN (?) ',"accepted",params[:mg_course_id],0,session[:current_user_school_id],@exam_detail)
    else
      @students = MgStudentAdmission.where(:is_selected_for_entrance_test=>"accepted",:mg_course_id=>params[:mg_course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end 

    @student_array=[]
    @students.each do|stu_obj|
      students_arr=[]
      key="#{stu_obj.first_name}(#{stu_obj.student_temporary_id})"+" "
      value=stu_obj.id
      students_arr.push(key,value)
      @student_array.push(students_arr)
    end
    render :layout=>false
  end

  def edit_students
    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
    start_date =Date.strptime(params[:exam_date],current_school.date_format)
    @exam_detail = MgEntranceExamDetail.where("mg_course_id=? and start_date=? and is_deleted=? and id NOT IN (?)",params[:mg_course_id],start_date,0,params[:exam_detail_id]).pluck(:id)

    #@exam_detail = MgEntranceExamDetail.where(:mg_course_id=>params[:mg_course_id],:start_date=>start_date,:is_deleted=>0).pluck(:id)
    if @exam_detail.present?
      @students = MgStudentAdmission.where('is_selected_for_entrance_test=? and mg_course_id=? and is_deleted=? and mg_school_id=? and mg_entrance_exam_details_id NOT IN (?) ',"accepted",params[:mg_course_id],0,session[:current_user_school_id],@exam_detail)
    else
      @students = MgStudentAdmission.where(:is_selected_for_entrance_test=>"accepted",:mg_course_id=>params[:mg_course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end 

    #@students = MgStudentAdmission.where(:is_selected_for_entrance_test=>"accepted",:mg_course_id=>params[:mg_course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @student_array=[]
    @students.each do|stu_obj|
      students_arr=[]
      key="#{stu_obj.first_name}(#{stu_obj.student_temporary_id})"+" "
      value=stu_obj.id
      students_arr.push(key,value)
      @student_array.push(students_arr)
    end
    render :layout=>false
  end

  


	private
  def params_exam_details
    params.require(:exam_detail).permit(:updated_by,:created_by, :mg_school_id,:is_deleted, :mg_course_id, :start_date, :start_time, :end_time, :exam_venue,:mg_entrance_exam_venue_id)
  end
end
