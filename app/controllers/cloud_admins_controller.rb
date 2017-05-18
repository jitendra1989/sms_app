class CloudAdminsController < ApplicationController
  before_filter :login_required
  layout "mindcom"
  require 'mime/types'
  require 'roo'
  require 'zip'

  
# ============================class import==============================================
def cloud_class
  
end

def class_cloud_admin_upload
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
      if @post==".xls"
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)
        @headerinfo = Hash.new
        @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
        ((@s.first_row + 1)..@s.last_row).each do |row|
          wing_name = @s.row(row)[@headerinfo['Wing *']]
          class_name = @s.row(row)[@headerinfo['Class name *']]
          class_code = @s.row(row)[@headerinfo['Code *']]
          puts "000000000000000000000000000000000000000000000"
          puts wing_name
          puts "000000000000000000000000000000000000000000000"
          wing_id=MgWing.find_by(:is_deleted=>0,:mg_school_id=>params[:mg_school_id],:wing_name=>wing_name)
            puts"insideeeeeeeeewing"
            puts wing_id.inspect
            puts"insideeeeeeeeewing"
          if wing_id.present?
            # MgCourse.transaction do
              if MgCourse.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :course_name=>class_name).present?
                array.push(wing_name)
              else 
                @user=MgCourse.new
                @user.mg_wing_id=wing_id.id
                @user.course_name=class_name
                @user.code=class_code
                @user.mg_school_id=params[:mg_school_id]
                @user.created_by=session[:user_id]
                @user.updated_by=session[:user_id]
                @user.is_deleted=false
                @user.created_at=Date.today
                @user.updated_at=Date.today
                @user.save
              end
            # end
          end
        end
      end
      flash[:notice]="Class uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) This class names are repeated, Please change class name and try again." : "")
      redirect_to :action=>'cloud_class'
end

# ==================================Section import=========================================

def section
  
end

def section_cloud_admin_upload
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
      if @post==".xls"
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)
        @headerinfo = Hash.new
        @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
        ((@s.first_row + 1)..@s.last_row).each do |row|
          class_name = @s.row(row)[@headerinfo['Class Name *']]
          section_name = @s.row(row)[@headerinfo['Section Name*']]
          start_date = @s.row(row)[@headerinfo['Start Date *']]
          end_date = @s.row(row)[@headerinfo['End Date *']]
          
          course=MgCourse.find_by(:is_deleted=>0,:mg_school_id=>params[:mg_school_id],:course_name=>class_name)
          if course.present?
            # MgCourse.transaction do
              if MgBatch.find_by(:mg_course_id=>course.id,:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :name=>section_name).present?
                array.push(section_name)
              else 
                @user=MgBatch.new
                @user.mg_course_id=course.id
                @user.name=section_name
                @user.start_date=start_date
                @user.end_date=end_date
                @user.mg_school_id=params[:mg_school_id]
                @user.created_by=session[:user_id]
                @user.updated_by=session[:user_id]
                @user.is_deleted=false
                @user.created_at=Date.today
                @user.updated_at=Date.today
                @user.save
              end
            # end
          end
        end
      end
      flash[:notice]="Batch uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) This batch names are repeated, Please change batch name and try again." : "")
      redirect_to :action=>'section'
end


# ========================================Account import===========================================

def cloud_acount
  
end

def cloud_acount_admin_upload
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
      if @post==".xls"
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)
        @headerinfo = Hash.new
        @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
        ((@s.first_row + 1)..@s.last_row).each do |row|
          account_name = @s.row(row)[@headerinfo['Account Name *']]
          description = @s.row(row)[@headerinfo['Description']]
          user_name = @s.row(row)[@headerinfo['User Name *']]
          password = @s.row(row)[@headerinfo['Password *']]
            # MgCourse.transaction do
              if MgAccount.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :mg_account_name=>account_name).present?
                array.push(account_name)
              else 
                # @user=MgAccount.new
# ====================================================================================================

                MgUser.transaction do
                school=MgSchool.find_by(:id=>params[:mg_school_id])
                user=MgUser.new( :user_type=>"account_incharge",:password=>password,:is_deleted=>0,:mg_school_id=>params[:mg_school_id] )
                user_name_with_subdomain=school.subdomain + user_name
                user.save
                user.update(:user_name=>user_name_with_subdomain)
                role=MgRole.find_by(:role_name=>"central_account_incharge")
                if role.id.present?
                  user_role = user.mg_user_roles.build(:mg_role_id => role.id)
                  user_role.save
                end
                @account=MgAccountCentralIncharge.new(:mg_school_id=>params[:mg_school_id],:is_deleted=>0)
                @account.save
                @account.update(:mg_user_id=>user.id,:status=>"Incharge")
              end
# ====================================================================================================
                # @user.mg_account_name=account_name
                # @user.description=description
                # @user.user_name=user_name
                # @user.end_date=end_date
                # @user.mg_school_id=params[:mg_school_id]
                # @user.created_by=session[:user_id]
                # @user.updated_by=session[:user_id]
                # @user.is_deleted=false
                # @user.created_at=Date.today
                # @user.updated_at=Date.today
                # @user.save
              end
            # end
        end
      end
      flash[:notice]="Account uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) This account are repeated, Please change account name and try again." : "")
      redirect_to :action=>'account'
end

