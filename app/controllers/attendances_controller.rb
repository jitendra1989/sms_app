class AttendancesController < ApplicationController
   before_filter :login_required
   #com
 layout "mindcom"
 require 'date'
 require 'active_support/core_ext'
 
  def new
    puts "Step--new method 1"
   


      @batchId = params[:batchId]
       date_student_id = params[:date_student_id]
       month = params[:month]
       year = params[:year]
      logger.info(date_student_id.inspect)

      date_student_id=date_student_id.split(",")
      logger.info(date_student_id.inspect)
      date=date_student_id[0]
      @day=date
      @student_id=date_student_id[1]
      logger.info(date)
      logger.info(@student_id)
      @final_date=date+"-"+month+"-"+year
      logger.info(@final_date)



  render :layout => false

    
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



  
  def index
      redirect_to :controller=>'employees_attendances',:action=>'index'
  end

  def update
  @attendances = MgStudentAttendance.find(params[:id])
 
  @attendances.update(ajax_params)
  @attendances.updated_by=session[:user_id]
  @attendances.save

# redirect_to :action => "index"
end

def delete
  # subjects/delete/"+splString[1]
   @attendances=MgStudentAttendance.find_by_id(params[:id])

  @attendances.is_deleted =1
  @attendances.save
  
end

def edit
      @batchId = params[:batchId]
      date_student_id = params[:date_student_id]
      month = params[:month]
      year = params[:year]
      logger.info(date_student_id.inspect)

      date_student_id=date_student_id.split(",")
      logger.info(date_student_id.inspect)
      date=date_student_id[0]
      @day=date
      @student_id=date_student_id[1]
      logger.info(date)
      logger.info(@student_id)
      @final_date=(date+"-"+month+"-"+year).to_datetime
      logger.info(@final_date)
      id=MgStudentAttendance.where(:absent_date=>@final_date, :mg_student_id=>params[:id]).pluck(:id)
      puts "id ---- step --1"
      puts id[0]
      @attendances=MgStudentAttendance.find(id[0])
      puts "step  ------2----"
      puts @attendances.inspect
 render :layout => false


  
end

  def studentsHash

    data = Array.new
    puts "StudentsHash -- is comming"
    @sql = "Select * from mg_students where mg_batch_id = #{params[:id]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=#{0}"
    @students = MgStudent.find_by_sql(@sql)
    data.push(@students)
    # @sql1 = "Select absent_date from mg_student_attendances where mg_batch_id = #{params[:id]} "
    @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_student_id from mg_student_attendances where mg_batch_id = #{params[:id]} and is_deleted=0 and mg_school_id=#{session[:current_user_school_id]}"

    @absent_dates = MgStudent.find_by_sql(@sql1)
    data.push(@absent_dates)



        respond_to do |format| 
            format.json  { render :json =>  data }
          

        end
  end

def createstudent
  @all_data = params.require(:attendances).permit(:from_date, :to_date, :mg_student_id, :mg_batch_id, :reason, :is_halfday, :is_afternoon)
    
    start_dt=@all_data[:from_date]
    end_dt=@all_data[:to_date]
    total_days=(end_dt.to_date - start_dt.to_date).to_i
    total_days=total_days+1
    puts "xxxxxxxxxxxxxxxxxxxxxxxxxx"
    puts total_days

     for i in 0...total_days
                          date=@all_data[:from_date]
                          puts "absent_date"
                          puts date
                          arr = date.split('-');
                          # days = Time.days_in_month(arr[1].to_i+1, arr[2].to_i)
                          month= arr[1].to_i
                          year=arr[2].to_i
                          day =arr[0].to_i
                          puts "day"
                          puts day
                          puts "month"
                          puts month
                          puts "year"
                          puts year
                               abc= Date.new(year,month,day) + i
                               puts abc
                          savedate=abc.to_s

      sql="INSERT INTO mg_student_attendances(absent_date, mg_student_id, reason, is_halfday, is_afternoon, mg_batch_id, is_deleted, is_approved) VALUES ( '#{savedate}', #{@all_data[:mg_student_id]}, '#{@all_data[:reason]}', #{@all_data[:is_halfday]}, #{@all_data[:is_afternoon]}, #{@all_data[:mg_batch_id]})"
          ActiveRecord::Base.connection.execute(sql)  
        end


    redirect_to :controller => 'dashboards'
  
