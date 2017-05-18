class InvitationsController < ApplicationController
	layout "mindcom"
	before_filter :login_required
	
	def index
		@events=[]
		mg_school_id=session[:current_user_school_id]
		# @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck( :title, :id)
		@event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name, :id )
		params[:mg_event_id]=params[:mg_event_id]
			if params[:mg_event_id].present?
				events=MgEvent.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :id=>params[:mg_event_id])
				params[:mg_event_committee_id]=events.mg_event_committee_id
				@events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>events.mg_event_committee_id).pluck(:title, :id)
		end

	end

	def new
		mg_school_id=session[:current_user_school_id]
		@mg_event_id=params[:mg_event_id]
        @department_list=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
		@course_list=MgCourse.where(:is_deleted=>0, :mg_school_id=>mg_school_id)

		@department_list_checked=MgInvitation.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_event_id=>@mg_event_id,:employee=>1).pluck(:mg_employee_department_id)
	  	@batch_std_checked=MgInvitation.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_event_id=>@mg_event_id,:student=>1).pluck(:mg_batch_id)
	  	@batch_gnd_list_checked=MgInvitation.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_event_id=>@mg_event_id,:guardian=>1).pluck(:mg_batch_id)
		@department_list_tech_checked=MgInvitation.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_event_id=>@mg_event_id,:teacher=>1).pluck(:mg_employee_department_id)
		render :layout => false
	end

	def create
		puts params.inspect
		# puts dhfashfyhasgh
		mg_school_id=session[:current_user_school_id]
		created_by=session[:user_id]
		guardian_arr=params[:guardian_mg_batch_id]
		student_arr=params[:student_mg_batch_id]
		employee_arr=params[:mg_employee_department_id]

		   begin
		     MgInvitation.transaction do
			
				
				# @albums=MgAlbum.new(albums_params)

					var=MgInvitation.where(:mg_school_id=>mg_school_id, :mg_event_id=>params[:invitation][:mg_event_id])
					if var.present?
						var.each do |delete|
							delete.update(:is_deleted=>1, :updated_by=>created_by)
						end
					end
				  	if params[:invitation][:employee]=='1'
				  		if params[:mg_employee_department_id].present?
			  				puts params[:mg_employee_department_id].inspect
			  				for i in 0...params[:mg_employee_department_id].size
			  					present_date=MgInvitation.find_by(:mg_school_id=>mg_school_id, :mg_event_id=>params[:invitation][:mg_event_id], :mg_employee_department_id=>params[:mg_employee_department_id][i], :employee=>1)
			  					if present_date.present?
			  						present_date.update(:is_deleted=>0, :employee=>1)
			  					else
		  							event=MgInvitation.new(:mg_event_id=>params[:invitation][:mg_event_id],:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>params[:mg_employee_department_id][i], :employee=>1, :created_by=>created_by, :updated_by=>created_by)
		  							event.save

		  						end

			  				end
				  		end
				  	end

				  	if params[:invitation][:teacher]=='1'
				  		if params[:tech_mg_employee_department_id].present?
			  				puts params[:tech_mg_employee_department_id].inspect
			  				for i in 0...params[:tech_mg_employee_department_id].size
			  					present_date=MgInvitation.find_by(:mg_school_id=>mg_school_id, :mg_event_id=>params[:invitation][:mg_event_id], :mg_employee_department_id=>params[:tech_mg_employee_department_id][i], :teacher=>1)
			  					if present_date.present?
			  						present_date.update(:is_deleted=>0, :teacher=>1)
			  					else
		  							event=MgInvitation.new(:mg_event_id=>params[:invitation][:mg_event_id],:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>params[:tech_mg_employee_department_id][i], :teacher=>1, :created_by=>created_by, :updated_by=>created_by)
		  							event.save

		  						end

			  				end
				  		end
				  	end

				  	if params[:invitation][:student]=='1'
				  		if params[:student_mg_batch_id].present?
				  			puts params[:student_mg_batch_id].inspect
				  			for i in 0...params[:student_mg_batch_id].size
				  				present_date=MgInvitation.find_by(:mg_school_id=>mg_school_id, :mg_event_id=>params[:invitation][:mg_event_id], :mg_batch_id=>params[:student_mg_batch_id][i], :student=>1	)
			  					if present_date.present?
			  						present_date.update(:is_deleted=>0, :updated_by=>created_by)
			  					else
			  						event=MgInvitation.new(:mg_event_id=>params[:invitation][:mg_event_id],:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>params[:student_mg_batch_id][i], :student=>1, :created_by=>created_by, :updated_by=>created_by)
			  						event.save
			  					end
			  				end
				  		end
				  	end

				  	if params[:invitation][:guardian]=='1'
				  		if params[:guardian_mg_batch_id].present?
				  				puts params[:guardian_mg_batch_id].inspect
				  				for i in 0...params[:guardian_mg_batch_id].size
					  				present_date=MgInvitation.find_by(:mg_school_id=>mg_school_id, :mg_event_id=>params[:invitation][:mg_event_id], :mg_batch_id=>params[:guardian_mg_batch_id][i], :guardian=>1)
				  					if present_date.present?
				  						present_date.update(:is_deleted=>0, :updated_by=>created_by)
				  					else
				  						event=MgInvitation.new(:mg_event_id=>params[:invitation][:mg_event_id],:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>params[:guardian_mg_batch_id][i], :guardian=>1, :created_by=>created_by, :updated_by=>created_by)
				  						event.save
				  					end
			  					end
				  		end
				  	end

			@notice=email_and_notification(params[:guardian_mg_batch_id],params[:student_mg_batch_id],params[:mg_employee_department_id],params[:tech_mg_employee_department_id],params[:invitation][:mg_event_id])

			  	flash[:notice]='Invitation send successfully'+", "+@notice.to_s
			     # redirect_to :action => "index"#, :id=>@albums.id
			end
		  rescue Exception => e
			puts e
			
			 flash[:error]="Error occured, please contact administrator"
			# render 'new'
			 
		  end
		redirect_to :action => "index", :params=>{:mg_event_id=>params[:invitation][:mg_event_id]}
	end

	def email_and_notification(guardian_mg_batch_id,student_mg_batch_id, mg_employee_department_id,tech_mg_employee_department_id, mg_event_id)
		mg_school_id=session[:current_user_school_id]
		all_users=[]

		if mg_employee_department_id.present?
			employee=MgEmployee.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>mg_employee_department_id, :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Non Teaching Staff").id)).pluck(:mg_user_id)
			all_users +=employee
		end

		if tech_mg_employee_department_id.present?
			employee=MgEmployee.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>mg_employee_department_id, :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Teaching Staff").id)).pluck(:mg_user_id)
			all_users +=employee
		end
		if student_mg_batch_id.present?
			student=MgStudent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>student_mg_batch_id).pluck(:mg_user_id)		
			all_users +=student
		end
		if guardian_mg_batch_id.present?
			student_gnd=MgStudent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>guardian_mg_batch_id).pluck(:id)
			guardian_ids=MgStudentGuardian.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_student_id=>student_gnd, :has_login_access=>1).pluck(:mg_guardians_id)
			guardian=MgGuardian.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>guardian_ids).pluck(:mg_user_id)
			all_users +=guardian
		end

		msg=''
		event_suject=''
		school=MgSchool.find_by(:id=>mg_school_id)
		event=MgEvent.find_by(:id=>mg_event_id)
		if event.present?
		 	event_suject=event.try(:title)


		 	msg="Dear Sir/Madam \n\n\n"
			msg +="Event information\n\n"
			msg +="\t #{event.title}  event is created from "
			msg +="#{event.event_date.strftime(school.date_format)} #{event.start_time.strftime('%I:%M%p')}"
			msg +=" to #{event.end_date.strftime(school.date_format)}  #{event.start_time.strftime('%I:%M%p')} \n\n"
			# @event_msg +=" \n"
			msg +="\t#{event.event_description} \n\n\n"
			# @event_msg +=" for Event Committee Members \n\n\n\ "
			msg +="Thanks & Regards \n #{school.school_name}"
			# msg=@event_msg="Dear Sir/Madam \n #{event.event_description.to_s} \n\n\n  Thanks & Regards \n #{school.school_name}"
		end
		@notice=''
		if all_users.present?
			all_users.each do |user|
				@notice=send_email(user,msg,event_suject)
			end
		end

		return @notice
	end



	def send_email(user, event_msg, event_suject)
			begin
			@email_from = MgEmail.where(:mg_user_id => session[:user_id])
			@message = Message.new
			@message.subject =  event_suject.to_s
			@message.description =event_msg

						# all_user.each do |user|
					    	@email_to = MgEmail.where(:mg_user_id => user)

				            	if @email_to.present?
						            @message.to_user_id = @email_to[0][:mg_email_id ]
					    		    @message.from_user_id = @email_from[0][:mg_email_id ]
									
									db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
																	:to_user_id => user.to_i,
																	:subject => @message.subject,
																	:description => @message.description,
																	:is_deleted => 0,
																	:from_user_id =>session[:user_id],
																	:status => 0)
							                        server_response = NotificationMailer.send_mail(@message).deliver!
				            		@event_mail = MgMailStatus.create(:status_code => server_response.status,
				                                            :email_addrs_to => @message.to_user_id,
				                                            # current school Id will come here
			                        						:mg_school_id => session[:current_user_school_id] ,
				                                            :email_addrs_by => @message.from_user_id,
				                                            :email_subject => 'test',
				                                           :email_server_description => server_description(server_response.status) )
					            else
					            	puts "Email id is not present"
					            end

						# end
						return @notice="Mail Sent Successfully"
			 		rescue Net::SMTPFatalError => e
				      return @notice= 'Email-Id is not valid.'
				    rescue ArgumentError=>e
				      return @notice='Email to address is not present.'
				    rescue Exception=>e
				     return  @notice='Error while sending email,Please contact admin.'
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


end
