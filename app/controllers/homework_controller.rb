class HomeworkController < ApplicationController
     before_filter :login_required
     layout "mindcom"

  def index
    @emp=MgEmployee.where(:mg_user_id=>session[:user_id])
    #@assignment=MgAssignment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>@emp[0].id).order(:created_at).paginate(page: params[:page], per_page: 10)
    #=============================================================
     if params[:short_lab_wise].present?
      if params[:short_lab_wise][:mg_batch_id].present?
         @value=params[:short_lab_wise][:mg_batch_id]
      else
         @value=0
      end
    else
      @value=0
    end

    if  @value!=0
      @id=params[:short_lab_wise][:mg_batch_id]
    @assignment=MgAssignment.where(:mg_batch_id=>params[:short_lab_wise][:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>@emp[0].id).order(:created_at).paginate(page: params[:page], per_page: 10)
    
  else
    @assignment=MgAssignment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>@emp[0].id).order(:created_at).paginate(page: params[:page], per_page: 10)

    end
  end

  def new
    @emp=MgEmployee.where(:mg_user_id=>session[:user_id])
    @assignment=MgAssignment.new
  end

  def student_update
    file_arr=params[:file]
    begin
      if file_arr.length>0
        @student_id=MgStudent.where(:mg_user_id=>session[:user_id]).pluck(:id)
        previous_document=MgAssignmentDocumentation.where(:mg_student_id=>@student_id[0],:user_type=>"student",:mg_assignment_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        # if previous_document.length>0
        #   puts "in if condition"
        #   previous_document.each do |pre_doc|
        #     pre_doc.update(:is_deleted=>1)
        #   end
        # end
        for k in 0...file_arr.length
        assignment_documentation=MgAssignmentDocumentation.new()
        assignment_documentation.mg_student_id=@student_id[0]
        assignment_documentation.mg_assignment_id=params[:id]
        assignment_documentation.mg_school_id=session[:current_user_school_id]
        assignment_documentation.is_deleted=0
        assignment_documentation.user_type="student"
        assignment_documentation.updated_by=session[:user_id]
        assignment_documentation.created_by=session[:user_id]
        assignment_documentation.file=file_arr[k]
        assignment_documentation.save
        flash[:notice]="Assignment successfully uploaded"
        end
        homework_status=MgAssignmentSubmission.where(:mg_student_id=>@student_id[0],:mg_assignment_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        if homework_status.length>0
            homework_status.each do |work_status|
              work_status.update(:status=>"submitted")
            end
        end
      end
      rescue Exception => e       
              flash[:notice]="Error,Please contact admin."
             end
      redirect_to :back
  end

  def create
    #puts ksdjfhsdk
   # begin
        #MgItemPurchase.transaction do
        assignment=MgAssignment.new(assignment_details_params)
        timeformat = MgSchool.find(session[:current_user_school_id])
        date = Date.strptime(params[:assignment][:due_date],timeformat.date_format)
       # assignment.created_by=session[:user_id]batch_subject_id
       batch_subject=params[:batch_subject_id]
       batch_subject_array=batch_subject.split(" ")
        assignment.mg_batch_id=batch_subject_array[1].to_i
        assignment.mg_subject_id=batch_subject_array[0].to_i
        if assignment.save
          assignment.update(:due_date=>date)
        end


        mg_student_id_arr=params[:mg_student_id]
        for j in 0...mg_student_id_arr.length
        assignment_submission=MgAssignmentSubmission.new()
        assignment_submission.mg_student_id=mg_student_id_arr[j]
        assignment_submission.mg_assignment_id=assignment.id
        assignment_submission.mg_school_id=session[:current_user_school_id]
        assignment_submission.is_deleted=0
        assignment_submission.status="pending"
        assignment_submission.remarks=""
        assignment_submission.created_by=session[:user_id]
        assignment_submission.save
        end#for end
        file_arr=params[:file]
        if file_arr.present?
            for f in 0...file_arr.length
            assignment_documentation=MgAssignmentDocumentation.new()
            assignment_documentation.mg_employee_id=assignment.mg_employee_id
            assignment_documentation.mg_assignment_id=assignment.id
            assignment_documentation.mg_school_id=session[:current_user_school_id]
            assignment_documentation.is_deleted=0
            assignment_documentation.user_type="employee"
            assignment_documentation.updated_by=session[:user_id]
            assignment_documentation.created_by=session[:user_id]
            assignment_documentation.file=file_arr[f]
            assignment_documentation.save
            end
        end
#====================================Notification to students and Guardian==========================================
# objArray=params[:event_privacy]

      @timeformat = MgSchool.find(session[:current_user_school_id])

      unless mg_student_id_arr.nil?
        for i in 0...mg_student_id_arr.size
            begin
              # notification work start
            multi_mail_list = MgStudent.where(:id => mg_student_id_arr[i]).pluck(:mg_user_id)
            @message = Message.new
            @email_from = MgEmail.where(:mg_user_id => session[:user_id])
            @message.subject =  params[:assignment][:title]
            @message.description = "Dear Student \n #{params[:assignment][:detail]} \n Due Date #{params[:assignment][:due_date]}\n\n Thanks & Regards \n #{@timeformat.school_name}"
            if multi_mail_list.length > 0 
                #Thread.new do
                      multi_mail_list.each do |user|
                        @email_to = MgEmail.where(:mg_user_id => user)
                        if @email_to.present?
                          @message.to_user_id = @email_to[0][:mg_email_id ]
                        @message.from_user_id = @email_from[0][:mg_email_id ]
                    server_response = NotificationMailer.send_mail(@message).deliver!
                    db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                                    :to_user_id => user.to_i,
                                    :subject => @message.subject,
                                    :description => @message.description,
                                    :is_deleted => 0,
                                    :from_user_id =>session[:user_id],
                                    :status => 0)
                          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                      :email_addrs_to => @message.to_user_id,
                                                      # current school Id will come here
                                                :mg_school_id => session[:current_user_school_id] ,
                                                      :email_addrs_by => @message.from_user_id,
                                                      :email_subject => 'test',
                                                     :email_server_description => server_description(server_response.status))
                        else
                          puts "Email is not present for student"
                        end
                      end
                    end
 #===============Notification to Guardian start===============================================
  multi_mail_list = MgGuardian.where(:mg_student_id => mg_student_id_arr[i]).pluck(:mg_user_id)
            @message = Message.new
            @email_from = MgEmail.where(:mg_user_id => session[:user_id])
            @message.subject =  params[:assignment][:title]
            @message.description = "Dear Sir/Madam \n #{params[:assignment][:detail]} \n Due Date #{params[:assignment][:due_date]}\n\n Thanks & Regards \n #{@timeformat.school_name}"
            if multi_mail_list.length > 0 
   multi_mail_list.each do |user|

                        @email_to = MgEmail.where(:mg_user_id => user)
                        if @email_to.present?
                          @message.to_user_id = @email_to[0][:mg_email_id ]
                        @message.from_user_id = @email_from[0][:mg_email_id ]
                    server_response = NotificationMailer.send_mail(@message).deliver!
                    db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                                    :to_user_id => user.to_i,
                                    :subject => @message.subject,
                                    :description => @message.description,
                                    :is_deleted => 0,
                                    :from_user_id =>session[:user_id],
                                    :status => 0)
                          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                      :email_addrs_to => @message.to_user_id,
                                                      # current school Id will come here
                                                :mg_school_id => session[:current_user_school_id] ,
                                                      :email_addrs_by => @message.from_user_id,
                                                      :email_subject => 'test',
                                                     :email_server_description => server_description(server_response.status))
                        else
                          puts "Email is not present for guardian"
                        end
                      end
 #===============Notification to Guardian end=================================================
                  #end
                end 
                flash[:notice]="Mail Sent Successfully."
              # notification work end
            rescue Net::SMTPFatalError => e
              puts "inside Exception in principal"
              flash[:notice]="Email Id is not valid."
             
            rescue ArgumentError => e
              puts "inside Exception in principal"
              flash[:notice]="Email to address is not present."
             
            rescue Exception => e
              puts "inside Exception in principal"
              flash[:notice]="Error while sending email,Please contact admin."
              
             end
        end
      end
      #=========================================================Ending Notification===============================
        redirect_to :action => "index"

  end

 def server_description(code_s)
    
    case code_s.to_s

          when '0'
              return "Email address is not correct"
        
          when '211'   
              return "A system status message."
          when '214'   
              return "A help message for a human reader follows."
          when '220'   
              return "SMTP Service ready."
          when '221'   
              return "Service closing."
          when '250'   
              return "Requested action taken and completed. The best message of them all."
          when '251'   
              return "The recipient is not local to the server, but the server will accept and forward the message."
          when '252'   
              return "The recipient cannot be VRFYed, but the server accepts the message and attempts delivery."
          when '354'   
              return "Start message input and end with . This indicates that the server is ready to accept the message itself (after you have told it who it is from and where you want to to go)."



          when '421'   
              return "The service is not available and the connection will be closed."
          when '450'   
              return "The requested command failed because the users mailbox was unavailable (for example because it was locked). Try again later."
          when '451'   
              return "The command has been aborted due to a server error. Not your fault. Maybe let the admin know."
          when '452'   
              return "The command has been aborted because the server has insufficient system storage."


          when '500'   
              return "The server could not recognize the command due to a syntax error. "

          when '501'   
              return "A syntax error was encountered in command arguments."
          when '502'   
              return "This command is not implemented."
          when '503'   
              return "The server has encountered a bad sequence of commands."
          when '504'   
              return "A command parameter is not implemented."

          when '550'   
              return "The requested command failed because the users mailbox was unavailable (for example because it was not found, or because the command was rejected for policy reasons)."
          when '551'   
              return "The recipient is not local to the server. The server then gives a forward address to try."
          when '552'   
              return "The action was aborted due to exceeded storage allocation."
          when '553'   
              return "The command was aborted because the mailbox name is invalid."
          when '554'   
              return "The transaction failed. Blame it on the weather."
          
    end
   
  end

  def edit
    @assignment=MgAssignment.find(params[:id])
    @emp=MgEmployee.where(:mg_user_id=>session[:user_id])
    
  end

  def update
   
   begin
    assignment=MgAssignment.find(params[:id])
    assignment_submission=MgAssignmentSubmission.where(:mg_assignment_id=>params[:id])
    assignment_submission.each do |assign_solut|
      assign_solut.update(:is_deleted=>1)
    end
    assignment.update(assignment_update_params)
    #changes to be done
    timeformat = MgSchool.find(session[:current_user_school_id])
    date = Date.strptime(params[:assignment][:due_date],timeformat.date_format)
       # assignment.created_by=session[:user_id]batch_subject_id
        batch_subject=params[:batch_subject_id]
        batch_subject_array=batch_subject.split(" ")
        assignment.update(:mg_batch_id=>batch_subject_array[1].to_i)
        assignment.update(:mg_subject_id=>batch_subject_array[0].to_i)
        assignment.update(:due_date=>date)

        mg_student_id_arr=params[:mg_student_id]
        for j in 0...mg_student_id_arr.length
          student_present=MgAssignmentSubmission.where(:mg_assignment_id=>params[:id],:mg_student_id=>mg_student_id_arr[j])
          if student_present.length<1
            assignment_submission=MgAssignmentSubmission.new()
            assignment_submission.mg_student_id=mg_student_id_arr[j]
            assignment_submission.mg_assignment_id=assignment.id
            assignment_submission.mg_school_id=session[:current_user_school_id]
            assignment_submission.is_deleted=0
            assignment_submission.status="pending"
            assignment_submission.remarks=""
            assignment_submission.created_by=session[:user_id]
            assignment_submission.save
          else
            student_present.each do |stu_present|
                stu_present.update(:is_deleted=>0)
            end
          end
        end#for end
        # ===========================================================================
        file_arr=params[:file]
      if file_arr.present?
        @employee_id=MgEmployee.where(:mg_user_id=>session[:user_id]).pluck(:id)
        previous_document=MgAssignmentDocumentation.where(:mg_employee_id=>@employee_id[0],:user_type=>"employee",:mg_assignment_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        # if previous_document.length>0
        #   puts "in if condition"
        #   previous_document.each do |pre_doc|
        #     pre_doc.update(:is_deleted=>1)
        #   end
        # end
        for k in 0...file_arr.length
        assignment_documentation=MgAssignmentDocumentation.new()
        assignment_documentation.mg_employee_id=@employee_id[0]
        assignment_documentation.mg_assignment_id=params[:id]
        assignment_documentation.mg_school_id=session[:current_user_school_id]
        assignment_documentation.is_deleted=0
        assignment_documentation.user_type="employee"
        assignment_documentation.updated_by=session[:user_id]
        assignment_documentation.created_by=session[:user_id]
        assignment_documentation.file=file_arr[k]
        assignment_documentation.save
        flash[:notice]="Assignment successfully uploaded"
        end
      end
      rescue Exception => e
              flash[:notice]="Error ,Please contact admin."
             end

        #===============================================================================
        redirect_to :action => "index"

  end

  def delete
    assignment=MgAssignment.find(params[:id])
    assignment.update(:is_deleted=>1)
    assignment_submission=MgAssignmentSubmission.where(:mg_assignment_id=>params[:id])
    assignment_submission.each do |assign_sub|
      assign_sub.update(:is_deleted=>1)
    end
    redirect_to :action => "index"
  end

  def show
    @assignment=MgAssignment.find(params[:id])
    @assignment_submission=MgAssignmentSubmission.where(:mg_assignment_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    
    #render :layout=> false
  end

  def homework_new
    @students=MgStudent.where(:mg_batch_id=>params[:mg_batch_id])
    render :layout=> false
  end

  def student
    stu=MgStudent.where(:mg_user_id=>session[:user_id])
    @assignment_submission=MgAssignmentSubmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_student_id=>stu[0].id).order(:created_at).paginate(page: params[:page], per_page: 10)
  end
  
  def assignment
    @assignment=MgAssignmentSubmission.find(params[:id])
  end

  def guardian
    guardian=MgGuardian.where(:mg_user_id=>session[:user_id])
    stu=MgStudent.find(guardian[0].mg_student_id)
    @assignment_submission=MgAssignmentSubmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_student_id=>stu.id).order(:created_at).paginate(page: params[:page], per_page: 10)
  end

  def student_homework
    @assignment=MgAssignmentSubmission.find(params[:id])
  end

  def submission
    @emp=MgEmployee.where(:mg_user_id=>session[:user_id])
     if params[:short_lab_wise].present?
      if params[:short_lab_wise][:mg_batch_id].present?
         @value=params[:short_lab_wise][:mg_batch_id]
      else
         @value=0
      end
    else
      @value=0
    end
    if  @value!=0
      @id=params[:short_lab_wise][:mg_batch_id]
    @assignment=MgAssignment.where(:mg_batch_id=>params[:short_lab_wise][:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>@emp[0].id).order(:created_at).paginate(page: params[:page], per_page: 10)
  else
    @assignment=MgAssignment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>@emp[0].id).order(:created_at).paginate(page: params[:page], per_page: 10)
    end
  end

  def student_list
    @assignment_submission=MgAssignmentSubmission.where(:mg_assignment_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def student_show
    @assignment=MgAssignmentSubmission.find(params[:id])
    #render :layout=> false
  end

  def review_update
    assignment=MgAssignmentSubmission.find(params[:id])
    assignment.update(:status=>params[:status],:remarks=>params[:assignment][:remarks])
    redirect_to :back
  end

  def notify_guardian
    #====================================Notification to Guardian==========================================
# objArray=params[:event_privacy]

      @timeformat = MgSchool.find(session[:current_user_school_id])

      
            begin
             assign_sub=MgAssignmentSubmission.find(params[:id])
  multi_mail_list = MgGuardian.where(:mg_student_id =>assign_sub.mg_student_id).pluck(:mg_user_id)
            @message = Message.new
            @email_from = MgEmail.where(:mg_user_id => session[:user_id])
            assi_temp=MgAssignment.find(assign_sub.mg_assignment_id)
            @message.subject =  assi_temp.title
            @message.description = "Dear Sir/Madam \n #{assign_sub.status} \n\n #{assign_sub.remarks} \n \n\n Thanks & Regards \n #{@timeformat.school_name}"
            if multi_mail_list.length > 0 
   multi_mail_list.each do |user|

                        @email_to = MgEmail.where(:mg_user_id => user)
                        if @email_to.present?
                          @message.to_user_id = @email_to[0][:mg_email_id ]
                        @message.from_user_id = @email_from[0][:mg_email_id ]
                    server_response = NotificationMailer.send_mail(@message).deliver!
                    db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                                    :to_user_id => user.to_i,
                                    :subject => @message.subject,
                                    :description => @message.description,
                                    :is_deleted => 0,
                                    :from_user_id =>session[:user_id],
                                    :status => 0)
                          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                      :email_addrs_to => @message.to_user_id,
                                                      # current school Id will come here
                                                :mg_school_id => session[:current_user_school_id] ,
                                                      :email_addrs_by => @message.from_user_id,
                                                      :email_subject => 'test',
                                                     :email_server_description => server_description(server_response.status))
                        else
                          puts "Email is not present for guardian"
                        end
                      end
 #===============Notification to Guardian end=================================================
                  #end
                end 
              flash[:notice]="Mail Sent Successfully."
              # notification work end
            rescue Net::SMTPFatalError => e
              flash[:notice]="Email Id is not valid."
            rescue ArgumentError => e
              puts "inside Exception in principal"
              flash[:notice]="Email to address is not present."
            rescue Exception => e
              puts "inside Exception in principal"
              flash[:notice]="Error while sending email,Please contact admin."
             end
      #=========================================================Ending Notification===============================
       #redirect_to :action =>"submission"  
       redirect_to :back
  end
  def employee_attachment_delete
    doc=MgAssignmentDocumentation.find(params[:id])
    doc.update(:is_deleted=>1)
    redirect_to :back
  end

  def status
    
  end

