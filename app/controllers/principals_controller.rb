#com
class PrincipalsController < ApplicationController
    before_filter :login_required
	layout "mindcom"

	def index
		
		puts "ShowMethod "
    #Added By Bindhu
    principal_user_id=MgUser.where(:user_type=>"principal",:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
		if principal_user_id.length >0
      @employee_data = MgEmployee.where(:mg_user_id=>principal_user_id[0].id)

    #end By Bindhu
    # @employee_data = MgEmployee.where(:id=>3) Commented By Bindhu
		puts @employee_data.inspect
 		
 		@employeeUserId= @employee_data[0].mg_user_id
 		@employee = @employee_data[0]

 		@address=MgAddress.where(mg_user_id: @employeeUserId)

 		puts "Step --1"
		puts @address.inspect
 		puts "Step --2"

        @contact=MgPhone.where(mg_user_id: @employeeUserId)
        puts "Step --11"
		puts @contact.inspect
 		puts "Step --22"
        @email=MgEmail.where(mg_user_id: @employeeUserId)
        puts "Step --111"
		puts @contact.inspect
 		puts "Step --222"
		#render 'show'
    else
      @employee_data=MgEmployee.new
    end
		
	end


  def syllabus_tracker_show
    
  end

  def tracker_edit


      @syllabus = MgSyllabusTracker.find(params[:id])
      puts "888888888888"
      
    end





    def tracker_update
      @syllabus = MgSyllabusTracker.find(params[:id])
     
      if @syllabus.update(track_param)
        redirect_to :controller => "principals" , :action => "syllabus_tracker_show"
      else
        render 'tracker_edit'
      end
    end


    def tracker_delete

      @syllabus = MgSyllabusTracker.find(params[:id])
      
      if @syllabus.update(:is_deleted => 1)
        render 'syllabus_tracker_show'
        else
      
      end
      
    end



def syllabus_track
      #   @courses=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      #   @dataHash=Hash.new
      #   @courses.each do |course|
      #       @batches=MgBatch.where(:mg_course_id=>course.id)
      #       @batches.each do |batch|
      #           subject_ids=MgBatchSubject.where(:mg_batch_id=>batch.id)
      #           #For each subject in batch
      #           subject_ids.each do |subjectID|

      #               subject=MgSubject.find(subjectID.mg_subject_id)
      #               syllabus_ids=MgSyllabus.where(:mg_subject_id=>subject.id).pluck(:id)
                    
      #               @array=Array.new
      #               syllabus_ids.each do |syllabusID|
      #                 # expected_time=MgSyllabusTracker.where(:mg_syllabus_id=>syllabusID).pluck(:expected_class).count
      #                 # puts "Expected Time"
      #                 # puts expected_time
      #                   alloated_time=MgUnit.where(:mg_syllabus_id=>syllabusID)
      #                   alloated_time.each do |time|
      #                     @array=Array.new
      #                     @array.push(subject.subject_name,batch.name)
      #                     @dataHash[@array]=time.time
      #                   end
      #               end
      #           end
      #       end
      # end
end



    def principle_new
  @demo=params[:mg_department_id]
  puts "778888888888888888888888"
  puts @demo.inspect
  puts "778888888888888888888888"
  render :layout => false
end

def principle_data
  @empPrincipleId=params[:mg_employee_id]
  puts "778888888888888888888888"
  puts @empPrincipleId.inspect
  puts "778888888888888888888888"
  render :layout => false
end
	

	def show
          
		 
		
	end



   #==========below part updated on 15th jan=================================
   def pdf_gen
@@temp=1
    @employeedatas=MgEmployee.find(params[:id])
     school=MgSchool.find(session[:current_user_school_id])
    @@school_logo=school.logo.url(:medium, timestamp: false)
     @@emp_photo=@employeedatas.photo.url
      @last_employee = @employeedatas.id
      puts "before mg_user_id"
      @employeeUserId= @employeedatas.mg_user_id
      @customData = MgCustomFieldsData.where(mg_user_id:@employeeUserId)
#customfield========================================================================
@get_std_value="select value, mg_custom_field_id from mg_custom_fields_data where mg_user_id=#{@employeeUserId}"
            @get_std_valu=MgCustomFieldsData.find_by_sql(@get_std_value)
      get_std_v=@get_std_valu.as_json 
#if (@get_std_valu != nil)
  #if @get_std_v.nil?
  if  @get_std_valu[0].to_s.empty?
    @@temp=2
  else
      @mg_cu_fi_ID=@get_std_valu[0].mg_custom_field_id
            @get_std_nam=MgCommonCustomField.find_by_id(@mg_cu_fi_ID)
      get_std_n=@get_std_nam.as_json 
  end
#customfield========================================================================





     
puts "@employeeUserId"
puts "userid======================"
        @employee_details="select employee_number, DATE_FORMAT(joining_date,'%d-%m-%Y') 'joining date', first_name, middle_name,last_name, gender,DATE_FORMAT(date_of_birth,'%d-%m-%Y') 'date of birth',job_title, qualification, blood_group,language,experience_year,experience_month from mg_employees  where id=#{@employeedatas.id}"
       @employee_details=MgEmployee.find_by_sql(@employee_details)
       std_all_dada=@employee_details.as_json 

       principal_personal_detail_query="select marital_status,mother_name,father_name,nationality from mg_employees  where id=#{@employeedatas.id}"
       principal_personal_detail=MgEmployee.find_by_sql(principal_personal_detail_query)
       principal_personal_detail_as_json=principal_personal_detail.as_json
       puts "principal_personal_detail_as_json===="
       puts principal_personal_detail_as_json

#      #= @get_std_value="select  value, mg_custom_field_id from mg_custom_fields_data where mg_user_id=#{@employeeUserId}"
#        #=     @get_std_valu=MgCustomFieldsData.find_by_sql(@get_std_value)
#             #=============================================================

      @get_emp_paddress="select  address_line1, address_line2, city, state , pin_code,street,country,landmark from mg_addresses where mg_user_id=#{@employeeUserId} AND address_type='Permanent'"
            @emp_p=MgAddress.find_by_sql(@get_emp_paddress)
      std_p=@emp_p.as_json 

      

      #c address
      @get_emp_caddress="select  address_line1, address_line2, city, state , pin_code,street,country,landmark from mg_addresses where mg_user_id=#{@employeeUserId} and address_type='Temporary'"
            @emp_ca=MgAddress.find_by_sql(@get_emp_caddress)
      std_c=@emp_ca.as_json 

      #STUDENT HOME PHONE NUMBER
      @emp_h_phone="SELECT phone_number,notification,
subscription from mg_phones where mg_user_id=#{@employeeUserId} and phone_type='mobile'"
      @emp_h_phone=MgPhone.find_by_sql(@emp_h_phone)
      std_h_phone=@emp_h_phone.as_json
      # logger.info "inside phone"
      # logger.info std_h_phone

      #STUDENT HOME PHONE NUMBER
      @emp_p_phone="SELECT phone_number from mg_phones where mg_user_id=#{@employeeUserId} and phone_type='phone'"
      @emp_p_phone=MgPhone.find_by_sql(@emp_p_phone)
      std_p_phone=@emp_p_phone.as_json
      puts"phone==============================================================================="
      # logger.info "inside phone"
      # logger.info std_p_phone \\@email=MgEmail.where(mg_user_id: @studentUserId)
      @emp_email="SELECT mg_email_id,notification,
subscription from mg_emails where mg_user_id=#{@employeeUserId}"
      @emp_email=MgEmail.find_by_sql(@emp_email)
      employee_email=@emp_email.as_json

      #emergency Contact detail
      @principal_emergency_query="select emergency_contact_name,emergency_contact_number from mg_employees where id=#{@employeedatas.id}"
      @principal_emergency_contact_detail=MgEmployee.find_by_sql(@principal_emergency_query)
      principal_emergency_as_json=@principal_emergency_contact_detail.as_json


      @@employeedatas=@employeedatas.id
      @@some=@employeedatas.mg_user_id
      @@stu="0"+@@employeedatas.to_s
      @@stuphoto=@@some.to_s+".jpeg"


puts  "email doneeeeeeeeeeeeeeeeeeeeeeee"
      pdf = Prawn::Document.new do

            
        #this code for stamp
        #here this code should be first line of the code
             # create_stamp("approved this") do
             #        rotate(30, :origin => [-5, -5]) do
             #        stroke_color "FF3333"
             #        stroke_ellipse [0, 0], 100, 50
             #        stroke_color "000000"
             #        fill_color "993456"
             #        font("Times-Roman") do
             #        draw_text "approved this", :at => [-23, -3]
             #        end
             #        fill_color "000000"
             #        end
             #        end
             #        stamp "approved this"
             #        stamp_at "approved this", [200, 400]


                      # 2.times do
                      #     start_new_page
                      # end

                  repeat :all do

                    # header
                        bounding_box [bounds.left, bounds.top],:align => :right, :width  => bounds.width do
                          font "Helvetica"
                          if File.exists?("#{Rails.root}/public/#{@@school_logo}") 
                             image( "#{Rails.root}/public/#{@@school_logo}",:width =>  45)
                            # image ("#{Rails.root}/public/#{@@school_logo}"),:at=>[425,690],:width=>45
                            # image "#{Rails.root}/public/#{@@school_logo}", :width => 45, :align => :left
                          
                           end
                           move_up 15
                          text school.school_name, :align => :center, :size => 18
                          stroke_horizontal_rule
                         end
        move_down 10

        # footer
                        bounding_box [bounds.left, bounds.bottom + 45], :width  => bounds.width do
                            font "Helvetica"
                            stroke_horizontal_rule
                            move_down(5)
                            # text " Powered By - ©", :size => 12
                            move_down 12
                            draw_text "Terms & Conditions| Privacy Policy| About Us| Contact Us",:at => [70,3]
                            draw_text "Powered By - ©", :at => [400,3]
                            image "#{Rails.root}/app/assets/images/mindcom-logo.png", :at=>[495,15], :width => 45, :align => :right
                        end
                  end
               

 bounding_box([bounds.left, bounds.top - 60], :width  => bounds.width, :height => bounds.height - 100) do


                      # string = "page <page> of <total>"
                      # # Green page numbers 1 to 11
                      # options = { :at => [bounds.right - 150, 0],
                      #  :width => 150,
                      #  :align => :right,
                      #  :page_filter => (1..11),
                      #  :start_count_at => 1,
                      #  :color => "018fda" }
                      # number_pages string, options

                   
                    puts "before general llllllllllllllll"

                    if  File.exists?("#{Rails.root}/public/#{@@emp_photo}")
                            # image "#{Rails.root}/public/#{@@emp_photo}", :align => :right, :width =>45
                            image("#{Rails.root}/public/#{@@emp_photo}", :at => [450,600], :width =>  65)
                        else
                          
                            
                        end
                     move_down 130
      text "General "
                    data =  Array.new
                    widths = Array.new(30, 50)
                    cell_height = 15
                    count=0
                    
                    $rowdata=Array.new
                    
                    std_all_dada[0].each_with_index { |(key, value), index|
                    if index % 2==0
                      $rowdata=Array.new
                    end
                     if(key != 'id') 
                     

                      if( key =='date of birth')
                        str="Date of Birth"
                      elsif key=="language"
                        str="Mother Tounge"                          
                      else
                          str=key.tr('_', ' ') 
                          str=str.titleize
                      end    
                                
                    inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)
                              
                                # display +=["#{value}"]
                    end
                    $rowdata +=[inner_table]
                    if index % 2==1
                    table([$rowdata],:column_widths => 270)  
                     
                    end 

                    }

                    move_down 25


      text "Personal Detail "
                    data =  Array.new
                    widths = Array.new(30, 50)
                    cell_height = 15
                    count=0
                    
                    $rowdata=Array.new
                    
                    principal_personal_detail_as_json[0].each_with_index { |(key, value), index|
                    if index % 2==0
                      $rowdata=Array.new
                    end
                     if(key != 'id') 
                          str=key.tr('_', ' ') 
                          str=str.titleize
                                
                    inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)
                              
                                # display +=["#{value}"]
                    end
                    $rowdata +=[inner_table]
                    if index % 2==1
                    table([$rowdata],:column_widths => 270)  
                     
                    end 

                    }

                    move_down 25

      text "Permanent Address"
                    data =  Array.new
                    widths = Array.new(30, 50)
                    cell_height = 15
                    count=0
                    
                    $rowdata=Array.new
      
                    std_p[0].each_with_index { |(key, value), index|
                    if index % 2==0
                      $rowdata=Array.new
                    end
                    # display=Array.new
                                # display +=["#{key}",":","#{value}"]
                                str=key.tr('_', ' ') 
                    str=str.titleize
                    inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)
                              
                                # display +=["#{value}"]
                               
                    $rowdata +=[inner_table]
                    if index % 2==1
                    table([$rowdata],:column_widths => 270)  
                     
                    end 
                    }
                    move_down 25

      text "Correspondence Address"
                    data =  Array.new
                    widths = Array.new(30, 50)
                    cell_height = 15
                    count=0
                    
                    $rowdata=Array.new
      
                    std_c[0].each_with_index { |(key, value), index|
                    if index % 2==0
                      $rowdata=Array.new
                    end
                    # display=Array.new
                                # display +=["#{key}",":","#{value}"]
                                str=key.tr('_', ' ') 
                    str=str.titleize
                    inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)
                              
                                # display +=["#{value}"]
                               
                    $rowdata +=[inner_table]
                    if index % 2==1
                    table([$rowdata],:column_widths => 270)  
                     
                    end 
                    }
                    move_down 25

          
      text "Contact Details "
                    data =  Array.new
                    widths = Array.new(30, 50)
                    cell_height = 15
                    count=0
                    
                    $rowdata=Array.new
                    
                      std_h_phone[0].each_with_index { |(key, value), index|
                            if(key=='phone_number')
                            $phone1 = value
                            end
                          }
                           std_h_phone[0].each_with_index { |(key, value), index|

                           if(key=='notification')
                            $notification = value
                            end
                          }
                          std_h_phone[0].each_with_index { |(key, value), index|

                           if(key=='subscription')
                            $subscription = value
                            end
                          }
                           std_p_phone[0].each_with_index { |(key, value), index|
                            if(key=='phone_number')
                            $phone2 = value
                            end
                          }
        #phone No       

                    table([
                        ["Phone Number","#{$phone2}", "Mobile Number","+91-#{$phone1}"]
                        ],:column_widths => 135) 
                    table([
                        ["Notification","#{$notification}", "Subscription","#{$subscription}"]
                        ],:column_widths => 135)

                  
                   
                    employee_email[0].each_with_index { |(key, value), index|
                            if(key=="mg_email_id")
                              $email_id = value
                            end
                          }
                           employee_email[0].each_with_index { |(key, value), index|
                            if(key=="notification")
                             $emailnotification = value
                            end
                          }
                           employee_email[0].each_with_index { |(key, value), index|
                            if(key=='subscription')
                            $emailsubscription = value
                            end
                          }

                    table([
                        ["Email Id","#{$email_id}"]
                        ],:column_widths => 135) 
                    table([
                       ["Notification","#{$emailnotification}", "Subscription","#{$emailsubscription}"]
                        ],:column_widths => 135)


                  
                    move_down 25


          text "Emergency Contact Details "
            data =  Array.new
                    widths = Array.new(30, 50)
                    cell_height = 15
                    count=0
                    
                    $rowdata=Array.new
      
                     principal_emergency_as_json[0].each_with_index { |(key, value), index|
                    if index % 2==0
                      $rowdata=Array.new
                    end
                    if key=="emergency_contact_name"
                      str="Contact Name"
                    else
                      str="Contact Number"
                      value="+91-"+"#{value}"
                      end
                    inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)

                               
                    $rowdata +=[inner_table]
                    if index % 2==1
                    table([$rowdata],:column_widths => 270)  
                     
                    end 
                    }
                    move_down 25


