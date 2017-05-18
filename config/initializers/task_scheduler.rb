require 'rubygems'
require 'rufus/scheduler'
 
## to start scheduler
 scheduler = Rufus::Scheduler.new
 
## It will print message every i minute
#replace the line 10 for( every month on the last day at 23:59)
this_month=Date.today
 previous_month=this_month.ago(1.month)
 start_from=previous_month.beginning_of_month
 end_to=previous_month.end_of_month

 month_start=start_from.strftime('%Y-%m-%d')
 month_end=end_to.strftime('%Y-%m-%d')
 this_month_start=this_month.strftime('%Y-%m-%d')
 this_month_end=this_month.strftime('%Y-%m-%d')
 scheduler.cron '59 23 L * *' do
  # scheduler.every '1m' do #this for testing

  schools=MgSchool.where(:is_deleted=>0,:id=>1)
  schools.each do |school|
    leave_types=MgEmployeeLeaveType.where(:mg_school_id=>school.id,:is_deleted=>0)
    # leave_types=MgEmployeeLeaveType.where(:mg_school_id=>school.id,:is_deleted=>0,:is_accumilation=>1)

    # puts leave_types.inspect
    leave_types.each do |leave_type|

      query_str  = "is_deleted = 0 AND mg_school_id = ? AND experience_year*12 + experience_month +TIMESTAMPDIFF(MONTH, joining_date, CURDATE())>= ? AND mg_employee_type_id = ? "
      if leave_type.gender!="all"
          query_str += " AND gender = '#{leave_type.gender}'"
        end
        employees=MgEmployee.where(query_str,school.id,leave_type.minimum_month_experience,leave_type.mg_employee_type_id)  
      
      employees.each do |employee|
        employee_leave_detail=MgEmployeeLeaves.where(:mg_employee_id=>employee.id,:mg_leave_type_id=>leave_type.id,:is_deleted=>0,:mg_school_id=>school.id,  :leave_month_year=>month_start..month_end)
        if employee_leave_detail[0].present?

          increment_value=employee_leave_detail[0].available_leave.to_f + leave_type.accumilation_count.to_f  
          puts "Increment Value"
          puts increment_value
          # employee_leave_detail[0].update(:available_leave=>increment_value)

          leave_create=MgEmployeeLeaves.where(:mg_employee_id=>employee.id,:mg_leave_type_id=>leave_type.id,:is_deleted=>0,:mg_school_id=>school.id,  :leave_month_year=>this_month_start..this_month_end)
          if leave_create[0].present?
            leave_create=leave_create[0]
          else
            leave_create=MgEmployeeLeaves.new
            leave_create.is_deleted=0
            leave_create.mg_school_id=school.id 
            leave_create.mg_employee_id=employee_leave_detail[0].mg_employee_id
            leave_create.leave_taken=0
            leave_create.leave_month_year=Date.today
            leave_create.mg_leave_type_id=leave_type.id
          end
          pos_value=employee_leave_detail[0].available_leave.to_f-employee_leave_detail[0].leave_taken.to_f
          if pos_value>0
            if leave_type.is_accumilation
              leave_create.available_leave =pos_value+leave_type.accumilation_count.to_f
            else
              leave_create.available_leave =pos_value
            end
          else
            if leave_type.is_accumilation
              leave_create.available_leave =leave_type.accumilation_count.to_f
            else
              leave_create.available_leave =0
            end
          end
          leave_create.save

        end
      end
  end

end 
end

scheduler.every '1d' do #this for testing

	
book_inventory_data=MgBooksInventory.where("is_deleted=? AND mg_school_id=? AND status=? AND issued_to=? AND reservation_due_date IS NOT NULL",0,1,"Reserved","")
puts book_inventory_data.inspect
book_inventory_data.each do |data|
		
	book_inventory=MgBooksInventory.find(data.id)
      student_id=MgStudent.find(book_inventory.reserved_by)

	if book_inventory.reservation_due_date<Date.today
		puts "Message in if condition>>===========>"
		begin
             
            @message = Message.new
              #@email_from = #MgEmail.where(:mg_user_id => @session[:user_id])
            @message.subject =  "Libraray"
              @message.description = "Dear Student your book reservation is cancelled\n Thanks & Regards"
           
                #Thread.new do
                     
                        @email_to = MgEmail.where(:mg_user_id => student_id.mg_user_id)

                        
                          puts "Start Step >--------------------------------------------------------->  1   "
                         
                          puts "End Step >--------------------------------------------------------->  2   "

                          @message.to_user_id = @email_to[0][:mg_email_id ]
                        @message.from_user_id = "jreddy@mindcomgroup.com"#@email_from[0][:mg_email_id ]
                    server_response = NotificationMailer.send_mail(@message).deliver!
                    db_user = MgNotification.create(:mg_school_id => 1 ,
                                    :to_user_id => student_id.mg_user_id,
                                    :subject => @message.subject,
                                    :description => @message.description,
                                    :is_deleted => 0,
                                    :from_user_id =>1,
                                    :status => 0)
                          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                      :email_addrs_to => @message.to_user_id,
                                                      # current school Id will come here
                                                :mg_school_id => 1 ,
                                                      :email_addrs_by => @message.from_user_id,
                                                      :email_subject => 'test',
                                                     :email_server_description => server_description(server_response.status) )

                    puts " Ste p >-------------------------> status"
                   
                    puts " Ste p >-------------------------> status"
                        
                      
               
              
                
            rescue Net::SMTPFatalError => e
              
              puts e.message
              
            rescue ArgumentError => e
             
              puts e.message

             
            rescue Exception => e
             
              puts e.message

              
            end
	book_inventory.update(:status=>"On-shelf",:reserved_by=>0,:reservation_due_date=>"")
end
end
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
