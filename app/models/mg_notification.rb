class MgNotification < ActiveRecord::Base
	belongs_to :mg_school

		def self.send_notification(from_user_id,to_user_id,subject,description,school_id,is_deleted,created_by,updated_by)
		notification=MgNotification.new(:from_user_id=>from_user_id,:to_user_id=>to_user_id,
						   :subject=>subject,:description=>description,:status=>false,
						   :mg_school_id=>school_id,:is_deleted=>is_deleted,
						   :created_by=>created_by,:updated_by=>updated_by)
		
	end

	def self.send_email(from_email_id,to_email_id,subject,description,school_id)
		message = Message.new
        message.subject =  subject
        message.description = description
        message.to_user_id = to_email_id
        message.from_user_id = from_email_id
        server_response = NotificationMailer.send_mail(message).deliver!
        event_mail = MgMailStatus.new(:status_code => server_response.status,
                                          :email_addrs_to => to_email_id,
                                          :mg_school_id => school_id,
                                          :email_addrs_by => from_email_id,
                                          :email_subject => subject,
                                          :email_server_description => server_description(server_response.status) 
                                          )
		
	end

	def self.server_description(code_s)
    
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
