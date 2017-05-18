class StudentsController < ApplicationController
	#com
	layout "mindcom"
    before_filter :login_required

    def search_student_data

    puts "Stepeeddd "
    puts params[:student].nil?
    puts "Stepeeddd "

    if params[:student].nil?
    	@student_list = MgStudent.where("first_name LIKE :fname",{:fname => "%"}).paginate(page: params[:page], per_page: 10)
    else
		@student_list = MgStudent.where("first_name LIKE :fname",{:fname => "#{params[:student][:searchData]}%"}).paginate(page: params[:page], per_page: 10)
    end


    end

	def new
		@student = MgStudent.new
		@dbdatas = MgCommonCustomField.where(model_name: "student",is_deleted:0,mg_school_id:session[:current_user_school_id])

    	# find_data = MgStudent.first
    	# if MgStudent.count.zero? # empty array
     #  		@strVal='1'
    	# else
	    # 	@lastrecord = MgStudent.last
	    # 	@lastadmissionId= @lastrecord.id.to_i
	    # 	@nextAdmissionNumber = @lastadmissionId + 1;
	    # 	@strVal = @nextAdmissionNumber.to_s
    	# end
		#render :layout => false
	end

	def create
		require 'mime/types'
		 begin
		MgUser.transaction do
@school_sub_domain=MgSchool.find(session[:current_user_school_id])
			if MgStudent.where(:mg_school_id=>session[:current_user_school_id]).count.zero? # empty array
	      		@strVal='1'
	    	else
		    @lastrecord = MgStudent.where(:mg_school_id=>session[:current_user_school_id]).last

		    	m=@school_sub_domain.subdomain.length
		    	n=@lastrecord.admission_number.length
		    	@lastadmissionId= @lastrecord.admission_number.slice(m+1, n)
		    	
		    	puts "Last Admission number Id"
		    	puts @lastadmissionId
		    	@nextAdmissionNumber = @lastadmissionId.to_i + 1;
		    	# ============================================================================
		    	@nextAdmissionNumber=@nextAdmissionNumber+20
		    	# ============================================================================
		    	puts @nextAdmissionNumber.inspect
		    	#logger.infoazdgjh
		    	puts "Next Admission Number"
		    	puts @nextAdmissionNumber
		    	@strVal = @nextAdmissionNumber.to_s
		    	puts "str value"
		    	puts @strVal	

	    	end

	    	@user = MgUser.new(user_params)

			@user.user_name="#{@school_sub_domain.subdomain}#{"S"}#{@strVal}"
			@user_obj = @user.save

			#If User Saved
			if @user_obj
				#For Student Start
				
				@student = @user.mg_students.build(student_params)
		    	@student.admission_number="#{@school_sub_domain.subdomain}#{"S"}#{@strVal}"
				#For Student End

				#For Address Start
				c_address = @user.mg_addresses.build(correspondace_address_params)
		    	p_address = @user.mg_addresses.build(permanent_address_params)
				#For Address End

				#For Phone Start
				phone = @user.mg_phones.build(phone_params)
		    	personal_phone = @user.mg_phones.build(personal_phone_params)
				#For Phone End

				#For Email Start
				email = @user.mg_emails.build(email_params)
				#For Email End

				#For User Role Start
				@user_role = @user.mg_user_roles.build( :mg_role_id => 2)
            	@user_role.save
				#For User Role End

				#For Custom Fields Start
				@custFieldNameIds = params[:custom_data]
				if @custFieldNameIds.nil?
				else
					for j in 0...@custFieldNameIds.size
			     
			      			@custFieldValObj = params[:"custom_field_#{@custFieldNameIds[j]}"]

			     			@custFieldVal = nil

			     			if !@custFieldValObj.nil? && @custFieldValObj.size>0

			      				@custFieldVal =@custFieldValObj[0];

			        			for index in 1...@custFieldValObj.size 
			          			@custFieldVal << ','+@custFieldValObj[index]

			         			end 
			      			end   
			      			logger.info("==================================================")
			      			logger.info(@custFieldVal.inspect)
			      			@data=params[:status1]
			      			puts @data.inspect

			         		@savedetails=MgCustomFieldsData.new(save_params) 
			            	@savedetails.value=@custFieldVal
			             	@savedetails.mg_custom_field_id=@custFieldNameIds[j]
			             	@savedetails.mg_user_id = @user.id
			             	@savedetails.is_deleted = 0
			             	@savedetails.mg_school_id = session[:current_user_school_id]
			           		@savedetails.save
			        
			    
			 			end
			 		end
				#For Custom Fields End
				@timeformat = MgSchool.find(session[:current_user_school_id])

				@student.save
				@admissionDate = Date.strptime(params[:student][:admission_date],@timeformat.date_format)
				@dateOfBirth = Date.strptime(params[:student][:date_of_birth],@timeformat.date_format)
				@student.update(:admission_date => @admissionDate,:date_of_birth => @dateOfBirth)
				c_address.save
		    	p_address.save
		    	phone.save
		    	personal_phone.save
		    	email.save
		    	@last_studentId=@student.id

		    	if params[:sibling][:name].to_s.present?
			    	@sibling = MgSibling.new(sibling_params)
					@sibling.save
					@sibling.update(:mg_user_id => @student.mg_user_id)
					
					if params[:sibling][:admission_date].present?
						@admissionDates = Date.strptime(params[:sibling][:admission_date],@timeformat.date_format)
						@sibling.update(:admission_date => @admissionDates)						
					end #sibiling admission date end
			    end # If sibiling present
			    require 'open-uri'

			    if params[:employeechild][:employee_name].present?
			    	@employeechild = MgEmployeeChild.new(empchild_params)
					@employeechild.save
					@employeechild.update(:mg_user_id => @student.mg_user_id)
					if params[:employeechild][:joining_date].present?
					#@admissionDates = Date.strptime(params[:employeechild][:joining_date],@timeformat.date_format)
					joining_date = Date.strptime(params[:employeechild][:joining_date],@timeformat.date_format)
					@employeechild.update(:joining_date => joining_date)
				    end #employee child joining date end
				end #if employee child

				if params[:managementquota][:name].present?
			    	@managementquota = MgManagementQuota.new(mngment_params)
					@managementquota.save
					@managementquota.update(:mg_user_id => @student.mg_user_id)
					if params[:managementquota][:joining_date].present?
					admissionDates = Date.strptime(params[:managementquota][:joining_date],@timeformat.date_format)
					
					@managementquota.update(:joining_date => admissionDates)
				    end #managementquota joining date
				end #if managementquota 

				if params[:scholarship][:name].present?
			    	@scholarship = MgStudentScholarship.new(scholar_params)
					@scholarship.save
					@scholarship.update(:mg_user_id => @student.mg_user_id)
					
					if (params[:scholarship][:start_date].present? && params[:scholarship][:end_date].present?)
						
						@startDates = Date.strptime(params[:scholarship][:start_date],@timeformat.date_format)
						@endDates = Date.strptime(params[:scholarship][:end_date],@timeformat.date_format)
						@scholarship.update(:start_date => @startDates,:end_date => @endDates)

					elsif (params[:scholarship][:start_date].present?)
						
						@startDates = Date.strptime(params[:scholarship][:start_date],@timeformat.date_format)
						@scholarship.update(:start_date => @startDates)

					elsif (params[:scholarship][:end_date].present?)
						
						@endDates = Date.strptime(params[:scholarship][:end_date],@timeformat.date_format)
						@scholarship.update(:end_date => @endDates)
					end
				end #Scholarship end

				@previous_educations=MgPreviousEducation.new(edu_params)
			  	@previous_educations.mg_student_id=@student.id
			  	@previous_educations.is_transfer_certificate_produced=params[:is_transfer_certificate_produced]
			  	@previous_educations.save

			  	@file=params[:transferfiles]
			  	if @file.nil?
			  	else
			  		@file.each do |a|
				  		 @fileupload=MgDocumentManagement.new()
				  		 @fileupload.file=a
				  		 puts @student.mg_user_id
				  		 @fileupload.document_type="TransferCertificate"
				  		 @fileupload.mg_user_id=@student.mg_user_id
				  		 @fileupload.save
		  			end
		  		end #transferfiles end

	  			@file=params[:file]
		  		if @file.nil?
		  		else
			  		 @file.each do |a|
				  		 @fileupload=MgDocumentManagement.new()
				  		 @fileupload.file=a
				  		 puts @student.mg_user_id
				  		 @fileupload.document_type="SportsActivity"
				  		 @fileupload.mg_user_id=@student.mg_user_id
				  		 @fileupload.save
			  		end
		  		end #SportsActivity end

		  		@files=params[:files]
		  		puts params[:files].inspect
		  		if @files.nil?
		  		else
			  		 @files.each do |a|
				  		 @fileupload=MgDocumentManagement.new()
				  		 @fileupload.file=a
				  		 puts @student.mg_user_id
				  			@fileupload.document_type="ExtraCurricular"
				  		 @fileupload.mg_user_id=@student.mg_user_id
				  		 @fileupload.save
			  		end
		  		end #ExtraCurricular end

		  		@files=params[:healthrecordfiles]
		  		puts params[:healthrecordfiles].inspect
		  		if @files.nil?
		  		else
			  		 @files.each do |a|
				  		 @fileupload=MgDocumentManagement.new()
				  		 @fileupload.file=a
				  		 puts @student.mg_user_id
				  		 @fileupload.document_type="HealthRecords"
				  		 @fileupload.mg_user_id=@student.mg_user_id
				  		 @fileupload.save
		  			 end
		  		end #HealthRecords end

		  		@files=params[:classfiles]
		  		puts params[:classfiles].inspect
		  		if @files.nil?
		  		else
			  		 @files.each do |a|
				  		 @fileupload=MgDocumentManagement.new()
				  		 @fileupload.file=a
				  		 puts @student.mg_user_id
				  		 @fileupload.document_type="ClassRecords"
				  		 @fileupload.mg_user_id=@student.mg_user_id
				  		 @fileupload.save
			  		end
		  		end #ClassRecords End
		  		redirect_to :controller=>'guardians', :action=>'new',:id=>@student.id
		  		#redirect_to '/guardians/new'
		  	else
		  		redirect_to '/students',:notice=>"Duplicate Record"
			end #If User save end

		end #Transaction end
		rescue
		flash[:error]="Error occured, please contact administrator"
		redirect_to :action=>'new'
	end
	end #method end

	def index


		puts "student index   "
		puts session[:current_user_school_id].inspect
		puts "student index   "



		# @student_list=MgStudent.where(:is_deleted => '0',:mg_school_id => $current_user_school_id.to_i).paginate(page: params[:page], per_page: 10)
		 @student_list=MgStudent.where(:is_deleted => '0',:mg_school_id => session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)




		#@student_list=MgStudent.all.paginate(page: params[:page], per_page: 5)
	end

	def show
		#logger.info "inside show"
		@student = MgStudent.find(params[:id])

		@studentUserId= @student.mg_user_id
		@studentCategoryId= @student.mg_student_catagory_id

		@address=MgAddress.where(mg_user_id: @studentUserId)
		puts @address.inspect
		@contact=MgPhone.where(mg_user_id: @studentUserId)
		@email=MgEmail.where(mg_user_id: @studentUserId)
		@studentCategory=MgStudentCategory.where(id: @studentCategoryId)


		@dbdatas = MgCommonCustomField.where(model_name: "student",is_deleted:0,mg_school_id:session[:current_user_school_id])

         @customData = MgCustomFieldsData.where(mg_user_id:@student.mg_user_id,is_deleted:0,mg_school_id:session[:current_user_school_id])
		@previous_education=MgPreviousEducation.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_student_id=>@student.id)

		#logger.info "@address"
		#logger.info @address.inspect
		logger.info "inside show"
		#render :layout => false
	end
	#modification on 14th jan..>>>>>>>>>>>>>>>>>>>>>


	def pdf_gen


