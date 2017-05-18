class EmployeesAttendancesController < ApplicationController

  #com
  before_filter :login_required
		layout "mindcom"

  

require 'date'

def new
  mg_school_id=session[:current_user_school_id]
    @deptId = params[:mg_employee_departments_id]
      date_student_id = params[:date_student_id]
      month = params[:month]
      logger.info("month :"+month);
      year = params[:year]
      logger.info("year :"+year);
      
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


       employee = MgEmployee.find(@student_id)
        emp_experience = employee.experience_year*12 + employee.experience_month
        emp_gender = Array.new
        emp_gender << "all"
        emp_gender << employee.gender
        emp_type_id = employee.mg_employee_type_id
        
      @leave_types=MgEmployeeLeaveType.where("is_deleted  = 0 AND mg_school_id = #{session[:current_user_school_id]} AND minimum_month_experience <= ? AND gender IN (?) AND mg_employee_type_id =?",emp_experience, emp_gender, emp_type_id)#.pluck(:id, :leave_name)
      puts  @leave_types.inspect

        weekday=[0,1,2,3,4,5,6]
        my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
        @school_employee_weekday_arr=weekday-my_days

  render :layout => false
  
end

def index
  
end

def update
  @employees_attendances = MgEmployeeAttendance.find(params[:id])
 
  @employees_attendances.update(employees_ajax_params)
   @employees_attendances.updated_by=session[:user_id]
    @employees_attendances.save

    #Notification Start
    begin
    user=MgUser.find(session[:user_id])
    usertype=user.user_type
    if(usertype=='principal')
      if(params[:is_lock]=="true")
          puts "Inside Notification===="
         
          employee=MgEmployee.find(params[:mg_employee_id])
          school=MgSchool.find(session[:current_user_school_id])
          not_sub ="Employee Attendance Unlock to edit"
          not_des ="#{employee.first_name} #{employee.middle_name} #{employee.last_name} attendance on #{params[:absent_date]} can be edited."
          to_user_id=MgUser.where(:user_type=>"admin").pluck(:id)
          db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id],:to_user_id =>to_user_id[0], :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
          @message = Message.new
          @email_from = MgEmail.where(:mg_user_id => session[:user_id])
          @message.subject =  not_sub
          @message.description = not_des
          @email_to = MgEmail.where(:mg_user_id => to_user_id[0])
          @message.to_user_id = @email_to[0][:mg_email_id ]
          @message.from_user_id = @email_from[0][:mg_email_id ]
          server_response = NotificationMailer.send_mail(@message).deliver!
          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                  :email_addrs_to => @message.to_user_id,
                                            :mg_school_id => session[:current_user_school_id] ,
                                                  :email_addrs_by => @message.from_user_id,
                                                  :email_subject => not_sub,
                                                 :email_server_description => server_description(server_response.status) 
                                                 )
        end
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
    #Notification ends
    



end

# def delete
#   # subjects/delete/"+splString[1]
#    @employees_attendances=MgEmployeeAttendance.find_by_id(params[:id])

#   @employees_attendances.is_deleted =1
#   @employees_attendances.save

#   @employees_attendances=MgEmployeeAttendance.find_by_id(params[:id])

 

#     employeeID= @employees_attendances.mg_employee_id
#     mg_leave_type_id= @employees_attendances.mg_leave_type_id

#   puts "employeeID"
#   puts employeeID

#   puts "mg_leave_type_id"
#   puts mg_leave_type_id

#   @EmployeeLeave=MgEmployeeLeaves.where(:mg_employee_id=>employeeID, :mg_leave_type_id=> mg_leave_type_id, :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
#   @EmployeeLeaveUpdate=MgEmployeeLeaves.find_by_id(@EmployeeLeave[0])
#   leave=@EmployeeLeaveUpdate.leave_taken
 
#   value=leave-1
#   @EmployeeLeaveUpdate.leave_taken=value
#   @EmployeeLeaveUpdate.updated_by=session[:user_id]
#   @EmployeeLeaveUpdate.save
#   # sql="UPDATE mg_employee_leaves SET leave_taken =#{value} WHERE mg_employee_id=#{employeeID} and  mg_leave_type_id=#{mg_leave_type_id}"
#   # ActiveRecord::Base.connection.execute(sql)
# end


