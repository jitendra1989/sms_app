class TransportsController < ApplicationController
before_filter :login_required
    layout "mindcom"

  def index
    
    @transport_data=MgTransport.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).all.paginate(page: params[:page], per_page: 10)
    #@transport_vehicle_data=MgVehicle.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).all.paginate(page: params[:page], per_page: 10)
  end

  def create
    
   drop_start_time_hour=params[:drop_start_time]["game_time(4i)"]
   drop_start_time_hour_min=params[:drop_start_time]["game_time(5i)"]
  
   start_time=drop_start_time_hour+":"+drop_start_time_hour_min+":00";
   @data=MgTransport.new(transport_params)
    @data.drop_start_time=start_time
    @data.mg_employee_id=params[:employee][:mg_employee_id]
    @data.mg_employee_position_id=params[:employee][:mg_employee_position_id]
 
 
    @data.save
    vehicle_data=MgVehicle.find(params[:vehicle_route][:mg_vehicle_id])
    vehicle_data.mg_transport_id=@data.id
    vehicle_data.mg_employee_id=params[:employee][:mg_employee_id]
    vehicle_data.drop_start_time=start_time
    vehicle_data.mg_employee_position_id=params[:employee][:mg_employee_position_id]
    vehicle_data.mg_employee_category_id=@data.mg_employee_category_id
    vehicle_data.save
   redirect_to :action=>'index'
  end

  def new
   
    @school_id=session[:current_user_school_id]
    @add_report_index=MgVehicle.where("is_deleted=? AND mg_school_id=? AND mg_transport_id IS NULL",0,@school_id).pluck(:vehicle_number,:id)

  end

  def validation_params_transport
vehicle_data=MgVehicle.where(:mg_employee_id=>params[:emp_id],:drop_start_time=>params[:time],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
if vehicle_data.length>0
   render :json => {:name => "validates"}
 end
  end

  def employee_list
    @sql = "Select id,first_name from mg_employees where mg_employee_position_id = #{params[:emp_profile_id]} and is_deleted = '0' and mg_school_id = #{session[:current_user_school_id]} "
      @positionList = MgEmployee.find_by_sql(@sql)

      respond_to do |format|
        format.json  { render :json => @positionList }
  end

  end

  def edit
    @vehicle_route=MgTransport.find(params[:id])
      @employee = MgEmployee.find(@vehicle_route.mg_employee_id)

    @school_id=session[:current_user_school_id]

    @add_report_index=MgVehicle.where(:is_deleted=>0,:mg_school_id=>@school_id).pluck(:vehicle_number,:id)

  render :layout=>false

  end

  def show
  @transport_data=MgTransport.find(params[:id])
  render :layout=>false
  end

  def update_data
    @vehicle_route=MgTransport.find(params[:id])
     
     @vehicle_route.update(edit_transport_params)
      
    


    redirect_to :action=>'index'
  end

  def destroy
    @vehicle_route=MgTransport.find(params[:id])
    @vehicle_route.is_deleted =1

    data=MgVehicle.where(:mg_transport_id=>@vehicle_route.id)
    data.each do|value|
      vehicle_data=MgVehicle.find(value.id)
      vehicle_data.mg_employee_id=nil
      vehicle_data.mg_employee_position_id=nil
      vehicle_data.mg_employee_category_id=nil
      vehicle_data.mg_transport_id=nil
      vehicle_data.drop_start_time=nil
      vehicle_data.save
    end

      @vehicle_route.save

      redirect_to :action=>'index'
  end


  def transport_time_management_index
    @all_transport_time_management_data=MgTransportTimeManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).all.paginate(page: params[:page], per_page: 10)
  end

  def transport_time_management_new
    @school_id=session[:current_user_school_id]
  end

  def transport_time_management_create

    transport_time_details=MgTransportTimeManagement.new(transport_time_params)
    pick_up_start_time_hour=params[:pick_up_time]["game_time(4i)"]
     pick_up_start_time_hour_min=params[:pick_up_time]["game_time(5i)"]
     start_up_time=pick_up_start_time_hour+":"+pick_up_start_time_hour_min+":00";
      drop_time_hour=params[:drop_time]["game_time(4i)"]
     drop_time_hour_min=params[:drop_time]["game_time(5i)"]
     drop_time=drop_time_hour+":"+drop_time_hour_min+":00";

     transport_time_details.pick_up_time=start_up_time
     transport_time_details.drop_time=drop_time
     transport_time_details.created_by=session[:user_id]
     transport_time_details.save

     redirect_to :action=>'transport_time_management_index'

    
  end
  def transport_time_management_show
  @show_transport_time_management=MgTransportTimeManagement.find(params[:id])
  render :layout=>false
  end
  def transport_time_management_edit
    @school_id=session[:current_user_school_id]

  @transport_time=MgTransportTimeManagement.find(params[:id])
  render :layout=>false
  end
  def transport_time_management_update
    @transport_time_update=MgTransportTimeManagement.find(params[:id])
    
    if @transport_time_update.update(edit_transport_time_params)
    pick_up_time_hour=params[:transport_time]["pick_up_time(4i)"]
    pick_up_time_hour_min=params[:transport_time]["pick_up_time(5i)"]
    start_time=pick_up_time_hour+":"+pick_up_time_hour_min+":00";
    drop_time_hour=params[:transport_time]["drop_time(4i)"]
    drop_time_hour_min=params[:transport_time]["drop_time(5i)"]
    drop_time=drop_time_hour+":"+drop_time_hour_min+":00";

     @transport_time_update.update(:pick_up_time=>start_time,:drop_time=>drop_time)

  end
  redirect_to :action=>'transport_time_management_index'
  end
  def transport_time_management_destroy
     @transport_time_destroy=MgTransportTimeManagement.find(params[:id])
    @transport_time_destroy.is_deleted =1

      @transport_time_destroy.save

     redirect_to :action=>'transport_time_management_index'
  end