@@temp=1
puts "-----------------------------------------------"
		puts "inside pdf_genpdf_genpdf_gen"
puts "------------------------------------------------"

		    @studentdatas=MgStudent.find(params[:id])
		     school=MgSchool.find(session[:current_user_school_id])
    		@@school_logo=school.logo.url(:medium, timestamp: false)
		    @@stu_photo=@studentdatas.avatar.url(:medium, timestamp: false)
			@last_student = @studentdatas.id
			puts "before mg_user_id"
			@studentUserId= @studentdatas.mg_user_id
			
			@customData = MgCustomFieldsData.where(mg_user_id:@studentUserId,is_deleted:0,mg_school_id:session[:current_user_school_id])
			
puts "@studentUserId"
puts "userid======================"
  			
      		@student_details="select admission_number, DATE_FORMAT(admission_date,'%d/%m/%Y') 'admission date', first_name, middle_name, last_name, DATE_FORMAT(date_of_birth,'%d/%m/%Y') 'date of birth', gender, blood_group,mg_batch_id,birth_place,language,religion,nationality,mg_student_catagory_id from mg_students  where id=#{@studentdatas.id}"
			 @student_details=MgStudent.find_by_sql(@student_details)
			 std_all_dada=@student_details.as_json

			 #Student category
			 #1.For Scholarship
			 @student_under_scholarship="select name,amount,frequency,DATE_FORMAT(start_date,'%d/%m/%Y') 'start date',DATE_FORMAT(end_date,'%d/%m/%Y') 'end date' from mg_student_scholarships where mg_user_id=#{@studentdatas.mg_user_id}" 
			 @student_scholarship_query=MgStudentScholarship.find_by_sql(@student_under_scholarship)
			 student_scholarship_data=@student_scholarship_query.as_json

			 #2.For Management
			 @management_query="select name,position, DATE_FORMAT(joining_date,'%d/%m/%Y') 'joining date' from mg_management_quota where mg_user_id=#{@studentdatas.mg_user_id}"
			 management_data=MgManagementQuota.find_by_sql(@management_query)
			 student_management_data=management_data.as_json

			 #3.For Employee child
			 @employee_child_query="select employee_name,employee_type,employee_id,employee_type from mg_employee_children where mg_user_id=#{@studentdatas.mg_user_id}"
			 employee_data=MgEmployeeChild.find_by_sql(@employee_child_query)
			 student_employee_data=employee_data.as_json

			 #for Sibiling Details
			 @sibiling="select name,relation,mg_course_id,mg_batch_id,roll_no,DATE_FORMAT(admission_date,'%d/%m/%Y') 'admission date',admission_no from mg_siblings where mg_user_id=#{@studentdatas.mg_user_id}"
			 sibiling_data=MgSibling.find_by_sql(@sibiling)
			 student_sibiling_data=sibiling_data.as_json

			 #for Previous edcuation
			 previous_edcuation="select school_name,course,grade,year,marks_obtained,total_marks from mg_previous_educations where mg_student_id=#{@studentdatas.id}"
			 previous_edcuation_detail=MgPreviousEducation.find_by_sql(previous_edcuation)
			 student_previous_edcuation_detail=previous_edcuation_detail.as_json


			  @@dbdatas = MgCommonCustomField.where(model_name: "student",is_deleted:0,mg_school_id:session[:current_user_school_id])

  @@customData = MgCustomFieldsData.where(mg_user_id:@studentUserId,is_deleted:0,mg_school_id:session[:current_user_school_id])
 