end

   def create
    @attendances=MgStudentAttendance.new(ajax_params)
    @no_of_days= params.permit(:no_of_days, :absent_date)
    no_of_days=@no_of_days[:no_of_days]
    no_of_days=no_of_days.to_i
    @date=params[:absent_date]
    @dateFormat=Date.parse(@date)
    @datevalue=@dateFormat.strftime('%d')
    puts "date="+@datevalue
    
     

    if(no_of_days != 0)
       @all_data= params.permit(:mg_student_id, :mg_period_table_entry_id, :is_afternoon, :is_halfday, :reason, :absent_date, :mg_batch_id ,:is_deleted)
           $dayCount=0
          $dayCheck= Date.new

      for i in 0...no_of_days
                date=@all_data[:absent_date]
                puts "absent_date"
                puts date
                arr = date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
                puts "day"
                puts day
                puts "month"
                puts month
                puts "year"
                puts year
                
                $dayCheck= Date.new(year,month,day)+$dayCount
                dayName=$dayCheck.strftime("%A")
                puts 'i try to get day name'
                puts dayName
                puts 'i got day name'

                  if dayName=='Sunday'

                    $dayCount +=1
                    $dayCheck= Date.new(year,month,day)+$dayCount
                    $dayCount +=1
                    puts "i am in if condition   ----if----"
                  else
                     $dayCheck= Date.new(year,month,day) + $dayCount
                     puts $dayCheck
                     $dayCount +=1
                    puts "i am in if condition   ----else----"

                     puts "step ----1-----"
                  end
                     puts $dayCheck.strftime("%A")
                     puts "step -----2------"
                savedate=$dayCheck.to_s
                # @student=MgStudentAttendance.new(:mg_student_id=>@all_data[:mg_student_id], :is_halfday, :is_afternoon,
                #  :reason, :absent_date, :mg_batch_id, :is_deleted, :mg_school_id, :created_by, :updated_by)
                @student=MgStudentAttendance.new(ajax_params)
                 @student.absent_date=savedate
                 @student.is_deleted=0
                 @student.mg_school_id=session[:current_user_school_id]
                 @student.created_by=session[:user_id]
                 @student.save

                # sql="INSERT INTO mg_student_attendances (mg_student_id, is_halfday, is_afternoon, reason, absent_date, mg_batch_id, is_deleted) VALUES (#{@all_data[:mg_student_id]}, #{@all_data[:is_halfday]}, #{@all_data[:is_afternoon]}, '#{@all_data[:reason]}', '#{savedate}', #{@all_data[:mg_batch_id]}, 0)"
                # # # sql="INSERT INTO mg_student_attendances(absent_date) VALUES('#{savedate}')"
                # ActiveRecord::Base.connection.execute(sql)    
      end  
    else
       @attendances.save
    end  
  end

  def student
    @userID=session[:user_id]
    puts "student_index ------ step 1"
    puts @userID

    @studentID= MgStudent.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts "student_index ------ step 2"
    puts @studentID

    @batchID= MgStudent.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:mg_batch_id) 
    puts "student_index ------ step 3"
    puts @batchID

                                    
    @batchName= MgBatch.where(:id => "#{@batchID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:name) 
    puts "student_index ------ step 4"
    puts @batchName

   
  end


  def student_index
    @userID=session[:user_id]
    puts "student_index ------ step 1"
    puts @userID

    @studentID= MgStudent.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts "student_index ------ step 2"
    puts @studentID

    @batchID= MgStudent.where(:id => "#{@studentID[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:mg_batch_id) 
    puts "student_index ------ step 3"
    batchID=@batchID[0]
    puts @batchID[0]
    puts batchID

                                    
    @batchName= MgBatch.where(:id => "#{@batchID[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:name) 
    puts "student_index ------ step 4"
    puts @batchName

    data = Array.new
    puts "student_index ------ step 5"

    @sql = "Select * from mg_students where mg_batch_id = #{batchID} and mg_students.id = #{@studentID[0]} and is_deleted=0 and mg_school_id=#{session[:current_user_school_id]}"
    @students = MgStudent.find_by_sql(@sql)
    data.push(@students)
    # @sql1 = "Select absent_date from mg_student_attendances where mg_batch_id = #{params[:id]} "
    @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_student_id from mg_student_attendances where mg_batch_id = #{batchID} and is_deleted=0 and mg_school_id=#{session[:current_user_school_id]}"

    @absent_dates = MgStudent.find_by_sql(@sql1)
    puts @absent_dates.inspect
    data.push(@absent_dates)



        respond_to do |format| 
            format.json  { render :json =>  data }
        end
    
  end

  def view_attendance
    @userID=session[:user_id]
    puts "student_index ------ step 1"
    puts @userID

    @mg_student_id= MgGuardian.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)
    puts "student_index ------ step 22"
    puts @mg_student_id

    @studentID= MgStudent.where(:id => "#{@mg_student_id[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts "student_index ------ step 2"
    puts @studentID

    @batchID= MgStudent.where(:id => "#{@mg_student_id[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:mg_batch_id) 
    puts "student_index ------ step 3"
    puts @batchID

                                    
    @batchName= MgBatch.where(:id => "#{@batchID[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:name) 
    puts "student_index ------ step 4"
    puts @batchName
 # render :layout => false

    
  end
  def gardian_index
    @userID=session[:user_id]
    puts "student_index ------ step 1"
    puts @userID

    @mg_student_id= MgGuardian.where(:mg_user_id => "#{@userID}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:mg_student_id)
    puts "student_index ------ step 22----- "
    puts @mg_student_id.inspect

     @studentID= MgStudent.where(:id => "#{@mg_student_id[0]}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:id)
    puts "student_index ------ step 2"
    puts @student_id

    @batchID= MgStudent.where(:id => "#{@mg_student_id[0]}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:mg_batch_id) 
    puts "student_index ------ step 3"
    batchID=@batchID[0]
    puts batchID

    @Guardian= MgGuardian.where(:mg_user_id => "#{@userID}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:id)

                                    
    @batchName= MgBatch.where(:id => "#{@batchID[0]}", :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:name) 
    puts "student_index ------ step 4"
    puts @batchName

    data = Array.new
    puts "student_index ------ step 5"

    # @sql = "Select * from mg_students where mg_batch_id = #{batchID} and mg_students.id = #{@studentID[0]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0"
    # @students = MgStudent.find_by_sql(@sql)
    @sql = "SELECT S.first_name ,S.last_name,S.admission_number, S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.has_login_access=1 And  M.mg_guardians_id  = #{@Guardian[0]} And S.id = M.mg_student_id and G.id = M.mg_guardians_id and S.is_deleted=0 and S.mg_school_id=#{session[:current_user_school_id]} and G.is_deleted=0 and G.mg_school_id=#{session[:current_user_school_id]} and M.is_deleted=0 and M.mg_school_id=#{session[:current_user_school_id]}"

    @students=MgStudent.find_by_sql(@sql)
    data.push(@students)
    # @sql1 = "Select absent_date from mg_student_attendances where mg_batch_id = #{params[:id]} "
    @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_student_id from mg_student_attendances where is_deleted=0 and mg_school_id=#{session[:current_user_school_id]}"

    @absent_dates = MgStudent.find_by_sql(@sql1)
    puts @absent_dates.inspect
    data.push(@absent_dates)



        respond_to do |format| 
            format.json  { render :json =>  data }
        end
    
  end
  def show
    @userID=session[:user_id]

    @stuID=MgGuardian.find_by_mg_user_id(@userID)
    @studentID=@stuID.mg_student_id
    
   
    #@studentID= MgStudent.where(:mg_user_id => "#{@userID}").pluck(:id)
     @batID=MgStudent.where(:mg_user_id => @userID, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:mg_batch_id)

     puts @batID.inspect
     puts "step  ---1---"

     puts @batID
     puts "step ----2---"
    #  if @batID!=nil
    #   @batchID=@batID.mg_batch_id
    # else
    #   puts"else"
    #   @batchID=''
    # end  

   

  end
  def apply_leave

     # @all_data = params.require(:attendances).permit(:from_date, :to_date, :mg_student_id, :mg_batch_id, :reason, :is_halfday, :is_afternoon)
    @userID=session[:user_id]
     # @batID=MgStudent.where(:mg_user_id => @userID)
    @studentID=MgGuardian.find_by_mg_user_id(@userID)
    puts @studentID.mg_student_id
    @batID=MgStudent.where(:id=>@studentID.mg_student_id, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:mg_batch_id)
    puts @batID[0]

    @student = MgStudent.find(params[:id])
   

    render :layout => false


  end
  def apply_leave_for_student
   
    # @student = MgStudent.find(params[:id])
    puts "apply_leave_for_student"
    # puts @student.inspect
   @timeformat = MgSchool.find(session[:current_user_school_id])
    # @half_day_date = Date.strptime(params[:mg_employee_leave_types][:half_day_date],@timeformat.date_format)

    @all_data = params.require(:attendances).permit(:mg_student_id, :is_afternoon, :is_halfday, :reason, :from_date, :to_date, :mg_batch_id ,:is_deleted)
    @student = MgStudent.where(:id=>@all_data[:mg_student_id])

    puts "step ----1----"
    @batID=MgStudent.where(:id=>params[:mg_student_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:mg_batch_id)
    puts @batID[0]
    if params[:attendances][:from_date].present?
      @from_date = Date.strptime(params[:attendances][:from_date],@timeformat.date_format)
    end
    if params[:attendances][:to_date].present?
      @to_date = Date.strptime(params[:attendances][:to_date],@timeformat.date_format)
    end
     if params[:attendances][:date].present?
      @date = Date.strptime(params[:attendances][:date],@timeformat.date_format)
    end
    # @from_date= @all_data[:from_date]
    # puts @from_date
    # @to_date= @all_data[:to_date]
    # puts @to_date


    # @from_date=@all_data[:from_date]
    # @to_date=@all_data[:to_date]
    puts "xxxxxxxxxxxxxxxxxxxxxxxxxx"

    puts params[:attendances][:is_halfday]
    puts "xxxxxxxxxxxxxxxxxxxxxxxxxx"

    if params[:attendances][:is_halfday]=='false'
          total_days=(@to_date.to_date - @from_date.to_date).to_i
          total_days=total_days+1
          puts "xxxxxxxxxxxxxxxxxxxxxxxxxx"
          puts total_days

           for i in 0...total_days
                                date=Date.parse(@from_date.to_s).strftime("%d-%m-%Y")
                                puts "absent_date"
                                puts date
                                arr = date.split('-');
                                # days = Time.days_in_month(arr[1].to_i+1, arr[2].to_i)
                                month= arr[1].to_i
                                year=arr[2].to_i
                                day =arr[0].to_i
                                puts "day"
                                puts day
                                puts "month"
                                puts month
                                puts "year"
                                puts year
                                     abc= Date.new(year,month,day) + i
                                     puts abc
                                savedate=abc.to_s
            @attendances=MgStudentAttendance.new(attes_params)
            @attendances.absent_date=savedate
            @attendances.save
              end
     else
        @attendances=MgStudentAttendance.new(attes_params)
        @attendances.absent_date=@date

        @attendances.save
     end

     #=========================================================================================
     begin
       @guardian=MgGuardian.where(:mg_user_id => session[:user_id])
       @student_id=@guardian[0].mg_student_id
       @student_batch=MgStudent.where(:id=>@student_id).pluck(:mg_batch_id)
       @class_teacher_id=MgBatch.where(:id=>@student_batch[0]).pluck(:mg_employee_id)

       if  @class_teacher_id[0].present?
        puts "-------------------"
        puts @class_teacher_id
        @class_teacher=MgEmployee.where(:id=>@class_teacher_id[0])
        employee_obj = MgGuardian.where(:mg_user_id => session[:user_id])#.pluck(:first_name,:middle_name, :last_name)
        user_obj = MgUser.where(:id => session[:user_id])#.pluck(:user_name)
        not_sub =   "#{employee_obj[0][:first_name]} #{employee_obj[0][:middle_name]} #{employee_obj[0][:last_name]}(#{user_obj[0][:user_name]})  leave application"
        not_des ="#{employee_obj[0][:first_name]} #{employee_obj[0][:middle_name]} #{employee_obj[0][:last_name]}  has applied for leave from   #{@all_data[:from_date]}   to  #{@all_data[:to_date]}  with reason \"#{@all_data[:reason]}\"."
        db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id]   ,:to_user_id => @class_teacher[0].mg_user_id, :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
        @message = Message.new
        @email_from = MgEmail.where(:mg_user_id => session[:user_id])

        @message.subject =  not_sub
        @message.description = not_des
        @email_to = MgEmail.where(:mg_user_id => @class_teacher[0].mg_user_id)
        @message.to_user_id = @email_to[0][:mg_email_id ]
        @message.from_user_id = @email_from[0][:mg_email_id ]
                  # @message.from_user_id = 'kgaurav@mindcomgroup.com'
        server_response = NotificationMailer.send_mail(@message).deliver!
        @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                    :email_addrs_to => @message.to_user_id,
                                                    # current school Id will come here
                                              :mg_school_id => session[:current_user_school_id] ,
                                                    :email_addrs_by => @message.from_user_id,
                                                    :email_subject => not_sub,
                                                   :email_server_description => server_description(server_response.status) )

      @notice="Mail sent successfully."
    end
    rescue Net::SMTPFatalError => e
      puts "inside Exception in principal"
      flash.now[:notice]="Email Id is not valid"
      flash.keep(:notice)
    rescue ArgumentError => e
      puts "inside Exception in principal"
      flash.now[:notice]="Email to address is not present."
      flash.keep(:notice)
    rescue Exception => e
      puts "inside Exception in principal"
      flash.now[:notice]="Error while sending email, please contact admin."
      flash.keep(:notice)
    end
  redirect_to :controller => 'dashboards', :action =>'guardian_leave',:notice=>@notice
  end

  def employee_student_attendance
     @userID=session[:user_id]
      @employee_id= MgEmployee.where(:mg_user_id => @userID).pluck(:id)
    @batches=MgBatch.where(:is_deleted=>0, :mg_employee_id=>@employee_id[0])

  end

  def time_table_for_attendance
    absent_date=params[:absentDate]
    school=MgSchool.find(session[:current_user_school_id])
    # date=Date.parse(absent_date.to_s).strftime("%d-%m-%Y")
    date=Date.strptime(params[:absentDate],school.date_format)
    date=Date.parse(date.to_s).strftime("%d-%m-%Y")
    puts "start from here"
    puts date
    puts "start from here"
    arr = date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
    absent_date =Date.new(year,month,day)
    absent_date.strftime("%w")
    puts "step --------1"
    puts absent_date.strftime("%w")
    puts "step --------2"
    @batches=MgBatch.find(params[:mg_batch_id])
    puts @batches.inspect
    @course=MgCourse.find(@batches.mg_course_id)
        puts @course.inspect
    puts "step----3"
    @weekdayID=MgWeekday.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id, :weekday=>absent_date.strftime("%w"), :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts @weekdayID[0]
    puts "step --------3"

    # @timeings=MgClassTiming.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], ).select(:start_time, :end_time).uniq
    @timeings=MgClassTiming.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id,:mg_weekday_id=>@weekdayID[0], :mg_school_id=>session[:current_user_school_id] )

    @students=MgStudent.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id])
    @absentDate=MgStudentAttendance.where(:mg_batch_id=>params[:mg_batch_id], :is_deleted=>0, :absent_date=>absent_date, :mg_school_id=>session[:current_user_school_id])
    
    render :layout => false
    
  end




  def period_attendence_save

  
    @mg_class_timing_id=params[:mg_class_timing_id]

    school=MgSchool.find(session[:current_user_school_id])
      date=Date.strptime(params[:absentDate],school.date_format)
    if  params[:is_reason]=='true' && params[:edit]=='true'
      absent_date=params[:absentDate]

      
      date_farmate=Date.parse(date.to_s).strftime("%d-%m-%Y")
      # date=Date.parse(absent_date.to_s).strftime("%d-%m-%Y")
      arr = date_farmate.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
      absent_date =Date.new(year,month,day)
      @attendances=MgStudentAttendance.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id], :mg_class_timing_id=>params[:mg_class_timing_id], :mg_student_id=>params[:mg_student_id],:absent_date=>absent_date).pluck(:id)
      
      @attendances_find=MgStudentAttendance.find(@attendances[0])
      @attendances_find.update(:is_deleted=>1)
      
    elsif params[:is_reason]=='true'
      @attendances=MgStudentAttendance.new(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id], :mg_class_timing_id=>params[:mg_class_timing_id], :mg_student_id=>params[:mg_student_id],:absent_date=>date, :created_by=>session[:user_id], :updated_by=>session[:user_id])
      @attendances.save
      
    else
       
   
    end
     @attendances=MgStudentAttendance.new()
    @batchId=params[:mg_batch_id]
    @student_id=params[:mg_student_id]
    @final_date =params[:absentDate]    
    # @attendances.save
    # mg_class_timing_id: mg_class_timing_id, mg_batch_id: batchID, 
    # absentDate: absentDate, mg_student_id: mg_student_id, mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by
    render :layout => false

  end

  def attendance_new_period
    absent_date=params[:absentDate]
    
    @batchId=params[:batchID]
    @student_id=params[:mg_student_id]
    # date=Date.parse(absent_date.to_s).strftime("%d-%m-%Y")
     school=MgSchool.find(session[:current_user_school_id])
      date=Date.strptime(params[:absentDate],school.date_format)
      date_farmate=Date.parse(date.to_s).strftime("%d-%m-%Y")
    @final_date=params[:absentDate]
    arr = date_farmate.split('-');  
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
    absent_date =Date.new(year,month,day)
    absent_date.strftime("%w")

     @batches=MgBatch.find(params[:batchID])
    @course=MgCourse.find(@batches.mg_course_id)
    @weekdayID=MgWeekday.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id, :weekday=>absent_date.strftime("%w"), :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts @weekdayID[0]

    # @timeings=MgClassTiming.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], ).select(:start_time, :end_time).uniq
    @timeings=MgClassTiming.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id,:mg_weekday_id=>@weekdayID[0], :is_break=>0 , :mg_school_id=>session[:current_user_school_id])

    @absentDate=MgStudentAttendance.where(:mg_batch_id=>params[:batchID], :is_deleted=>0, :absent_date=>absent_date, :mg_school_id=>session[:current_user_school_id])
    render :layout => false

  end


  def attendance_create
   
      puts "step    -----createstudent-----"
      school = MgSchool.find(session[:current_user_school_id])
      puts params[:absent_date]

      if params[:absent_date].present?
        date=Date.strptime(params[:absent_date],school.date_format)
        date_format=Date.parse(date.to_s).strftime("%d-%m-%Y")
      end

      if params[:attendancedate]=="periodwise"
        puts "step    -----createstudent-----periodwise"
        @attendance=MgStudentAttendance.new(ajax_params)
        @attendance.absent_date=date
        @attendance.save
      elsif params[:attendancedate]== "periodwiseedit"
        puts "step    -----createstudent-----periodwiseedit"
        @attendance=MgStudentAttendance.find(params[:id])
        @attendance.reason=params[:reason]
        @attendance.updated_by=session[:user_id]
        @attendance.save
      else
        puts "step    -----1-----"
        @all_data=params.permit(:mg_student_id, :absent_date, :mg_period_table_entry_id, :is_afternoon, :is_halfday, :reason, :mg_batch_id ,:is_deleted, :mg_school_id, :created_by, :updated_by)
        check=params.permit(:checkedvalue, :uncheckedvalue)
        date_formate=Date.parse(date.to_s).strftime("%d-%m-%Y")
        arr = date_formate.split('-');
        month= arr[1].to_i
        year=arr[2].to_i
        day =arr[0].to_i
        absent_date =Date.new(year,month,day)
        checkedvalue=params[:checkedvalue]
        if params[:checkedvalue].present?
          for i in 0...params[:checkedvalue].size
            @attendances=MgStudentAttendance.where(:mg_student_id=>params[:mg_student_id], :absent_date=>absent_date, :mg_batch_id=>params[:mg_batch_id],:mg_school_id=>params[:mg_school_id],:mg_class_timing_id=>checkedvalue[i], :is_deleted=>0)
            puts "object check ---- 1"
            @attendances.inspect
            puts "object check ---- 1"

            if @attendances[0].present?
              @attendance=MgStudentAttendance.find(@attendances[0].id)
              @attendance.mg_class_timing_id=params[:checkedvalue][i]
              @attendance.reason=params[:reason]
              @attendance.save
            else
              @attendances=MgStudentAttendance.new(ajax_params)
              @attendances.mg_class_timing_id=params[:checkedvalue][i]
              @attendances.absent_date=absent_date
              @attendances.reason=params[:reason]
              @attendances.save
            end
          end
        end
        uncheckedvalue=params[:uncheckedvalue]
        if params[:uncheckedvalue].present?
          for i in 0...params[:uncheckedvalue].size
            @attendances=MgStudentAttendance.where(:mg_student_id=>params[:mg_student_id], :absent_date=>absent_date, :mg_batch_id=>params[:mg_batch_id],:mg_school_id=>params[:mg_school_id],:mg_class_timing_id=>params[:uncheckedvalue][i], :is_deleted=>0)
            if @attendances[0].present?
              puts "i am if "
              @attendance=MgStudentAttendance.find(@attendances[0].id)
              @attendance.is_deleted=1
              @attendance.save
            end
          end
        end
      end
    begin
      student_obj = MgStudent.where(:id =>  params[:mg_student_id])
      guardianList = MgStudentGuardian.where(:mg_student_id => params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_guardians_id)
      not_sub =   "#{student_obj[0][:first_name]} #{student_obj[0][:middle_name]} #{student_obj[0][:last_name]} is absent on #{ params[:absent_date] }"
      not_des ="Dear Sir/Madam \n your child #{student_obj[0][:first_name]} #{student_obj[0][:middle_name]} #{student_obj[0][:last_name]}  is absent on #{ params[:absent_date] }."
      if guardianList.empty?
        puts " Guadian not present "
      else
        puts " Guardian present"
        guardianList.each do |g|
          guar = MgGuardian.where(:id => g.to_i).pluck(:mg_user_id)
          puts guar.inspect
          db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id],:to_user_id => guar[0].to_i, :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )

          @message = Message.new
          @email_from = MgEmail.where(:mg_user_id => session[:user_id])

          @message.subject =  not_sub
          @message.description = not_des
         
          @email_to = MgEmail.where(:mg_user_id => guar[0].to_i)

          @message.to_user_id = @email_to[0][:mg_email_id ]
          @message.from_user_id = @email_from[0][:mg_email_id ]
          server_response = NotificationMailer.send_mail(@message).deliver!
          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                  :email_addrs_to => @message.to_user_id,
                                                  # current school Id will come here
                                                 :mg_school_id =>  session[:current_user_school_id] ,
                                                  :email_addrs_by => @message.from_user_id,
                                                  :email_subject => not_sub,
                                                 :email_server_description => server_description(server_response.status) )
        end
      end
      rescue Net::SMTPFatalError => e
      puts "inside Exception in principal"
      flash.now[:notice]="Email Id is not valid"
      flash.keep(:notice)
      render :js => "alert('Email Id is not valid');"
    rescue ArgumentError => e
      puts "inside Exception in principal"
      flash.now[:notice]="Email to address is not present."
      flash.keep(:notice)
      render :js => "alert('Email to address is not present.');"
    rescue Exception => e
      puts "inside Exception in principal"
      flash.now[:notice]="Error while sending email, please contact admin."
      flash.keep(:notice)
      render :js => "alert('Error while sending email, please contact admin.');"
    end
   # redirect_to :action =>'employee_student_attendance',:notice=>@attendance_notification
  end

  def period_attendence_edit
      # date_format=Date.parse(params[:absentDate].to_s).strftime("%d-%m-%Y")
    school = MgSchool.find(session[:current_user_school_id])
    puts "i'm here"
      puts params[:absentDate]
      date=Date.strptime(params[:absentDate],school.date_format)
      date_format=Date.parse(date.to_s).strftime("%d-%m-%Y")
      @attendances=MgStudentAttendance.new()
      arr = date_format.split('-');
                      month= arr[1].to_i
                      year=arr[2].to_i
                      day =arr[0].to_i
          absent_date =Date.new(year,month,day)
    # @batchId=params[:mg_batch_id]
    # @student_id=params[:mg_student_id]
    # @final_date =params[:absentDate]
    # @mg_class_timing_id=params[:mg_class_timing_id]
    @attendances=MgStudentAttendance.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id], :absent_date=>absent_date ,:mg_school_id=>session[:current_user_school_id],:mg_class_timing_id=>params[:mg_class_timing_id], :is_deleted=>0).pluck(:id)
    puts "serp -------1"
    puts @attendances[0].inspect
    puts "serp -------1"
    @attendances=MgStudentAttendance.find(@attendances[0])
    # mg_class_timing_id: mg_class_timing_id, mg_batch_id: batchID, 
    # absentDate: absentDate, mg_student_id: mg_student_id, 
    # mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by
    render :layout => false
    
  end

  def period_wise_attendance_for_student
    school = MgSchool.find(session[:current_user_school_id])
      
      date=Date.strptime(params[:absentDate],school.date_format)
      absent_date=Date.parse(date.to_s).strftime("%d-%m-%Y")
     # date_format=Date.parse(params[:absentDate].to_s).strftime("%d-%m-%Y")
    # absent_date=params[:absentDate]
    arr = absent_date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
    absent_date =Date.new(year,month,day)
    absent_date.strftime("%w")
    puts "step --------1"
    puts absent_date.strftime("%w")
    puts "step --------2"
    @batches=MgBatch.find(params[:mg_batch_id])
    puts @batches.inspect
    @course=MgCourse.find(@batches.mg_course_id)
        puts @course.inspect
    puts "step----3"
    @weekdayID=MgWeekday.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id, :weekday=>absent_date.strftime("%w"), :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts @weekdayID[0]
    puts "step --------3"

    # @timeings=MgClassTiming.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], ).select(:start_time, :end_time).uniq
    @timeings=MgClassTiming.where(:is_deleted=>0, :mg_wing_id=> @course.mg_wing_id,:mg_weekday_id=>@weekdayID[0], :mg_school_id=>session[:current_user_school_id] )

   
    @absentDate=MgStudentAttendance.where(:mg_batch_id=>params[:mg_batch_id], :is_deleted=>0, :absent_date=>absent_date, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)

   

    @check_user=MgUser.where(:user_type=>'student', :id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)
    if @check_user.present?
      @student_id=MgStudent.where(:mg_user_id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:id)
      @students=MgStudent.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :id=>@student_id[0], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)
    end
    @check_user_gardian=MgUser.where(:user_type=>'student', :id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)
    if (@check_user_gardian.present?)
    end
    render :layout => false
   

  end

  # def period_wise_attendance_for_student_guardian
  #   absent_date=params[:absentDate]
  #   arr = absent_date.split('-');
  #               month= arr[1].to_i
  #               year=arr[2].to_i
  #               day =arr[0].to_i
  #   absent_date =Date.new(year,month,day)
  #   absent_date.strftime("%w")
  #   # puts "step --------1"
  #   # puts absent_date.strftime("%w")
  #   # puts "step --------2"
  #   # # @batches=MgBatch.find(params[:mg_batch_id])
  #   # puts @batches.inspect
  #   # @course=MgCourse.find(@batches.mg_course_id)
  #   #     puts @course.inspect
  #   # puts "step----3"
  #   @weekdayID=MgWeekday.where(:is_deleted=>0, :weekday=>absent_date.strftime("%w"), :mg_school_id=>session[:current_user_school_id]).pluck(:id)
  #   puts @weekdayID[0]
  #   puts "step --------3"

  #   # @timeings=MgClassTiming.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], ).select(:start_time, :end_time).uniq
  #   @timeings=MgClassTiming.where(:is_deleted=>0,:mg_weekday_id=>@weekdayID[0], :mg_school_id=>session[:current_user_school_id] )

   
  #   @absentDate=MgStudentAttendance.where( :is_deleted=>0, :absent_date=>absent_date, :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)

   

    
  #   @check_user_gardian=MgUser.where(:user_type=>'guardian', :id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0)
  #   if (@check_user_gardian.present?)
  #   @Guardian= MgGuardian.where(:mg_user_id => session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0).pluck(:id)

  #     # @sql = "SELECT * from mg_students S,mg_guardians G ,mg_student_guardians M Where M.mg_guardians_id  = #{@Guardian[0]} And S.id = M.mg_student_id and G.id = M.mg_guardians_id and S.is_deleted=0 and S.mg_school_id=#{session[:current_user_school_id]} and G.is_deleted=0 and G.mg_school_id=#{session[:current_user_school_id]} and M.is_deleted=0 and M.mg_school_id=   #{session[:current_user_school_id]}"
  #     @sql="SELECT S.first_name, S.id , S.mg_batch_id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.mg_guardians_id  = 1 And S.id = M.mg_student_id and G.id = M.mg_guardians_id and S.is_deleted=0 and S.mg_school_id=5 and G.is_deleted=0 and G.mg_school_id=5 and M.is_deleted=0 and M.mg_school_id=5"
  #     @students=MgStudent.find_by_sql(@sql)
  #     puts "@student_gardian"
  #     puts @students.inspect
  #     puts "@student_gardian"
  #   end
  #   render :layout => false
    
  # end
  def attendance_import
    mg_school_id=session[:current_user_school_id]
    user_id=session[:user_id]
    if params[:is_day_attendance]!='1'
    begin
    @demo=MgStudentAttendance.import(params[:file], mg_school_id, user_id)
    puts @demo.inspect
      @error_object="Imported successfully."

    rescue Exception => exc
    @error_object="Importing was unsuccessful, please provide the proper data."
      
    end

    else
    begin

    MgStudentAttendance.import_with_day_wise(params[:file], mg_school_id, user_id)
    @error_object="Imported successfully."

    rescue Exception => exc
    @error_object="Importing was unsuccessful, please provide the proper data."

    end

    end
   

    redirect_to :action=>'employee_student_attendance', notice: @error_object

  end

  

  private

  def attes_params
    params.require(:attendances).permit(:mg_batch_id, :mg_student_id, :is_afternoon, :is_halfday, :reason, :absent_date, :mg_batch_id ,:is_deleted, :mg_school_id, :created_by, :updated_by)
  end

  def ajax_params
    params.permit(:mg_class_timing_id, :mg_student_id, :absent_date, :mg_period_table_entry_id, :is_afternoon, :is_halfday, :reason, :mg_batch_id ,:is_deleted, :mg_school_id, :created_by, :updated_by)
  end 



  
end
