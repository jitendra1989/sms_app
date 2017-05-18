class LaboratoryController < ApplicationController
   before_filter :login_required
  # before_filter :authorization, :except => [:laboratory_search, :laboratory_search_data]
  layout "mindcom"

  def authorization
    user=MgUser.find_by(:id=>session[:user_id])
    if(!(user.user_type=="admin"))
      #redirect_to root_path
      flash[:notice]="Unauthorised Access."
      redirect_to(session[:last_url])
    end
  end



  def new
    laboratry=MgLab.new
    render :layout=>false
  end

  def edit
    @laboratry=MgLab.find(params[:id])
    render :layout=>false
    
  end

  def delete
    @lab=MgLab.find(params[:id])
    @lab.update(:is_deleted=>1)
    redirect_to :back
  end

  def show
    @laboratary=MgLab.find(params[:id])
    render :layout=>false
  end


  def index

    
    @lab=MgLab.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def create
    @lab=MgLab.new(lab_params)
    @lab.save
    redirect_to :back
  end
  def update
    @lab=MgLab.find(params[:id])
    @lab.update(:room_no=>params[:laboratry][:room_no],:lab_name=>params[:laboratry][:lab_name],:mg_laboratory_subject_id=>params[:laboratry][:mg_laboratory_subject_id])
    redirect_to :back
  end
  def inventory
    @lab_inv=MgLabInventory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end
  def inventory_new
    render :layout=>false
  end
  def inventory_create
    
     @lab=MgLabInventory.new(inven_params)
     @lab.save
     redirect_to :action => "inventory"
  end

  def inventory_edit
    @laboratry=MgLabInventory.find(params[:id])
    render :layout=>false
  end
  def inventory_update
    @lab=MgLabInventory.find(params[:id])
    @lab.update(:mg_lab_id=>params[:laboratry][:mg_lab_id],:category_name=>params[:laboratry][:category_name],:mg_laboratory_item_id=>params[:laboratry][:mg_laboratory_item_id],:prefix=>params[:laboratry][:prefix])
    redirect_to :action => "inventory"
  end
  def inventory_delete
    @lab=MgLabInventory.find(params[:id])
    @lab.update(:is_deleted=>1)
    redirect_to :action =>"inventory"
    
  end
  def inventory_show
    @laboratary=MgLabInventory.find(params[:id])
    render :layout=>false
  end

  def unit
    @lab_unit=MgLabUnit.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end
  def unit_new
    render :layout=>false
    
  end
  def unit_create
     @lab=MgLabUnit.new(unit_params)
     @lab.save
     redirect_to :action => "unit"
  end

  def unit_edit
    @laboratry=MgLabUnit.find(params[:id])
    render :layout=>false
    
  end
  def unit_update
    @lab=MgLabUnit.find(params[:id])
    @lab.update(:unit_name=>params[:laboratry][:unit_name])
    redirect_to :action => "unit"
  end
  def unit_delete
    @lab=MgLabUnit.find(params[:id])
    @lab.update(:is_deleted=>1)
    redirect_to :action =>"unit"
    
  end
  def unit_show
    @laboratary=MgLabUnit.find(params[:id])
    render :layout=>false
  end
  #===============================
  def management
    @isUserIncharge=0
  if session[:user_type]=="employee"
    employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    inchargeCount=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>employee.id,:incharge_type=>"Incharge").count
    if inchargeCount>0
      @isUserIncharge=1
      @inchargeSubject=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>employee.id,:incharge_type=>"Incharge").pluck(:mg_subject_id)
      @lab_ids=MgLab.where(:mg_laboratory_subject_id=>@inchargeSubject[0]).pluck(:id)
    end
  end

    if params[:custom_param].present?
      temp=params[:custom_param]
      custom=temp.split("-")
          if custom[1].present?
     
                    
                    if @isUserIncharge==1
                          @lab_management=MgInventoryManagement.where("mg_lab_id IN (?) and is_deleted=? and mg_school_id=?",@lab_ids[0],0,session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)

                      else
                          @lab_management=MgInventoryManagement.where(:mg_lab_id=>custom[1],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
                    end
                
          else
                  if @isUserIncharge==1
                          @lab_management=MgInventoryManagement.where("mg_lab_id IN (?) and is_deleted=? and mg_school_id=?",@lab_ids[0],0,session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
                  else
                          @lab_management=MgInventoryManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
                  end
          end
          @id=custom[1]
    else
      # ===================================================================
    if params[:short_lab_wise].present?
      if params[:short_lab_wise][:mg_lab_id].present?
         @value=params[:short_lab_wise][:mg_lab_id]
      else
         @value=0
      end
    else
      @value=0
    end

    if  @value!=0
      @id=params[:short_lab_wise][:mg_lab_id]
          if @isUserIncharge==1
                    @lab_management=MgInventoryManagement.where("mg_lab_id IN (?) and is_deleted=? and mg_school_id=?",@lab_ids[0],0,session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
          else
                     @lab_management=MgInventoryManagement.where(:mg_lab_id=>params[:short_lab_wise][:mg_lab_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
          end
  else
            if @isUserIncharge==1
                       @lab_management=MgInventoryManagement.where("mg_lab_id IN (?) and is_deleted=? and mg_school_id=?",@lab_ids[0],0,session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
            else
                        @lab_management=MgInventoryManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
            end

    end
  end
  end

  def management_new  
  end


  def management_create
      @lab=MgInventoryManagement.new(management_params)
      @lab.save
      @timeformat = MgSchool.find(session[:current_user_school_id])
      @validity = Date.strptime(params[:laboratry][:valid_upto],@timeformat.date_format)
      @lab.update(:valid_upto=>@validity)
     redirect_to :action => "management"
  end

  def management_edit
    @laboratry=MgInventoryManagement.find(params[:id])
  end

  def management_update
    @lab=MgInventoryManagement.find(params[:id])
    @lab.update(management_update_params)
    if params[:laboratry][:valid_upto].present?
      @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
      valid_dates = Date.strptime(params[:laboratry][:valid_upto],@timeformat.date_format)
      @lab.update(:valid_upto=>valid_dates)
    end
    redirect_to :action => "management"
  end

  def management_delete
    @lab=MgInventoryManagement.find(params[:id])
    @lab.update(:is_deleted=>1)
    redirect_to :action =>"management"
    
  end

  def management_show
    @laboratry=MgInventoryManagement.find(params[:id])
    render :layout=>false
  end

  def category_list

puts "777777777777777777777777777777777777777777777777777777777777777777"
puts params[:issuable_item_type_id]
puts params[:id]
puts "777777777777777777777777777777777777777777777777777777777777777777"
      @categoryList = MgLabInventory.where(:mg_laboratory_item_id=>params[:issuable_item_type_id],:is_deleted=>0, :mg_lab_id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
      respond_to do |format|
      format.json  { render :json => @categoryList }
      end
  end


  def category_list_for_purchase


      @categoryList = MgLabInventory.where(:is_deleted=>0, :mg_lab_id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
      respond_to do |format|
      format.json  { render :json => @categoryList }
      end
  end


  


  def item_type_list
      itemId = MgLabInventory.where(:is_deleted=>0, :id=>params[:id], :mg_school_id=>session[:current_user_school_id]).pluck(:mg_laboratory_item_id)
      @itemList = MgLaboratoryItem.where(:is_deleted=>0,:id=>itemId,:mg_school_id=>session[:current_user_school_id])
      @itemname=@itemList[0].name
      puts "99999999999999999999999999999999999"
      puts @itemname
      puts "99999999999999999999999999999999999"
     

      respond_to do |format|
      format.json  { render :json => @itemList }
      end
  end



  def room_list
      @roomList = MgLab.where(:is_deleted=>0, :mg_laboratory_subject_id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
      respond_to do |format|
      format.json  { render :json => @roomList }
      end
  end


  def lab_list
      @lab_list = MgLab.where(:is_deleted=>0, :mg_laboratory_subject_id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
      respond_to do |format|
      format.json  { render :json => @lab_list }
      end
  end


  def is_issuable
      @roomList = MgLaboratoryItem.where(:is_deleted=>0, :name=>params[:id], :mg_school_id=>session[:current_user_school_id]).pluck(:is_issuable)
      puts "7777777777777777777777777"
      puts @roomList
      puts "7777777777777777777777777"

      respond_to do |format|
      format.json  { render :json => @roomList }
      end
  end
  
  #=====================================================
  def consumption
    @isUserIncharge=0
  if session[:user_type]=="employee"
    employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    inchargeCount=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>employee.id).count
    if inchargeCount>0
      @isUserIncharge=1
      @inchargeSubject=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>employee.id).pluck(:mg_subject_id)
      @lab_ids=MgLab.where(:mg_laboratory_subject_id=>@inchargeSubject[0]).pluck(:id)
    end
  end
    

    if params[:custom_param].present?
      temp=params[:custom_param]
      custom=temp.split("-")
          if custom[1].present?
                   if @isUserIncharge==1
                          @consumption=MgItemConsumption.where("mg_lab_id IN (?) and is_deleted=? and mg_school_id=?",@lab_ids[0],0,session[:current_user_school_id]).paginate(page: params[:page], per_page: 10) 
                   else
                          @consumption=MgItemConsumption.where(:mg_lab_id=>custom[1],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10) 
                   end
          else
                  if @isUserIncharge==1
                          @consumption=MgItemConsumption.where("mg_lab_id IN (?) and is_deleted=? and mg_school_id=?",@lab_ids[0],0,session[:current_user_school_id]).paginate(page: params[:page], per_page: 10) 

                  else
                          @consumption=MgItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
                  end
          end
          @id=custom[1]
    else
# =======================================================================================
          if params[:short_lab_wise].present?
            if params[:short_lab_wise][:mg_lab_id].present?
               @value=params[:short_lab_wise][:mg_lab_id]
            else
               @value=0
            end
          else
            @value=0
          end

          if  @value!=0
            @id=params[:short_lab_wise][:mg_lab_id]
                if @isUserIncharge==1
                          @consumption=MgItemConsumption.where("mg_lab_id IN (?) and is_deleted=? and mg_school_id=?",@lab_ids[0],0,session[:current_user_school_id]).paginate(page: params[:page], per_page: 10) 
                else
                      @consumption=MgItemConsumption.where(:mg_lab_id=>params[:short_lab_wise][:mg_lab_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
                end
        else
                 if @isUserIncharge==1
                          @consumption=MgItemConsumption.where("mg_lab_id IN (?) and is_deleted=? and mg_school_id=?",@lab_ids[0],0,session[:current_user_school_id]).paginate(page: params[:page], per_page: 10) 
                else
                      @consumption=MgItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
                end
          end
# =======================================================================================
        end
  end
  def consumption_new  
  end


  def consumption_create
    #logger.infoZDGH
     @lab=MgItemConsumption.new(consumption_params)
     item_type_id=MgLaboratoryItem.where(:name=>params[:laboratry][:mg_item_type_id]).pluck(:id)
     @lab.update(:mg_item_type_id=>item_type_id[0])
 
     @lab.save
     @timeformat = MgSchool.find(session[:current_user_school_id])
      if params[:laboratry][:date].present?
        @dateOfBirth = Date.strptime(params[:laboratry][:date],@timeformat.date_format)
        @lab.update(:date => @dateOfBirth)
       end
       if params[:laboratry][:consumption_type]=="Issued"
       if params[:studentids].nil?
      else
        for i in 0...params[:studentids].size
        data=MgStudentItemConsumption.new()
      data.mg_student_id=params[:studentids][i]
      data.mg_course_id=params[:mg_course_id]
      data.mg_batch_id=params[:mg_batch_id] 
      data.mg_item_consumption_id=@lab.id
      data.mg_school_id=session[:current_user_school_id]
      data.is_deleted=0
      data.consumption_type= @lab.consumption_type

      data.save
      end
      end
       end
       if params[:laboratry][:consumption_type]=="Returned"
         @return_date = Date.strptime(params[:return_date],@timeformat.date_format)
        @lab.update(:return_date => @return_date)
       end
       student_list=params[:add_student]
       if(student_list.present?)
             for j in 0...student_list.size
             fee_particular=MgFeeFineParticular.new()
             fee_particular.amount=params[:amount]
             fee_particular.mg_student_id=student_list[j]
             fee_particular.mg_batch_id=params[:batch]
             fee_particular.fine_name="Fine From Lab"
             fee_particular.fine_name="Fine From Lab"
             fee_particular.fine_from="Lab"
             fee_particular.is_deleted=0
             fee_particular.mg_school_id=session[:current_user_school_id]
             fee_particular.mg_item_consumption_id=@lab.id
             fee_particular.start_date=Date.today
             fee_particular.due_date=Date.today+14
             fee_particular.end_date=Date.today+14
             fee_particular.save
           end
   end
   #====================================Notification to students and Guardian==========================================
# objArray=params[:event_privacy]

      @timeformat = MgSchool.find(session[:current_user_school_id])
      mg_student_id_arr=params[:add_student]
      unless mg_student_id_arr.nil?
        for i in 0...mg_student_id_arr.size
            begin
 #===============Notification to Guardian start===============================================
  multi_mail_list = MgGuardian.where(:mg_student_id => mg_student_id_arr[i]).pluck(:mg_user_id)
            @message = Message.new
            @email_from = MgEmail.where(:mg_user_id => session[:user_id])
            @message.subject =  "Fine From Lab"
            @message.description = "Dear Sir/Madam \n Fine has been imposed on your ward for lab damage \n Fine Amount #{params[:amount]}\n\n Thanks & Regards \n #{@timeformat.school_name}"
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
     redirect_to :action => "consumption"
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

 def consumption_edit
    @laboratry=MgItemConsumption.find(params[:id])
    @issue_return_count=0
    @issue_return_count=MgStudentItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_item_consumption_id=>params[:id]).count
    @fee_student_batch_id=MgFeeFineParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_item_consumption_id=>@laboratry.id).pluck(:mg_batch_id).uniq
    @fee_student_particular_id=MgFeeFineParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_item_consumption_id=>@laboratry.id).pluck(:mg_student_id)
    @student_data=MgStudent.where(:id=>@fee_student_particular_id).pluck(:first_name,:id)
    @fee_student_course_id=MgBatch.where(:id=>@fee_student_batch_id[0]).pluck(:mg_course_id)
    @fee_student_amount=MgFeeFineParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_item_consumption_id=>@laboratry.id).pluck(:amount).uniq
  end
  def consumption_update

    @lab=MgItemConsumption.find(params[:id])
    @timeformat = MgSchool.find(session[:current_user_school_id])

    @lab.update(consumption_update_params)
    @lab.update(:mg_laboratory_room_id=>params[:mg_laboratory_room_id])

     item_type_id=MgLaboratoryItem.where(:name=>params[:mg_item_type_id]).pluck(:id)
     @lab.update(:mg_item_type_id=>item_type_id[0])


    if params[:laboratry][:consumption_type]=="Broken" && params[:previous_consumption_type]=="Issued"

      @data=MgFeeFineParticular.new()
    @data.is_deleted=0
    @data.mg_batch_id=params[:mg_batch_id]
    @data.amount=params[:amount]
    @data.created_by=session[:user_id]
    @data.mg_student_id=params[:mg_student_id]
    @data.mg_item_consumption_id=params[:id]
    @data.fine_name="Fine From Lab"
    @data.fine_from="Lab"
    @data.start_date=Date.today
    @data.due_date=Date.today+14
    @data.end_date=Date.today+14
    @data.mg_school_id=session[:current_user_school_id]
    @data.save
      #@lab.update(:mg_course_id => params[:mg_course_id],:mg_batch_id => params[:mg_batch_id],:mg_student_id => params[:mg_student_id])
    elsif params[:laboratry][:consumption_type]=="Issued"
        @lab.update(:mg_course_id => params[:mg_course_id],:mg_batch_id => params[:mg_batch_id],:mg_student_id => params[:mg_student_id])
    end
       if params[:laboratry][:consumption_type]=="Returned"

         @params=params[:selectedEmployees]
         @broken_student_id=params[:asst_selected_employees]

  school_id=session[:current_user_school_id]
  if @params.nil?

    else
 for j in 0...@params.size

   library_employee_data=MgStudentItemConsumption.where('mg_school_id=? and  mg_student_id=? and mg_item_consumption_id=?', school_id,@params[j],@lab.id)

 if library_employee_data.size<1

    
  else
    @return_date = Date.strptime(params[:return_date],@timeformat.date_format)
        @lab.update(:return_date => @return_date)
        library_employee_data[0].update(:consumption_type=>"returned")

      end
    end
end

    if @broken_student_id.nil?

    else
 for j in 0...@broken_student_id.size

       library_employee_data=MgStudentItemConsumption.where('mg_school_id=? and  mg_student_id=? and mg_item_consumption_id=?', school_id,@broken_student_id[j],@lab.id)



if library_employee_data.size<1

  else
        library_employee_data[0].update(:consumption_type=>"Broken")
      end
end
end
       end
      if params[:laboratry][:date].present?
        @dateOfBirth = Date.strptime(params[:laboratry][:date],@timeformat.date_format)
        @lab.update(:date => @dateOfBirth)
       end
       ################################
       @params=params[:add_student]
  school_id=session[:current_user_school_id]

  @lab=MgItemConsumption.find(params[:id])
    @lab.update(consumption_update_params)
    @lab.update(:mg_laboratory_room_id=>params[:mg_laboratory_room_id])
    
    item_type_id=MgLaboratoryItem.where(:name=>params[:mg_item_type_id]).pluck(:id)
     @lab.update(:mg_item_type_id=>item_type_id[0])
    @timeformat = MgSchool.find(session[:current_user_school_id])
      if params[:laboratry][:date].present?
        @dateOfBirth = Date.strptime(params[:laboratry][:date],@timeformat.date_format)
        @lab.update(:date => @dateOfBirth)
       end


if @params.present?
 for j in 0...@params.size
   library_employee_data=MgFeeFineParticular.where('mg_school_id=? and mg_item_consumption_id=? and mg_student_id=?', school_id,params[:id], @params[j])
 if library_employee_data.size<1
    @data=MgFeeFineParticular.new()
    @data.is_deleted=0
    @data.mg_batch_id=params[:batch]
    @data.amount=params[:amount]
    @data.created_by=session[:user_id]
    @data.mg_student_id=@params[j]
    @data.mg_item_consumption_id=params[:id]
    @data.fine_name="Fine From Lab"
    @data.fine_from="Lab"
    @data.start_date=Date.today
    @data.due_date=Date.today+14
    @data.end_date=Date.today+14
    @data.mg_school_id=school_id
    @data.save
  else
        library_employee_data[0].update(:is_deleted=>0,:mg_school_id=>school_id)
        #logger.infoksHD

      end
    end
end
  library_employee_data=MgFeeFineParticular.where('is_deleted=? and mg_school_id=? and mg_item_consumption_id=? and  mg_student_id  NOT IN (?)', 0,school_id,params[:id],params[:add_student])
  #     puts library_employee_data.inspect 

 if library_employee_data.length>0
    for j in 0...library_employee_data.length
     
     data=MgFeeFineParticular.find_by(:id=>library_employee_data[j].id)
     if data.present?
    data.update(:is_deleted=>1)
   end
  end
   end
    redirect_to :action => "consumption"
  end
  def consumption_delete
    @lab=MgItemConsumption.find(params[:id])
    @lab.update(:is_deleted=>1)
    redirect_to :action =>"consumption"
    
  end
  def consumption_show
    @laboratry=MgItemConsumption.find(params[:id])
    render :layout=>false
  end

  def section_list
   
    @section_list = MgBatch.where(:is_deleted=>0,:mg_course_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    respond_to do |format|
      format.json  { render :json => @section_list }
      end
  end

  def students_list
    @student_list = MgStudent.where(:is_deleted=>0,:mg_batch_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    # respond_to do |format|
    #   format.json  { render :json => @student_list }
    #   end
    render :layout=>false
    
  end
   def students_list_for_issued
   consumption_id=params[:con_id]
   consumption_data=MgItemConsumption.find_by(:id=>consumption_id)
  
   student_id_data=MgStudentItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_item_consumption_id=>consumption_id,:consumption_type=>["Issued","returned"]).pluck(:mg_student_id)
 
    @student_list = MgStudent.where(:is_deleted=>0,:id=>student_id_data,:mg_school_id=>session[:current_user_school_id])
    @student_ary=Array.new
      @student_list.each do|list|
      list_ary=Array.new()
      first_name=list.first_name
      key="#{first_name} #{list.last_name} "
      value=list.id
      list_ary.push(key,value)
      @student_ary.push(list_ary)
    end
    render :layout=>false
    
  end
  def item_list
      @itemList = MgInventoryManagement.where(:is_deleted=>0, :mg_category_id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
      respond_to do |format|
      format.json  { render :json => @itemList }
      end
  end

  def available_list
      @quantityList = MgInventoryManagement.where(:is_deleted=>0, :id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
          @total_consumption=0
          @available=0
          @total_quantity=@quantityList[0].quantity  
          @item=MgItemConsumption.where(:is_deleted=>0, :mg_item_id=>params[:id], :mg_school_id=>session[:current_user_school_id])
              if @item.length>0
                  @item.each do |item|
                  @total_consumption=@total_consumption+item.quantity_consumption
                  end
              end
          if @total_quantity>@total_consumption
            @available=@total_quantity-@total_consumption
          end
      respond_to do |format|
      format.json  { render :json => @available }
      end
  end
#===========================================================================
def purchase
  @isUserIncharge=0
  if session[:user_type]=="employee"
    employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    inchargeCount=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>employee.id,:incharge_type=>"Incharge").count
    if inchargeCount>0
      @isUserIncharge=1
      @inchargeSubject=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>employee.id,:incharge_type=>"Incharge").pluck(:mg_subject_id)
    end
  end


  if params[:custom_param].present?
      temp=params[:custom_param]
      custom=temp.split("-")
          if custom[1].present?
           
                   if @isUserIncharge==1
                          @purchase=MgItemPurchase.where(:mg_laboratory_subject_id=>@inchargeSubject[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)
                   else
                          if params[:short_lab_wise][:mg_laboratory_room_id].present?
                          @purchase=MgItemPurchase.where(:mg_room_id=>params[:short_lab_wise][:mg_laboratory_room_id],:mg_laboratory_subject_id=>custom[1],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)

                          else
                          @purchase=MgItemPurchase.where(:mg_laboratory_subject_id=>custom[1],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)

                          end
                  end

          else     
                    if @isUserIncharge==1
                   @purchase=MgItemPurchase.where(:mg_laboratory_subject_id=>@inchargeSubject[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)

                    else
                   @purchase=MgItemPurchase.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)
                    end
          end
          @id=custom[1]
    else
      # ============================================================
  if params[:short_lab_wise].present?
      if params[:short_lab_wise][:mg_laboratory_subject_id].present?
         @value=params[:short_lab_wise][:mg_laboratory_subject_id]
      else
         @value=0
      end
    else
      @value=0
    end

    if  @value!=0
      @id=params[:short_lab_wise][:mg_laboratory_subject_id]
              if @isUserIncharge==1
                @purchase=MgItemPurchase.where(:mg_laboratory_subject_id=>@inchargeSubject[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)

              else
                if params[:short_lab_wise][:mg_laboratory_room_id].present?
                @purchase=MgItemPurchase.where(:mg_room_id=>params[:short_lab_wise][:mg_laboratory_room_id],:mg_laboratory_subject_id=>params[:short_lab_wise][:mg_laboratory_subject_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)

                else
                @purchase=MgItemPurchase.where(:mg_laboratory_subject_id=>params[:short_lab_wise][:mg_laboratory_subject_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)

                end

              end
   # @purchase=MgItemPurchase.where(:mg_laboratory_subject_id=>params[:short_lab_wise][:mg_laboratory_subject_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)
  
  else
                if @isUserIncharge==1
                  @purchase=MgItemPurchase.where(:mg_laboratory_subject_id=>@inchargeSubject[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)

                else

                  @purchase=MgItemPurchase.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)

                end
    #@purchase=MgItemPurchase.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date DESC').paginate(page: params[:page], per_page: 10)
    end
    end
  end
  def purchase_new
    
  end
  def purchase_create
   # begin
        #MgItemPurchase.transaction do
        item_purchase=MgItemPurchase.new(purchase_details_params)
        @timeformat = MgSchool.find(session[:current_user_school_id])
        @date_of_purchase = Date.strptime(params[:laboratry][:date],@timeformat.date_format)
        item_purchase.created_by=session[:user_id]
        item_purchase.is_deleted=0
        item_purchase.mg_school_id=session[:current_user_school_id]
        if item_purchase.save
          item_purchase.update(:date=>@date_of_purchase)
        end

        mg_category_id_arr=params[:mg_category_id]
        item_name_arr=params[:item_name]
        valid_upto_arr=params[:valid_upto]
        cost_arr=params[:cost]
        unit_arr=params[:unit]
        total_arr=params[:total]
        for j in 0...item_name_arr.length
          if (item_name_arr[j].present? && mg_category_id_arr[j].to_i>0 && cost_arr[j].present? && unit_arr[j].present? && valid_upto_arr[j].present?)
        item_information=MgItemInformation.new()
        item_information.mg_purchase_id=item_purchase.id
        item_information.mg_school_id=session[:current_user_school_id]
        item_information.is_deleted=0
        item_information.created_by=session[:user_id]
        item_information.mg_category_id=mg_category_id_arr[j]
        item_information.item_name=item_name_arr[j]
        item_information.valid_upto=valid_upto_arr[j]
        item_information.cost=cost_arr[j]
        item_information.unit=unit_arr[j]
        item_information.total=total_arr[j]
        item_information.save
                      if valid_upto_arr[j].present?
                        @timeformat = MgSchool.find(session[:current_user_school_id])
                       validdate = Date.strptime(valid_upto_arr[j],@timeformat.date_format)
                      item_information.update(:valid_upto=>validdate)
                    end

        end#for end
      end

        redirect_to :action => "purchase"

        # end#transaction end
        # rescue
        #   flash[:error]="Data Not Saved"
        #   redirect_to :action=>'purchase_new'
        # end#begin end
     
  end

  def purchase_edit
   @school_id=session[:current_user_school_id]
    @laboratory_purchase_details=MgItemPurchase.find(params[:id])
    @item_information_details=MgItemInformation.where(:mg_purchase_id=>params[:id],:is_deleted=>0,:mg_school_id=>@school_id)
   # render :layout=>false
  end
  def purchase_update
    @params=params[:ids]
    school_id=session[:current_user_school_id]
    mg_category_id_arr=params[:mg_category_id]
    item_name_arr=params[:item_name]
    valid_upto_arr=params[:valid_upto]
    cost_arr=params[:cost]
    unit_arr=params[:unit]
    total_arr=params[:total]
    @laboratory_purchase_details=MgItemPurchase.find(params[:id])
    @laboratory_purchase_details.update(laboratory_details_params)
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @date_of_purchase = Date.strptime(params[:laboratory_purchase_details][:date],@timeformat.date_format)
    @laboratory_purchase_details.update(:date=>@date_of_purchase)
    laboratory_data=MgItemInformation.where('is_deleted=? and mg_school_id=? and mg_purchase_id=? and id  NOT IN (?)', 0,school_id,params[:id],params[:ids])
 if laboratory_data.length>0
    for j in 0...laboratory_data.length 
     data=MgItemInformation.find_by(:id=>laboratory_data[j].id)
     if data.present?
    data.update(:is_deleted=>1)
  end
  end
   end
   for j in 0...@params.size
   laboratry_data=MgItemInformation.where('mg_school_id=? and mg_purchase_id=? and id=?', school_id,params[:id],@params[j])
 if laboratry_data.size<1
  if (item_name_arr[j].present? && mg_category_id_arr[j].to_i>0 && cost_arr[j].present? && unit_arr[j].present? && valid_upto_arr[j].present?)
item_information_detail=MgItemInformation.new()
item_information_detail.mg_purchase_id=params[:id]
item_information_detail.mg_school_id=session[:current_user_school_id]
item_information_detail.is_deleted=0
item_information_detail.created_by=session[:user_id]
item_information_detail.mg_category_id=mg_category_id_arr[j]
item_information_detail.item_name=item_name_arr[j]
item_information_detail.valid_upto=valid_upto_arr[j]
item_information_detail.cost=cost_arr[j]
item_information_detail.unit=unit_arr[j]
item_information_detail.total=total_arr[j]
item_information_detail.save
if valid_upto_arr[j].present?
    @timeformat = MgSchool.find(session[:current_user_school_id])

    valid_date = Date.strptime(valid_upto_arr[j],@timeformat.date_format)
    item_information_detail.update(:valid_upto=>valid_date)
end
end
  else
    laboratry_data[0].update(:mg_category_id=>mg_category_id_arr[j],:mg_purchase_id=>params[:id],:item_name=>item_name_arr[j],:valid_upto=>valid_upto_arr[j],:total=>total_arr[j],:cost=>cost_arr[j],:is_deleted=>0,:mg_school_id=>school_id,:unit=>unit_arr[j])
    valid_date = Date.strptime(valid_upto_arr[j],@timeformat.date_format)
    laboratry_data[0].update(:valid_upto=>valid_date)
      end
    end
    flash[:success]="Data has Updated"
    redirect_to :action => "purchase"
  end
  def purchase_delete
    item_pur=MgItemPurchase.find(params[:id])
    item_pur.update(:is_deleted=>1)
    item_info=MgItemInformation.where(:mg_purchase_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    item_info.each do |item|
     item.update(:is_deleted=>1)
    end
    redirect_to :action =>"purchase"
    
  end
  def purchase_show
   @purchase=MgItemPurchase.find(params[:id])
   render :layout=>false
  end
# ===============================================Laboratory Item==============================================
  def item
    @item=MgLaboratoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def item_new
    render :layout=>false
  end

  def item_create
    @temp_var=0
    lab_item=MgLaboratoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    lab_item.each do |item_validate|
      if item_validate.name==params[:laboratory][:name]
        @temp_var=@temp_var+1
      end
    end

      if @temp_var==0
        item=MgLaboratoryItem.new(laboratory_item_params)
        item.save
        redirect_to :action=>"item"
      else
        flash[:notice]='Duplicate Item Type'
        redirect_to :action=>"item"
      end
  end

  def item_edit
    @laboratory=MgLaboratoryItem.find_by(:id=>params[:id])
    render :layout=>false
  end

  def item_update
    @temp_var=0
    #lab_item=MgLaboratoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    lab_item=MgLaboratoryItem.where("is_deleted = ? and mg_school_id = ? and id NOT IN (?)",0,session[:current_user_school_id],params[:id])
    lab_item.each do |item_validate|
      if item_validate.name==params[:laboratory][:name]
        @temp_var=@temp_var+1
      end
    end
    if @temp_var==0
        laboratry=MgLaboratoryItem.find_by(:id=>params[:id])
        laboratry.update(item_update_params)
        redirect_to :action=>"item"
      else
        flash[:notice]='Duplicate Item Type'
        redirect_to :action=>"item"
      end
  end

  def item_delete
    item=MgLaboratoryItem.find_by(:id=>params[:id])
    item.update(:is_deleted=>1)
    redirect_to :action=>"item"
  end

  def item_show
      @item=MgLaboratoryItem.find_by(:id=>params[:id])
      render :layout=>false

  end

  def prefix_validation
  @prefix_count=MgLabInventory.where(:mg_school_id=>session[:current_user_school_id],:prefix=>params[:id],:is_deleted=>0).count
  respond_to do |format|
       format.json  { render :json => @prefix_count.to_json }
       end
end


  def auto_resource_number
  inventory=MgLabInventory.find_by(:id=>params[:id])
  if MgInventoryManagement.where(:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:id]).count.zero? # empty array
                          @strVal='1'
                      else
                          @lastrecord = MgInventoryManagement.where(:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:id]).last
                          str=@lastrecord.item_identification_number
                          m=inventory.prefix.length
                          n= str.length
                          tail= str.slice(m, n)
                          @lastrecord=tail
                          @last_item_identification_number= @lastrecord.to_i
                          @next_item_identification_number = @last_item_identification_number + 1;
                          @strVal = @next_item_identification_number.to_s
                      end
                      @number=inventory.prefix.to_s+""+@strVal
#render :json=>@number.to_json
respond_to do |format|
       format.json  { render :json => @number.to_json }
       end
end


def prefix_edit_validation
  @resource_type=MgLabInventory.where(:mg_school_id=>session[:current_user_school_id],:prefix=>params[:id],:is_deleted=>0).pluck(:id)
  if @resource_type.present?
  @resource_inventory=MgInventoryManagement.where(:mg_school_id=>session[:current_user_school_id],:mg_category_id=>@resource_type,:is_deleted=>0).count
  else
  @resource_inventory=0
  end
  respond_to do |format|
       format.json  { render :json => @resource_inventory.to_json }
       end
end

def subject
  @subject=MgLaboratorySubject.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def subject_new
    render :layout=>false
  
end

def subject_create
    subject=MgLaboratorySubject.new(params_subject)
    subject.save
    redirect_to :action=> "subject"
end

def subject_show
  @subject=MgLaboratorySubject.find_by(:id=>params[:id])
    render :layout=>false
end

def subject_edit
  @laboratory=MgLaboratorySubject.find_by(:id=>params[:id])
    render :layout=>false

end

def subject_update
  @laboratory=MgLaboratorySubject.find_by(:id=>params[:id])
  @laboratory.update(params_update_subject)
  redirect_to :action=> "subject"
end

def subject_delete
    @laboratory=MgLaboratorySubject.find_by(:id=>params[:id])
    @laboratory.update(:is_deleted=>1)
    redirect_to :back
end

def laboratory_settings_show
  # Client.select(:name).uniq
  #@laboratory_settings=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).select(:mg_subject_id).uniq
  @laboratory_settings=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order(:mg_subject_id).pluck(:mg_subject_id).uniq
  
end

def add_laboratory_incharge
end

def add_laboratory_assistant_incharge
end

def edit_laboratory_incharge
end

def edit_laboratory_assistant_incharge
end

def select_employees
      @subId=params[:mg_subject_id]
     @deptid=params[:dept_data]
     if params[:mg_subject_id].present?
      empId=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_subject_id=>@subId,:incharge_type=>"Assistant Incharge").pluck(:mg_employee_id)
                if empId.present?
                      @employeeList=MgEmployee.where("mg_employee_department_id=? and is_deleted=? and mg_school_id=? and id NOT IN (?)",@deptid,0,session[:current_user_school_id],empId)
                else
                      @employeeList=MgEmployee.where(:mg_employee_department_id=>@deptid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
                end
      else
      #@employeeList=MgEmployee.where("mg_employee_department_id=? and is_deleted=? and mg_school_id=?",@deptid,0,session[:current_user_school_id])
      @employeeList=MgEmployee.where(:mg_employee_department_id=>@deptid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      
      end
      @employee_ary=Array.new
      @employeeList.each do|list|
      list_ary=Array.new()
      first_name=list.first_name
      dept_data=MgEmployeeDepartment.find(list.mg_employee_department_id)
    if dept_data.present?
      dept_name=dept_data.department_name
    else
      dept_name="null"
    end
      key="#{first_name} "
      value=list.id
      list_ary.push(key,value)
      @employee_ary.push(list_ary)
    end
 render :layout=>false
  end


  def selected_employees
  
      @deptid=params[:dept_data]
      @subId=params[:mg_subject_id]
      if params[:mg_subject_id].present?
      empId=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_subject_id=>@subId,:incharge_type=>"Incharge").pluck(:mg_employee_id)
                if empId.present?
                      @employeeList=MgEmployee.where("mg_employee_department_id=? and is_deleted=? and mg_school_id=? and id NOT IN (?)",@deptid,0,session[:current_user_school_id],empId)
                else
                      @employeeList=MgEmployee.where("mg_employee_department_id=? and is_deleted=? and mg_school_id=?",@deptid,0,session[:current_user_school_id])
                end
     # @employeeList=MgEmployee.where("mg_employee_department_id=? and is_deleted=? and mg_school_id=? and id NOT IN (?)",@deptid,0,session[:current_user_school_id],empId)
      else
      @employeeList=MgEmployee.where("mg_employee_department_id=? and is_deleted=? and mg_school_id=?",@deptid,0,session[:current_user_school_id])
      end
      #@employeeList=MgEmployee.where(:mg_employee_department_id=>@deptid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @employee_ary=Array.new
      @employeeList.each do|list|
      list_ary=Array.new()
      first_name=list.first_name
      dept_data=MgEmployeeDepartment.find(list.mg_employee_department_id)
    if dept_data.present?
      dept_name=dept_data.department_name
    else
      dept_name="null"
    end
      key="#{first_name} "
      value=list.id
      list_ary.push(key,value)
      @employee_ary.push(list_ary)
    end
 render :layout=>false
  end

  def incharge_create
    mg_employee_id_arr=params[:selected_employees]
    for k in 0...mg_employee_id_arr.length
    laboratory_incharge=MgLaboratoryIncharge.new()
    laboratory_incharge.mg_employee_id=mg_employee_id_arr[k]
    laboratory_incharge.is_deleted=0
    laboratory_incharge.mg_school_id=session[:current_user_school_id]
    laboratory_incharge.created_by=session[:user_id]
    laboratory_incharge.updated_by=session[:user_id]
    laboratory_incharge.incharge_type="Incharge"
    laboratory_incharge.mg_subject_id=params[:laboratory][:mg_subject_id]
    laboratory_incharge.save
  end
  redirect_to :action=>"laboratory_settings_show"

  end

  def assistant_incharge_create
   mg_employee_id_arr=params[:selected_employees]
    for k in 0...mg_employee_id_arr.length
    laboratory_incharge=MgLaboratoryIncharge.new()
    laboratory_incharge.mg_employee_id=mg_employee_id_arr[k]
    laboratory_incharge.is_deleted=0
    laboratory_incharge.mg_school_id=session[:current_user_school_id]
    laboratory_incharge.created_by=session[:user_id]
    laboratory_incharge.updated_by=session[:user_id]
    laboratory_incharge.incharge_type="Assistant Incharge"
    laboratory_incharge.mg_subject_id=params[:laboratory][:mg_subject_id]
    laboratory_incharge.save
  end
  redirect_to :action=>"laboratory_settings_show"
  end


  def incharge_update
    incharge=MgLaboratoryIncharge.where(:incharge_type=>"Incharge",:mg_subject_id=>params[:subjectId],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    incharge.each do |incharge|
      incharge.update(:is_deleted=>1)
    end
    mg_employee_id_arr=params[:selected_employees]
    for k in 0...mg_employee_id_arr.length
    laboratory_incharge=MgLaboratoryIncharge.new()
    laboratory_incharge.mg_employee_id=mg_employee_id_arr[k]
    laboratory_incharge.is_deleted=0
    laboratory_incharge.mg_school_id=session[:current_user_school_id]
    laboratory_incharge.created_by=session[:user_id]
    laboratory_incharge.updated_by=session[:user_id]
    laboratory_incharge.incharge_type="Incharge"
    laboratory_incharge.mg_subject_id=params[:subjectId]
    laboratory_incharge.save
  end
  redirect_to :action=>"laboratory_settings_show"
  end


  def assistant_incharge_update
   # puts kjsdfhkjsdfh
     incharge=MgLaboratoryIncharge.where(:incharge_type=>"Assistant Incharge",:mg_subject_id=>params[:subjectId],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    incharge.each do |incharge|
      incharge.update(:is_deleted=>1)

    end   
                     
    mg_employee_id_arr=params[:selected_employees]
    for k in 0...mg_employee_id_arr.length
    laboratory_incharge=MgLaboratoryIncharge.new()
    laboratory_incharge.mg_employee_id=mg_employee_id_arr[k]
    laboratory_incharge.is_deleted=0
    laboratory_incharge.mg_school_id=session[:current_user_school_id]
    laboratory_incharge.created_by=session[:user_id]
    laboratory_incharge.updated_by=session[:user_id]
    laboratory_incharge.incharge_type="Assistant Incharge"
    laboratory_incharge.mg_subject_id=params[:subjectId]
    laboratory_incharge.save
  end
  redirect_to :action=>"laboratory_settings_show"
  end

  def show_laboratory_incharge
    @subId=params[:id]
    @incharge=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_subject_id=>params[:id],:incharge_type=>"Incharge")
    @assistantIncharge=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_subject_id=>params[:id],:incharge_type=>"Assistant Incharge")
  #puts khadjss

  end

  def laboratory_search
    employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    incharge=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>employee.id).count
      if incharge<1
        # flash[:notice]="Unauthorised User."
        # redirect_to(session[:last_url])
      end
    
  end

  def laboratory_search_data

    if (params[:itemName].present? && params[:itemCode].present?)
    @search=MgInventoryManagement.where("is_deleted=? and mg_school_id=? and item_name LIKE ? and item_identification_number LIKE ?",0,session[:current_user_school_id],"%#{params[:itemName]}%","%#{params[:itemCode]}%")
    puts "norrrr"
    elsif params[:itemName].present?
    @search=MgInventoryManagement.where("is_deleted=? and mg_school_id=? and item_name LIKE ?",0,session[:current_user_school_id],"%#{params[:itemName]}%")
    puts "no"
    elsif params[:itemCode].present?
    @search=MgInventoryManagement.where("is_deleted=? and mg_school_id=? and item_identification_number LIKE ?",0,session[:current_user_school_id],"%#{params[:itemCode]}%")
    puts "yes"
    end
    
    render :layout=>false

  end

  def generate_fine
    #  @fineparticular=MgFeeFineParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id]).not(mg_laboratory_subject_id:"").paginate(page: params[:page], per_page: 5)
      @fineparticular=MgFeeFineParticular.where("is_deleted=? and mg_school_id=? and mg_laboratory_subject_id not IN (?)",0,session[:current_user_school_id],"").paginate(page: params[:page], per_page: 5)
    
  end

  def newfineparticular
     @fineparticular=MgFeeFineParticular.new()
  render :layout=>false
  end

  def savefineParticularFee
    
  end

  def savefineParticularFee
    @selected_batches1 = params[:selected_batches1]


    @params=params[:selectedStudents]

   
    

    if params[:fesses2][:value1] == 'demo'  #using student admission number
      for i in 0...@params.size
       puts"inside if save particular"
       @feeParticularObj=MgFeeFineParticular.new(fine_particular_params) 
       @feeParticularObj.update(:fine_from=>"#{params[:fesses2][:mg_laboratory_subject_id]} #{params[:fesses2][:mg_laboratory_room_id]}")
       @data=MgStudent.find(@params[i])
       @batchID=@data.mg_batch_id
        @feeParticularObj.mg_batch_id=@batchID
        @feeParticularObj.mg_student_id= @data.id
       @current_school_obj = MgSchool.find(session[:current_user_school_id])
       @startDate = Date.strptime(params[:fesses2][:start_date],@current_school_obj.date_format)
        @endDate = Date.strptime(params[:fesses2][:end_date],@current_school_obj.date_format)
        @dueDate = Date.strptime(params[:fesses2][:due_date],@current_school_obj.date_format)
       @feeParticularObj.start_date=@startDate
        @feeParticularObj.end_date=@endDate
        @feeParticularObj.due_date=@dueDate
        if params[:fesses2][:mg_account_id].present?
          if params[:fesses2][:mg_account_id]=="central"
            @feeParticularObj.is_to_central=1
          else
            @feeParticularObj.mg_account_id=params[:fesses2][:mg_account_id]
          end
        end
       @feeParticularObj.save
     end
       

    else
      if params[:fesses2][:value1] == 'All'
        for i in 0...@selected_batches1.size
          @feeparticulars2=MgFeeFineParticular.new(fine_particular_params)
       #@feeParticularObj.update(:fine_from=>params[:fine_from])
       @feeparticulars2.update(:fine_from=>"#{params[:fesses2][:mg_laboratory_subject_id]} #{params[:fesses2][:mg_laboratory_room_id]}")


            @feeparticulars2.mg_batch_id = @selected_batches1[i]
            @current_school_obj = MgSchool.find(session[:current_user_school_id])
              @startDate = Date.strptime(params[:fesses2][:start_date],@current_school_obj.date_format)
              @endDate = Date.strptime(params[:fesses2][:end_date],@current_school_obj.date_format)
              @dueDate = Date.strptime(params[:fesses2][:due_date],@current_school_obj.date_format)
              @feeparticulars2.start_date=@startDate
             @feeparticulars2.end_date=@endDate
              @feeparticulars2.due_date=@dueDate
              if params[:fesses2][:mg_account_id].present?
          if params[:fesses2][:mg_account_id]=="central"
            @feeparticulars2.is_to_central=1
          else
            @feeparticulars2.mg_account_id=params[:fesses2][:mg_account_id]
          end
        end
             @feeparticulars2.save
          end
          
        end


          if params[:fesses2][:value1] == 'demo2' 
          for i in 0...@selected_batches1.size #using student category
            puts"inside demo2"
            @feeparticulars2=MgFeeFineParticular.new(fine_particular_params)
       #@feeParticularObj.update(:fine_from=>params[:fine_from])
       @feeParticularObj.update(:fine_from=>"#{params[:fesses2][:mg_laboratory_subject_id]} #{params[:fesses2][:mg_laboratory_room_id]}")


           
            @feeparticulars2.mg_batch_id = @selected_batches1[i]
           # @feeparticulars2.mg
            student_category_id=params[:fesses2][:mg_student_category_id]

            @current_school_obj = MgSchool.find(session[:current_user_school_id])
              @startDate = Date.strptime(params[:fesses2][:start_date],@current_school_obj.date_format)
              @endDate = Date.strptime(params[:fesses2][:end_date],@current_school_obj.date_format)
              @dueDate = Date.strptime(params[:fesses2][:due_date],@current_school_obj.date_format)
       
              @feeparticulars2.start_date=@startDate
              @feeparticulars2.end_date=@endDate
              @feeparticulars2.due_date=@dueDate
              if params[:fesses2][:mg_account_id].present?
          if params[:fesses2][:mg_account_id]=="central"
            @feeparticulars2.is_to_central=1
          else
            @feeparticulars2.mg_account_id=params[:fesses2][:mg_account_id]
          end
        end
             @feeparticulars2.save
          end

          
         
        end

    end
    redirect_to :action=>'generate_fine',:controller=>'laboratory'
  end

  def show_fine_fee_particular
    @fine_particular = MgFeeFineParticular.find(params[:id])
    render :layout => false
  end


  def edit_fine_fee_particular
  @fesses2 = MgFeeFineParticular.find(params[:id])
  @cceID=Array.new
     @cceID.push(@fesses2.mg_batch_id)
    render :layout => false
end


def update_fee_fine_particular
   @feeParticularObj = MgFeeFineParticular.find(params[:id])
   @timeformat = MgSchool.find(session[:current_user_school_id])
    @startDate = Date.strptime(params[:fesses2][:start_date],@timeformat.date_format)
    @endDate = Date.strptime(params[:fesses2][:end_date],@timeformat.date_format)
    @dueDate = Date.strptime(params[:fesses2][:due_date],@timeformat.date_format)

    @feeParticularObj.update(:start_date=>@startDate, :end_date=>@endDate, :due_date=>@dueDate, :mg_laboratory_room_id=>params[:mg_laboratory_room_id],:fine_from=>"#{params[:fesses2][:mg_laboratory_subject_id]} #{params[:mg_laboratory_room_id]}")

    @feefineParticularParams = update_fine_particular_params
    @params=params[:selectedStudents]

    if(params[:fesses2][:value1]=='All')
    #@feefineParticularParams[:admission_no] = ''
    @feefineParticularParams[:mg_student_category_id] =''
    end

    if(params[:fesses2][:value1]=='demo')
      

    #@feefineParticularParams[:admission_no] =  params[:fesses2][:admission_no] 
    @feefineParticularParams[:mg_student_category_id] =''
    end

    if(params[:fesses2][:value1]=='demo2')         
     #@feefineParticularParams[:admission_no] = ''  
     @feefineParticularParams[:mg_student_category_id] =params[:fesses2][:mg_student_category_id]
    end
         
    @feeParticularObj.update(@feefineParticularParams)
    redirect_to '/laboratory/generate_fine'
end


def destroy_fee_fine_particular
    @fees=MgFeeFineParticular.find_by_id(params[:id])
    @fees.is_deleted =1
    @fees.save
    redirect_to '/laboratory/generate_fine'
  end



























  private
  # def new_incharge_params
  #   params.require(:laboratory).permit(:is_deleted,:mg_school_id,:created_by,:updated_by,)
  # end

  def params_subject
  params.require(:laboratory).permit(:name,:description,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def params_update_subject
  params.require(:laboratory).permit(:name,:description,:is_deleted,:updated_by,:mg_school_id)
  end



  def laboratory_details_params
    params.require(:laboratory_purchase_details).permit(:mg_laboratory_subject_id,:mg_room_id,:vendor_name,:date,:amount_paid,:mg_school_id)
  end

  def lab_params
    params.require(:laboratry).permit(:room_no,:mg_laboratory_subject_id,:lab_name,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end
  def inven_params
    params.require(:laboratry).permit(:mg_lab_id,:category_name,:is_deleted,:created_by,:updated_by,:mg_school_id,:mg_laboratory_item_id,:prefix)
  end
  def unit_params
    params.require(:laboratry).permit(:unit_name,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end
  def management_params
    params.require(:laboratry).permit(:mg_laboratory_subject_id,:mg_laboratory_room_id,:item_identification_number,:valid_upto,:item_location,:mg_lab_id,:mg_category_id,:item_name,:item_description,:quantity,:mg_unit_id,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end
  def management_update_params
    params.require(:laboratry).permit(:valid_upto,:item_location,:item_name,:item_description,:quantity,:mg_unit_id,:is_deleted,:updated_by,:mg_school_id)
  end 
  def consumption_params
    params.require(:laboratry).permit(:mg_laboratory_item_type_id,:mg_laboratory_subject_id,:mg_laboratory_room_id,:mg_lab_id,:mg_category_id,:mg_item_id,:quantity_consumption,:date,:consumption_type,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end
  def consumption_update_params
    params.require(:laboratry).permit(:mg_laboratory_item_type_id,:mg_laboratory_subject_id,:mg_lab_id,:mg_category_id,:mg_item_id,:quantity_consumption,:date,:consumption_type,:updated_by)
  end
  def purchase_details_params
    params.require(:laboratry).permit(:mg_laboratory_subject_id,:mg_room_id,:vendor_name,:date,:amount_paid,:mg_school_id)
  end
  def laboratory_item_params
    params.require(:laboratory).permit(:is_issuable,:name,:description,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end
  def item_update_params
    params.require(:laboratory).permit(:is_issuable,:name,:description,:is_deleted,:mg_school_id,:updated_by)
  end
  def fine_particular_params
    params.require(:fesses2).permit(:mg_laboratory_subject_id,:mg_laboratory_room_id,:fine_name,:description,:is_deleted, :mg_school_id,:amount,
     :admission_no, :mg_student_category_id)
  end
  def update_fine_particular_params
    params.require(:fesses2).permit(:mg_laboratory_subject_id,:fine_name,:description,:is_deleted, :mg_school_id,:amount,
     :mg_student_category_id)
  end
end