def confirmation_request

end
def confirmation_request_new
  mg_transport_data=MgTransport.find(params[:id])
  @mg_vehicle_data=MgVehicle.where(:mg_transport_id=>mg_transport_data.id).pluck(:vehicle_number,:id)

  # @mg_vehicle_data=MgVehicle.find(mg_transport_data.mg_vehicle_id)
  # @transport_confirmation_data=MgGuardianTransportRequisition.where(:mg_transport_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  # @transport_confirmation_total=MgGuardianTransportRequisition.where(:mg_transport_id=>params[:id],:confirmation_status=>"confirmed",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  # @total_data=@transport_confirmation_total.length
  render :layout=>false

end
def confirmation_vehicle_request_new
  @mg_vehicle_data=MgVehicle.find(params[:id])
  @transport_confirmation_data=MgGuardianTransportRequisition.where(:mg_vehicle_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @transport_confirmation_total=MgGuardianTransportRequisition.where(:mg_vehicle_id=>params[:id],:confirmation_status=>"confirmed",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @total_data=@transport_confirmation_total.length
  render :layout=>false
  
  end

def confirmation_request_create

  if params[:data]=="cancel"
@data=MgGuardianTransportRequisition.find(params[:id])
@data.confirmation_status="Pending"
student_id=MgStudent.find(@data.mg_student_id)
     
    user_id=MgUser.find_by(:id=>student_id.mg_user_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      
    
  @email_from = MgEmail.where(:mg_user_id => session[:user_id])
     
      
      begin
              # notification work start
             
            @message = Message.new
              @email_from = MgEmail.where(:mg_user_id => session[:user_id])
              puts @email_from
            @message.subject =  "Message From Transportation"
              @message.description = "Dear Student\n your seat is alloted is Cancelled Thanks & Regards"
           
                #Thread.new do
                     
                        @email_to = MgEmail.where(:mg_user_id => student_id.mg_user_id)

                        puts @email_to

                          puts "Start Step >--------------------------------------------------------->  1   "
                          #puts params[:events][:title].inspect
                          puts session[:user_id]
                          puts "End Step >--------------------------------------------------------->  2   "

                          @message.to_user_id = @email_to[0][:mg_email_id ]
                          puts @email_to[0][:mg_email_id ]
                        @message.from_user_id = @email_from[0][:mg_email_id ]
                        puts @email_from[0][:mg_email_id ]
                    server_response = NotificationMailer.send_mail(@message).deliver!
                    puts server_response
                    db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                                    :to_user_id => student_id.mg_user_id,
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
                     # puts @email_to[0][:mg_email_id ]
                    puts " Ste p >-------------------------> status"
                        
                      
                  #end
              
                #flash.now[:notice]="Mail Sent Successfully."
              # notification work end
            rescue Net::SMTPFatalError => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Email Id is not valid."
              #flash.keep(:notice)
            rescue ArgumentError => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Email to address is not present."
              #flash.keep(:notice)
            rescue Exception => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Error while sending email,Please contact admin."
              #flash.keep(:notice)
            end
@data.save

  else
@data=MgGuardianTransportRequisition.find(params[:id])
@data.confirmation_status="confirmed"

      student_id=MgStudent.find(@data.mg_student_id)
     
    user_id=MgUser.find_by(:id=>student_id.mg_user_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      
    
  @email_from = MgEmail.where(:mg_user_id => session[:user_id])
     
      
      begin
              # notification work start
             
            @message = Message.new
              @email_from = MgEmail.where(:mg_user_id => session[:user_id])
              puts @email_from
            @message.subject =  "Confirmation Message For Transport Request"
              @message.description = "Dear Student\n your seat is alloted Thanks & Regards"
           
                #Thread.new do
                     
                        @email_to = MgEmail.where(:mg_user_id => student_id.mg_user_id)

                        puts @email_to

                          puts "Start Step >--------------------------------------------------------->  1   "
                          #puts params[:events][:title].inspect
                          puts session[:user_id]
                          puts "End Step >--------------------------------------------------------->  2   "

                          @message.to_user_id = @email_to[0][:mg_email_id ]
                          puts @email_to[0][:mg_email_id ]
                        @message.from_user_id = @email_from[0][:mg_email_id ]
                        puts @email_from[0][:mg_email_id ]
                    server_response = NotificationMailer.send_mail(@message).deliver!
                    puts server_response
                    db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                                    :to_user_id => student_id.mg_user_id,
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
                     # puts @email_to[0][:mg_email_id ]
                    puts " Ste p >-------------------------> status"
                        
                      
                  #end
              
                #flash.now[:notice]="Mail Sent Successfully."
              # notification work end
            rescue Net::SMTPFatalError => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Email Id is not valid."
              #flash.keep(:notice)
            rescue ArgumentError => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Email to address is not present."
              #flash.keep(:notice)
            rescue Exception => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Error while sending email,Please contact admin."
              #flash.keep(:notice)
            end
@data.save
end
redirect_to :action=>'confirmation_vehicle_request_new',:id=>@data.mg_vehicle_id 
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
  def list_vehicles
school_id=session[:current_user_school_id]
@data_id=params[:id]
@all_vehicle_data=MgVehicle.where(:is_deleted=>0,:mg_school_id=>school_id,:mg_transport_id=>params[:id]).all.paginate(page: params[:page], per_page: 10)
  #render :layout=>false

  end
def route_vehicle_selection
   @school_id=session[:current_user_school_id]
   @dat_id=params[:id]
   @data=MgTransport.find(params[:id])
    @add_report_index=MgVehicle.where("is_deleted =? AND mg_school_id=? AND mg_transport_id IS  NULL",0,@school_id).pluck(:vehicle_number,:id)

  #render :layout=>false

end
def route_vehicle_create
  #mg_vehicle_route=MgTransport.find(params[:id])
   drop_start_time_hour=params[:drop_start_time]["game_time(4i)"]
   drop_start_time_hour_min=params[:drop_start_time]["game_time(5i)"]
  
   start_time=drop_start_time_hour+":"+drop_start_time_hour_min+":00";
   @data=MgVehicle.find(params[:vehicles_routes][:mg_vehicle_id])
   @data.mg_transport_id=params[:id]
    @data.drop_start_time=start_time
    @data.mg_employee_id=params[:employee][:mg_employee_id]
    @data.mg_employee_position_id=params[:employee][:mg_employee_position_id]
    @data.mg_employee_category_id=params[:vehicles_routes][:mg_employee_category_id]

    #logger.infoazsdkh
    @data.save
   redirect_to :action=>'list_vehicles',:id=>@data.mg_transport_id
  end

  def vehicle_transport_show
    @vehicle_data=MgVehicle.find(params[:id])
    @transport_data=MgTransport.find(@vehicle_data.mg_transport_id)
  render :layout=>false

  end
  def vehicle_transport_edit
    @vehicle_data=MgVehicle.find(params[:id])
    @transport_data=MgTransport.find(@vehicle_data.mg_transport_id)

 @employee = MgEmployee.find(@vehicle_data.mg_employee_id)
 @school_id=session[:current_user_school_id]
  @add_report_index=MgVehicle.where("is_deleted=? AND mg_school_id=?",0,@school_id).pluck(:vehicle_number,:id)

  render :layout=>false

  end
  def vehicle_transport_update

    data=MgVehicle.find(params[:vid])
      data.mg_employee_category_id=params[:vehicle_data][:mg_employee_category_id]
      data.mg_employee_position_id=params[:vehicle_data][:mg_employee_position_id]
      data.mg_employee_id=params[:vehicle_data][:mg_employee_id]

   drop_start_time_hour=params[:vehicle_data]["drop_start_time(4i)"]
   drop_start_time_hour_min=params[:vehicle_data]["drop_start_time(5i)"]
   start_time=drop_start_time_hour+":"+drop_start_time_hour_min+":00";
   data.drop_start_time=start_time
   data.save
   redirect_to :action=>"list_vehicles" ,:id=>data.mg_transport_id
  end

  def vehicle_transport_destroy
    ids=params[:id]
    id=ids.split("-")
    data=MgVehicle.find(id[0])
    data.mg_employee_id=nil
    data.mg_transport_id=nil
    data.drop_start_time=nil
    data.mg_employee_position_id=nil
    data.mg_employee_category_id=nil
    data.save
   redirect_to :action=>"list_vehicles" ,:id=>id[1]

end
def student_status_data
  
  if params[:date_validation].present?
    @timeformat = MgSchool.find(session[:current_user_school_id])
     if @timeformat.present?
                @date_valid = Date.strptime(params[:date_validation],@timeformat.date_format)
              end
    @data=@date_valid

   @school_id=session[:current_user_school_id]
    @add_report_index=MgVehicle.where("is_deleted=? AND mg_school_id=?",0,@school_id)
  else
  @data=Date.today
   @school_id=session[:current_user_school_id]
    @add_report_index=MgVehicle.where("is_deleted=? AND mg_school_id=?",0,@school_id)
end
  end
  def transport_student_information
    vehicle_ids=params[:id]
        @vehicle_id=vehicle_ids.split("/")

    data=MgVehicle.find(@vehicle_id[0])
         
    @data=MgGuardianTransportRequisition.where(:mg_vehicle_id=>@vehicle_id[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id).uniq
    # pickup_data=MgGuardianTransportRequisition.where(:mg_vehicle_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_transport_time_management_id)
              #=MgTransportTimeManagement.where(:id=>pickup_data)
    @student_info_data=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>@data)
    #render :layout=>false
  end
  def transport_fee_category
   
  end
  def transport_fee_category_new
    @feesquery=MgBatch.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id, :mg_course_id)
  
   render :layout => false
  end
  def   transport_fee_category_create
    @selected_batches = params[:selected_batches]
    @feedetails=MgFeeCategory.new(subject_params)
    @feedetails.save
settings_data=MgSchool.find_by(:is_deleted=>0,:id=>session[:current_user_school_id])    #if settings_data.present?
      settings_data.mg_fee_category_id=@feedetails.id
      settings_data.save
    #end
                     @particularData=params[:particulars]
                     
                     for i in 0...@particularData.size
                      @saveParticular=MgParticularType.new()
                      @saveParticular.particular_name=@particularData[i]
                      @saveParticular.mg_fee_category_id=@feedetails.id
                      @saveParticular.is_deleted=0
                      @saveParticular.mg_school_id=session[:current_user_school_id]
                      @saveParticular.save
                     end
   
    redirect_to :action => "transport_fee_category"

  end
  def transport_fee_category_show
     @feeCategory = MgFeeCategory.find(params[:id])
    render :layout => false
  end
def transport_fee_category_edit
 @transport_fees = MgFeeCategory.find(params[:id])
    
    @mg_batch_list=MgBatch.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id]).pluck(:name,:id, :mg_course_id) 

    @mg_fee_category_batch_list=MgFeeCategoryBatches.where(:mg_fee_id=>params[:id]).pluck(:mg_batch_id,:id)
    @dueFine=MgParticularType.where(:mg_fee_category_id=>params[:id])
    

    render :layout => false 
end
def transport_fee_category_update
   @feeCategoryObj = MgFeeCategory.find(params[:id])
                 
          @updateparticulars=params[:particulars]
      @particulartypeId=params[:particularstype]
     
                
                
  for i in 0 ... @updateparticulars.size
  @particulartype=MgParticularType.find_by(:mg_fee_category_id=>params[:id],:id=>@particulartypeId[i])                

  if !(@particulartype.nil?)
  @particulartype.update(:particular_name=>@updateparticulars[i])
else
   @particular=MgParticularType.new()
   @particular.particular_name=@updateparticulars[i]
  # puts @updateparticulars[i].inspect
  @particular.mg_fee_category_id=params[:id]
   @particular.is_deleted=0
   @particular.mg_school_id=session[:current_user_school_id]
   puts @particular.inspect
  @particular.save
#logger.infosd
end


end



    
     if @feeCategoryObj.update(subject_params)
       redirect_to :action=>'transport_fee_category'
     else
       render 'transport_fee_category_edit'
     end
  end
  def delete_transport_fee_category
      @fees=MgFeeCategory.find_by_id(params[:id])
    @fees.is_deleted =1
    @fees.save
    @particularType=MgParticularType.where(:mg_fee_category_id=>params[:id])
    @particularType.each do |delete|
      delete.is_deleted=1
      delete.save
    end
    redirect_to :action=>'transport_fee_category'
  end

  def manage_transport_particulars

    if params[:id].nil? 
      @particular_list=MgFeeParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:fee_category=>session[:feedetails_id]).paginate(page: params[:page], per_page: 5)
    else
      @particular_list=MgFeeParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:fee_category=>params[:id]).paginate(page: params[:page], per_page: 5)
      @fee_category=MgFeeCategory.find(params[:id])
      session[:feedetails_id] = @fee_category.id
    end 
  end
  def manage_transport_particulars_new
    @transport_particular_data=MgFeeParticular.new()
    #render :layout => false
  end 
  def select_students
    guardian_data=MgGuardianTransportRequisition.where(:mg_transport_id=>params[:transport_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id).uniq
    @studentdata=MgStudent.where(:id=>guardian_data)
    @student_hash=Array.new
    @studentdata.each do |data|
      student_array=Array.new
       batch_data= MgBatch.find(data.mg_batch_id)
       course_data=MgCourse.find(batch_data.mg_course_id)
       student_array.push("#{data.first_name}(#{course_data.course_name})",data.id)
       @student_hash.push(student_array)

    end
    render :layout => false

  end
  def manage_transport_particulars_create
@selected_batches1 = params[:selected_batches1]



    @params=params[:transportSelectedStudents]

   

    #if params[:transport_particulars][:value1] == 'demo'  #using student admission number
      for i in 0...@params.size
       puts"inside if save particular"
       @feeParticularObj=MgFeeParticular.new(particular_params) 
       @data=MgStudent.find(@params[i])
       @batchID=@data.mg_batch_id
        @feeParticularObj.mg_batch_id=@batchID
        @feeParticularObj.admission_no= @data.admission_number
        puts params[:mg_account_id]
       # puts jhghgjh
     if params[:mg_account_id]=="central"
      @feeParticularObj.is_to_central=1
     else
      @feeParticularObj.mg_account_id=params[:mg_account_id]
     end 
      
       @feeParticularObj.save
     end

    redirect_to :action=>'manage_transport_particulars',:controller=>'transports',:id=>params[:id]
  end

   def manage_transport_particulars_edit
    @transport_particulars = MgFeeParticular.find(params[:id])
  #   @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  #    @info=Array.new
  #  @batches.each do |b|
  #  @info.push(b.id)
  # end
  @cceID=Array.new
  
    
     @cceID.push(@transport_particulars.mg_batch_id)




    logger.info @transport_particulars.inspect
    render :layout => false
   end

   def manage_transport_particulars_show
     @fee_particular = MgFeeParticular.find(params[:id])
    render :layout => false
   end

   def manage_transport_particulars_update
 @feeParticularObj = MgFeeParticular.find(params[:id])

    @feeParticularParams = update_particular_params
    @params=params[:selectedStudents]

    if(params[:transport_particulars][:value1]=='All')
    @feeParticularParams[:admission_no] = ''
    @feeParticularParams[:mg_student_category_id] =''
    end


    if(params[:transport_particulars][:value1]=='demo')
      

    @feeParticularParams[:admission_no] =  params[:transport_particulars][:admission_no] 
    @feeParticularParams[:mg_student_category_id] =''
    end

    if(params[:transport_particulars][:value1]=='demo2')         
     @feeParticularParams[:admission_no] = ''  
     @feeParticularParams[:mg_student_category_id] =params[:fesses2][:mg_student_category_id]
    end
         
    @feeParticularObj.update(@feeParticularParams)
    redirect_to :action=>'manage_transport_particulars',:id=>@feeParticularObj.fee_category
   end

   def manage_transport_particulars_destroy
 @fees=MgFeeParticular.find_by_id(params[:id])
    @fees.update(:is_deleted=>1)
    redirect_to :action=>'manage_transport_particulars',:id=>@fees.fee_category
   end

   def transport_fees_schedule_index
    settings_datas=MgSchool.find_by(:is_deleted=>0,:id=>session[:current_user_school_id])
    @fee_collection_list=MgFeeCollection.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id],:mg_fee_category_id=>settings_datas.mg_fee_category_id).paginate(page: params[:page], per_page: 5)

   end

   def transport_fees_schedule
    @booleanValue=false
    if request.xhr?

      ajaxParamFeeCategoryId=params[:feeCategoryIdParam] 

      if(ajaxParamFeeCategoryId=="feeCategoryIdParam")

        @batch_details=[]
        @feeCategoryBatchId=MgFeeParticular.select(:mg_batch_id).where(:fee_category => params[:feeCategoryId],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        puts @feeCategoryBatchId
        @batch_details = MgBatch.includes(:mg_course).where(:id=>@feeCategoryBatchId,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order("mg_course_id","name").pluck(:id, :name, :mg_course_id,:course_name)
        puts @batch_details
        logger.infolasdjf
        @booleanValue=true
        render :json => { :batch_details => @batch_details }
      end

    end # ends of request.xhr?

    if request.post?
        @selected_batch_id_array = params[:selected_batch]
        puts"post request in fee_schedule"
        puts @selected_batch_id_array.inspect

        school_id=session[:current_user_school_id]
        #batchIds=params[:fee_schedule][:batch_ids]

        @selected_batch_id_array .each do|batchId|
          
            #logger.info '@fee_particular_list'
            #logger.info @batch_fee_particular_list.inspect

            #creating collection for each batch start
            @mg_fee_collection=MgFeeCollection.new(:name=>params[:fee_schedule][:name], :mg_fee_category_id=>params[:fee_schedule][:fee_category_id], :mg_batch_id=>batchId, :mg_fine_id=>params[:fee_schedule][:fee_fine_id], :start_date=>params[:fee_schedule][:start_date], :end_date=>params[:fee_schedule][:end_date], :due_date=>params[:fee_schedule][:due_date], :is_deleted=>params[:fee_schedule][:is_deleted], :mg_school_id=> session[:current_user_school_id])
            
            if @mg_fee_collection.save
              @current_school_obj = MgSchool.find(school_id)
              @startDate = Date.strptime(params[:fee_schedule][:start_date],@current_school_obj.date_format)
              @endDate = Date.strptime(params[:fee_schedule][:end_date],@current_school_obj.date_format)
              @dueDate = Date.strptime(params[:fee_schedule][:due_date],@current_school_obj.date_format)
              @mg_fee_collection.update(:start_date => @startDate,:end_date => @endDate, :due_date => @dueDate)
            end
            #creating collection for each batch end


            #creating discount for each batch start            
            @batchFeeDiscounList=MgFeeDiscount.select(:discount_type, :name, :mg_receiver_id, :discount).where(:mg_batch_id => batchId,:is_deleted => 0, :mg_school_id=> session[:current_user_school_id])#, :discount_type=>"Section")
            # logger.info '@mgFeeDiscounList'
            # logger.info @mgFeeDiscounList.inspect

             for k in 0 ... @batchFeeDiscounList.size
              puts"@mgFeeDiscounList.size"
              discountType= @batchFeeDiscounList[k].discount_type
              discountName= @batchFeeDiscounList[k].name
              receiverId= @batchFeeDiscounList[k].mg_receiver_id
              discount= @batchFeeDiscounList[k].discount

              @mg_fee_collection_discount=@mg_fee_collection.mg_fee_collection_discounts.build(:mg_discount_type =>discountType ,:mg_discount_name => discountName,:mg_discount_receiver_id => receiverId, :mg_discount => discount ,:is_percent => 0, :is_deleted=> params[:fee_schedule][:is_deleted], :mg_school_id=> session[:current_user_school_id] )
              @mg_fee_collection.save
              
            end
            #creating discount for each batch start            


            #creating particular for each student start
            @batch_student_list=MgStudent.select(:id, :admission_number, :mg_student_catagory_id).where(:mg_batch_id => batchId)
            
            @batch_fee_particular_list=MgFeeParticular.select(:mg_particular_type_id, :description, :amount, :mg_batch_id,:mg_student_category_id).where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id],:fee_category=>params[:fee_schedule][:fee_category_id],:mg_batch_id=>batchId,:admission_no=>nil,:mg_student_category_id => nil)
            for i in 0 ... @batch_student_list.size
              puts"@batch_student_list.size"

              studentId= @batch_student_list[i].id
              studentAdmissionNumber= @batch_student_list[i].admission_number
              studentCategoryId= @batch_student_list[i].mg_student_catagory_id

              @mg_finance_fees=@mg_fee_collection.mg_finance_fees.build(:student_id=>studentId, :is_paid=>0, :is_deleted=> params[:fee_schedule][:is_deleted], :mg_school_id=> session[:current_user_school_id])

              @mg_finance_fees.save

                @student_fee_particular_list=MgFeeParticular.select(:mg_particular_type_id, :description, :amount, :mg_batch_id,:mg_student_category_id).
           where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id],:fee_category=>params[:fee_schedule][:fee_category_id],:admission_no => studentAdmissionNumber)

                @category_fee_particular_list=MgFeeParticular.select(:mg_particular_type_id, :description, :amount, :mg_batch_id,:mg_student_category_id).
           where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id],:fee_category=>params[:fee_schedule][:fee_category_id],:mg_batch_id=>batchId,:mg_student_category_id=>studentCategoryId)

                #@studentFeeDiscounList=MgFeeDiscount.select(:discount_type, :name, :mg_receiver_id, :discount).where(:mg_batch_id => batchId, :discount_type=>"Student",:mg_receiver_id=>studentId)

                #@categoryFeeDiscounList=MgFeeDiscount.select(:discount_type, :name, :mg_receiver_id, :discount).where(:mg_batch_id => batchId, :discount_type=>"Student Category",:mg_receiver_id=>studentCategoryId)

                 @student_fee_particular_list += @category_fee_particular_list+ @batch_fee_particular_list

                    

                # @studentFeeDiscounList += @categoryFeeDiscounList+ @batchFeeDiscounList
                 puts @student_fee_particular_list.inspect
                 #logger.infoadf

                 #puts @studentFeeDiscounList.inspect

              
            for index in 0 ... @student_fee_particular_list.size
                puts "hello particular"
                #mgParticularName= @batch_fee_particular_list[index].name
                
                puts @student_fee_particular_list[index].mg_particular_type_id.inspect
              
                #@particularType=MgParticularType.find_by(:id=>@student_fee_particular_list[index].mg_particular_type_id)
                #@particularType=MgParticularType.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id]).find(@student_fee_particular_list[index].mg_particular_type_id)
                @particularType=MgParticularType.find(@student_fee_particular_list[index].mg_particular_type_id)
             

                mgParticularName= @particularType.particular_name
                mgParticularDescription= @student_fee_particular_list[index].description
                mgParticularAmount= @student_fee_particular_list[index].amount
                mgBatchId= @student_fee_particular_list[index].mg_batch_id

                mg_student_category_id =@student_fee_particular_list[index].mg_student_category_id
                mg_collection_id = @mg_fee_collection.id

                mg_collection_particular = MgFeeCollectionParticular.where(:mg_student_id=> studentId,:mg_fee_collection_id=>mg_collection_id,:mg_fee_particular_name=>mgParticularName,:is_deleted => 0, :mg_school_id=> session[:current_user_school_id])
                
                puts "Checking for empty"
                puts "mg_collection_particular.inspect"
                puts mg_collection_particular.inspect

                if(mg_collection_particular.empty?)
                  puts "inside Jayanth"
                  @mg_fee_collection_particular=@mg_fee_collection.mg_fee_collection_particulars.build(:mg_fee_particular_name => mgParticularName,:mg_fee_particular_description => mgParticularDescription,:mg_fee_particular_amount => mgParticularAmount, :mg_student_category_id => mg_student_category_id ,:mg_student_admission_number => studentAdmissionNumber, :mg_student_id=> studentId , :is_deleted=> params[:fee_schedule][:is_deleted], :mg_school_id=> session[:current_user_school_id] )
                  @mg_fee_collection.save
                end
                #end
              end #ends of inner for loop
                
             
            end #ends of outer for loop
           #creating particular for each student end
        end  #ends of each loop
        redirect_to :action=>'transport_fees_schedule_index'
    end #ends of request.post?

    if request.get?
      if @booleanValue==true
        puts" @booleanValue==true"
      else  
        puts" inside render :layout => false"
        render :layout => false
      end
    end

  end

  def transport_show_fee_schedule
     @fee_schedule_show_list=MgFeeCollection.find_by_id(params[:id])
    render :layout => false
  end
   def transport_edit_fee_schedule
     @fee_schedule=MgFeeCollection.find_by_id(params[:id])
    puts @fee_schedule.inspect
    render :layout => false
   end
   def update_transport_fee_schedule
    school_id=session[:current_user_school_id]
    @fee_schedule=MgFeeCollection.find_by_id(params[:id])
    @timeformat = MgSchool.find(school_id)
    @startDate = Date.strptime(params[:fee_schedule][:start_date],@timeformat.date_format)
    @endDate = Date.strptime(params[:fee_schedule][:end_date],@timeformat.date_format)
    @dueDate = Date.strptime(params[:fee_schedule][:due_date],@timeformat.date_format)

    @fee_schedule.update(:name=>params[:fee_schedule][:name], :start_date=>@startDate, :end_date=>@endDate, :due_date=>@dueDate)
    redirect_to :action=>'transport_fees_schedule_index'
   end

   def transport_delete_fee_schedule

    @fee_fine_schedule=MgFeeCollection.find_by_id(params[:id])
    #@fee_discount.is_deleted =1
    @fee_fine_schedule.update(:is_deleted=>1)
    redirect_to :action=>'transport_fees_schedule_index'
  end
  private
  def transport_params
    params.require(:vehicle_route).permit(:route_name,:description,:mg_employee_category_id,:mg_vehicle_id,:is_deleted,:mg_school_id)
  end
   def transport_vehicle_route_params
    params.require(:vehicles_routes).permit(:route_name,:description,:mg_employee_category_id,:mg_vehicle_id,:is_deleted,:mg_school_id)
  end
  def edit_transport_params
    params.require(:vehicle_route).permit(:route_name,:description)
  end
  private
  def transport_time_params
   params.require(:transport_time).permit(:mg_transport_id,:bus_stop_name,:is_deleted,:mg_school_id)
  end
    
 def edit_transport_time_params
   params.require(:transport_time).permit(:mg_transport_id,:bus_stop_name)
  end
  def subject_params
    params.require(:transport_fees).permit(:name,:description,:is_deleted, :mg_school_id)
  end
  def particular_params
    params.require(:transport_particulars).permit(:mg_particular_type_id,:description,:fee_category,:is_deleted, :mg_school_id,:amount,
     :admission_no, :mg_student_category_id)
  end
  def update_particular_params
    params.require(:transport_particulars).permit(:name,:description,:fee_category,:is_deleted, :mg_school_id,:amount, :admission_no, :mg_student_category_id)
  end

end