# ===================================================================================================



  #  wing upload start
  def wing

  end

  def wing_cloud_admin_upload
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
      if @post==".xls"
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)
        @headerinfo = Hash.new
        @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
        ((@s.first_row + 1)..@s.last_row).each do |row|
          wing_name = @s.row(row)[@headerinfo['Wing name *']]
            # MgCourse.transaction do
              if MgWing.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :wing_name=>wing_name).present?
                array.push(wing_name)
              else 
                @user=MgWing.new
                @user.wing_name=wing_name
                @user.mg_school_id=params[:mg_school_id]
                @user.created_by=session[:user_id]
                @user.updated_by=session[:user_id]
                @user.is_deleted=false
                @user.created_at=Date.today
                @user.updated_at=Date.today
                @user.save
              end
            # end
        end
      end
      flash[:notice]="Wing uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) This wing names are repeated, Please change wing name and try again." : "")
      redirect_to :action=>'wing'
  end
  #  wing upload end

  # ============================================================================================

  #  Lab Item Type upload start
  def lab_item_type

  end

  def lab_item_type_cloud_admin_upload
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
      if @post==".xls"
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)
        @headerinfo = Hash.new
        @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
        ((@s.first_row + 2)..@s.last_row).each do |row|
          item_type = @s.row(row)[@headerinfo['Item Type *']]
          description = @s.row(row)[@headerinfo['Description']]
          is_issuable =  @s.row(row)[@headerinfo['Is Issuable *']]=='Yes' ? true : false
            # MgCourse.transaction do
              if MgLaboratoryItem.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :name=>item_type).present?
                array.push(item_type)
              else 
                @user=MgLaboratoryItem.new
                @user.name=item_type
                @user.description=description
                @user.is_issuable=is_issuable
                @user.mg_school_id=params[:mg_school_id]
                @user.created_by=session[:user_id]
                @user.updated_by=session[:user_id]
                @user.is_deleted=false
                @user.created_at=Date.today
                @user.updated_at=Date.today
                @user.save
              end
            # end
        end
      end
      flash[:notice]="Item Type uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) This item type names are repeated, Please change item type name and try again." : "")
      redirect_to :action=>'lab_item_type'
  end
  #  Lab Item Type end

  # ============================================================================================

  # ============================================================================================

  #  Lab Item Type upload start
  def employee_data

  end

  # def employee_cloud_admin_upload
  #   @postdata = FileUploadData.demo(params[:upload])
  #   @post = FileUploadData.save(params[:upload],content_type == "text/js")
  #   @datainfo=FileUploadData.uploadfile(params[:upload])
  #   @file_name= params[:upload]['datafile'].original_filename
  #   array=[]
  #     if @post==".xls"
  #       @s = Roo::Excel.new("upload/public/data/#{@file_name}")
  #       @s.default_sheet=@s.sheets[0]
  #       logger.info(@data.inspect)
  #       @headerinfo = Hash.new
  #       @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
  #       ((@s.first_row + 2)..@s.last_row).each do |row|

  #         joining_date = @s.row(row)[@headerinfo['Joining Date *']]
  #         f_name = @s.row(row)[@headerinfo['First Name *']]
  #         m_name = @s.row(row)[@headerinfo['Middle Name']]
  #         l_name = @s.row(row)[@headerinfo['Last Name *']]
  #         gender = @s.row(row)[@headerinfo['Gender *']]
  #         date_of_birth = @s.row(row)[@headerinfo['Date of Birth *']]
  #         emp_category = @s.row(row)[@headerinfo['Employee Category *']]
  #         emp_profile = @s.row(row)[@headerinfo['Employee Profile *']]
  #         emp_department = @s.row(row)[@headerinfo['Employee Department *']]
  #         job_title = @s.row(row)[@headerinfo['Job Title']]
  #         qualification = @s.row(row)[@headerinfo['Qualification']]
  #         t_year_exp = @s.row(row)[@headerinfo['Total Year Experience *']]
  #         t_mon_exp = @s.row(row)[@headerinfo['Total Month Experience *']]
  #         emp_type = @s.row(row)[@headerinfo['Employee Type *']]
  #         mother_tongue = @s.row(row)[@headerinfo['Mother Tongue *']]
  #         ltc_applicable = @s.row(row)[@headerinfo['LTC Applicable']]
  #         max_class_per_day = @s.row(row)[@headerinfo['Max Class Per Day *']]
  #         emp_grade = @s.row(row)[@headerinfo['Employee Grade *']]
  #         last_working_day = @s.row(row)[@headerinfo['Last Working Day']]
  #         status = @s.row(row)[@headerinfo['Status *']]
  #         bank_name = @s.row(row)[@headerinfo['Bank Name *']]
  #         account_number = @s.row(row)[@headerinfo['Account Number *']]
  #         branch_name = @s.row(row)[@headerinfo['Branch Name *']]
  #         ifs_code = @s.row(row)[@headerinfo['IFS Code *']]
  #         marital_status = @s.row(row)[@headerinfo['Marital Status']]
  #         mother_name = @s.row(row)[@headerinfo["Mother's Name *"]]
  #         father_name = @s.row(row)[@headerinfo["Father's Name *"]]
  #         blood_group = @s.row(row)[@headerinfo['Blood Group']]
  #         country = @s.row(row)[@headerinfo['Country *']]
  #         language = @s.row(row)[@headerinfo['Language']]
  #         speak = @s.row(row)[@headerinfo['Speak']]
  #         s_beginner = @s.row(row)[@headerinfo['S-Beginner']]
  #         s_intermediate = @s.row(row)[@headerinfo['S-Intermediate']]
  #         s_advanced = @s.row(row)[@headerinfo['S-Advanced']]
  #         read = @s.row(row)[@headerinfo['Read']]
  #         r_beginner = @s.row(row)[@headerinfo['R-Beginner']]
  #         r_intermediate = @s.row(row)[@headerinfo['R-Intermediate']]
  #         r_advanced = @s.row(row)[@headerinfo['R-Advanced']]
  #         write = @s.row(row)[@headerinfo['Write']]
  #         w_beginner = @s.row(row)[@headerinfo['W-Beginner']]
  #         w_intermediate = @s.row(row)[@headerinfo['W-Intermediate']]
  #         w_advanced = @s.row(row)[@headerinfo['W-Advanced']]
  #         referred = @s.row(row)[@headerinfo['Referred']]
  #         referred_by = @s.row(row)[@headerinfo['Referred By *']]
  #         designation = @s.row(row)[@headerinfo['Designation']]
  #         c_address_line1 = @s.row(row)[@headerinfo['C-Address Line1 *']]
  #         c_address_line2 = @s.row(row)[@headerinfo['C-Address Line2']]
  #         c_city = @s.row(row)[@headerinfo['C-City *']]
  #         c_state = @s.row(row)[@headerinfo['C-State *']]
  #         c_pincode = @s.row(row)[@headerinfo['C-Pincode *']]
  #         c_country = @s.row(row)[@headerinfo['C-Country *']]
  #         c_landmark = @s.row(row)[@headerinfo['C-Landmark']]
  #         p_address_line1 = @s.row(row)[@headerinfo['P-Address Line1 *']]
  #         p_address_line2 = @s.row(row)[@headerinfo['P-Address Line2']]
  #         p_city = @s.row(row)[@headerinfo['P-City *']]
  #         p_state = @s.row(row)[@headerinfo['P-State *']]
  #         p_pincode = @s.row(row)[@headerinfo['P-Pincode *']]
  #         p_country = @s.row(row)[@headerinfo['P-Country *']]
  #         p_landmark = @s.row(row)[@headerinfo['P-Landmark']]
  #         phone_number = @s.row(row)[@headerinfo['Phone Number']]
  #         mobile_number = @s.row(row)[@headerinfo['Mobile Number *']]
  #         m_notification = @s.row(row)[@headerinfo['M-Notification']]
  #         m_subscription = @s.row(row)[@headerinfo['M-Subscription']]
  #         email_id = @s.row(row)[@headerinfo['Email Id *']]
  #         e_notification = @s.row(row)[@headerinfo['E-Notification']]
  #         e_subscription = @s.row(row)[@headerinfo['E-Subscription']]
  #         cont_name = @s.row(row)[@headerinfo['Contact Name *']]
  #         cont_number = @s.row(row)[@headerinfo['Contact Number *']]
  #         sport_activity = @s.row(row)[@headerinfo['Sport Activity']]
  #         extra_curr = @s.row(row)[@headerinfo['Extra Curricular']]
  #         hobbies = @s.row(row)[@headerinfo['Hobbies']]


  #           # MgCourse.transaction do
  #             if MgEmployeePosition.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :position_name=>emp_profile).present?
  #               if MgEmployeeDepartment.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :department_name=>emp_department).present?
  #                 if MgEmployeeGrade.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :grade_name=>emp_grade).present?
  #                   if MgEmployeeType.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :employee_type=>status).present?
  #           #------------------code down for saving---------------------------------------

  #           #------------------fething id for given data----------------------------------

  #                         @emp_position_id=MgEmployeePosition.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :position_name=>emp_profile).pluck(:id)
  #                         @emp_department_id=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :department_name=>emp_department).pluck(:id)
  #                         @emp_grade_id=MgEmployeeGrade.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :grade_name=>emp_grade).pluck(:id)
  #                         @emp_type_id=MgEmployeeType.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :employee_type=>status).pluck(:id)
  #                         #-------------------------------------------------------------------------------
  #                         if MgEmployee.where(:mg_school_id=>params[:employee][:mg_school_id]).count.zero? # empty array
  #                           @strVal='1'   
  #                     else
  #                           @lastrecord = MgEmployee.where(:mg_school_id=>params[:mg_school_id]).last
  #                           str=@lastrecord.employee_number
  #                           @sub=params[:mg_school_id]
  #                           school_id_sub=MgSchool.find(@sub)
  #                           m=school_id_sub.subdomain.length
  #                           n= str.length
  #                           tail= str.slice(m+1, n)
  #                           @lastrecord=tail
  #                           @lastadmissionId= @lastrecord.to_i
  #                           @nextAdmissionNumber = @lastadmissionId + 1;
  #                           @strVal = @nextAdmissionNumber.to_s
  #                     end
  #                     #---------------------------------------------------------------------------------------
  #                         @user = MgUser.new
  #                         @ids=params[:mg_school_id]
  #                         school_id=MgSchool.find(@ids)
  #                         @user.user_name="#{school_id.subdomain}#{"E"}#{@strVal}"
  #                         @user.first_name=f_name
  #                         @user.middle_name=m_name
  #                         @user.last_name=l_name
  #                         @user.email=email_id
  #                         @user.user_type="employee"
  #                         @user.password="employee123"
  #                         @user.is_deleted=0
  #                         @user.mg_school_id=params[:mg_school_id]
  #                         role_id=MgRole.find_by(:role_name=>"employee")
  #                         @user_role = @user.mg_user_roles.build( :mg_role_id =>role_id.id )
  #                         if emp_category=="Teaching Staff"
  #                           @emp_category=1
  #                         else
  #                           @emp_category=2
  #                         end
  #                         @user_employee= @user.mg_employees.build(:mg_employee_type_id=>@emp_type_id, :mg_employee_category_id=>@emp_category, :mg_employee_position_id=>@emp_position_id
  #                           , :mg_employee_department_id=>@emp_department_id,:mg_employee_grade_id=>@emp_grade_id,:mg_user_id=>@user.id,:emergency_contact_name=>cont_name,:emergency_contact_number=>cont_number
  #                           , :hobby=>hobbies, :extra_curricular=>extra_curr,:sport_activity=>sport_activity, :language=>language,:nationality=>"IN"
  #                           , :employee_number=>@strVal,:joining_date=>joining_date,:first_name=>f_name,:middle_name=>m_name,:last_name=>l_name,:gender=>gender,:job_title=>job_title,:qualification=>qualification
  #                           , :experience_year=>t_year_exp, :experience_month=>t_mon_exp,:status=>status,:date_of_birth=>date_of_birth,:marital_status=>marital_status,:father_name=>father_name,:mother_name=>mother_name
  #                           , :blood_group=>blood_group,:mg_school_id=>params[:mg_school_id],:is_deleted=>0,:referred_by=>referred_by,:designation=>designation,:is_ltc_applicable=>ltc_applicable,:is_referred=>referred,:max_no_of_class=>max_class_per_day)







  #                         @user=MgLab.new
  #                         @user.lab_name=lab_name
  #                         @user.mg_laboratory_subject_id=@mg_laboratory_subject_id[0]
  #                         @user.room_no=room_number
  #                         @user.mg_school_id=params[:mg_school_id]
  #                         @user.created_by=session[:user_id]
  #                         @user.updated_by=session[:user_id]
  #                         @user.is_deleted=false
  #                         @user.created_at=Date.today
  #                         @user.updated_at=Date.today
  #                         @user.save
  #           #------------------code up for saving---------------------------------------             
  #                   else
  #                   array.push(status)
  #                 end
  #                 else
  #                   array.push(emp_grade)
  #                 end
  #               else
  #                 array.push(emp_department)
  #               end
  #             else 
  #               array.push(emp_profile)
  #             end
  #           # end
  #       end
  #     end
  #     flash[:notice]="Lab details uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) Subject details doesn't matches with laboratory subjects, Please manage laboratory subject name and try again." : "")
  #     redirect_to :action=>'employee_data'
  # end
  #  Lab Item Type end

  # ============================================================================================


  # =========================Employees upload============================

  #  Lab Item Type upload start
  def lab

  end

  def lab_cloud_admin_upload
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
      if @post==".xls"
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)
        @headerinfo = Hash.new
        @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
        ((@s.first_row + 1)..@s.last_row).each do |row|
          lab_name = @s.row(row)[@headerinfo['Lab Name *']]
          subject = @s.row(row)[@headerinfo['Subject *']]
          room_number = @s.row(row)[@headerinfo['Room Number *']]
            # MgCourse.transaction do
              if MgLaboratorySubject.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :name=>subject).present?
                @mg_laboratory_subject_id=MgLaboratorySubject.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :name=>subject).pluck(:id)
                @user=MgLab.new
                @user.lab_name=lab_name
                @user.mg_laboratory_subject_id=@mg_laboratory_subject_id[0]
                @user.room_no=room_number
                @user.mg_school_id=params[:mg_school_id]
                @user.created_by=session[:user_id]
                @user.updated_by=session[:user_id]
                @user.is_deleted=false
                @user.created_at=Date.today
                @user.updated_at=Date.today
                @user.save
              else 
                array.push(subject)
              end
            # end
        end
      end
      flash[:notice]="Lab details uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) Subject details doesn't matches with laboratory subjects, Please manage laboratory subject name and try again." : "")
      redirect_to :action=>'lab'
  end
  #  Lab Item Type end

  # ============================================================================================

  #  school upload end
  def school
    
  end
  def school_cloud_admin_upload
    begin
     @postdata = FileUploadData.demo(params[:upload])
      @post = FileUploadData.save(params[:upload],content_type == "text/js")
      @datainfo=FileUploadData.uploadfile(params[:upload])
      @file_name= params[:upload]['datafile'].original_filename
      array=[]
       @school_status=false
        if @post==".xls"
          @s = Roo::Excel.new("upload/public/data/#{@file_name}")
          @s.default_sheet=@s.sheets[0]
          #logger.info(@data.inspect)
          @headerinfo = Hash.new
          @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
          ((@s.first_row + 1)..@s.last_row).each do |row|
            school_name = @s.row(row)[@headerinfo['School Name*']]
            puts school_name
            school_code = @s.row(row)[@headerinfo['School Code*']]
            start_time = @s.row(row)[@headerinfo['Start Time*']]
            end_time = @s.row(row)[@headerinfo['End TIme*']]
            affilicated_to = @s.row(row)[@headerinfo['Affiliated To* ']]
            reg_num = @s.row(row)[@headerinfo['Affiliation No/Reg No*']]
            mg_leave_calendar_start_date = @s.row(row)[@headerinfo['Leave Calendar Start Date']]
            address_line1 = @s.row(row)[@headerinfo['Address Line1*']]
            address_line2 = @s.row(row)[@headerinfo['Address Line2']]
            street = @s.row(row)[@headerinfo['Street']]
            landmark = @s.row(row)[@headerinfo['Landmark']]
            city = @s.row(row)[@headerinfo['City*']]
            state = @s.row(row)[@headerinfo['State*']]
            pin_code = @s.row(row)[@headerinfo['Pincode*']]
            country = @s.row(row)[@headerinfo['Country*']]
            mobile_number = @s.row(row)[@headerinfo['Phone Number*']].to_i
            fax_number = @s.row(row)[@headerinfo['Fax Number*']].to_i
            email_id = @s.row(row)[@headerinfo['Email Id*']]
            if ('dd/mm/yy'==@s.row(row)[@headerinfo['Date Format*']])
              date_format = "%d/%m/%y"
            elsif ('dd/mm/yyyy'==@s.row(row)[@headerinfo['Date Format*']])
              date_format = "%d/%m/%Y"
            end
            timezone = @s.row(row)[@headerinfo['Time Zone*']]
            currency_type = @s.row(row)[@headerinfo['Currency Type*']]
            grading_system = @s.row(row)[@headerinfo['Grading System*']]
            
              # MgCourse.transaction do
                  @school=MgSchool.new(:created_by=>session[:user_id], :updated_by=>session[:user_id],:is_deleted=>false, :created_at=>Date.today, :updated_at=>Date.today)
                  @school.school_name=school_name
                  @school.school_code=school_code
                  @school.address_line1=address_line1
                  @school.address_line2=address_line2
                  @school.country=country
                  #@school.country_code=country_code
                  @school.start_time=start_time
                  @school.end_time=end_time 
                  @school.street=street
                  @school.city=city
                  @school.state=state
                  @school.pin_code=pin_code.to_i
                  @school.landmark=landmark
                  @school.mobile_number=mobile_number
                  @school.email_id=email_id
                  @school.fax_number=fax_number
                  #@school.language=language
                  @school.date_format=date_format
                  @school.timezone=timezone
                  @school.currency_type=currency_type

                  @school.affilicated_to=affilicated_to
                  @school.grading_system=grading_system
                  @school.reg_num=reg_num
                  # @school.subdomain=subdomain
                  @school.mg_leave_calendar_start_date=mg_leave_calendar_start_date
                  @school_status=@school.save
              # end
          end
        end

        flash[:notice]=  @school_status ? "School uploaded successfully" : ""#+ (array.present? ? ", (#{array.join(",") }) This wing names are repeated, Please change wing name and try again." : "")
        redirect_to :action=>'school'
        rescue Exception => e
        flash[:error]=  @school_status ? "School upload failed" : ""#+ (array.present? ? ", (#{array.join(",") }) This wing names are repeated, Please change wing name and try again." : "")
        redirect_to :action=>'school'
        end
  end
  #  school upload end
  def subject
    
  end

  def subject_cloud_admin_upload
    begin

      @postdata = FileUploadData.demo(params[:upload])
      @post = FileUploadData.save(params[:upload],content_type == "text/js")
      @datainfo=FileUploadData.uploadfile(params[:upload])
      @file_name= params[:upload]['datafile'].original_filename
      array=[]
      @sub_status=[]
      if @post==".xls"
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)
        @headerinfo = Hash.new
        @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
        ((@s.first_row + 1)..@s.last_row).each do |row|
          mg_course_id = MgCourse.find_by(:course_name=>@s.row(row)[@headerinfo['Class *']], :is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).try(:id)
          subject_name = @s.row(row)[@headerinfo['Subject Name *']]
          subject_code = @s.row(row)[@headerinfo['Subject Code']]
          max_weekly_class = @s.row(row)[@headerinfo['Max Weekly Class *']]
          is_core = (@s.row(row)[@headerinfo['Is Core Subject']]=='Yes' ? true : false)
          is_lab = (@s.row(row)[@headerinfo['Is Lab']]=='Yes' ? true : false)
          no_of_classes = @s.row(row)[@headerinfo['No of Classes *']]

          MgCourse.transaction do
            if !mg_course_id.present?
              array.push(" Course Name = "+@s.row(row)[@headerinfo['Class *']].to_s+" & Subject Name = "+subject_name.to_s);
              @sub_status.push(false)
            else
              @subject=MgSubject.new(:mg_school_id=>params[:mg_school_id],:created_by=>session[:user_id], :updated_by=>session[:user_id],:is_deleted=>false, :created_at=>Date.today, :updated_at=>Date.today)
              @subject.mg_course_id=mg_course_id
              @subject.subject_name=subject_name
              @subject.subject_code=subject_code
              @subject.max_weekly_class=max_weekly_class.to_i
              @subject.is_core=is_core
              @subject.is_lab=is_lab
              if is_lab
                @subject.no_of_classes=no_of_classes.to_i
              end
              @sub_status.push(@subject.save)
            end
          end
        end
      end
      if !@sub_status.include?(false)
          flash[:notice]="Subject uploaded successfully"#+ (array.present? ? ", (#{array.join(",") }) This course names are not present, Please change course name and try again." : "")
      else
        flash[:error]="Some subject are not uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) This course names are not present, Please change course name and try again." : "")
      end
    rescue Exception => e
      flash[:error]= "Subject upload failed"
    end
    redirect_to :action=>'subject'
  end

  def employee_department
    
  end
  def employee_department_cloud_admin_upload
    begin
      

      @postdata = FileUploadData.demo(params[:upload])
      @post = FileUploadData.save(params[:upload],content_type == "text/js")
      @datainfo=FileUploadData.uploadfile(params[:upload])
      @file_name= params[:upload]['datafile'].original_filename
      array=[]
      @dept_status=[]
        if @post==".xls"
          @s = Roo::Excel.new("upload/public/data/#{@file_name}")
          @s.default_sheet=@s.sheets[0]
          logger.info(@data.inspect)
          @headerinfo = Hash.new
          @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
          ((@s.first_row + 1)..@s.last_row).each do |row|
            department_name = @s.row(row)[@headerinfo['Department name *']]
            puts "1111111111111111111111111111111111111111111111"
            puts department_name
            puts "1111111111111111111111111111111111111111111111"
            department_code = @s.row(row)[@headerinfo['Department code *']]
            puts "22222222222222222222222222222222222222222222222"
            puts department_code
            puts "222222222222222222222222222222222222222222222222"

              # MgCourse.transaction do
                if MgEmployeeDepartment.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :department_name=>department_name).present?
                  array.push(department_name)
                  @dept_status.push(false)
                else 
                  @dept=MgEmployeeDepartment.new(:mg_school_id=>params[:mg_school_id],:created_by=>session[:user_id], :updated_by=>session[:user_id],:is_deleted=>false, :created_at=>Date.today, :updated_at=>Date.today)
                  @dept.department_name=department_name
                  @dept.department_code=department_code
                  @dept_status.push(@dept.save)
                end
              # end
          end
        end
        if !@dept_status.include?(false)
          flash[:notice]="Employee Department uploaded successfully"#+ (array.present? ? ", (#{array.join(",") }) This wing names are repeated, Please change wing name and try again." : "")
        else
          flash[:error]="Some Employee Department are not uploaded successfully"+ (", (#{array.join(",") }) This Department names are repeated, Please change Department name and try again.")
        end
    rescue Exception => e
      flash[:error]='Error occured, please contact administrator'
      # puts e
    end
        redirect_to :action=>'employee_department'
  end

  def employee_profile
  end

  def employee_profile_cloud_admin_upload
    # begin
      @postdata = FileUploadData.demo(params[:upload])
      @post = FileUploadData.save(params[:upload],content_type == "text/js")
      @datainfo=FileUploadData.uploadfile(params[:upload])
      @file_name= params[:upload]['datafile'].original_filename
      array=[]
      array_not_present=[]
      @dept_status=[]
        if @post==".xls"
          @s = Roo::Excel.new("upload/public/data/#{@file_name}")
          @s.default_sheet=@s.sheets[0]
          logger.info(@data.inspect)
          @headerinfo = Hash.new
          @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
          ((@s.first_row + 1)..@s.last_row).each do |row|
            position_name = @s.row(row)[@headerinfo['Profile Name *']]
            mg_employee_category_id = MgEmployeeCategory.find_by(:category_name=>@s.row(row)[@headerinfo['Category *']],:is_deleted=>0)#.try(:id)
              # MgCourse.transaction do
              if mg_employee_category_id.try(:id).present?

                if MgEmployeePosition.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :position_name=>position_name).present?
                  array.push(position_name)
                  @dept_status.push(false)
                else
                  @dept=MgEmployeePosition.new(:mg_school_id=>params[:mg_school_id],:created_by=>session[:user_id], :updated_by=>session[:user_id],:is_deleted=>false, :created_at=>Date.today, :updated_at=>Date.today)
                  @dept.mg_employee_category_id=mg_employee_category_id.try(:id)
                  @dept.position_name=position_name
                  @dept_status.push(@dept.save)
                end
              else
                array_not_present.push(@s.row(row)[@headerinfo['Category *']])
              end
              # end
          end
        end
        if !@dept_status.include?(false) && !array_not_present.present?
          flash[:notice]="Employee Profile uploaded successfully"#+ (array.present? ? ", (#{array.join(",") }) This wing names are repeated, Please change wing name and try again." : "")
        else
          flash[:error]="Some Employee Profile are not uploaded successfully"+  (array.present? ? (", (#{array.join(",") }) This Profile names are repeated, Please change Employee Profile name and try again.") : "")
        end
        if array_not_present.present?
          flash[:error1]="Some Employee Profile are not uploaded successfully"+ (array_not_present.present? ? (", (#{array_not_present.join(",") }) This Employee Category names are not present, Please change Employee Category name and try again.") : "")
        end
    # rescue Exception => e
      flash[:error]='Error occured, please contact administrator'
      # puts e
    # end
        redirect_to :action=>'employee_profile'
  end
  # MgEmployeeCategory

  def salary_component
    
  end
  def salary_component_cloud_admin_upload
    begin

      @postdata = FileUploadData.demo(params[:upload])
      @post = FileUploadData.save(params[:upload],content_type == "text/js")
      @datainfo=FileUploadData.uploadfile(params[:upload])
      @file_name= params[:upload]['datafile'].original_filename
      array=[]
      object_status=[]
      account_status=[]
        if @post==".xls"
          @s = Roo::Excel.new("upload/public/data/#{@file_name}")
          @s.default_sheet=@s.sheets[0]
          logger.info(@data.inspect)
          @headerinfo = Hash.new
          @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
          ((@s.first_row + 2)..@s.last_row).each do |row|
            name = @s.row(row)[@headerinfo['Name *']]
            is_deduction = @s.row(row)[@headerinfo['Is deduction *']]=="Yes" ? true : false
            if @s.row(row)[@headerinfo['Account Name']]=='Central'
              is_from_central=true
            else
              is_from_central=false
            end
            mg_account_id = MgAccount.find_by(:mg_account_name=>@s.row(row)[@headerinfo['Account Name']],:is_deleted=>0,:mg_school_id=>params[:mg_school_id]).try(:id)
            
              # MgCourse.transaction do
              if is_from_central || mg_account_id.present?
                if MgSalaryComponent.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :name=>name).present?
                  array.push(name)
                  object_status.push(false)
                else 
                  @object=MgSalaryComponent.new(:mg_school_id=>params[:mg_school_id],:created_by=>session[:user_id], :updated_by=>session[:user_id],:is_deleted=>false, :created_at=>Date.today, :updated_at=>Date.today)
                  @object.name=name
                  @object.is_deduction=is_deduction
                  #if is_from_central
                    @object.mg_account_id= is_from_central ? nil : mg_account_id
                  #end
                  @object.is_from_central=is_from_central
                  object_status.push(@object.save)

                    @grades=MgEmployeeGrade.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id])
                    @grades.each do |grade_components|
                      @grade_components=@object.mg_grade_components.build(:mg_employee_grade_id=>grade_components.id,:is_deleted=>0, :amount=>0.0, :mg_school_id=>params[:mg_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id], :is_applicable=>false)
                      @grade_components.save
                    end
                end
              else
                account_status.push(@s.row(row)[@headerinfo['Account Name']])
              end
              # end
          end
        end
        if !object_status.include?(false) && !account_status.present?
          flash[:notice]="Salary Component uploaded successfully"
        else
           flash[:error]="Some Salary Component are not uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) This Salary Component names are repeated, Please change Salary Component name and try again." : "")
        end
        if account_status.present?
           flash[:error1]="Some Account are not uploaded successfully"+ (account_status.present? ? ", (#{account_status .join(",") }) This Account names are not present, Please change Account name and try again." : "")
        end
    rescue Exception => e
      flash[:error]='Error occured, please contact administrator'
      puts e
    end
     
      redirect_to :action=>'salary_component'
  end

  def grade
    
  end

  def grade_cloud_admin_upload
    begin
      

      @postdata = FileUploadData.demo(params[:upload])
      @post = FileUploadData.save(params[:upload],content_type == "text/js")
      @datainfo=FileUploadData.uploadfile(params[:upload])
      @file_name= params[:upload]['datafile'].original_filename
      array=[]
        if @post==".xls"
          @s = Roo::Excel.new("upload/public/data/#{@file_name}")
          @s.default_sheet=@s.sheets[0]
          logger.info(@data.inspect)
          @headerinfo = Hash.new
          @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
          ((@s.first_row + 2)..@s.last_row).each do |row|
            wing_name = @s.row(row)[@headerinfo['Wing name']]
              # MgCourse.transaction do
                if MgWing.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :wing_name=>wing_name).present?
                  array.push(wing_name)
                else 
                  @user=MgWing.new
                  @user.wing_name=wing_name
                  @user.mg_school_id=params[:mg_school_id]
                  @user.created_by=session[:user_id]
                  @user.updated_by=session[:user_id]
                  @user.is_deleted=false
                  @user.created_at=Date.today
                  @user.updated_at=Date.today
                  @user.save
                end
              # end
          end
        end
        flash[:notice]="Wing uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) This wing names are repeated, Please change wing name and try again." : "")
    rescue Exception => e
      flash[:error]='Error occured, please contact administrator'
      puts e
    end
        redirect_to :action=>'grade'
  end

  def uploadFile

  @postdata = FileUploadData.demo(params[:upload])
      @post = FileUploadData.save(params[:upload],content_type == "text/js")
      logger.info(@post.inspect)

      @datainfo=FileUploadData.uploadfile(params[:upload])
      logger.info("-----------------------------------------------------")
      logger.info(@datainfo.inspect)
          
      @file_name= params[:upload]['datafile'].original_filename
      puts "jayanthskdhfkshkfhshfhuisi"
      puts @file_name.inspect
    
  logger.info @file_name



    if @post==".xls"



    
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)

        @headerinfo = Hash.new
        @s.row(1).each_with_index {|header,i| @headerinfo[header] = i} 
        #used for the iteration from first row to last row
              ((@s.first_row + 1)..@s.last_row).each do |row|
                 @Wing = @s.row(row)[@headerinfo['Wing*']]
              @Class_name = @s.row(row)[@headerinfo['Class name*']] 
              @Code = @s.row(row)[@headerinfo['Code*']]
              @Name = @s.row(row)[@headerinfo['Name*']]
              @Start_Date=@s.row(row)[@headerinfo['Start Date*']]
              @End_Date=@s.row(row)[@headerinfo['End Date*']]
               print "Row: #{@Wing}, #{@Class_name}, #{@Code}, #{@Name}\n\n"
               #logger.infoaksghdadad
                  MgCourse.transaction do
                  @user=MgCourse.new
                  course_data=MgCourse.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:course_name=>@Class_name)
                    if course_data.present?
                    else
                      @user.mg_wing_id=@Wing
                      @user.course_name=@Class_name
                      @user.code=@Code
                      @user.is_deleted=0
                      @user.mg_school_id=session[:current_user_school_id]
                      @user.created_by=session[:user_id]
                      @user.updated_by=session[:user_id]
                      @user.save
                    end
                    @model=MgBatch.new
                    if course_data.present?
                      @model.mg_course_id= course_data.id
                    else
                      @model.mg_course_id= @user.id
                    end
                    @model.name=@Name
                    @model.start_date=@Start_Date
                    @model.end_date=@End_Date
                    @model.is_deleted=0
                    @model.mg_school_id=session[:current_user_school_id]
                    @model.created_by=session[:user_id]
                    @model.updated_by=session[:user_id]
                    @model.save
                  end

              end
    end
    redirect_to "/cloud_admins/class_file_upload"

  end 




  def new_school
    @schools=MgSchool.new
    @dbdatas = MgCommonCustomField.where(model_name: "school")
  end
  def help_document_new
    
  end

  def help_document_create
    
    @help_document=MgHelpDocument.new(help_document_params)
    @help_document.save
    redirect_to :action => "help_document_show"
    
  end

  def help_document_edit
  @help_document = MgHelpDocument.find(params[:id])
  end

  def help_document_update
  puts"in subject update method 888888888888885555555555555555555555"
      @help_document = MgHelpDocument.find(params[:id])
     
      if @help_document.update(help_document_params)
        redirect_to :controller => "cloud_admins" , :action => "help_document_show"
      else
        render 'help_document_edit'
      end