def delete
  # subjects/delete/"+splString[1]
   @employees_attendances=MgEmployeeAttendance.find_by_id(params[:id])

  @employees_attendances.is_deleted =1
  @employees_attendances.save

  @employees_attendances=MgEmployeeAttendance.find_by_id(params[:id])


  if @employees_attendances.absent_date.present?
     previous_month=Date.parse(@employees_attendances.absent_date.to_s)#.ago(1.month)
    start_from=previous_month.beginning_of_month
    end_to=previous_month.end_of_month
    @month_start=start_from.strftime('%Y-%m-%d')
    @month_end=end_to.strftime('%Y-%m-%d')

  end
  
 

    employeeID= @employees_attendances.mg_employee_id
    mg_leave_type_id= @employees_attendances.mg_leave_type_id

  puts "employeeID"
  puts employeeID

  puts "mg_leave_type_id"
  puts mg_leave_type_id

  @EmployeeLeave=MgEmployeeLeaves.where(:mg_employee_id=>employeeID, :mg_leave_type_id=> mg_leave_type_id, :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>@month_start...@month_end).pluck(:id)
  @EmployeeLeaveUpdate=MgEmployeeLeaves.find_by_id(@EmployeeLeave[0])
  leave=@EmployeeLeaveUpdate.leave_taken
puts "leave_taken before---------:#{leave}"
    value=0
  if @employees_attendances.is_halfday
     value=leave-0.5
     puts "is halfday---------"
  else
     value=leave-1
     puts "is full day---------"

  end
puts "leave_taken middle---------:#{value}"


  if value>=0
  else
    value=0
  end
puts "leave_taken last---------:#{leave}"


 
 
  @EmployeeLeaveUpdate.leave_taken=value
  @EmployeeLeaveUpdate.updated_by=session[:user_id]
  @EmployeeLeaveUpdate.save
  # sql="UPDATE mg_employee_leaves SET leave_taken =#{value} WHERE mg_employee_id=#{employeeID} and  mg_leave_type_id=#{mg_leave_type_id}"
  # ActiveRecord::Base.connection.execute(sql)
end