#customfield========================================================================
 
			 #custom_fields
			
         	#Permenent Address
			@get_std_paddress="select  address_line1, address_line2, street, city, state , pin_code, landmark, country from mg_addresses where mg_user_id=#{@studentUserId} AND address_type='Permanent'"
          	@std_p=MgAddress.find_by_sql(@get_std_paddress)
			std_p=@std_p.as_json 


			#Correspondance Address
			@get_student_correspondance_address="select  address_line1, address_line2, street, city, state , pin_code, landmark, country from mg_addresses where mg_user_id=#{@studentUserId} AND address_type='Correspondance'"
          	@std_correspondance=MgAddress.find_by_sql(@get_student_correspondance_address)
			std_correspondance=@std_correspondance.as_json


			#STUDENT HOME PHONE NUMBER                     
			@std_h_phone="SELECT phone_number,notification,subscription from mg_phones where mg_user_id=#{@studentUserId} and phone_type='mobile'"
			@std_h_phone=MgPhone.find_by_sql(@std_h_phone)
			std_h_phone=@std_h_phone.as_json


			#STUDENT HOME PHONE NUMBER
			@std_p_phone="SELECT phone_number from mg_phones where mg_user_id=#{@studentUserId} and phone_type='phone'"
			@std_p_phone=MgPhone.find_by_sql(@std_p_phone)
			std_p_phone=@std_p_phone.as_json
			puts"phone==============================================================================="
			# logger.info "inside phone"
			# logger.info std_p_phone \\@email=MgEmail.where(mg_user_id: @studentUserId)
			@std_email_query="select mg_email_id , notification , subscription from mg_emails where mg_user_id=#{@studentUserId}"
			puts "Student user Id==="
			puts @studentUserId
			@std_email=MgEmail.find_by_sql(@std_email_query)
			std_e=@std_email.as_json
			
			@@studentdatas=@studentdatas.id
			@@some=@studentdatas.mg_user_id
			@@stu="0"+@@studentdatas.to_s
			@@stuphoto=@@some.to_s+".jpeg"
					 puts @@stu.inspect
				     puts @@stuphoto.inspect
					 puts "asdfasdddddddddddddddddddd"
							