#===============================================================================================

if @@temp==2 #@get_std_valu.nil?

    puts "second if @get_std_valu"
    puts @get_std_valu.inspect
    puts "@check"
    puts @check.inspect
  #c 
else
        
        # puts "second else @get_std_valu"
        # puts @get_std_valu.inspect
        # text "Custom Fields"

        #             data =  Array.new
        #             widths = Array.new(30, 50)
        #             cell_height = 15
        #             count=0
                    
        #             $rowdata=Array.new
                    
        #               get_std_v[0].each_with_index { |(key, value), index|
        #                     if(key=='value')
        #                     $custvalue = value
        #                     end
        #                   }

        #                     get_std_n.each_with_index { |(key, value), index|
        #                     if(key=='name')
        #                     $custname = value
        #                     end
        #                    }
        
        #             table([
        #               ["#{$custname}","#{$custvalue}"]
                        
        #                 ],:column_widths => 135) 

                  
        #             move_down 25


end
#===============================================================================================


end


end
              

         # Sends the PDF as inline document with name x.pdf
            send_data pdf.render,   :info => {
                      :Title => "My title",
                      :Author => "John Doe",
                      :Subject => "My Subject",
                      :Keywords => "test metadata ruby pdf dry",
                      :Creator => "ACME Soft App",
                      :Producer => "Prawn",
                      :CreationDate => Time.now
                      }, :filename => "x.pdf", :type => "application/pdf", :disposition => 'inline'
  end


    
    #==========above part updated on 15th jan=================================





   def edit
   	puts "edit method"
    # user=MgUser.where(:user_type=>"principal",:mg_school_id=>session[:current_user_school_id])
    # user_employee=MgEmployee.find_by(:mg_user_id=>user[0].id)

    @employee_data = MgEmployee.where(:id => params[:id])
    @employee = @employee_data[0]


    @dbdatas = MgCommonCustomField.where(model_name: "employee",mg_school_id:session[:current_user_school_id],is_deleted:0)
	  @customData = MgCustomFieldsData.where(mg_user_id:@employee.mg_user_id)

    @Permanent=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type => 'Permanent')
    @Temporary=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type => 'Temporary')

    @phone=MgPhone.find_by_mg_user_id_and_phone_type(@employee.mg_user_id, "phone")
     
    @mobile=MgPhone.find_by_mg_user_id_and_phone_type(@employee.mg_user_id, "mobile")
      
    #E-mail Work

    @email_address=MgEmail.find_by_mg_user_id_and_email_type(@employee.mg_user_id, "home")



    render :layout => false
   end

   def update
		puts "Update is have to Work"
		puts params[:employee].inspect

		@employee = MgEmployee.find(params[:id])
      
        @employeeId= @employee.mg_user_id


	    @temporary_address=MgAddress.find_by_mg_user_id_and_address_type(@employeeId, "Temporary")

	    @permanent_address=MgAddress.find_by_mg_user_id_and_address_type(@employeeId, "Permanent")

	    @phone_number=MgPhone.find_by_mg_user_id_and_phone_type(@employeeId, "phone")
	     
	    @mobile_number=MgPhone.find_by_mg_user_id_and_phone_type(@employeeId, "mobile")

	    @email_address=MgEmail.find_by_mg_user_id_and_email_type(@employeeId, "home")


	     if  @employee.update(employees_params)
	     	puts "Employee updated"

           @temporary_address.update(temporary_address_params)
           @permanent_address.update(permanent_address_params)

           @phone_number.update(emergency_phone_params)
           @mobile_number.update(personal_phone_params)

           @email_address.update(email_params)

         
          @timeformat = MgSchool.find(session[:current_user_school_id])
    
          @joiningDate = Date.strptime(params[:employee][:joining_date],@timeformat.date_format)
          @dateOfBirth = Date.strptime(params[:employee][:date_of_birth],@timeformat.date_format)

          @employee.update(:joining_date => @joiningDate,:date_of_birth => @dateOfBirth)


          

         redirect_to '/principals'
      end
		
	end

  def edit_contact_by_principle
    @employee=MgEmployee.find(params[:id])
      @phone = MgPhone.find_by(:mg_user_id => @employee.mg_user_id, :phone_type => 'phone')
      @mobile = MgPhone.find_by(:mg_user_id => @employee.mg_user_id, :phone_type => 'mobile')
      @email = MgEmail.find_by(:mg_user_id => @employee.mg_user_id, :email_type => 'home')
      @phone.update(emergency_phone_params)
      @mobile.update(personal_phone_params)
      @email.update(email_params_principle)
      redirect_to '/dashboards/principal_profile/'
  end

  def edit_permanent_address_by_principle
    @employee=MgEmployee.find(params[:id])
    @Permanent=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type=>"Permanent")

    @Permanent.update(permanent_address_params)

    redirect_to '/dashboards/principal_profile/'

    
  end

  def edit_correspondnce_address_by_principal
     @employee=MgEmployee.find(params[:id])
    @Temporary=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type=>"Temporary")

    @Temporary.update(temporary_address_params)

    redirect_to '/dashboards/principal_profile/'
  end

  def event_new
    @events=MgEvent.new()
      params.permit(:currentDate)
      @date=params[:currentDate]
      render :layout => false
  end

  def event_edit
    @events = MgEvent.find(params[:id])
    render :layout => false

    
  end

  def event_create
    @events=MgEvent.new(events_params)
    @events.save
         
    redirect_to :controller=>'dashboards', :action => "principle_events"
        
    
  end
  def event_update
    @events = MgEvent.find(params[:id])
     
       @events.update(events_params)
      redirect_to :controller=>'dashboards', :action => "principle_events"
 
  end

  def event_delete
    @events=MgEvent.find(params[:id])
      @events.is_deleted =1
      @events.save
      redirect_to :controller=>'dashboards', :action => "principle_events"
     
    
  end


   private 

   def employees_params
   	params.require(:employee).permit(:language, :employee_number, :joining_date, :first_name, :middle_name, :last_name, :gender, :job_title, :qualification, :experience_detail, :experience_year, :experience_month, :status, :status_description, :date_of_birth, :marital_status, :father_name, :mother_name, :blood_group, :mg_nationality_id, :is_deleted , :mg_school_id, :photo)
   end


    def temporary_address_params
       params.require(:Temporary).permit( :address_line1,:address_line2,:city,:state,:pin_code,:country ,:landmark, :address_type, :is_deleted)
    end

    def permanent_address_params
       params.require(:Permanent).permit( :address_line1,:address_line2,:city,:state,:pin_code,:country ,:landmark, :address_type, :is_deleted)
    end

    def emergency_phone_params
      params.require(:phone).permit(:phone_number, :notification, :subscription, :phone_type, :is_deleted)
    end
    def personal_phone_params
      params.require(:mobile).permit(:phone_number, :notification, :subscription, :phone_type, :is_deleted)
    end

    def email_params_principle
      params.require(:email).permit(:mg_email_id, :notification, :subscription, :email_type, :is_deleted)
    end

    def email_params
      params.require(:email_address).permit(:mg_email_id, :notification, :subscription, :email_type, :is_deleted)
    end


    def track_param
        params.require(:syllabus).permit(:mg_employee_id,:mg_syllabus_id,:mg_unit_id,:mg_topic_id,:date, :is_deleted)
    end
     def events_params
    params.require(:events).permit(:end_date,:title, :mg_event_type_id, :event_privacy, :event_description,  :start_time, :end_time, :all_day, :editable, :is_deleted, :event_date)
  end
  def permission_param
    params.require(:permission).permit(:is_lock, :date, :mg_school_id, :created_by, :updated_by, :is_deleted)
  end
   
end