def section_list

  batch=MgTimeTableEntry.select(:mg_batch_id).where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>params[:id]).uniq
      batch_array=Array.new
      batch.each do |batch_obj|
        small_array=Array.new
                  batches=MgBatch.find(batch_obj.mg_batch_id)
                              courseObj = MgCourse.find(batches.mg_course_id)
                small_array.push("#{courseObj.course_name}-#{batches.name}")
                small_array.push("#{batch_obj.mg_batch_id}")
                               batch_array.push(small_array)
                          end

   # @student_list = MgTimeTableEntry.where(:is_deleted=>0,:mg_employee_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    respond_to do |format|
      format.json  { render :json => batch_array }
      end
    
  end

  def subject_list
    subject=MgTimeTableEntry.select(:mg_subject_id).where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>params[:emp_id],:mg_batch_id=>params[:batch_id]).uniq
      subject_array=Array.new
      subject.each do |subject_obj|
        small_array=Array.new
                  subject=MgSubject.find(subject_obj.mg_subject_id)
                  small_array.push("#{subject.subject_name}")
                  small_array.push("#{subject_obj.mg_subject_id}")
                  subject_array.push(small_array)
                          end
   # @student_list = MgTimeTableEntry.where(:is_deleted=>0,:mg_employee_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    respond_to do |format|
      format.json  { render :json => subject_array }
      end

  end

  def homework_status
    @assignment=MgAssignment.where(:mg_employee_id=>params[:emp_id],:mg_batch_id=>params[:batch_id],:mg_subject_id=>params[:subject_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('due_date DESC')
    render :layout=> false
  end

  def homeworkStatus
    
  end

  def homework_status_date_wise
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    date=Date.strptime(params[:created_date],school.date_format)
    @assignment=MgAssignment.where("DATE(created_at) = ? AND is_deleted = ? AND mg_school_id = ?", date,0,session[:current_user_school_id]).order(:mg_batch_id).order(:mg_subject_id)
    
    render :layout=> false
  end

  def strip_tags(html)     
        return html if html.blank?
        if html.index("<")
          text = ""
          tokenizer = HTML::Tokenizer.new(html)
          while token = tokenizer.next
            node = HTML::Node.parse(nil, 0, 0, token, false)
            text << node.to_s if node.class == HTML::Text  
          end
          text.gsub(/<!--(.*?)-->[\n]?/m, "") 
        else
          html 
        end 
      end

      def category
        @category=MgHomeworkCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
      end

      def category_new
        render :layout=>false
      end

      def category_create
        category=MgHomeworkCategory.new(homework_new_params)
        category.save
        redirect_to :action=>"category"
      end

      def category_edit
        @homework=MgHomeworkCategory.find(params[:id])
        render :layout=>false
      end

      def category_update
        @homework=MgHomeworkCategory.find(params[:id])
        @homework.update(homework_edit_params)
        redirect_to :action=>"category"
      end

      def category_show
        @category=MgHomeworkCategory.find(params[:id])
        render :layout=>false

      end

      def category_delete
        @homework=MgHomeworkCategory.find(params[:id])
        @homework.update(:is_deleted=>1)
        redirect_to :action=>"category"
      end


  private
  def assignment_details_params
    params.require(:assignment).permit(:mg_homework_category_id,:is_carring_marks,:title,:detail,:due_date,:mg_employee_id,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end

  def assignment_update_params
    params.require(:assignment).permit(:mg_homework_category_id,:is_carring_marks,:title,:detail,:due_date,:mg_employee_id,:is_deleted,:mg_school_id,:updated_by)
  end

  def homework_new_params
    params.require(:homework).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
  end

  def homework_edit_params
    params.require(:homework).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by)
  end
end
