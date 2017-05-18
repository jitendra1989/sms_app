
class StudentHallTicketsController < ApplicationController
	layout "mindcom"  

  def index    
   @classes = MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)  
  end

  def student_list
    @student_list = MgStudentAdmission.where("is_deleted=? and mg_school_id=? and mg_course_id=? and is_selected_for_entrance_test =? and mg_entrance_exam_details_id>? ",0,session[:current_user_school_id],params[:mg_course_id],"accepted",0).order('student_temporary_id ASC')
    #@student_list = MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_course_id],:is_selected_for_entrance_test=>"accepted").paginate(page: params[:page], per_page: 10)
    render :layout=>false 
  end

  def show   
    @student_list=MgStudentAdmission.where(:id=>params[:id],:mg_course_id=>params[:mg_course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @student_exam_detail = MgEntranceExamDetail.find_by(:id=>@student_list[0].mg_entrance_exam_details_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_course_id])
    @class_name = MgCourse.find_by(:id=>params[:mg_course_id], :is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  	render :layout=>false
  end

  def generate_pdf
    @session_id = session[:current_user_school_id]
    @student_name=MgStudentAdmission.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @exam_detail = MgEntranceExamDetail.find_by(:id=>@student_name.mg_entrance_exam_details_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:mg_id])
    @course_name = MgCourse.find_by(:id=>params[:mg_id], :is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @school=MgSchool.find(session[:current_user_school_id])
    @school_logo=@school.logo.url(:medium,:timestamp=>false)
    @date_format = MgSchool.find_by(:id=>session[:current_user_school_id]).date_format

      respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(@student_name,@exam_detail,@course_name,@school_logo,@school,@date_format,@session_id)
        
        send_data pdf.render, filename: 
        "mindcom_hall_ticket_#{DateTime.now.strftime(@date_format)}.pdf",
        type: "application/pdf", :disposition => 'inline'
      end
    end
  end

  def send_hall_ticket
    @student_id_array = params[:student_id_list]
    @session_id = session[:current_user_school_id]
    
    if @student_id_array.present?
      @student_id_array.each do |stu_id|        
        @session_id = session[:current_user_school_id] 
        @student_name=MgStudentAdmission.find_by(:id=>stu_id)
        @exam_detail = MgEntranceExamDetail.find_by(:id=>@student_name.mg_entrance_exam_details_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id] ,:mg_course_id=>@student_name.mg_course_id)
        @course_name = MgCourse.find_by(:id=>@student_name.mg_course_id, :is_deleted=>0,:mg_school_id=>session[:current_user_school_id] )
        @school=MgSchool.find_by(:id=>session[:current_user_school_id] )
        @school_logo=@school.logo.url(:medium,:timestamp=>false)
        @date_format = MgSchool.find_by(:id=>session[:current_user_school_id] ).date_format 

        respond_to do |format|
          format.html
          format.pdf do
            pdf = ReportPdf.new(@student_name,@exam_detail,@course_name,@school_logo,@school,@date_format,@session_id)
            pdf.render_file File.join(Rails.root, "public/student_hall_ticket", "hall_ticket#{stu_id}.pdf")                        
          end
        end
         NotificationMailer.send_mail_to_student(stu_id,@session_id).deliver
         @student_name.update(:hall_ticket_release=>1)        
      end
      redirect_to :controller=>'student_hall_tickets',:action=>'index' 
    end   
  end  
end