puts  "email doneeeeeeeeeeeeeeeeeeeeeeee"
			pdf = Prawn::Document.new do
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
									   #  # Green page numbers 1 to 11
									   #  options = { :at => [bounds.right - 150, 0],
									   #   :width => 150,
									   #   :align => :right,
									   #   :page_filter => (1..11),
									   #   :start_count_at => 1,
									   #   :color => "018fda" }
									   #  number_pages string, options

										move_down 100
										puts "before general llllllllllllllll"
										if  File.exists?("#{Rails.root}/public/#{@@stu_photo}")
					                        image( "#{Rails.root}/public/#{@@stu_photo}",:at => [450,600], :width =>  65)
					                    else
					                    end
										
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
										# display=Array.new
				                        # display +=["#{key}",":","#{value}"]
				                        if(key != 'id')
				                        	if(key=="date of birth")
				                        		str="Date of Birth"
				                        	elsif key=="mg_batch_id"
				                        		str="Class Name"
				                        		puts "batch id ========="
				                        		puts value
				                        		batch_name=MgBatch.find(value)
				                        		value=batch_name.course_batch_name
				                        	elsif key=="language"
				                        		str="Mother Tongue"
				                        	elsif key=="nationality"
				                        		str="Country"
				                        	elsif key=="mg_student_catagory_id"
				                        		str="Student Category"
				                        		category_name=MgStudentCategory.find(value)
				                        		value=category_name.name	
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
										if student_scholarship_data[0].present?
										student_scholarship_data[0].each_with_index { |(key, value), index|
										if index % 2==0
											$rowdata=Array.new
										end
										# display=Array.new
				                        # display +=["#{key}",":","#{value}"]
				                       if(key !='id')
				                        if(key =="name")
				                        	str="Name of Scholarship"
				                        elsif key=="amount"
				                        	str="Scholarship Amount"
				                        elsif key=="frequency"
				                        	str="Frequency"
				                        else
							                  str=key.tr('_', ' ') 
							                  str=str.titleize
							            end
				                        
										inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)
				                      
				                        
				                        end
										$rowdata +=[inner_table]
										if index % 2==1
										table([$rowdata],:column_widths => 270)  
									   
										end
									}
									end

									
									if student_management_data.present?
										student_management_data[0].each_with_index { |(key, value), index|
										if index % 2==0
											$rowdata=Array.new
										end
										# display=Array.new
				                        # display +=["#{key}",":","#{value}"]
				                        if(key != 'id')
							                  str=key.tr('_', ' ') 
							                  str=str.titleize
				                        
										inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)
				                      
				                        
				                        end
										$rowdata +=[inner_table]
										if index % 2==1
										table([$rowdata],:column_widths => 270)  
									   
										end
									}
									end
									
									if student_employee_data.present?
										student_employee_data[0].each_with_index { |(key, value), index|
										if index % 2==0
											$rowdata=Array.new
										end
										# display=Array.new
				                        # display +=["#{key}",":","#{value}"]
				                        if(key != 'id')
							                  str=key.tr('_', ' ') 
							                  str=str.titleize
				                        
										inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)
				                      
				                        
				                        end
										$rowdata +=[inner_table]
										if index % 2==1
										table([$rowdata],:column_widths => 270)  
									   
										end
									}
									end

										move_down 25

			if student_sibiling_data[0].present?
							text "Sibiling"
										data =  Array.new
										widths = Array.new(30, 50)
										cell_height = 15
										count=0
										
										$rowdata=Array.new
			
										student_sibiling_data[0].each_with_index { |(key, value), index|
										if index % 2==0
											$rowdata=Array.new
										end
										if(key != 'id')
										if key=="mg_course_id"
											str="Class"
											course_detail=MgCourse.find(value)
											value=course_detail.course_name
										elsif key=="mg_batch_id" 
											str="Section"
											if value !=nil
												batch_detail=MgBatch.find(value)
												value=batch_detail.name
											end
										else
											str=key.tr('_', ' ') 
											str=str.titleize
										end
				                        
										inner_table = make_table([ ["#{str}","#{value}"] ],:column_widths => 135)
				                      	end
				                        # display +=["#{value}"]
				                       
										$rowdata +=[inner_table]
										if index % 2==1
										table([$rowdata],:column_widths => 270)  
									   
										end	
										}
										move_down 25

			end	

			if student_previous_edcuation_detail[0].present?
					text "Previous Edcuation Detail"
										data =  Array.new
										widths = Array.new(30, 50)
										cell_height = 15
										count=0
										
										$rowdata=Array.new
			
										student_previous_edcuation_detail[0].each_with_index { |(key, value), index|
										if index % 2==0
											$rowdata=Array.new
										end

										
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

			end						




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

			if std_correspondance[0].present?
			text "Current Address"
										data =  Array.new
										widths = Array.new(30, 50)
										cell_height = 15
										count=0
										
										$rowdata=Array.new

										
										std_correspondance[0].each_with_index { |(key, value), index|
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
			end
										move_down 25

					
			text "Contact Details "
			@@phone_notification="No"
			@@phone_subscription="No"

			@@email_notification="No"
			@@email_subscription="No"

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
							            	$notification1 = value
								            	if (value==true)
								            		@@phone_notification="Yes"

								            	end
							            	end
							            }

							            std_h_phone[0].each_with_index { |(key, value), index|
							            	if(key=='subscription')
							            	$subscription1 = value
							            			if (value==true)
								            		@@phone_subscription="Yes"

								            		end
							            	end
							            }
							             std_p_phone[0].each_with_index { |(key, value), index|
							            	if(key=='phone_number')
							            	$phone2 = value
							            	end
							            }
										table([
											  ["Phone Number","#{$phone2}", "Mobile Number","+91-#{$phone1}"]
											  ],:column_widths => 135) 

										table([
											  ["Notification","#{@@phone_notification}", "Subscription","#{@@phone_subscription}"]
											  ],:column_widths => 135) 

										std_e[0].each_with_index{|(key, value), index|
											# if(key !="id")
											# 	$email=value
											# end
											if(key=='mg_email_id')
							            	$email = value
							        
							            	end
										}
										std_e[0].each_with_index{|(key, value), index|
											if(key=='notification')
							            	$notification2 = value
							            			if (value==true)
								            		@@email_notification="Yes"

								            		end
							            	end
										}
										std_e[0].each_with_index{|(key, value), index|
											if(key=='subscription')
							            	$subscription2 = value
							            			if (value==true)
								            		@@email_subscription="Yes"

								            		end
							            	end
										}

										table([
											  ["Email Id","#{$email}"]
											  ],:column_widths => 135) 

										table([
											  ["Notification","#{@@email_notification}", "Subscription","#{@@email_subscription}"]
											  ],:column_widths => 135) 

									
										move_down 25




 if @@customData.size>0
                 text "Custom Fields"
                
                
                 @@dbdatas.each do |dbdata| 
               
             @@customData.each do |custDatas|

            if dbdata.id.to_s==custDatas.mg_custom_field_id


              custom_data=Array.new
            


             


             

               @@customData.each do |custData| 

               if custData.mg_custom_field_id == dbdata.id.to_s
                  @custValue = custData.value
               
               end
             end
              
             
      table([
                      [ dbdata.name ,@custValue]
                        
                        ],:column_widths => 135) 
       
                
        

              
    end

 end               
                end

                      
                    







    

end







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

		#---------------------------------------






	#end========ch

	

def delete_record
	@delete=MgDocumentManagement.find(params[:documentID])
	@delete.delete
end



	#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<14th jan

	def edit
		 @student = MgStudent.find(params[:id])
		  @dbdatas = MgCommonCustomField.where(model_name: "student",is_deleted:0,mg_school_id:session[:current_user_school_id])
         @customData = MgCustomFieldsData.where(mg_user_id:@student.mg_user_id,is_deleted:0,mg_school_id:session[:current_user_school_id])
		 @Permanent=MgAddress.find_by(:mg_user_id=>@student.mg_user_id, :address_type => 'Permanent')
		 @Correspondance=MgAddress.find_by(:mg_user_id=>@student.mg_user_id, :address_type => 'Correspondance')
         @phone=MgPhone.find_by(:mg_user_id=>@student.mg_user_id, :phone_type => 'phone')
		 @mobile=MgPhone.find_by(:mg_user_id=>@student.mg_user_id, :phone_type => 'mobile')
		 @email=MgEmail.find_by(:mg_user_id=>@student.mg_user_id)

		 @sibling=MgSibling.find_by(:mg_user_id=>@student.mg_user_id,:is_deleted=>0)
		 #puts @sibling.inspect

		 #@previous_education=MgPreviousEducation.find_by(:mg_student_id=>@student.id)
		@previous_education=MgPreviousEducation.find_by(:mg_student_id=>@student.id, :is_deleted=>0)
		puts @previous_education.inspect

		 @employeechild=MgEmployeeChild.find_by(:mg_user_id=>@student.mg_user_id, :is_deleted=>0)
		 @managementquota=MgManagementQuota.find_by(:mg_user_id=>@student.mg_user_id, :is_deleted=>0)
		 @scholarship=MgStudentScholarship.find_by(:mg_user_id=>@student.mg_user_id, :is_deleted=>0)

		 render :layout => false
	end

def update
		puts "Step -- 1 update "
		begin
	MgStudent.transaction do
		@timeformat = MgSchool.find(session[:current_user_school_id]) 	
        @student = MgStudent.find(params[:id])
        @student.update(student_params)
        #update first name and last name in user table
          @student.mg_user.update(:first_name => params[:student][:first_name], 
                                   :last_name => params[:student][:last_name])
          #end here
        @catid=MgStudentCategory.find_by_id(params[:student][:mg_student_catagory_id])
        
        #===============================Employee Child start===================
        if @catid.name=="Employee Child"
	        @employeechild=MgEmployeeChild.where(:mg_user_id=>@student.mg_user_id)

	        if @employeechild.present?
	        	 @employeechild[0].update(empchild_params)
	        	  # @employeechild[0].update(:mg_user_id=>@student.mg_user_id)
	        	 if params[:employeechild][:joining_date].present?
			        @admissiondates = Date.strptime(params[:employeechild][:joining_date],@timeformat.date_format)
			        @employeechild[0].update(:joining_date => @admissiondates)
		      	end
			else
		        @employeechild = MgEmployeeChild.new(empchild_params)
		         # @employeechild.mg_user_id=@student.mg_user_id
				@employeechild.save

				if params[:employeechild][:joining_date].present?
					@admissiondates = Date.strptime(params[:employeechild][:joining_date],@timeformat.date_format)
					@employeechild.update(:joining_date => @admissiondates)
				end
			end

		else
			 @employeechild=MgEmployeeChild.where(:mg_user_id=>@student.mg_user_id)
			 if @employeechild.present?
			 	@employeechild[0].update(:mg_user_id=>@student.mg_user_id, :is_deleted=>1)
			 end
		end


        #===============================Employee Child end===================

        #===============================Management Quota start===================
        if @catid.name=="Management"
	        @managementquota=MgManagementQuota.where(:mg_user_id=>@student.mg_user_id)

	        if @managementquota.present?
	        	@managementquota[0].update(mngment_params)
	        	 # @managementquota[0].update(:mg_user_id=>@student.mg_user_id)
	        	if params[:managementquota][:joining_date].present?
		        @admissiondates = Date.strptime(params[:managementquota][:joining_date],@timeformat.date_format)
		        @managementquota[0].update(:joining_date => @admissiondates)
		    	end
			else
				@managementquota = MgManagementQuota.new(mngment_params)
				# @managementquota.mg_user_id=@student.mg_user_id
				@managementquota.save
				if params[:managementquota][:joining_date].present?
					@admissiondates = Date.strptime(params[:managementquota][:joining_date],@timeformat.date_format)
					@managementquota.update(:joining_date => @admissiondates)
				end
			end

		else
			@managementquota=MgManagementQuota.where(:mg_user_id=>@student.mg_user_id)
			if @managementquota.present?
	        	 @managementquota[0].update(:is_deleted=>1)
	        end
		end            


        #===============================Management Quota end===================
        #===============================Scholarship start===================
        if @catid.name=="On Scholarship"
	        @scholarship=MgStudentScholarship.where(:mg_user_id=>@student.mg_user_id)

	        if @scholarship.present?
	        	 @scholarship[0].update(scholar_params)
	        	 # @scholarship[0].update(:mg_user_id=> @student.mg_user_id)

	        	 if params[:scholarship][:start_date].present? && params[:scholarship][:end_date].present?
			        @startdate = Date.strptime(params[:scholarship][:start_date],@timeformat.date_format)
			        @enddate = Date.strptime(params[:scholarship][:end_date],@timeformat.date_format)
			        @scholarship[0].update(:start_date => @startdate,:end_date => @enddate)
			    elsif params[:scholarship][:start_date].present?
			    	 @startdate = Date.strptime(params[:scholarship][:start_date],@timeformat.date_format)
			        @scholarship[0].update(:start_date => @startdate)
			    elsif params[:scholarship][:end_date].present?
			    	  @enddate = Date.strptime(params[:scholarship][:end_date],@timeformat.date_format)
			        @scholarship[0].update(:end_date => @enddate)
			    end    
			else
				@scholarship = MgStudentScholarship.new(scholar_params)
				# @scholarship.mg_user_id=@student.mg_user_id
				@scholarship.save
				if params[:scholarship][:start_date].present? && params[:scholarship][:end_date].present?
					@startdate = Date.strptime(params[:scholarship][:start_date],@timeformat.date_format)
			        @enddate = Date.strptime(params[:scholarship][:end_date],@timeformat.date_format)
					@scholarship[0].update(:start_date => @startdate,:end_date => @enddate)
				elsif params[:scholarship][:start_date].present? 
					@startdate = Date.strptime(params[:scholarship][:start_date],@timeformat.date_format)
					@scholarship[0].update(:start_date => @startdate)
				elsif params[:scholarship][:end_date].present? 
					 @enddate = Date.strptime(params[:scholarship][:end_date],@timeformat.date_format)
					@scholarship[0].update(:end_date => @enddate)
				end
			end

		else

			@scholarship=MgStudentScholarship.where(:mg_user_id=>@student.mg_user_id)
	        if @scholarship.present?
	        	@scholarship[0].update(:mg_user_id=> @student.mg_user_id, :is_deleted=>1)
	        end
		end


        #===============================Scholarship end===================

        if params[:sibling][:is_sibling]== "true"
        	@sibling=MgSibling.where(:mg_user_id=>@student.mg_user_id)
    		if @sibling.present?
    			 @sibling[0].update(sibling_params)
    			 @sibling[0].update(:mg_user_id => @student.mg_user_id)

    			 if params[:sibling][:admission_date].present?
			        @admissiondates = Date.strptime(params[:sibling][:admission_date],@timeformat.date_format)
			        @sibling[0].update(:admission_date => @admissiondates)
			     end 
   
			else
                @sibling = MgSibling.new(sibling_params)
				@sibling.save
				@sibling.update(:mg_user_id => @student.mg_user_id)
				if params[:sibling][:admission_date].present?
					@admissiondates = Date.strptime(params[:sibling][:admission_date],@timeformat.date_format)
					@sibling.update(:admission_date => @admissiondates)
				end

			end


		 else 
		 	@sibling=MgSibling.where(:mg_user_id=>@student.mg_user_id)
    		if @sibling.present?
    			 @sibling[0].update(:mg_user_id => @student.mg_user_id, :is_deleted=>1)

    			 
			end

		end
        # @sibling.update(:mg_school_id=>params[:sibling][:mg_school_id],:name=>params[:sibling][:name],:relation=>params[:sibling][:relation],:mg_course_id=>params[:sibling][:mg_course_id],
        # 	:mg_batch_id=>params[:sibling][:mg_batch_id],:roll_no=>params[:sibling][:roll_no],:admission_no=>params[:sibling][:admission_no],:admission_date=>params[:sibling][:admission_date],
        # 	:is_deleted=>params[:sibling][:is_deleted],:is_sibling=>params[:sibling][:is_sibling])

        @admissionDate = Date.strptime(params[:student][:admission_date],@timeformat.date_format)
		@dateOfBirth = Date.strptime(params[:student][:date_of_birth],@timeformat.date_format)

		@student.update(:date_of_birth => @dateOfBirth,:admission_date=>@admissionDate)


        @Permanent=MgAddress.find_by(:mg_user_id=>@student.mg_user_id, :address_type => 'Permanent')
        @Permanent.update(permanent_address_params)

        @Correspondance=MgAddress.find_by(:mg_user_id=>@student.mg_user_id, :address_type => 'Correspondance')
        @Correspondance.update(correspondace_address_params)

        @phone=MgPhone.find_by(:mg_user_id=>@student.mg_user_id, :phone_type => 'phone')
		@phone.update(phone_params)

		@mobile=MgPhone.find_by(:mg_user_id=>@student.mg_user_id, :phone_type => 'mobile')
		@mobile.update(personal_phone_params)

		@email=MgEmail.find_by(:mg_user_id=>@student.mg_user_id)
		@email.update(email_params)

		@previous_education_updateparams=MgPreviousEducation.find_by(:mg_student_id=>@student.id)
		puts "==================================="
		puts @previous_education_updateparams.inspect
		puts "==================================="
		if @previous_education_updateparams.present?
			@previous_education_updateparams.update(edu_params)
			@previous_education_updateparams.update(:mg_student_id=>@student.id)
		else
			@previous_edcuation=MgPreviousEducation.new(edu_params)
			@previous_edcuation.mg_student_id=@student.id
			@previous_edcuation.save
		end	



		 @custFieldNameIds = params[:custom_data]
if  @custFieldNameIds.nil?
 	else
        for j in 0...@custFieldNameIds.size

      
    	 @custFieldValObj = params[:"custom_field_#{@custFieldNameIds[j]}"]
		if !@custFieldValObj.nil? && @custFieldValObj.size>0
		   @custFieldVal =@custFieldValObj[0];
		    for index in 1...@custFieldValObj.size 
		    @custFieldVal << ','+@custFieldValObj[index]
		          	
		    end 
		end
		


          
          @id=@custFieldNameIds[j]

          #@userName =  params[:student][:admission_number ]
	      puts @student.admission_number
          @userObj = MgUser.where(:user_name=>@student.admission_number)

        if @userObj.present?
          @userObjId = @userObj[0].id


          @details = MgCustomFieldsData.where(:mg_custom_field_id=>@id,:mg_user_id=>@userObjId)

          puts "@details.inspect"
          puts @details.inspect

            
            if @details.size<1
           @savedetails=MgCustomFieldsData.new(save_params) 
            @savedetails.value=@custFieldVal
             @savedetails.mg_custom_field_id=@id
             @savedetails.mg_user_id = @userObjId
             @savedetails.is_deleted = 0
             @savedetails.mg_school_id = session[:current_user_school_id]
           @savedetails.save
      	else
          @data = @custFieldVal
          @details[0].update(value: @data,is_deleted:0)
 
 		end
end
    end       #@data = @fields[j]
          # @data = @custFieldVal
          #@details.update(value: @data)
      end 
      
		           
require 'open-uri'


		  	@file=params[:transferfiles]
		  		 # @fileupload.file=params[:file]
		  		 	if @file.nil?
		  		 	else
		  		 @file.each do |a|
		  		 @fileupload=MgDocumentManagement.new()
		  		 	
		  		 @fileupload.file=a
		  		 puts @student.mg_user_id
		  		 @fileupload.document_type="TransferCertificate"
		  		 @fileupload.mg_user_id=@student.mg_user_id
		  	
		  		 @fileupload.save
		  		
		  		end
		  		
		  		end

require 'open-uri'



		  	
		  			
		  			@file=params[:file]
		  		 # @fileupload.file=params[:file]
		  		 	if @file.nil?
		  		 	else
		  		 @file.each do |a|
		  		 @fileupload=MgDocumentManagement.new()
		  		 	
		  		 @fileupload.file=a
		  		 puts @student.mg_user_id
		  		 @fileupload.document_type="SportsActivity"
		  		 @fileupload.mg_user_id=@student.mg_user_id
		  	
		  		 @fileupload.save
		  		
		  		end
		  		
		  		end
		  		
		  		@files=params[:files]
		  		puts params[:files].inspect
		  		 # @fileupload.file=params[:file]
		  		 puts "hello"
		  		 puts params[:files].inspect
		  		 if @files.nil?
		  		 else
		  		 @files.each do |a|
		  		 @fileupload=MgDocumentManagement.new()
		  		 	
		  		 @fileupload.file=a
		  		 puts @student.mg_user_id
		  			@fileupload.document_type="ExtraCurricular"
		  		 @fileupload.mg_user_id=@student.mg_user_id
		  	
		  		 @fileupload.save
		  		
		  		end
		  		
		  		end
		  		 
		  		@files=params[:healthrecordfiles]
		  		puts params[:healthrecordfiles].inspect
		  		 # @fileupload.file=params[:file]
		  		 if @files.nil?
		  			else
		  		 @files.each do |a|
		  		 @fileupload=MgDocumentManagement.new()
		  		 	
		  		 @fileupload.file=a
		  		 puts @student.mg_user_id
		  			@fileupload.document_type="HealthRecords"
		  		 @fileupload.mg_user_id=@student.mg_user_id
		  	
		  		 @fileupload.save
		  		end
		  
		  	end
		   

		  		@files=params[:classfiles]
		  		puts params[:classfiles].inspect
		  		 # @fileupload.file=params[:file]
		  		 if @files.nil?
		  		 	else
		  		 @files.each do |a|
		  		 @fileupload=MgDocumentManagement.new()
		  		 	
		  		 @fileupload.file=a
		  		 puts @student.mg_user_id
		  			@fileupload.document_type="ClassRecords"
		  		 @fileupload.mg_user_id=@student.mg_user_id
		  	
		  		 @fileupload.save
		  		end
		  	
		  	end
        redirect_to :back
    end
    rescue
	flash[:error]="Error occured, please contact administrator"
    redirect_to :back

end
end

	def destroy
		
	end

	def delete
		puts "Delete step -- 1"

		@student = MgStudent.find(params[:id])
      #  @employee.destroy
 
       # redirect_to '/employees/show'
       @user=MgUser.find(@student.mg_user_id)
       @user.is_deleted=1
       @user.save
        if @student.update(:is_deleted => 1)
          redirect_to '/students'
          else
        
        end
		
	end




	def manage_students
		puts "Step -- 1"
		# student category list will going to show
		@student_categories=MgStudentCategory.all

		puts @student_list.inspect
        puts "Step -- 1"
		#render :layout => false

	end


	def custom_index
		#render :layout => false
	end

	def custom_create

	    @customfields = MgCommonCustomField.new(post_params)
	      
	    @customfields.save
	    redirect_to :action=>'custom_new'
	end

	def custom_new
		@dbdatas = MgCommonCustomField.where(model_name: "student", is_deleted:0,mg_school_id:session[:current_user_school_id])
		#render :layout => false
	end	

	def custom_fields_edit
		@student_custom_field = MgCommonCustomField.find(params[:id])
  		render :layout => false
	end

	def custom_fields_update
	  @customfields = MgCommonCustomField.find(params[:id])
	 
	  @customfields.update(custom_field_params)
	  
	  redirect_to :action=>'custom_new'
	end

	def custum_fields_delete

	    @customfields=MgCommonCustomField.find_by_id(params[:id])
	    @customfields.is_deleted =1
	    @customfields.save
	    redirect_to :action=>'custom_new'
  
    end

    def student_contact_edit_by_guardian
 

    	@student=MgStudent.where(:id=>params[:id])

	    @phone = MgPhone.find_by(:mg_user_id => @student[0].mg_user_id, :phone_type => 'phone')
	    @mobile = MgPhone.find_by(:mg_user_id => @student[0].mg_user_id, :phone_type => 'mobile')

	    @email = MgEmail.find_by(:mg_user_id => @student[0].mg_user_id)

	    @phone.update(phone_params)
	    @mobile.update(personal_phone_params)
	    @email.update(email_params)

		redirect_to '/dashboards/guardian/'
    end

    def student_address_update_by_guardian
    	@student=MgStudent.where(:id=>params[:id])
		@Permanent=MgAddress.find_by(:mg_user_id=>@student[0].mg_user_id, :address_type=>"Permanent")
		@Permanent.update(permanent_address_params)
		redirect_to '/dashboards/guardian/'
    	
    end
    def student_Caddress_update_by_guardian
    	@student=MgStudent.where(:id=>params[:id])
		@Permanent=MgAddress.find_by(:mg_user_id=>@student[0].mg_user_id, :address_type=>'Correspondance')
		@Permanent.update(correspondace_address_params)
		redirect_to '/dashboards/guardian/'
    	
    end

    #created by bindhu
    def batches_for_selected_course
    	@batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:course_id]).pluck(:name,:id)
    	render :layout => false
    end

	






	private

	  def student_params
	  	 params.require(:student).permit(:admission_number,:class_roll_number,:first_name,:middle_name,:last_name,:date_of_birth,
	    	:admission_date,:gender,:blood_group,:birth_place,  :mg_batch_id, :nationality_id, 
	    	:language,:religion,:mg_student_catagory_id,:status_description,:has_paid_fees,:mg_user_id,:mg_school_id,:is_deleted,:nationality, :avatar, :sport_activity,:extra_curricular,:hobby,:class_record,:health_record)#, :s_photo)
	  end

	  def correspondace_address_params
	     params.require(:Correspondance).permit( :address_line1,:address_line2,:city,:state,:pin_code,:country ,:landmark, :is_deleted, :street,:address_type,:mg_school_id)
	  end

	  def permanent_address_params
	     params.require(:Permanent).permit( :address_line1,:address_line2,:city,:state,:pin_code,:country ,:landmark, :is_deleted, :street,:address_type,:mg_school_id)
	  end

	  def user_params
	    params.require(:student).permit(:user_name,:first_name,:last_name,:email, :password, :mg_school_id, :is_deleted,:user_type)
	  end

	  def phone_params
	    params.require(:phone).permit(:phone_number, :notification, :subscription, :phone_type, :is_deleted,:mg_school_id)
	  end
	  def personal_phone_params
	    params.require(:mobile).permit(:phone_number, :notification, :subscription, :phone_type, :is_deleted,:mg_school_id)
	  end

	  def email_params
	    params.require(:email).permit(:mg_email_id, :notification, :subscription, :is_deleted,:mg_school_id)
	  end

	  def edu_params
    params.require(:previous_education).permit(:school_name, :course, :year, :total_marks, :marks_obtained, :grade, :mg_student_id, :mg_school_id, :is_deleted,:is_transfer_certificate_produced)
  end

	  # def language_params
	  # 	params.require(:language).permit(:mg_school_id, :mg_user_id, :language_name, :read, :write, :speak, :is_deleted)
	  # end


	   def post_params
	        params.require(:demo).permit(:mg_school_id,:model_name,:name,:text_data,:data_type, :is_deleted)
	      end

	  def save_params
	   #params.require(:save).permit(:School_id,:custom_field_id,:one['value'],:two['value'],:three['value'],:four['value'])
	      params.require(:student).permit(:mg_school_id,:is_deleted)

	     end

	  def custom_field_params
        params.require(:student_custom_field).permit(:mg_school_id,:model_name,:name,:text_data,:data_type, :is_deleted)
      end
      
      def sibling_params
        params.require(:sibling).permit(:mg_school_id,:name,:relation,:mg_course_id,:mg_batch_id,:roll_no,:admission_no,:admission_date, :is_deleted,:mg_user_id,:created_by,:updated_by,:is_sibling)
      end
      
      def empchild_params
        params.require(:employeechild).permit(:mg_school_id,:employee_name,:employee_type,:employee_id,:joining_date, :is_deleted,:mg_user_id,:created_by,:updated_by)
      end

      def mngment_params
        params.require(:managementquota).permit(:mg_school_id,:name,:position,:employee_id,:joining_date, :is_deleted,:mg_user_id,:created_by,:updated_by)
      end

      

      def scholar_params
        params.require(:scholarship).permit(:mg_school_id,:name,:amount,:frequency,:start_date,:end_date,:is_deleted,:mg_user_id,:created_by,:updated_by)
      end



end