class NotificationsController < ApplicationController

	layout "mindcom"
    before_filter :login_required

    def index
      @user = MgUser.find(session[:user_id])
      @user_type = @user[:user_type]
      @notification = MgNotification.new 
      principal_user=MgUser.where(:mg_school_id=>session[:current_user_school_id],:user_type=>"principal").pluck(:id)
      @principal_noti=MgEmployee.where(:mg_school_id=>session[:current_user_school_id],:mg_user_id => principal_user[0]).pluck(:first_name,:middle_name,:last_name,:mg_user_id)
    end

    def get_data_list
        @user_type = params[:user_type]

        case @user_type.to_s
           when 'Student'
           	  @userList = MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id => params[:id]).pluck(:first_name,:middle_name,:last_name,:mg_user_id)
           when 'Parent'
           		puts "Step - - parent"
           		@sql = "select A.first_name, A.middle_name, A.last_name , A.mg_user_id from mg_guardians A,  mg_students B where B.mg_batch_id = #{params[:id]} && B.id = A.mg_student_id && B.is_deleted='0' && B.mg_school_id=#{session[:current_user_school_id]}"
           		puts @sql.inspect

           		@data = MgGuardian.find_by_sql(@sql)
           		@userList = @data
           		puts @data.inspect
           		puts "Step - - parent"

           when 'Employee'
           	  @userList = MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id => params[:id], :mg_employee_category_id=>2).pluck(:first_name,:middle_name,:last_name, :mg_user_id)
            when 'Teacher'
              @userList = MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id => params[:id], :mg_employee_category_id=>1).pluck(:first_name,:middle_name,:last_name, :mg_user_id)
           when 'principal'
              principal_user=MgUser.where(:mg_school_id=>session[:current_user_school_id],:user_type=>"principal").pluck(:id)
              @userList =MgEmployee.where(:mg_school_id=>session[:current_user_school_id],:mg_user_id => principal_user[0]).pluck(:first_name,:middle_name,:last_name,:mg_user_id)   

        end	

      respond_to do |format|
        format.json  { render :json => @userList }
      end

    	
    end

	def principal_notifications
		@notification = MgNotification.new 
		puts @notification.inspect

		@user = MgUser.find(session[:user_id])

		@user_type = @user[:user_type]
    principal_user=MgUser.where(:mg_school_id=>session[:current_user_school_id],:user_type=>"principal").pluck(:id)
    @principal_noti=MgEmployee.where(:mg_school_id=>session[:current_user_school_id],:mg_user_id => principal_user[0]).pluck(:first_name,:middle_name,:last_name,:mg_user_id)
	end

  def notification_seen
    @notification = MgNotification.find(params[:id])
    @notification.update(:status => true)
    redirect_to show_notification_path
  end

  def notification_unseen
		@notification = MgNotification.find(params[:id])
		@notification.update(:status => false)
		redirect_to show_notification_path
	end

  def principal_notification_unseen
    @notification = MgNotification.find(params[:id])
    @notification.update(:status => false)
    redirect_to show_by_box_path
  end

	def view_notification
		@notification = MgNotification.find(params[:id])

    @parent_url= request.env['HTTP_REFERER']
    puts "Parent Url"
    puts @parent_url

		@user = MgUser.find(session[:user_id])

		@user_type = @user[:user_type]
    @notification.update(:status => true)
	end

  def show_by_box
    @notifications = MgNotification.where(:to_user_id => session[:user_id]).order(:status).all.paginate(page: params[:page], per_page: 5)

    @notifi = MgNotification.where(:to_user_id => session[:user_id],:status => false ).all

    @size = @notifi.size
  end

	def show_notification
		
		@notifications = MgNotification.where(:to_user_id => session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order(:status).all.paginate(page: params[:page], per_page: 5)

		@notifi = MgNotification.where(:to_user_id => session[:user_id],:status => false,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).all

		@size = @notifi.size
		
		@user = MgUser.find(session[:user_id])

		@user_type = @user[:user_type]

	end

	def create
		multi_mail_list = params[:mg_notification][:user_check]

    if(params[:Group].to_s == "All")

      multi_mail_list = MgEmail.where.not(:mg_user_id => session[:user_id]).where(:mg_school_id=>session[:current_user_school_id]).pluck(:mg_user_id)
      puts multi_mail_list

    end 

    #For Principal start
    if(params[:Group].to_s == "Principal")

      multi_mail_list = MgEmail.where(:mg_user_id => params[:mg_notification][:to_user_id]).pluck(:mg_user_id)

      puts "param   "
      puts multi_mail_list.inspect
      puts "param   "
    end 
    #For Principal end
    begin
      @message = Message.new(params[:mg_notification])
      @email_from = MgEmail.where(:mg_user_id => session[:user_id])
      puts "Email From"
      puts @email_from

      if @message.valid?
      #Thread.new do
        puts notification_params.inspect
              multi_mail_list.each do |user|
                @email_to = MgEmail.where(:mg_user_id => user)
                puts "user ===="
                puts user
                
                db_user = MgNotification.new(notification_params)
                puts db_user
                db_user.save
                db_user.update(:to_user_id => user)

                puts "message"
                puts @message.inspect

                @message.to_user_id = @email_to[0][:mg_email_id ]
                @message.from_user_id = @email_from[0][:mg_email_id ]
            # sending notification
                server_response = NotificationMailer.send_mail(@message).deliver!

                MgMailStatus.create(:status_code => server_response.status,
                                            :email_addrs_to => @email_to[0][:mg_email_id ],
                                            :email_addrs_by => @email_from[0][:mg_email_id ],
                                            :email_subject => @message.subject,
                                            :email_server_description =>server_description(server_response.status) )

              end
              @notice="Mail sent successfully."

        else
          puts "Inside else notification is not created"
          @notice="Error in Sending Notification"
        end 
    rescue Net::SMTPFatalError => e
      @notice= 'Email-Id is not valid.'
    rescue ArgumentError=>e
      @notice='Email to address is not present.'
    rescue Exception=>e
      @notice='Error while sending email, Please contact admin.'
    end
    redirect_to :action =>"principal_notifications",:emailnotice=> @notice
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


	def notification_params
		 params.require(:mg_notification).permit(:mg_school_id ,:to_user_id, :subject,:description,:is_deleted,:from_user_id,:status)
	end

	def show
		
	end
end