def create
    @no_of_days_arr=[]
    @last_date
    previous_month=Date.today#.ago(1.month)
    start_from=previous_month.beginning_of_month
    end_to=previous_month.end_of_month
    month_start=start_from.strftime('%Y-%m-%d')
    month_end=end_to.strftime('%Y-%m-%d')
    @all_data= params.permit(:mg_employee_id, :mg_leave_type_id, :absent_date, :mg_employee_department_id, :reason, :is_halfday, :is_afternoon, :is_deleted, :is_approved, :leave_type, :abcent_without_notice, :is_late_come, :time)

    this_mont=Date.parse(@all_data[:absent_date])
    this_mont_start=this_mont.beginning_of_month
    this_mont_end=this_mont.end_of_month
    this_mont_start=this_mont_start.strftime('%Y-%m-%d')
    this_mont_end=this_mont_end.strftime('%Y-%m-%d')

    mg_school_id=session[:current_user_school_id]

     weekday=[0,1,2,3,4,5,6]
     my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     my_days=weekday-my_days

      weekdays_hash=Hash.new

      
      weekdays_hash[1]='Monday'
      weekdays_hash[2]='Tuesday'
      weekdays_hash[3]='Wednesday'
      weekdays_hash[4]='Thursday'
      weekdays_hash[5]='Friday'
      weekdays_hash[6]='Saturday'
      weekdays_hash[0]="Sunday"

    # , :leave_month_year=>month_start...month_end
    @employees_attendances=MgEmployeeAttendance.new(employees_ajax_params)
    @no_of_days= params.permit(:no_of_days, :absent_date)
    no_of_days=@no_of_days[:no_of_days]
    no_of_days=no_of_days.to_i
    
    @school=MgSchool.find(session[:current_user_school_id])

    if @all_data[:is_late_come].present?
      @time=@all_data[:time]
      # puts "@time if"
      # puts @time
    else
      @time=@school.start_time
      # puts "@time else"
      # puts @time
    end
    if(no_of_days != 0)
                
          $dayCount=0
          $dayCheck= Date.new

      for i in 0...no_of_days
                date=@all_data[:absent_date]
                # puts "absent_date"
                # puts date
                arr = date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
                # puts "day"
                # puts day
                # puts "month"
                # puts month
                # puts "year"
                # puts year
                
                $dayCheck= Date.new(year,month,day)+$dayCount
                dayName=$dayCheck.strftime("%A")
                # puts 'i try to get day name'
                # puts dayName
                # puts 'i got day name'
               

                 # if dayName=='Sunday'

                  for i in 1..7
                    if i==7
                      count=0
                     else
                     count=i
                    end
                    if dayName=="#{weekdays_hash[count]}" && my_days.include?(count)   
                      $dayCount +=1
                      $dayCheck= Date.new(year,month,day)+$dayCount
                      dayName=$dayCheck.strftime("%A")
                    end
                  end

                  
                  
                 
                  
                     $dayCheck= Date.new(year,month,day) + $dayCount
                     @last_date=$dayCheck
                     puts $dayCheck
                     $dayCount +=1
                    puts "i am in if condition   ----else----"

                     puts "step ----1-----"
                  #end
                     puts $dayCheck.strftime("%A")
                     puts "step -----2------"
                savedate=$dayCheck.to_s
                @employees_attendanc=MgEmployeeAttendance.new(:absent_date=>savedate, :mg_employee_id=>@all_data[:mg_employee_id], :reason=>@all_data[:reason], :is_halfday=>0, :is_afternoon=>0, :mg_employee_department_id=>@all_data[:mg_employee_department_id], :is_deleted=>0, :is_approved=>1, :mg_leave_type_id=>@all_data[:leave_type], :abcent_without_notice=>@all_data[:abcent_without_notice], :is_late_come=>@all_data[:is_late_come], :time=>@time, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id])
                @employees_attendanc.save
      end  


       absent_date=Date.parse(@all_data[:absent_date])
                  result=no_of_sunday(absent_date,(absent_date+$dayCount.to_i-1))
                  # @no_of_days_arr=$dayCount-2
                  

                   from_date=Date.parse(@all_data[:absent_date])
                   # @last_date
                   puts "---------test date difference------------------"
                   puts "from_date-----#{from_date}"
                   puts "@last_date-----#{@last_date}"
                   puts "---------test date difference------------------"

                   # @timeformat=MgSchool.find(session[:current_user_school_id])
                   #  @from_date = Date.strptime(absent_date.to_s,@timeformat.date_format)
                   #  puts @from_date
                    # @last_date = Date.strptime( @last_date,@timeformat.date_format)
                  

                    @no_of_days_arr=(@last_date.to_date-from_date.to_date).to_i
                   # (from_date-@last_date)
                   # @no_of_days_arr+=1
                      puts @no_of_days_arr
                     # puts last_datehhhh
                   to_date=from_date+no_of_days-1+result
                   date_array=((from_date)..to_date).map{|d|[d.year, d.month] }
                  date_wise_employee_leave_update(date_array,@all_data,my_days.count)


    else
        
        @employees_attendances.updated_by=session[:user_id]
        @employees_attendances.created_by=session[:user_id]
        @employees_attendances.is_approved=1
        @employees_attendances.time=@time
        @employees_attendances.mg_school_id=session[:current_user_school_id]
        @employees_attendances.save
        @count_leave=MgEmployeeLeaves.where(:mg_employee_id => @all_data[:mg_employee_id], :mg_leave_type_id=> @all_data[:leave_type], :mg_school_id=>session[:current_user_school_id], :leave_month_year=>this_mont_start...this_mont_end)
          if  @count_leave.length > 0
            @updateEmployeeLeves=MgEmployeeLeaves.find(@count_leave[0].id)
            @updateEmployeeLeves.leave_taken +=0.5
            @updateEmployeeLeves.updated_by=session[:user_id]
            @updateEmployeeLeves.mg_school_id=session[:current_user_school_id]
            @updateEmployeeLeves.save
          else
            @updateEmployeeLeves=MgEmployeeLeaves.new(:mg_employee_id=>@all_data[:mg_employee_id],:mg_leave_type_id=>@all_data[:leave_type], :leave_taken=>0.5, :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id] , :leave_month_year=>this_mont_start)
            @updateEmployeeLeves.save
           end

    end  
    user=MgUser.find(session[:user_id])
    usertype=user.user_type
    puts "User Type====="
    puts usertype.inspect

    #Notification Starts for admin
    begin
      if(usertype == "admin") 
        puts "Inside Notification===="
        not_sub ="Employee Attendance"
        employee=MgEmployee.find(@all_data[:mg_employee_id])
        school=MgSchool.find(session[:current_user_school_id])
        principal_user_id=MgUser.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:user_type=>"principal").pluck(:id)
        not_des ="#{employee.first_name} #{employee.middle_name} #{employee.last_name} has taken leave on #{@all_data[:absent_date]} because of #{@all_data[:reason]}."
        db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id],:to_user_id =>principal_user_id[0] , :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
        @message = Message.new
        @email_from = MgEmail.where(:mg_user_id => session[:user_id])
        @message.subject =  not_sub
        @message.description = not_des
        @email_to = MgEmail.where(:mg_user_id => principal_user_id[0])
        @message.to_user_id = @email_to[0][:mg_email_id ]
        @message.from_user_id = @email_from[0][:mg_email_id ]
        server_response = NotificationMailer.send_mail(@message).deliver!
        @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                          :email_addrs_to => @message.to_user_id,
                                          :mg_school_id => session[:current_user_school_id] ,
                                          :email_addrs_by => @message.from_user_id,
                                          :email_subject => not_sub,
                                          :email_server_description => server_description(server_response.status) 
                                          )

        
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
    #Notification Ends for admin

    #Notification Start for principal
    begin
      if(usertype == "principal")
      puts "inside principal"
      puts params[:is_lock]
      if(params[:is_lock]=="true")
          puts "Inside Principal Notification===="
         
          employee=MgEmployee.find(params[:mg_employee_id])
          school=MgSchool.find(session[:current_user_school_id])
          not_sub ="Employee Attendance Unlock to edit"
          not_des ="#{employee.first_name} #{employee.middle_name} #{employee.last_name} attendance on #{params[:absent_date]} can be edited."
          to_user_id=MgUser.where(:user_type=>"admin",:mg_school_id=>session[:current_user_school_id],:is_deleted=>0).pluck(:id)
          db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id],:to_user_id =>to_user_id[0], :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
          @message = Message.new
          @email_from = MgEmail.where(:mg_user_id => session[:user_id])
          @message.subject =  not_sub
          @message.description = not_des
          @email_to = MgEmail.where(:mg_user_id => to_user_id[0])
          @message.to_user_id = @email_to[0][:mg_email_id ]
          @message.from_user_id = @email_from[0][:mg_email_id ]
          server_response = NotificationMailer.send_mail(@message).deliver!
          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                            :email_addrs_to => @message.to_user_id,
                                            :mg_school_id => session[:current_user_school_id] ,
                                            :email_addrs_by => @message.from_user_id,
                                            :email_subject => not_sub,
                                            :email_server_description => server_description(server_response.status) 
                                          )
        end
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
    #Notification ends for principal


      # render :layout => false
     respond_to do |format|
            format.json  { render :json => @no_of_days_arr }
        end
  end

  def no_of_sunday(start_of_month,end_of_month)
    mg_school_id=session[:current_user_school_id]
    weekday=[0,1,2,3,4,5,6]
     my_dayss = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     my_dayss=weekday-my_dayss
     puts "weekday----->#{my_dayss.inspect}"
          result = (start_of_month..end_of_month).to_a.select {|k| my_dayss.include?(k.wday)}
    puts "result.inspect  -------#{result.inspect}"
    return result.count
  end

  def date_wise_employee_leave_update(date_array,all_data,my_days_count)
      absent_date=Date.parse(all_data[:absent_date])
      puts "------------------date_wise_employee_leave_update-------------------------"
      puts "absent_date----------------[#{absent_date}]"
      no_of_days= params.permit(:no_of_days)
      no_of_days=params[:no_of_days]

      puts "no_of_days----------------[#{no_of_days}]"

      # result=no_of_sunday(absent_date,(absent_date+no_of_days.to_i-1))
      # puts "result-------total-days-----[#{result}]"


      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      puts "date_array -------#{date_array.inspect}"
     

      date_count=dup_hash(date_array)
      puts "date_count -------#{date_count.inspect}"

 puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

      date_count.each do |key,value|
        puts "#{key}-----#{value}"
        puts key[0]
        puts key[1]
        puts "#{key}-----#{value}"


        start_of_month1=Date.new(key[0].to_i,key[1].to_i.to_i,1)
        end_of_month1=start_of_month1.end_of_month
        puts "-------no of sundays------testing--------------"
        puts "absent_date ------#{absent_date}"
        result=no_of_sunday(absent_date,absent_date+value-1)
        absent_date=absent_date+value

       # puts "absent_date_after ------#{absent_date}"
        
       #  puts 
       #  puts "-------no of sundays------testing--------------"

       #  puts "result ------#{result}------value------#{value}"
       #  puts "result ------#{result}------value------#{value}"
       #  puts "result ------#{result}------value------#{value}"
       #  puts "result ------#{result}------value------#{value}"
       #  puts "result ------#{result}------value------#{value}"
       #  puts "result ------#{result}------value------#{value}"

     
       #  # puts jjjjjjjhj

        countleave=MgEmployeeLeaves.where(:mg_employee_id=>all_data[:mg_employee_id], :mg_leave_type_id=>all_data[:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>start_of_month1...end_of_month1)
        puts countleave.inspect
        if countleave[0].present?
          puts "-----if---------"
          leave_count=countleave[0].leave_taken
              leave_taken=leave_count+(value-result)
              countleave[0].leave_taken=leave_taken
              countleave[0].updated_by=session[:user_id]
              countleave[0].save
          else
          puts "--------else---------"

            countleave_new=MgEmployeeLeaves.new(:leave_taken=>(value-result),:mg_employee_id=>all_data[:mg_employee_id], :mg_leave_type_id=>all_data[:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>start_of_month1)
          countleave_new.save
        end

      puts "------------------date_wise_employee_leave_update-------------------------"

      end
    
  end

  def dup_hash(ary)
      ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { 
      |k,v| v >= 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
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

	def studentsHash

    @checkuser=MgUser.where(:id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :user_type=>'principal')
    puts "@checkuser"

    mg_school_id=session[:current_user_school_id]
    weekday=[0,1,2,3,4,5,6]
     my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     my_days=weekday-my_days


        data = Array.new
    if @checkuser.present?
      #princy
        @sql = "Select * from mg_employees where mg_employee_department_id = #{params[:id]} and mg_school_id=#{session[:current_user_school_id] } and is_deleted=0 ORDER BY first_name "
        # @sql = "Select * from mg_employees where mg_employee_department_id = #{params[:id]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0 and mg_employee_category_id=(SELECT id FROM mg_employee_categories where category_name='Teaching Staff' and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0)"
        
        @employees = MgEmployee.find_by_sql(@sql)
      # logger.info(@students.inspect)
        data.push(@employees)
        @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_employee_id, created_at, updated_at from mg_employee_attendances where mg_employee_department_id=#{params[:id]} and is_deleted=0 and mg_school_id=#{session[:current_user_school_id] } and is_approved=1"
        @absent_dates = MgStudent.find_by_sql(@sql1)
        data.push(@absent_dates)



    else
      #admin
        puts "i m in else"
        @sql = "Select * from mg_employees where mg_employee_department_id = #{params[:id]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0 and mg_employee_category_id=(SELECT id FROM mg_employee_categories where category_name='Non Teaching Staff' and is_deleted=0) ORDER BY first_name"
        @employees = MgEmployee.find_by_sql(@sql)
      # logger.info(@students.inspect)
        data.push(@employees)
       @sql1="select DATE_FORMAT(a.absent_date, '%Y') year, DATE_FORMAT(a.absent_date, '%c') month, DATE_FORMAT(a.absent_date,
         '%e') day, a.mg_employee_id, a.created_at, a.updated_at from mg_employee_attendances a, mg_employees b where
          a.mg_employee_department_id=#{params[:id]} and a.is_deleted=0 and b.id=a.mg_employee_id and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id] } and b.mg_school_id=#{session[:current_user_school_id] } and a.is_approved=1 and b.mg_employee_category_id=(SELECT id FROM mg_employee_categories where category_name='Non Teaching Staff' and is_deleted=0)"
        # @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_employee_id from mg_employee_attendances where mg_employee_department_id=#{params[:id]} and is_deleted=0"
        @absent_dates = MgStudent.find_by_sql(@sql1)
        data.push(@absent_dates)
          puts "i'm in else"
    end

  	puts "StudentsHash -- is comming"
    data.push(my_days)
  	

  	    respond_to do |format|
            format.json  { render :json => data }
        end
  	#puts @students.inspect
	#render :layout => false
  end

  def employee_index

     
      @userID=session[:user_id]
      puts "step ----1----"
      puts @userID

      @employee_id= MgEmployee.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
      puts "step ------2-----"
      puts @employee_id

      @mg_employee_department_id= MgEmployee.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_department_id)
      puts "step ------3-----"
      puts @mg_employee_department_id


      @mg_employee_department_name= MgEmployeeDepartment.where(:id => "#{@mg_employee_department_id[0]}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:department_name)
      puts "step ------4-----"
      puts @mg_employee_department_name

      # @subjects=MgEmployeeSubject.where(:mg_employee_id=>@employee_id[0])
      # puts "subjects list   ---5---"
      # puts @subjects.inspect
      sql="select a.id, a.subject_name from mg_subjects a, mg_employee_subjects b where b.mg_employee_id=#{@employee_id[0]} and a.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
      @subjects=MgEmployeeSubject.find_by_sql sql

      puts "subjects list   ---6---"
      puts @subjects.inspect

      puts "subjects list   ---7---"




  # render :layout => false

  end



  def employee_attendence
     @userID=session[:user_id]
      puts "step ----1----"
      puts @userID


    mg_school_id=session[:current_user_school_id]
    weekday=[0,1,2,3,4,5,6]
     my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     my_days=weekday-my_days


      @employee_id= MgEmployee.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
      puts "step ------2-----"
      puts @employee_id

      @mg_employee_department_id= MgEmployee.where(:mg_user_id => "#{@userID}", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_department_id)
      puts "step ------3-----"
      puts @mg_employee_department_id



    data = Array.new
    puts "employee_attendence -- is comming"
    @sql = "Select * from mg_employees where mg_employee_department_id = #{@mg_employee_department_id[0]} and id=#{@employee_id[0]} and mg_school_id=#{session[:current_user_school_id]}"
    @employees = MgEmployee.find_by_sql(@sql)
    # logger.info(@students.inspect)
    data.push(@employees)
    @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_employee_id from mg_employee_attendances where mg_employee_department_id=#{@mg_employee_department_id[0]} and mg_employee_id=#{@employee_id[0]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0"
    @absent_dates = MgEmployee.find_by_sql(@sql1)
    data.push(@absent_dates)
    data.push(my_days)
    
        respond_to do |format|
            format.json  { render :json => data }
        end
    
  end

  def employee_list
    if request.xhr?

        departmentParam=params[:departmentParam]
      

        
        if(departmentParam=="departmentParam")
         user= MgUser.where(:id=>session[:user_id], :user_type=>'principal', :mg_school_id=>session[:current_user_school_id])
          if user[0].present?
           @employee_list=MgEmployee.where(:mg_employee_department_id=> params[:departmentId], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
          else
           @employee_list=MgEmployee.where(:mg_employee_department_id=> params[:departmentId], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Non Teaching Staff").id))

          end
          render :json=> {:employee=>@employee_list}
        end

        if params[:employeeCheck]=="employee"
          @levee_typs=MgEmployeeLeaveType.where(:is_deleted=>0)
          sql="select a.leave_name, b.leave_taken, a.max_leave_count, a.reset_period from mg_employee_leave_types a, mg_employee_leaves b where a.id=b.mg_leave_type_id and mg_employee_id=#{params[:employeeID]} and a.is_deleted=0 and b.is_deleted=0"
        
          @employee=MgEmployee.find_by_sql sql

           render :json=> {:employee=>@employee, :levee_typs=>@levee_typs}
        end
    end
    
  end


  def subjects_for_employee
      @userID=session[:user_id]
      puts "step ----1----"
      puts @userID

      @employee_id= MgEmployee.where(:mg_user_id => "#{@userID}",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:id)
      puts "step ------2-----"
      puts @employee_id


      sql="select a.id, a.subject_name from mg_subjects a, mg_employee_subjects b where b.mg_employee_id=#{@employee_id[0]} and a.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]}"
      @subjects=MgEmployeeSubject.find_by_sql sql

      puts "subjects list   ---6---"
      puts @subjects.inspect
      puts "subjects list   ---7---"
    
  end

  def edit

     @deptId = params[:mg_employee_departments_id]
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


      id=MgEmployeeAttendance.where(:absent_date=>@final_date, :mg_employee_id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
      puts "id ---- step --1"
      puts id[0]
      @employees_attendances=MgEmployeeAttendance.find(id[0])
      puts "step  ------2----"
      puts @employees_attendances.inspect

      # puts "check one day "
      # puts "step  ----1---"
      # puts  @employees_attendances.inspect
      # puts "step  ----2---"
      # $abc=0
      # @employees_attendances.each do |f|
      #  $avc=f.id

      # end
      # puts $abc
      render :layout => false

     
  end

  def delete_attendance
    puts "i'm in delete_attendance"
    puts "step ----1----"

     redirect_to :action => "index"
    
  end

  def leave_details_for_employee
    @employee_id=MgEmployee.find(params[:id])
    @levee_typs=MgEmployeeLeaveType.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    employee = MgEmployee.find(params[:id])
        emp_experience = employee.experience_year*12 + employee.experience_month
        emp_gender = Array.new
        emp_gender << "all"
        emp_gender << employee.gender
        emp_type_id = employee.mg_employee_type_id
        
       @levee_typs=MgEmployeeLeaveType.where("mg_school_id=#{session[:current_user_school_id]} and is_deleted  = 0 AND minimum_month_experience <= ? AND gender IN (?) AND mg_employee_type_id =?",emp_experience, emp_gender, emp_type_id)
    
      render :layout => false
  end


   def attendance_report
    @all_data= params.permit(:startDate, :endDate, :departmentId)
    @timeformat = MgSchool.find(session[:current_user_school_id])
      puts @all_data[:startDate]
      puts @all_data[:endDate]
      if @all_data[:startDate].present?
        @start_date = Date.strptime(@all_data[:startDate],@timeformat.date_format)
      end
      if @all_data[:endDate].present?
        @end_date = Date.strptime(@all_data[:endDate],@timeformat.date_format)
      end

    # Date.strptime(params[:mg_employee_leave_types][:half_day_date],@timeformat.date_format)
    puts "i'm attendance_report"
    puts "step ----1---"
    deptId =   @all_data[:departmentId]
    puts "step ----2---"
    puts deptId
   

    puts "step ----3---"
    puts @start_date
    puts "step ----4---"

   
    puts @end_date
    total_days=(@end_date.to_date - @start_date.to_date).to_i
    @total_days=total_days+1
    puts "step total_days ----1"
    puts @total_days

    @data=MgEmployeeAttendance.where(:absent_date=>@start_date.to_date..@end_date.to_date, :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    puts "steps  ----5----"
    puts @data.inspect
    puts "absent_date -----"
    puts  @data.length
    sqlquery="SELECT distinct mg_employee_id FROM mg_employee_attendances WHERE absent_date BETWEEN '#{@start_date.to_date}' AND '#{@end_date.to_date}' and is_deleted=0"
    @employeeIDs=MgEmployeeAttendance.find_by_sql sqlquery
    puts "step -----------6-----"
    puts  @employeeIDs.inspect

    # @allEmloyees=MgEmployee.where(:is_deleted=>0).paginate(page: params[:page], per_page: 10)
    user=MgUser.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :user_type=>'principal', :id=>session[:user_id])
    if user[0].present?
    @allEmloyees=MgEmployee.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])

    else
    @allEmloyees=MgEmployee.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Non Teaching Staff").id))
    end
      render :layout => false


    
  end
  def report
    if request.xhr?
      if params[:employee]=="halfday"
        @halfdayObject=MgEmployeeAttendance.where(:mg_employee_id=>params[:employeeID], :absent_date=>params[:start_date].to_date..params[:end_date].to_date, :is_halfday=>1, :is_deleted=>0) 
        @leaveName=MgEmployeeLeaveType.where(:is_deleted=>0)
        render :json=> {:halfdayObject=>@halfdayObject, :leaveName=> @leaveName}
      elsif params[:employee]=="fullday"
        @fulldayObject=MgEmployeeAttendance.where(:mg_employee_id=>params[:employeeID], :absent_date=>params[:start_date].to_date..params[:end_date].to_date, :is_halfday=>0, :is_afternoon=>0, :is_deleted=>0) 
        @leaveName=MgEmployeeLeaveType.where(:is_deleted=>0)
        render :json=> {:fulldayObject=>@fulldayObject, :leaveName=> @leaveName}
      elsif params[:employee]=="allday"
        @fullday=MgEmployeeAttendance.where(:mg_employee_id=>params[:employeeID], :absent_date=>params[:start_date].to_date..params[:end_date].to_date, :is_halfday=>0, :is_afternoon=>0, :is_deleted=>0) 
        @halfdayObject=MgEmployeeAttendance.where(:mg_employee_id=>params[:employeeID], :absent_date=>params[:start_date].to_date..params[:end_date].to_date, :is_halfday=>1, :is_afternoon=>0, :is_deleted=>0)
        # @fulldayObject=MgEmployeeAttendance.where(:mg_employee_id=>params[:employeeID], :absent_date=>params[:start_date].to_date..params[:end_date].to_date, :is_deleted=>0) 
        @fulldayObject=MgEmployeeAttendance.where(:mg_employee_id=>params[:employeeID], :absent_date=>params[:start_date].to_date..params[:end_date].to_date, :is_deleted=>0, :is_halfday=>1, :is_afternoon=>1) 
        @leaveName=MgEmployeeLeaveType.where(:is_deleted=>0)
        render :json=> {:fulldayObject=>@fulldayObject, :leaveName=> @leaveName, :halfdayObject=>@halfdayObject,:fullday=>@fullday}
      else

      end


      # render :json=> {:employee=>@employee_list}
    end
  end

  def attendance_validation
    

     mg_school_id=session[:current_user_school_id]
      weekday=[0,1,2,3,4,5,6]
     my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     my_days=weekday-my_days

     weekdays_hash=Hash.new

      
      weekdays_hash[1]='Monday'
      weekdays_hash[2]='Tuesday'
      weekdays_hash[3]='Wednesday'
      weekdays_hash[4]='Thursday'
      weekdays_hash[5]='Friday'
      weekdays_hash[6]='Saturday'
      weekdays_hash[0]="Sunday"


    if request.xhr?
      notice=""
    puts params[:mg_employee_id]
    puts params[:is_halfday]
    puts params[:is_late]
    
    if params[:is_halfday]=='false' && params[:is_late]=='false'
      no_of_days=params[:no_of_days].to_i
    else
      no_of_days=1
    end
    if params[:no_of_days].present?
    $dayCount=0
      for i in 0..params[:no_of_days].to_i  
          date=params[:absent_date]
                arr = date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
                
                $dayCheck= Date.new(year,month,day)+$dayCount
                dayName=$dayCheck.strftime("%A")

                  for i in 1..7
                    if i==7
                      count=0
                     else
                     count=i
                    end
                    if dayName=="#{weekdays_hash[count]}" && my_days.include?(count)   
                      $dayCount +=1
                      $dayCheck= Date.new(year,month,day)+$dayCount
                      dayName=$dayCheck.strftime("%A")
                    end
                  end
                  
                     $dayCheck= Date.new(year,month,day) + $dayCount
                     @last_date=$dayCheck
                     puts $dayCheck
                     $dayCount +=1
      end
    end

     # date_array=((from_date)..to_date).map{|d|[d.year, d.month] }




                        # is_late: is_late
        arr = params[:absent_date].split('-');
                    month= arr[1].to_i
                    year=arr[2].to_i
                    day =arr[0].to_i
        from_date=Date.new(year,month,day)
        to_date= Date.new(year,month,day)+no_of_days
        employee_joing_date=MgEmployee.where(:id=>params[:mg_employee_id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
       # puts "from_date--------------:#{from_date}"
       # puts "to_date--------------:#{to_date}"
       # puts "joining_date--------------:#{Date.parse(employee_joing_date[0].joining_date.to_s)}"
       
      
        if from_date.to_date<=Date.parse(employee_joing_date[0].joining_date.to_s).to_date
          notice="date_equal_to_absent_date"
          puts "if"
       
        end
        @fulldayObject=MgEmployeeAttendance.where(:mg_employee_id=>params[:mg_employee_id], :absent_date=>from_date.to_date...@last_date, :is_deleted=>0, :is_approved=>[1,0]) 
        if @fulldayObject.present?
          notice="absent_date_present"
        end

        # puts jugvubdasrbkgkdrgni
    notice_msg = Hash["notice" => notice]

    render :json=> notice_msg
  end


    
  end

  def import_attendance
    
  end

  def import
    schoolId=session[:current_user_school_id]
    userId=session[:user_id]
    MgEmployeeAttendance.import(params[:file], schoolId, userId)
    redirect_to :action=>'import_attendance', notice: "Imported successfully."
  end

  private
  def employees_params
    params.require(:employees_attendances).permit(:mg_employee_id, :mg_leave_type_id, :absent_date, :mg_employee_department_id, :reason, :is_halfday, :is_afternoon, :is_deleted, :is_late_come, :time, :is_lock, :mg_school_id, :created_by, :updated_by)
  end

  private
  def employees_ajax_params
    params.permit(:mg_employee_id, :mg_leave_type_id, :absent_date, :mg_employee_department_id, :reason, :is_halfday, :is_afternoon, :is_deleted, :is_late_come, :time, :abcent_without_notice, :is_lock, :mg_school_id, :created_by, :updated_by)
  end

end