end


def help_document_delete
  @help_document = MgHelpDocument.find(params[:id])
      
      if @help_document.update(:is_deleted => 1)
        render 'help_document_show'
        else
      
      end
  
end
def check_help_document
  if request.xhr?
  puts "0000000000000000000000000000"
puts params[:mg_school_id]
@perticular_count=MgHelpDocument.where(:mg_school_id=>params[:mg_school_id],:user_type=>params[:user_type],:is_deleted=>0).count
puts params[:user_type]
puts "0000000000000000000000000000"

  render :json=> {:employee=>@perticular_count}
  end
  
end



# def help_document_src
#   user=MgUser.find(session[:user_id])
#   @help_document=MgHelpDocument.where(:mg_school_id=>session[:current_user_school_id],:user_type=>user.user_type],:is_deleted=>0).last
#   if @help_document.present?
    
#   else
#   end
  
# end




  def school_index
    #@schools=MgSchool.where(:is_deleted=>0)    
    @schools=MgSchool.where(:is_deleted=>0).paginate(page: params[:page], per_page: 5)
  end

  def add_school_data
    school_id = params[:id]
    puts "Schoollll -1 "
    puts school_id
    puts "Schoollll -1 "
    
    #session[:current_user_school_id] = nil
    session[:current_user_school_id] = school_id

    $current_user_school_id = school_id
    
    redirect_to '/students'
  end


  def show_super_principal

    #@employeeDepartment=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    #@employees = MgEmployee.where(:is_deleted => '0')#.paginate(page: params[:page], per_page: 10)
      #@employees = MgEmployee.where(:mg_employee_department_id=>'12')
     # @employees = MgEmployee.where(:is_deleted => '0', :mg_school_id=>session[:current_user_school_id]).where("id != ?", 3).paginate(page: params[:page], per_page: 10)
    all_admins=MgUser.where(:is_deleted=>0, :user_type=>"superprincipal").pluck(:id)
    @employees=MgEmployee.where(:is_deleted=>0,:mg_user_id=>all_admins).paginate(page: params[:page], per_page: 10)

  end

  def school_association
      # MgMultiSchoolAccess
      @super_principal=MgUser.where(:is_deleted=>0, :user_type=>'superprincipal')
  end

    def school_principal_association
      @school=MgSchool.where(:is_deleted=>0)
      @mg_user_id=params[:id]
      @user_obj=MgUser.find_by(:id=>@mg_user_id, :is_deleted=>0)
      @super_principal=MgMultiSchoolAccess.where(:is_deleted=>0, :mg_user_id=>params[:id]).pluck(:mg_school_id)
    end


    def school_principal_association_save


      user_id=params[:attendances][:mg_user_id]
      selected_school_ids=params[:mg_school_id]
      default_school_id=params[:attendances][:default_school_id]
      selected_school_ids.push(default_school_id)

      # puts "selected_school_ids"
      # puts selected_school_ids
      #
      # puts "selected_school_ids"
      # puts selected_school_ids

      # code for add new school in MgMultiSchoolAccess
      
      if selected_school_ids.present?
        selected_school_ids.each_with_index do |school_id,i|
          multi_school_access_obj=MgMultiSchoolAccess.find_by(
                                :mg_user_id=>user_id, :mg_school_id=>school_id)
          if multi_school_access_obj.present?
            multi_school_access_obj.update( :is_deleted=>0, :updated_by=>session[:user_id] )
          else
            new_multi_school_access_obj=MgMultiSchoolAccess.new(:mg_school_id=>school_id, :mg_user_id=>user_id, 
              :is_deleted=>0, :created_by=>session[:user_id], :updated_by=>session[:user_id])
            new_multi_school_access_obj.save
          end
        end
      end

      # code for remove school from MgMultiSchoolAccess

      temp=false
      multi_school_access_objs=MgMultiSchoolAccess.where(:mg_user_id=>user_id,:is_deleted=>0)
      if multi_school_access_objs.present?
        schoolId=0
        existingSchoolId=0
        multi_school_access_objs.each_with_index do |multi_school_obj,i|
          selected_school_ids.each_with_index do |school_id,i|
            schoolId=school_id.to_i
            existingSchoolId=multi_school_obj.mg_school_id.to_i
            if schoolId==existingSchoolId
              temp=false
              break
            else
              temp=true
            end
          end
          if temp
            multi_school_obj.update( :is_deleted=>1, :updated_by=>session[:user_id] )
          end
        end

      end





      # multi_school=Array.new
      # if params[:mg_school_id].present?
      #   for i in 0...params[:mg_school_id].size
      #     multi_school.push(params[:mg_school_id][i].to_i)
      #   end
      # end

      # all_school=MgMultiSchoolAccess.where(:is_deleted=>0, :mg_user_id=>params[:attendances][:mg_user_id]).pluck(:mg_school_id)
      # value=all_school-multi_school
      
      # if params[:mg_school_id].present?
      #   for i in 0...params[:mg_school_id].size
      #     if !MgMultiSchoolAccess.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id][i],:mg_user_id=>params[:attendances][:mg_user_id]).present?
      #       MgMultiSchoolAccess.new(:mg_school_id=>params[:mg_school_id][i], :mg_user_id=>params[:attendances][:mg_user_id], :is_deleted=>0, :created_by=>session[:user_id], :updated_by=>session[:user_id]).save
      #     else
      #       object=MgMultiSchoolAccess.where(:is_deleted=>0,:mg_school_id=>params[:mg_school_id][i],:mg_user_id=>params[:attendances][:mg_user_id])
      #       object[0].save
      #     end
      #   end
      # end
      # if value.present?
      #   for v in 0...value.size
      #     object_absent=MgMultiSchoolAccess.where(:is_deleted=>0,:mg_school_id=>value[v],:mg_user_id=>params[:attendances][:mg_user_id])
      #     object_absent[0].is_deleted=1
      #     object_absent[0].save
      #   end
      # end
      redirect_to :controller=>'cloud_admins', :action=>'school_association', :notice=>'School '

    end



  def super_principal
      @employee = MgEmployee.new
      find_data = MgEmployee.first
      #for chartkick object
      @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
      @schoolList=MgSchool.where(:is_deleted=>0).pluck(:school_name,:id)
      # @employee = ( flash[:employee] ) ? flash[:employee] : MgEmployee.new
      # @Temporary = (flash[:c_address]) ? flash[:c_address] : MgAddress.new
      # @Permanent = (flash[:p_address]) ? flash[:p_address] : MgAddress.new
      # @phone = (flash[:phone]) ? flash[:phone] : MgPhone.new
      # @mobile = (flash[:personal_phone]) ? flash[:personal_phone] : MgPhone.new
      # @email = (flash[:email]) ? flash[:email] : MgEmail.new
      # #@dbdatas = (flash[:custFields]) ? flash[:custFields] : MgCommonCustomField.where(model_name: "student")
      # flash[:errorInRecords]=(flash[:errorInRecord]) ? flash[:errorInRecord] : ""
      # #flash[:emergency_phone] = @emergency_phone
      @dbdatas = MgCommonCustomField.where(model_name: "employee",is_deleted:0,mg_school_id:session[:current_user_school_id])
      # if MgEmployee.count.zero? # empty array
      #     @strVal='1'
      # else
      #   @lastrecord = MgEmployee.last
      #   @lastadmissionId= @lastrecord.id.to_i
      #   @nextAdmissionNumber = @lastadmissionId + 1;
      #   @strVal = @nextAdmissionNumber.to_s
      # end

  end

  def edit_super_principal

    @employee = MgEmployee.find(params[:id])
    @dbdatas = MgCommonCustomField.where(model_name: "employee")
    @customData = MgCustomFieldsData.where(mg_user_id:@employee.mg_user_id)
    @Permanent=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type => 'Permanent')
    @Temporary=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type => 'Temporary')
    @phone=MgPhone.find_by(:mg_user_id=>@employee.mg_user_id, :phone_type => 'phone')
    @mobile=MgPhone.find_by(:mg_user_id=>@employee.mg_user_id, :phone_type => 'mobile')
    @email=MgEmail.find_by(:mg_user_id=> @employee.mg_user_id)
    @schoolList=MgSchool.where(:is_deleted=>0).pluck(:school_name,:id)
    @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
    render :layout => false

  end

  
  def show_super_principal_profile

    @employee = MgEmployee.find(params[:id])
    @employeeUserId= @employee.mg_user_id
    @address=MgAddress.where(mg_user_id: @employeeUserId)
    @contact=MgPhone.where(mg_user_id: @employeeUserId)
    @email=MgEmail.where(mg_user_id: @employeeUserId)
    @dbdatas = MgCommonCustomField.where(model_name: "employee")
    @customData = MgCustomFieldsData.where(mg_user_id:@employee.mg_user_id)
    @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
    add_breadcrumb "Show"
    #render :layout => false

  end

  def delete_super_principal

     employee = MgEmployee.find(params[:id])
     employee.update(:is_deleted => 1)
     @employee.mg_user.update(:is_deleted => 1)
     redirect_to '/cloud_admins/show_super_principal'

  end

  def admin_index

    all_admins=MgUser.where(:is_deleted=>0, :user_type=>"admin").pluck(:id)
    @employees=MgEmployee.where(:is_deleted=>0,:mg_user_id=>all_admins).paginate(page: params[:page], per_page: 10)

  end

  def new_admin

    @employee = MgEmployee.new
    find_data = MgEmployee.first
    @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
    @schoolList=MgSchool.where(:is_deleted=>0).pluck(:school_name,:id)
    @dbdatas = MgCommonCustomField.where(model_name: "employee",is_deleted:0,mg_school_id:session[:current_user_school_id])
    # if MgEmployee.count.zero? # empty array
    #     @strVal='1'
    # else
    #   @lastrecord = MgEmployee.last
    #   @lastadmissionId= @lastrecord.id.to_i
    #   @nextAdmissionNumber = @lastadmissionId + 1;
    #   @strVal = @nextAdmissionNumber.to_s
    # end

  end

  def edit_admin

    @employee = MgEmployee.find(params[:id])
    @dbdatas = MgCommonCustomField.where(model_name: "employee")
    @customData = MgCustomFieldsData.where(mg_user_id:@employee.mg_user_id)
    @Permanent=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type => 'Permanent')
    @Temporary=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type => 'Temporary')
    @phone=MgPhone.find_by(:mg_user_id=>@employee.mg_user_id, :phone_type => 'phone')
    @mobile=MgPhone.find_by(:mg_user_id=>@employee.mg_user_id, :phone_type => 'mobile')
    @email=MgEmail.find_by(:mg_user_id=> @employee.mg_user_id)
    @schoolList=MgSchool.where(:is_deleted=>0).pluck(:school_name,:id)
    @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
    render :layout => false

  end

  def show_admin

    @employee = MgEmployee.find(params[:id])
    @employeeUserId= @employee.mg_user_id
    @address=MgAddress.where(mg_user_id: @employeeUserId)
    @contact=MgPhone.where(mg_user_id: @employeeUserId)
    @email=MgEmail.where(mg_user_id: @employeeUserId)
    @dbdatas = MgCommonCustomField.where(model_name: "employee")
    @customData = MgCustomFieldsData.where(mg_user_id:@employee.mg_user_id)
    @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
    add_breadcrumb "Show"
    
  end

  def delete_admin

     @employee = MgEmployee.find(params[:id])
     @employee.update(:is_deleted => 1)
     @employee.mg_user.update(:is_deleted => 1)
     redirect_to '/cloud_admins/admin_index'

  end

  def principal_index

    all_admins=MgUser.where(:is_deleted=>0, :user_type=>"principal").pluck(:id)
    @employees=MgEmployee.where(:is_deleted=>0,:mg_user_id=>all_admins).paginate(page: params[:page], per_page: 10)

  end

  def add_principal

    @employee = MgEmployee.new
    find_data = MgEmployee.first
    @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
    @schoolList=MgSchool.where(:is_deleted=>0).pluck(:school_name,:id)
    @dbdatas = MgCommonCustomField.where(model_name: "employee",is_deleted:0,mg_school_id:session[:current_user_school_id])
    # if MgEmployee.count.zero? # empty array
    #   @strVal='1'
    # else
    #   @lastrecord = MgEmployee.last
    #   @lastadmissionId= @lastrecord.id.to_i
    #   @nextAdmissionNumber = @lastadmissionId + 1;
    #   @strVal = @nextAdmissionNumber.to_s
    # end

  end

  def edit_principal

    @employee = MgEmployee.find(params[:id])
    @dbdatas = MgCommonCustomField.where(model_name: "employee")
    @customData = MgCustomFieldsData.where(mg_user_id:@employee.mg_user_id)
    @Permanent=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type => 'Permanent')
    @Temporary=MgAddress.find_by(:mg_user_id=>@employee.mg_user_id, :address_type => 'Temporary')
    @phone=MgPhone.find_by(:mg_user_id=>@employee.mg_user_id, :phone_type => 'phone')
    @mobile=MgPhone.find_by(:mg_user_id=>@employee.mg_user_id, :phone_type => 'mobile')
    @email=MgEmail.find_by(:mg_user_id=> @employee.mg_user_id)
    @schoolList=MgSchool.where(:is_deleted=>0).pluck(:school_name,:id)
    @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
    render :layout => false

  end

  def show_principal

    @employee = MgEmployee.find(params[:id])
    @employeeUserId= @employee.mg_user_id
    @address=MgAddress.where(mg_user_id: @employeeUserId)
    @contact=MgPhone.where(mg_user_id: @employeeUserId)
    @email=MgEmail.where(mg_user_id: @employeeUserId)
    @dbdatas = MgCommonCustomField.where(model_name: "employee")
    @customData = MgCustomFieldsData.where(mg_user_id:@employee.mg_user_id)
    @languageList = MgLanguage.where(mg_user_id:@employee.mg_user_id)
    add_breadcrumb "Show"

  end

  def delete_principal

     @employee = MgEmployee.find(params[:id])
     @employee.update(:is_deleted => 1)
     @employee.mg_user.update(:is_deleted => 1)
     redirect_to '/cloud_admins/principal_index'

  end



  # def show_image
 #    @school = MgSchool.find(params[:id])
 #    send_data @school.school_logo, :type => 'image/png',:disposition => 'inline'
 #  end

  def student
  end

  def student_cloud_admin_upload
    begin
      @postdata = FileUploadData.demo(params[:upload])
      @post = FileUploadData.save(params[:upload],content_type == "text/js")
      @datainfo=FileUploadData.uploadfile(params[:upload])
      @file_name= params[:upload]['datafile'].original_filename
      array=[]
      @sub_status=[]
      if @post==".xls"
        @s = Roo::Excel.new("upload/public/data/#{@file_name}")
        @s.default_sheet=@s.sheets[0]
        logger.info(@data.inspect)
        @headerinfo = Hash.new
        @s.row(1).each_with_index {|header,i| @headerinfo[header] = i}
        ((@s.first_row + 1)..@s.last_row).each do |row|
          first_name = @s.row(row)[@headerinfo['First Name *']]
          middle_name = @s.row(row)[@headerinfo['Middle Name']]
          last_name = @s.row(row)[@headerinfo['Last Name *']]
          course_name = @s.row(row)[@headerinfo['Class *']]

          date_of_birth = @s.row(row)[@headerinfo['Date of Birth *']]
          gender = @s.row(row)[@headerinfo['Gender']]
          country = @s.row(row)[@headerinfo['Country *']]
          guardian = @s.row(row)[@headerinfo['Parent/Guardian *']]

          category = @s.row(row)[@headerinfo['Category *']]

          c_address_line1 = @s.row(row)[@headerinfo['C_Address Line1 *']]
          c_address_line2 = @s.row(row)[@headerinfo['C_Address Line2']]
          c_street = @s.row(row)[@headerinfo['C_Street']]
          c_landmark = @s.row(row)[@headerinfo['C_Landmark']]
          c_city = @s.row(row)[@headerinfo['C_City *']]
          c_state = @s.row(row)[@headerinfo['C_State *']]
          c_pincode = @s.row(row)[@headerinfo['C_Pincode *']]
          c_country = @s.row(row)[@headerinfo['C_Country *']]
          p_address_line1 = @s.row(row)[@headerinfo['P_Address Line1 *']]
          p_address_line2 = @s.row(row)[@headerinfo['P_Address Line2']]
          p_street = @s.row(row)[@headerinfo['P_Street']]
          p_landmark = @s.row(row)[@headerinfo['P_Landmark']]
          p_city = @s.row(row)[@headerinfo['P_City *']]
          p_state = @s.row(row)[@headerinfo['P_State *']]
          p_pincode = @s.row(row)[@headerinfo['P_Pincode *']]
          p_country = @s.row(row)[@headerinfo['P_Country *']]
          phone_number = @s.row(row)[@headerinfo['Phone Number']]
          mobile_number = @s.row(row)[@headerinfo['Mobile Number *']]
          email_id = @s.row(row)[@headerinfo['Email Id *']]
          school_name = @s.row(row)[@headerinfo['School Name']]
          class_name = @s.row(row)[@headerinfo['Class']]
          year = @s.row(row)[@headerinfo['Year']]
          marks_obtained = @s.row(row)[@headerinfo['Marks Obtained']]
          total_marks = @s.row(row)[@headerinfo['Total Marks']]
          grade = @s.row(row)[@headerinfo['Grade/Percentage']]

          MgCourse.transaction do
            if MgCourse.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :course_name=>course_name).present? && MgStudentCategory.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :name=>category).present?
              @mg_course_id=MgCourse.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :course_name=>course_name).pluck(:id)
              @category_id=MgStudentCategory.where(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :name=>category).pluck(:id)
              
              @student_admission=MgStudentAdmission.new
              @student_admission.first_name=first_name
              @student_admission.middle_name=middle_name
              @student_admission.last_name=last_name
              @student_admission.mg_course_id=@mg_course_id[0]
              @student_admission.date_of_birth=date_of_birth
              @student_admission.gender=gender
              @student_admission.nationality=country
              @student_admission.guardian_name=guardian
              @student_admission.mg_student_category_id=@category_id[0]
              @student_admission.mg_c_address_line1=c_address_line1
              @student_admission.mg_c_address_line2=c_address_line2
              @student_admission.mg_c_street=c_street
              @student_admission.mg_c_landmark=c_landmark
              @student_admission.mg_c_city=c_city
              @student_admission.mg_c_state=c_state
              @student_admission.mg_c_pin_code=c_pincode
              @student_admission.mg_c_country=c_country
              @student_admission.mg_p_address_line1=p_address_line1
              @student_admission.mg_p_address_line2=p_address_line2
              @student_admission.mg_p_street=p_street
              @student_admission.mg_p_landmark=p_landmark
              @student_admission.mg_p_city=p_city
              @student_admission.mg_p_state=p_state
              @student_admission.mg_p_pin_code=p_pincode
              @student_admission.mg_p_country=p_country
              @student_admission.phone_number=phone_number
              @student_admission.mobile_number=mobile_number
              @student_admission.mg_email_id=email_id
              @student_admission.school_name=school_name
              @student_admission.course=class_name
              @student_admission.year=year
              @student_admission.marks_obtained=marks_obtained
              @student_admission.total_marks=total_marks
              @student_admission.grade=grade

              @student_admission.mg_school_id=params[:mg_school_id]
              @student_admission.created_by=session[:user_id]
              @student_admission.updated_by=session[:user_id]
              @student_admission.is_deleted=false
              @student_admission.created_at=Date.today
              @student_admission.updated_at=Date.today
              if @sub_status.push(@student_admission.save)
                @status_admission = MgStudentAdmission.find_by(:id=>@student_admission.id)
                temp_id = "123"+"#{@student_admission.id}"
                @sub_status.push(@status_admission.update(:student_temporary_id=>temp_id.to_i,:is_selected_for_entrance_test=>"pending", :is_shortlisted_for_admission=>"pending"))
              end
            else 
              array.push(course_name)
              array.push(category)
              @sub_status.push(false)
            end
          end
        end
      end

      if !@sub_status.include?(false)
          flash[:notice]="Student Details uploaded successfully"#+ (array.present? ? ", (#{array.join(",") }) This course names are not present, Please change course name and try again." : "")
      else
        flash[:error]="There is some problem"+ (array.present? ? ", (#{array.join(",") }) Class or Category doesn't matches with Admission class name, Please manage admission class name and try again." : "")
      end
      #flash[:notice]="student details uploaded successfully"+ (array.present? ? ", (#{array.join(",") }) Class details doesn't matches with Admission class name, Please manage admission class name and try again." : "")
    rescue Exception => e
      flash[:error]= "Student Details upload failed"
    end
    redirect_to :action=>'student'
  end

  def unit
  end

  def unit_create
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
    @sub_status=[]
    if @post==".xls"
      @s = Roo::Excel.new("upload/public/data/#{@file_name}")
      @s.default_sheet=@s.sheets[0]
      logger.info(@data.inspect)
      @headerinfo = Hash.new
      @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
      ((@s.first_row + 2)..@s.last_row).each do |row|
        unit_name = @s.row(row)[@headerinfo['Unit Name *']]
          # MgCourse.transaction do
            if MgLabUnit.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :unit_name=>unit_name).present?
              array.push(unit_name)
              @sub_status.push(false)
            else 
              @user=MgLabUnit.new
              @user.unit_name=unit_name
              @user.mg_school_id=params[:mg_school_id]
              @user.created_by=session[:user_id]
              @user.updated_by=session[:user_id]
              @user.is_deleted=false
              @user.created_at=Date.today
              @user.updated_at=Date.today
              @sub_status.push(@user.save)
            end
          # end
      end
    end

    if !@sub_status.include?(false)
      flash[:notice]="Unit Name uploaded successfully"
    else
     flash[:error]=""+ (array.present? ? " (#{array.join(",") }) This unit names are repeated, Please change unit name and try again." : "")
    end
    redirect_to :action=>'unit'
  end

  def laboratory_subject
  end

  def subject_create
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
    @sub_status=[]
    if @post==".xls"
      @s = Roo::Excel.new("upload/public/data/#{@file_name}")
      @s.default_sheet=@s.sheets[0]
      logger.info(@data.inspect)
      @headerinfo = Hash.new
      @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
      ((@s.first_row + 2)..@s.last_row).each do |row|
        subject_name = @s.row(row)[@headerinfo['Name *']]
        subject_description = @s.row(row)[@headerinfo['Description ']]
          # MgCourse.transaction do
            if MgLaboratorySubject.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :name=>subject_name).present?
              array.push(subject_name)
              @sub_status.push(false)
            else 
              @user=MgLaboratorySubject.new
              @user.name=subject_name
              @user.description=subject_description
              @user.mg_school_id=params[:mg_school_id]
              @user.created_by=session[:user_id]
              @user.updated_by=session[:user_id]
              @user.is_deleted=false
              @user.created_at=Date.today
              @user.updated_at=Date.today
              @sub_status.push(@user.save)
            end
          # end
      end
    end
    if !@sub_status.include?(false)
      flash[:notice]="Subject Name uploaded successfully"
    else
     flash[:error]=""+ (array.present? ? " (#{array.join(",") }) This subject names are repeated, Please change subject name and try again." : "")
    end
    redirect_to :action=>'laboratory_subject'
  end

  def route_management
  end

  def route_create
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
    @sub_status=[]
    if @post==".xls"
      @s = Roo::Excel.new("upload/public/data/#{@file_name}")
      @s.default_sheet=@s.sheets[0]
      logger.info(@data.inspect)
      @headerinfo = Hash.new
      @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
      ((@s.first_row + 2)..@s.last_row).each do |row|
        route_name = @s.row(row)[@headerinfo['Route Name *']]
        route_description = @s.row(row)[@headerinfo['Description']]
          # MgCourse.transaction do
            if MgTransport.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :route_name=>route_name).present?
              array.push(route_name)
              @sub_status.push(false)
            else 
              @user=MgTransport.new
              @user.route_name=route_name
              @user.description=route_description
              @user.mg_school_id=params[:mg_school_id]
              @user.created_by=session[:user_id]
              @user.updated_by=session[:user_id]
              @user.is_deleted=false
              @user.created_at=Date.today
              @user.updated_at=Date.today
              @sub_status.push(@user.save)
            end
          # end
      end
    end
    if !@sub_status.include?(false)
      flash[:notice]="Route Name uploaded successfully"
    else
     flash[:error]=""+ (array.present? ? " (#{array.join(",") }) This route names are repeated, Please change route name and try again." : "")
    end
    redirect_to :action=>'route_management'
  end

  def route_vehicle
  end

  def create_route_vehicle
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
    @sub_status=[]
    if @post==".xls"
      @s = Roo::Excel.new("upload/public/data/#{@file_name}")
      @s.default_sheet=@s.sheets[0]
      logger.info(@data.inspect)
      @headerinfo = Hash.new
      @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
      ((@s.first_row + 2)..@s.last_row).each do |row|
        route_name = @s.row(row)[@headerinfo['Route Name *']]
        vehicle_name = @s.row(row)[@headerinfo['Vehicle *']]
        employee_category = @s.row(row)[@headerinfo['Employee Category *']]
        employee_profile = @s.row(row)[@headerinfo['Employee Profile *']]
        employee_name = @s.row(row)[@headerinfo['Driver *']]
        drop_time = @s.row(row)[@headerinfo['Drop Start Time *']]
          # MgCourse.transaction do
            @transport_obj = MgTransport.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :route_name=>route_name)  
            
            @vehicle_number = MgVehicle.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :vehicle_number=>vehicle_name)  
            @employee_category_name = MgEmployeeCategory.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :category_name=>employee_category)  
            if @employee_category_name.present?
              @employee_position = MgEmployeePosition.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :position_name=>employee_profile,:mg_employee_category_id=>@employee_category_name.id)  
              if @employee_position.present?
                @employee_obj= MgEmployee.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :first_name=>employee_name,:mg_employee_category_id=>@employee_category_name.id,:mg_employee_position_id=>@employee_position.id)  
                if @employee_obj.present? && @transport_obj.present? && @vehicle_number.present?
                  
                  seconds = drop_time % 60
                  minutes = (drop_time / 60) % 60
                  hours = drop_time / (60 * 60)
                  @new_drop_time = hours.to_s+":"+minutes.to_s+":"+seconds.to_s
                  @vehicle_number.mg_transport_id=@transport_obj.id
                  @vehicle_number.mg_employee_category_id=@employee_category_name.id
                  @vehicle_number.mg_employee_position_id=@employee_position.id
                  @vehicle_number.mg_employee_id=@employee_obj.id
                  @vehicle_number.drop_start_time=@new_drop_time

                  @vehicle_number.mg_school_id=params[:mg_school_id]
                  @vehicle_number.created_by=session[:user_id]
                  @vehicle_number.updated_by=session[:user_id]
                  @vehicle_number.is_deleted=false
                  @vehicle_number.created_at=Date.today
                  @vehicle_number.updated_at=Date.today
                  @sub_status.push(@vehicle_number.save)
                else
                  array.push(route_name)
                  array.push(vehicle_name.to_s)
                  array.push(employee_name)
                  @sub_status.push(false)  
                end
              else
                array.push(employee_profile)
                @sub_status.push(false)  
              end
            else
              array.push(employee_category)
              @sub_status.push(false)
            end
          # end
      end
    end
    if !@sub_status.include?(false)
      flash[:notice]="Route Vehicle uploaded successfully"
    else
     flash[:error]=""+ (array.present? ? " (#{array.join(",") }) This information are not matching, Please enter correct information and try again." : "")
    end
    redirect_to :action=>'route_vehicle'
  end

  def bus_pickup_route
  end

  def create_buspickup_route
    @postdata = FileUploadData.demo(params[:upload])
    @post = FileUploadData.save(params[:upload],content_type == "text/js")
    @datainfo=FileUploadData.uploadfile(params[:upload])
    @file_name= params[:upload]['datafile'].original_filename
    array=[]
    @sub_status=[]
    if @post==".xls"
      @s = Roo::Excel.new("upload/public/data/#{@file_name}")
      @s.default_sheet=@s.sheets[0]
      logger.info(@data.inspect)
      @headerinfo = Hash.new
      @s.row(2).each_with_index {|header,i| @headerinfo[header] = i}
      ((@s.first_row + 2)..@s.last_row).each do |row|
        route_name = @s.row(row)[@headerinfo['Route Name *']]
        bus_stop_name = @s.row(row)[@headerinfo['Bus Stop Name *']]
        bus_pickup_time = @s.row(row)[@headerinfo['Pick Up Time *']]
        bus_drop_time = @s.row(row)[@headerinfo['Drop Time *']]

        @transport_obj = MgTransport.find_by(:is_deleted=>0, :mg_school_id=>params[:mg_school_id], :route_name=>route_name)  
        if @transport_obj.present?
          @transport_time_management = MgTransportTimeManagement.new
          seconds = bus_pickup_time % 60
          minutes = (bus_pickup_time / 60) % 60
          hours = bus_pickup_time / (60 * 60)
          @new_bus_pickup_time = hours.to_s+":"+minutes.to_s+":"+seconds.to_s
          in_seconds = bus_drop_time % 60
          in_minutes = (bus_drop_time / 60) % 60
          in_hours = bus_drop_time / (60 * 60)
          @new_bus_drop_time = in_hours.to_s+":"+in_minutes.to_s+":"+in_seconds.to_s
          @transport_time_management.mg_transport_id=@transport_obj.id
          @transport_time_management.bus_stop_name=bus_stop_name
          @transport_time_management.pick_up_time=@new_bus_pickup_time
          @transport_time_management.drop_time=@new_bus_drop_time
          @transport_time_management.mg_school_id=params[:mg_school_id]
          @transport_time_management.created_by=session[:user_id]
          @transport_time_management.updated_by=session[:user_id]
          @transport_time_management.is_deleted=false
          @transport_time_management.created_at=Date.today
          @transport_time_management.updated_at=Date.today
          @sub_status.push(@transport_time_management.save)
        else
          array.push(route_name)
          @sub_status.push(false)
        end
      end
    end
    if !@sub_status.include?(false)
      flash[:notice]="Route Details uploaded successfully"
    else
     flash[:error]=""+ (array.present? ? " (#{array.join(",") }) this route name are not matching, Please change route name and try again." : "")
    end
    redirect_to :action=>'bus_pickup_route'
  end
end #class end


private
#comments addedhelp_document
    def help_document_params
      params.require(:help_document).permit(:user_type, :name, :document, :mg_school_id, :is_deleted, :created_by , :updated_by)
    end