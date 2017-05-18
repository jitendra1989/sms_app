class EventsController < ApplicationController
	layout "mindcom"
	before_filter :login_required
	require 'json'

        def new 
			@events=MgEvent.new()
			params.permit(:currentDate)
			@date=params[:currentDate]
			@school=MgSchool.find(session[:current_user_school_id])
			@MgEventPrivacy
			render :layout => false
			
		end
	
		def index
	
		  	# @events = MgEvent.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
	 		# render :layout => false


		end

		def  send_mail_to_member(event_committee, event_msg)
					event_committee.each do |user_find|
						if !user_find.mg_employee_id.present?

							user_id=MgStudent.find_by(:id=>user_find.mg_student_id)
							if user_id.present?
								send_email(user_id.mg_user_id, event_msg)

							end
						else
							user_id=MgEmployee.find_by(:id=>user_find.mg_employee_id)
							if user_id.present?
								@notice=send_email(user_id.mg_user_id, event_msg)
							end
						end
					end

			return @notice
		end

		def send_email(user, event_msg)
		 begin
			@email_from = MgEmail.where(:mg_user_id => session[:user_id])
			@message = Message.new
			@message.subject =  params[:events][:title]
			@message.description =event_msg
		    @email_to = MgEmail.where(:mg_user_id => user)

					            	if @email_to.present?
						            	puts "Start Step >--------------------------------------------------------->  1 	"
						            	puts params[:events][:title].inspect
						            	puts "End Step >--------------------------------------------------------->  2 	"

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
					                                           :email_server_description => server_description(server_response.status) )

										puts " Ste p >-------------------------> status"
										puts @email_to[0][:mg_email_id ]
										puts " Ste p >-------------------------> status"
						            else
						            	puts "Email id is not present"
						            end
				return @notice="Mail Sent Successfully."
				
			rescue Net::SMTPFatalError => e
		      puts "inside Exception in principal"
		      puts e
		      return @notice="Email Id is not valid."
		    rescue ArgumentError => e
		      puts "inside Exception in principal"
		      puts e
		     return @notice="Email to address is not present."
		    rescue Exception => e
		    	puts e
		      puts "inside Exception in principal"
		     return @notice="Error while sending email,Please contact admin."
			end
			

		end

		def create
			@event_msg=''
			begin

			# MgEvent.transaction do
			
			mg_school_id=session[:current_user_school_id]
			objArray=params[:event_privacy]
			puts params[:mg_event_committee_id]
			@timeformat = MgSchool.find(mg_school_id)
			#here start send email to event_committee
			
			#here end send email to event_committee
			@events=MgEvent.new(events_params)
				  	start_date=Date.strptime(params[:events][:event_date],@timeformat.date_format)
				  	end_date=Date.strptime(params[:events][:end_date],@timeformat.date_format)
				  	@events.event_date = start_date.to_s
				  	@events.end_date= end_date.to_s 
				  	# @events.event_privacy=objArray[i]
				  	@events.save

			@event_msg="Dear Member \n"
			@event_msg +="Event information\n\n"
			@event_msg +="\t #{params[:events][:titles]}  event is created from"
			@event_msg +="#{params[:events][:event_date]} #{params[:events][:start_time]} to #{params[:events][:end_date]}  #{params[:events][:start_time]} \n\n"
			# @event_msg +=" \n"
			@event_msg +="\t#{params[:events][:event_description]} \n\n\n"
			# @event_msg +=" for Event Committee Members \n\n\n\ "
			@event_msg +="Thanks & Regards \n #{@timeformat.school_name}"
		

		 	event_committee=MgCommitteeMember.where(:mg_event_committee_id=>params[:events][:mg_event_committee_id], :mg_school_id=>mg_school_id,:is_deleted=>0)
			@notice= send_mail_to_member(event_committee, @event_msg)
			flash[:notice]="Event created successfully" +" "+@notice.to_s
			rescue Net::SMTPFatalError => e
		      puts "inside Exception in principal"
		      puts e
		      flash.now[:notice]="Email Id is not valid."
		      flash.keep(:notice)
		    rescue ArgumentError => e
		    	puts e
		      puts "inside Exception in principal"
		      flash.now[:notice]="Email to address is not present."
		      flash.keep(:notice)
		    rescue Exception => e
		    	puts e
		      puts "inside Exception in principal"
		      flash.now[:notice]="Error while sending email,Please contact admin."
		      flash.keep(:notice)
			end
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
		def show
		  	@events = MgEvent.find(params[:id])
		  	render :layout => false
		  	
		end

	  	def edit
	 	@events = MgEvent.find(params[:id])
	 	@school=MgSchool.find(session[:current_user_school_id])
	 	render :layout => false

		end

		def edit_event
			@events = MgEvent.find(params[:id])
	 	render :layout => false
		end
		def update_event
					  puts "Step -- 1 for update"	

		    @events = MgEvent.find(params[:id])
		 
		  if @events.update(events_params)
		    # redirect_to '/events/index'
			    redirect_to :back
			    

				else
				    render 'edit'
		  end
		end

		def user_type_event(user_typ)

			case user_typ.to_s

          		when 'Teacher'
              		return "employee"
              	when 'Guardian'
              		return "parent"
              	when 'Student'
              		return "student"

              	when 'teacher'
              		return "employee"
              	when 'guardian'
              		return "parent"
              	when 'student'
              		return "student"
              	
            end	
			
		end

		def update
		@event_msg=''
		  puts "Step -- 1 for update   by Me"	
		  puts params[:event_privacy].inspect
		  objArray=params[:event_privacy]
		  mg_school_id=session[:current_user_school_id]
		  @timeformat = MgSchool.find(mg_school_id)

	 	begin
		  @events = MgEvent.find(params[:id])
		  @events.update(events_params)
	  			start_date=Date.strptime(params[:events][:event_date],@timeformat.date_format)
		  		end_date=Date.strptime(params[:events][:end_date],@timeformat.date_format)
		  		@events.event_date = start_date.to_s
		  		@events.end_date= end_date.to_s 
		  		@events.save


		  	@event_msg="Dear Member \n"
			@event_msg +="Event information\n\n"
			@event_msg +="\t #{params[:events][:titles]}  event is created from"
			@event_msg +="#{params[:events][:event_date]} #{params[:events][:start_time]} to #{params[:events][:end_date]}  #{params[:events][:start_time]} \n\n"
			# @event_msg +=" \n"
			@event_msg +="\t#{params[:events][:event_description]} \n\n\n"
			# @event_msg +=" for Event Committee Members \n\n\n\ "
			@event_msg +="Thanks & Regards \n #{@timeformat.school_name}"
			

			# @event_msg="Dear Sir/Madam \n #{params[:events][:event_description]} \n\n\n Thanks & Regards \n #{@timeformat.school_name}"
						
				
	        event_committee=MgCommitteeMember.where(:mg_event_committee_id=>params[:events][:mg_event_committee_id], :mg_school_id=>mg_school_id,:is_deleted=>0)
			@notice = send_mail_to_member(event_committee, @event_msg)
	       flash[:notice]="Event updated successfully" +" "+@notice.to_s
       	rescue Exception => e
	    	puts e
	      	puts "inside Exception in principal"
	      	flash.now[:notice]="Error while sending email,Please contact admin."
	      	flash.keep(:notice)
		end
			redirect_to :back
		end

		def destroy

		end

		# 
		 		    	

		def delete
			begin
			mg_school_id=session[:current_user_school_id]
			@event_msg=''
			@events=MgEvent.find(params[:id])
			@events.is_deleted =1
			@events.save
			all_users=[]
			@timeformat=MgSchool.find_by(:id=>mg_school_id)
			 @events.mg_guests.update_all(:is_deleted=>1)
			 @events.mg_albums.update_all(:is_deleted=>1)

			# Foo.update_all(:new_column => "bar")

			# event_privacy_val = @events.event_privacy
			# puts "event_deleted"
			# puts event_privacy_val.inspect
			# privacy_object=MgEventPrivacy.where(:is_deleted=>0, :mg_event_id=>@events.id, :mg_school_id=>session[:current_user_school_id])
			privacy_object=MgInvitation.where(:is_deleted=>0,:mg_school_id=>mg_school_id,:mg_event_id=>params[:id])
			mg_employee_department_id=privacy_object.where("teacher= 1 or employee=1").pluck(:mg_employee_department_id)
			mg_batch_id_gnd=privacy_object.where("guardian=1").pluck(:mg_batch_id)
			mg_batch_id_std=privacy_object.where("student= 1 ").pluck(:mg_batch_id)
			if mg_employee_department_id.present?
			employee_user_id=MgEmployee.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>mg_employee_department_id).pluck(:mg_user_id)
			all_users +=employee_user_id
			end
			if mg_batch_id_std.present?
			student_user_id=MgStudent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>mg_batch_id_std)
			all_users +=student_user_id
			end

			if mg_batch_id_gnd.present?
			student_gnd=MgStudent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>mg_batch_id_gnd).pluck(:id)
			guardian_ids=MgStudentGuardian.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_student_id=>student_gnd, :has_login_access=>1).pluck(:mg_guardians_id)
			guardian=MgGuardian.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>guardian_ids).pluck(:mg_user_id)
			all_users +=guardian
			end

			@message = "Dear Sir/Madam \n #{@events.event_description }  has been canceled.\n\n\n Thanks & Regards \n #{@timeformat.school_name}"
		   # @event_msg= "Dear Sir/Madam \n #{@events.event_description }  has been canceled.\n\n\n Thanks & Regards \n #{@timeformat.school_name}"
			

			if all_users.present?
					# privacy_object.each do |delete|
					# 	delete.is_deleted=1
					# 	delete.save
					# end

					@notice=''
					if all_users.present?
						all_users.each do |user|
							@notice=send_email(user,@message,"Event cancel")
						end
					end
			end
			event_committee=MgCommitteeMember.where(:mg_event_committee_id=>@events.mg_event_committee_id, :mg_school_id=>mg_school_id,:is_deleted=>0)
			@notice=send_mail_to_member(event_committee, @event_msg)

		    # notification delete
			rescue Net::SMTPFatalError => e
			  puts e
		      puts "inside Exception in principal"
		      flash.now[:notice]="Email Id is not valid"
		      flash.keep(:notice)
		    rescue ArgumentError => e
		      puts e
		      puts "inside Exception in principal"
		      flash.now[:notice]="Email to address is not present."
		      flash.keep(:notice)
		    rescue Exception => e
		      puts e
		      puts "inside Exception in principal"
		      flash.now[:notice]="Error while sending email,Please contact admin."
		      flash.keep(:notice)
			end
		  	# redirect_to events_path
			redirect_to :action => "index"

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

		def admin_calender
			mg_school_id=session[:current_user_school_id]
			@school=MgSchool.find_by(:id=>mg_school_id)
			qry=" is_deleted=0 "
			if params[:date_for_sort].present?
				start_date=Date.strptime(params[:date_for_sort],@school.date_format)
				qry +=" and event_date <= '#{start_date}' and  end_date >= '#{start_date}' "
				if params[:mg_committee_id].present?
					qry +=" and mg_event_committee_id ='#{params[:mg_committee_id]}' "
				end
			else
				if params[:mg_committee_id].present?
					qry +=" and mg_event_committee_id ='#{params[:mg_committee_id]}' "
				end
			end
			@event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name,:id )
			@events = MgEvent.where( :mg_school_id=>session[:current_user_school_id]).where(qry).paginate(page: params[:page], per_page: 10)

		end

		def testing

			# @events = MgEvent.find(params[:id])
   #  		# @event_type = @events.mg_event_types.create(event_types_params)
   #  		puts "testing step 1---"
   #  		# puts @event_type.inspect
   #  		puts "testing step 2---"

				
		end

		def allevents
			 if request.xhr?
			 		@events = MgEvent.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id])
			 		sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',
			 		CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color', a.event_description 'description', a.id from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
			 		@abc=MgEvent.find_by_sql sql
			 		objArray = @abc.as_json

			 		# abc= [{ title: 'jlsgdaj', start: '2015-01-13T20:00:00', end: '2015-01-14T24:00:00',color: 'yellow',textColor: 'black'},
			 		# 	{ title: 'sruai', start: '2014-12-31', end: '2014-12-31', color: 'green',textColor: 'black'},
			 		# 	{ title: 'isudfh', start: '2014-12-31', end: '2014-12-31', color: 'yellow',extColor: 'black'},
			 		# 	{ title: 'morning', start: '2015-01-01', end: '2015-01-01', color: 'green',textColor: 'black'}]


           			render :json=> objArray

    		end
				
		end

		# def delete
		# 	 @events=MgEvent.find_by_id(params[:id])

		# 	@events.is_deleted =1
		# 	@events.save

		#   redirect_to subjects_path
			
		# end

  private
  def events_params
    params.require(:events).permit(:mg_event_committee_id, :end_date,:title, :mg_event_type_id, :event_privacy, :event_description,  :start_time, :end_time, :all_day, :editable, :is_deleted, :event_date, :mg_school_id,  :created_by, :updated_by)
  end
  def event_types_params
    params.require(:event_types).permit(:name, :event_color, :is_deleted, :mg_school_id, :created_by, :updated_by)

  	
  end
  def event_privecy
    params.require(:events).permit(:mg_event_id,:privacy, :is_deleted,  :mg_school_id,  :created_by, :updated_by)

  end
end
