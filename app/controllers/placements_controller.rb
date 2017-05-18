class PlacementsController < ApplicationController
	before_filter :login_required
	layout "mindcom"

  def index

  end

  # Bindhu Work Starts

  def index_corporate_login
    @users=MgUser.where(:user_type=>"corporate",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def new_user
    @action='new'
    parent_url = request.env['HTTP_REFERER']
    puts parent_url
    if parent_url!=nil  && (parent_url.include? "corporate")
      @user_type="corporate"
    elsif parent_url!=nil  && (parent_url.include? "assistant")
      @user_type="recruitment_assistant"
    elsif parent_url!=nil  && (parent_url.include? "placement")
      @user_type="placement_cell_head"
    end
    @user=MgUser.new
    render :layout=>false
  end

  def create_user
    MgUser.transaction do
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(user_accounts_params)
      user_name_with_subdomain=school.subdomain + params[:user][:user_name]
      user.save
      user.update(:user_name=>user_name_with_subdomain)
      if params[:user][:user_type]=="corporate"
        role=MgRole.find_by(:role_name=>"corporate")
      elsif params[:user][:user_type]=="placement_cell_head"
        role=MgRole.find_by(:role_name=>"placement_cell_head")
      elsif params[:user][:user_type]=="recruitment_assistant"
        role=MgRole.find_by(:role_name=>"recruitment_assistant")
      end

      if role.id.present?
        user_role = user.mg_user_roles.build(:mg_role_id => role.id)
        user_role.save 
      end
    end
    redirect_to :back
  end

  def edit_user
    @action='edit'
    @user=MgUser.find(params[:id])
    render :layout=>false
  end

  def update_user
    user=MgUser.find(params[:id])
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:user][:user_name]
    user.update(:user_name=>user_name_with_domain)
    redirect_to :back
  end

  def delete_user
    user=MgUser.find(params[:id])
    user.update(:is_deleted=>1,:updated_by=>session[:user_id])
    redirect_to :back 
  end

  def change_password
    @user=MgUser.find(params[:id])
    render :layout=>false
  end

  def user_change_password
    user_id=params[:change_password][:user_id]
    @user=MgUser.where(:id =>user_id)
    new_password = params[:change_password][:new_password] 
    re_new_password =  params[:change_password][:re_type_password] 
    if new_password==re_new_password
      if @user
        @userMe=MgUser.find(user_id)
        @userMe.update(:password=>new_password)
        flash[:notice] = "Password changed successfully." 
      end 
    else
      flash[:error] = "Re Entered password didn't matched !"
    end
    redirect_to :back
  end

  def index_placement_cell_head
    @users=MgUser.where(:user_type=>"placement_cell_head",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end
  
  def index_recruitment_assistant
    @users=MgUser.where(:user_type=>"recruitment_assistant",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])   
  end

  def placement_student_detail_index
  	@school=MgSchool.find(session[:current_user_school_id])
    student_id=MgStudent.where(:mg_user_id=>session[:user_id]).pluck(:id)
  	@student_detail=MgPlacementStudentDetail.find_by(:mg_student_id=>student_id[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def placement_student_detail_new
  	@action='new' 
    @student_id=MgStudent.where(:mg_user_id=>session[:user_id]).pluck(:id)
  	@student_detail=MgPlacementStudentDetail.new
  end

  def placement_student_detail_create
  	puts placement_student_detail_params
  	student_detail=MgPlacementStudentDetail.new(placement_student_detail_params)
  	if student_detail.save
	  	school=MgSchool.find(session[:current_user_school_id])
	  	date_of_birth = Date.strptime(params[:student_detail][:date_of_birth],school.date_format)
	  	if student_detail.update(:date_of_birth=>date_of_birth)
	  		flash[:notice]="Job profile created successfully"
	  	end
	  else
	  	flash[:error]="Error occured,Please try later"
	  end
	  redirect_to :action=>"placement_student_detail_index"
  end

  def placement_student_detail_edit
  	@action='edit' 
  	@student_id=MgStudent.where(:mg_user_id=>session[:user_id]).pluck(:id)
  	@student_detail=MgPlacementStudentDetail.find(params[:id])
  end

  def placement_student_detail_update
  	student_detail=MgPlacementStudentDetail.find(params[:id])
  	if student_detail.update(placement_student_detail_params)
  		school=MgSchool.find(session[:current_user_school_id])
	  	date_of_birth = Date.strptime(params[:student_detail][:date_of_birth],school.date_format)
	  	student_detail.update(:date_of_birth=>date_of_birth)
	  	flash[:notice]="Job profile updated successfully"
	  else
	  	flash[:error]="Error occured,Please try later"
	  end
	  redirect_to :action=>"placement_student_detail_index"
  end

  def placement_student_detail_delete
  	student_detail=MgPlacementStudentDetail.find(params[:id])
  	if student_detail.update(:is_deleted=>1,:updated_by=>session[:user_id])
  		flash[:notice]="Job profile deleted successfully"
  	else
  		flash[:error]="Error occured,Please try later"
  	end
    redirect_to :action=>"placement_student_detail_index"
  end

  def placement_student_detail_show
  	@student_detail=MgPlacementStudentDetail.find(params[:id])
    @school=MgSchool.find(session[:current_user_school_id])
    render layout:false
  end

  def student_uploaded_resume_index
    @resume_list=MgDocumentManagement.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page],per_page: 10)
  end

  def student_resume_upload_new
    render layout:false
  end

  def student_doc_edit
    @student_doc_edit=MgDocumentManagement.find(params[:id])
    render layout:false

  end

  def student_doc_name_update
    @student_doc_edit=MgDocumentManagement.find(params[:id])
    @student_doc_edit.file_file_name=params[:student_doc_edit][:name]
    @student_doc_edit.save 
    redirect_to :action=>"student_uploaded_resume_index"
    
  end
  

  def student_resume_upload_create
    puts params
    resume_detail=MgDocumentManagement.new(student_resume_upload_params)
    if resume_detail.save
      puts params[:student_resume][:is_default]
      if params[:student_resume][:is_default]=="1"
        default_resume_list=MgDocumentManagement.where('id NOT IN (?) AND mg_user_id=? And document_type=? AND is_deleted=? AND mg_school_id=?',resume_detail.id,session[:user_id],"studentCv",0,session[:current_user_school_id])       
        puts default_resume_list.inspect
        default_resume_list.each do |resume|
          resume.update(:is_default=>0)
        end
        
      end
      flash[:notice]="CV uploaded successfully"
    else
      flash[:error]="Error occured,Please try later"
    end
    redirect_to :action=>"student_uploaded_resume_index"
  end

  def change_default_resume
    selected_resume=MgDocumentManagement.find(params[:id])
    selected_resume.update(:is_default=>1)
    default_resume_list=MgDocumentManagement.where('id NOT IN (?) AND is_default=? AND mg_user_id =? AND is_deleted=? AND mg_school_id=?',params[:id],1,session[:user_id],0,session[:current_user_school_id])
    puts default_resume_list.inspect
    default_resume_list.each do |resume|
      resume.update(:is_default=>0)
    end
    @resume_list=MgDocumentManagement.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page],per_page: 10)
    render layout:false
  end

  def delete_student_resume
    selected_resume=MgDocumentManagement.find(params[:id])
    if selected_resume.update(:is_deleted=>1)
      flash[:notice]="Resume deleted successfully"
    else
      flash[:error]="Error occured,Please try later"
    end
    redirect_to :action=>"student_uploaded_resume_index"
  end

  def student_resume_upload_show
    @resume=MgDocumentManagement.find(params[:id])
    render layout:false
  end
  # Bindhu Work Ends
  def placements_registration
    @placements_registration=MgPlacementRegistration.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  
  end

  def placements_registration_new
    @request="new"
    @school=MgSchool.find_by(:id=>session[:current_user_school_id])

    @placements_registration=MgPlacementRegistration.new

  end
  def placements_registration_edit
    @request="edit"
    @school=MgSchool.find_by(:id=>session[:current_user_school_id])

    @placements_registration=MgPlacementRegistration.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :id=>params[:id])
    @user=MgUser.find(@placements_registration.mg_user_id)
    
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    @user_name=@user.user_name.sub(school.subdomain,"")
  end

  def placements_registration_create 
    mg_school_id=session[:current_user_school_id]
    @placements_registration=MgPlacementRegistration.new(placements_registration_params)
    @comp_user=MgUser.new()
    @comp_user.is_deleted=0
    @comp_user.mg_school_id=session[:current_user_school_id]
    @comp_user.created_by=session[:user_id]
    @comp_user.updated_by=session[:user_id]

    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    @comp_user.user_name=school.subdomain + params[:user_name]
    @comp_user.password=params[:password]
    @comp_user.user_type=params[:user_type]

    if @comp_user.save
       if params[:user_type]=="Company"
        role=MgRole.find_by(:role_name=>"Company")
        if role.id.present?
        user_role = @comp_user.mg_user_roles.build(:mg_role_id => role.id)
        user_role.save 
        end
       end
       @placements_registration.mg_user_id=@comp_user.id
       @placements_registration.save

      to_email_id=params[:placements_registration][:contact_email]
      from_email_id=MgEmail.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id,:mg_user_id=>session[:user_id]).try(:mg_email_id)
      if params[:placements_registration][:is_alumni].to_i==1  && params[:placements_registration][:have_alumni_id].to_i==0
         send_email(from_email_id,to_email_id,mg_school_id)
      end
      flash[:notice]="Registration created successfully"
      redirect_to :action=>'placements_registration'
    else
      flash[:error]="Registration not successfull"
      render :action=>'placements_registration'
    end
  end
  
  def send_email(from_email_id,to_email_id,mg_school_id)
    school=MgSchool.find(mg_school_id)
    description="Hi, 

                Please register with alumi,

                 Regards,
                 #{school.school_name}"
    subject="Registration"
     begin
        MgNotification.send_email(from_email_id,to_email_id,subject,description,mg_school_id)
      rescue Exception => e
        puts e
      end
  end
  def placements_registration_update
    mg_school_id=session[:current_user_school_id]

    @placements_registration=MgPlacementRegistration.find_by_id(params[:id])
    user_data=MgUser.find_by(:id=>@placements_registration.mg_user_id)

    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:user_name]
    user_data.update(:user_name=>user_name_with_domain)

    if user_data.save 
      @placements_registration.update(placements_registration_params_update)
      to_email_id=params[:placements_registration][:contact_email]
      from_email_id=MgEmail.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id,:mg_user_id=>session[:user_id]).try(:mg_email_id)
 
       if params[:placements_registration][:is_alumni].to_i==1  && params[:placements_registration][:have_alumni_id].to_i==0
          send_email(from_email_id,to_email_id,mg_school_id)
        end
      flash[:notice]="Registration updated successfully"
      redirect_to :action=>'placements_registration'
    else
      flash[:error]="Registration updated unsuccessfull"
      render :action=>'placements_registration'
    end
  end


  
  def placements_registration_delete
    @placements_registration=MgPlacementRegistration.find_by_id(params[:id])
    user_data=MgUser.find_by(:id=>@placements_registration.mg_user_id)
    
     if user_data.save
      user_data.update(:is_deleted=>1, :updated_by=>session[:user_id])
      @placements_registration.update(:is_deleted=>1, :updated_by=>session[:user_id])
      

      flash[:notice]="Registration deleted successfully"
    else
      flash[:error]="Registration deletion unsuccessfull"
    end
    redirect_to :action=>'placements_registration'
  end

  def placements_registration_show
     @placements_registration=MgPlacementRegistration.find_by_id(params[:id])
  end

  def placement_registration_password
    @registration_data=MgPlacementRegistration.find_by(:id=>params[:id])
     render :layout=>false
    
 
  end
  def placement_change_password
    @placements_registration=MgUser.find_by(:id=>params[:user_id])
    @placements_registration.inspect
    @placements_registration.password=params[:placement_password][:password]
    @placements_registration.save
    flash[:notice]="Password updated successfully"
    redirect_to :action=>'placements_registration'
  end

  # def job_upload
  #   @job_upload=MgAlumniJobPostingDetail.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  # end

  def interview_rounds
    @interview_rounds=MgInterviewRound.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def interview_rounds_new
    @new='new'
    @interview_rounds=MgInterviewRound.new
    render :layout=>false

  end

  def interview_rounds_edit
    @new='edit'
    @interview_rounds=MgInterviewRound.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    render :layout=>false
  end

  def interview_rounds_show
    @interview_rounds=MgInterviewRound.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    render :layout=>false
  end
  def interview_rounds_create
    @interview_rounds=MgInterviewRound.new(interview_rounds_params)
    if @interview_rounds.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :back
  end
  def interview_rounds_update
    @interview_rounds=MgInterviewRound.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @interview_rounds.update(interview_rounds_params)
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :back
  end
  def interview_rounds_delete
     @interview_rounds=MgInterviewRound.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @interview_rounds.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :back
  end
  
  def training_offered
    if session[:user_type]=="Company"
      @training_offered=MgPlacementTrainingOffered.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).paginate(page: params[:page], per_page: 10)
      @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
    else
      @training_offered=MgPlacementTrainingOffered.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
      @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
    end
  end



  def training_offered_new
    if session[:user_type]=="Company"

       @placement_registration=MgPlacementRegistration.where(:status=>'Active',:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:name_of_the_company,:id)
    @request="new"
    else
    @placement_registration=MgPlacementRegistration.where(:status=>'Active',:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
    @request="new"
  end
  end

  def training_offered_create
    puts"0000000000000111100000000000000"
    puts params
    puts"0000000000000111100000000000000"
    placements_training=MgPlacementTrainingOffered.new(placement_training_params)
    dateformat = MgSchool.find(session[:current_user_school_id])
    start_date = Date.strptime(params[:placement_training][:start_date],dateformat.date_format)
    end_date = Date.strptime(params[:placement_training][:end_date],dateformat.date_format)

     placements_training.start_date=start_date
     placements_training.end_date=end_date
     placements_training.mg_user_id=session[:user_id]
     placements_training.is_active=params[:is_active]
   #   if params[:is_active]=="pending"
   #   placements_training.is_active=true
   # else
   #   placements_training.is_active=false
   #  end
     # placements_training.status=params[:is_active]

     if placements_training.save
      flash[:notice]="training created successfully"
      redirect_to :action=>'training_offered'
     else
      flash[:error]="training not successfull"
      render :action=>'training_offered'
     end
  end
  
  def training_offered_show
    @placements_training=MgPlacementTrainingOffered.find_by(:id=>params[:id])
    @placement=MgPlacementRegistration.find_by(:id=>@placements_training.mg_placement_registration_id)
    @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
    render :layout=>false
  end

  def training_offered_new_show
    @data=params[:id]
    @placements_training=MgPlacementTrainingOffered.find_by(:id=>params[:id])
    @placement=MgPlacementRegistration.find_by(:id=>@placements_training.mg_placement_registration_id)
    student_id=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @accept_traine=MgPlacementAcceptedTrainee.find_by(:mg_student_id=>student_id.id,:mg_placement_training_offered_id=>@placements_training.id)
    @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
    render :layout=>false
  end
  
  def training_offered_edit
     if session[:user_type]=="Company"

      @request="edit"
    @placement_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:name_of_the_company,:id)
        @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format

    @placement_training=MgPlacementTrainingOffered.find_by(:id=>params[:id])
   @selected_data=@placement_training.mg_placement_registration_id
    else
    @request="edit"
    @placement_registration=MgPlacementRegistration.where(:status=>'Active',:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
        @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format

    @placement_training=MgPlacementTrainingOffered.find_by(:id=>params[:id])
   @selected_data=@placement_training.mg_placement_registration_id

   
  end
end
  
  def training_offered_update
    @placements_training=MgPlacementTrainingOffered.find_by_id(params[:id_data])
    dateformat = MgSchool.find(session[:current_user_school_id])
     start_date = Date.strptime(params[:start_date_data11],dateformat.date_format)
     end_date = Date.strptime(params[:end_date_data11],dateformat.date_format)
     @placements_training.start_date=start_date
     @placements_training.end_date=end_date
    @placements_training.area_of_training=params[:placement_training][:area_of_training]
    @placements_training.mg_placement_registration_id=params[:placement_training][:mg_placement_registration_id]
    @placements_training.is_active=params[:is_active]
    # if params[:is_active]=="pending"
    #      @placements_training.is_active=true
    # else
    #      @placements_training.is_active=false
    # end
         # @placements_training.status=params[:is_active]

    if @placements_training.save
      
      flash[:notice]="Training Offered updated successfully"
      redirect_to :action=>'training_offered'
    else
      flash[:error]="Training Offered updated unsuccessfull"
      render :action=>'training_offered'
    end
  end
  def training_offered_delete
    @placements_training=MgPlacementTrainingOffered.find_by_id(params[:id])
    @placements_training.is_deleted=1
    @placements_training.save
    redirect_to :action=>'training_offered'

  end
  def training_offered_validation
   result= MgPlacementTrainingOffered.where(:mg_placement_registration_id=>params[:company_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
   if result.size>0
    data=1
   else
    data=0
   end
   render :json => {:name => data}

  end
  def job_apply
    student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @job_apply=MgPlacementJobApplication.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_student_id=>student_data.id).paginate(page: params[:page], per_page: 10)

  end
  def job_apply_new
    @placement_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
    @request="new"
    document_data=MgDocumentManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id],:document_type=>"studentCv",:is_default=>1)
   document=MgDocumentManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id],:document_type=>"studentCv",:is_default=>0)

    @document_array=Array.new
    
    document_data.each do|data|
      document_array_data=Array.new
      document_array_data.push(data.file_file_name,data.id)
      @document_array.push(document_array_data)
    end
     document.each do|data|
      document_array_datas=Array.new
      document_array_datas.push(data.file_file_name,data.id)
      @document_array.push(document_array_datas)
    end
   
  end

  def onchange_data

    if params[:selecter]=='company_job_id'

      job_upload_data=MgPlacementJobUpload.where(:status=>'active',:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:company=>params[:id])
     str='<option value="">Select</option>'
      job_upload_data.each do |a|
         str +="<option value='#{a.id}'>#{a.job_id}</option>"
      end
      @object=str
 elsif params[:selecter]=='Select_Semester'

    course_data=MgCourse.where(:mg_wing_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:id)
    puts course_data.inspect

    batch_data=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_data)
    puts batch_data.inspect

        str='<option value="">Select</option>'
      batch_data.each do |s|
        str +="<option value='#{s.try(:id)}'>#{s.try(:course_batch_name)}</option>"
      end
      @object=str

  end

          respond_to do |format|
          format.json  { render :json => {main: @object, sub: ""} }
        end
  end
   def onchange_data_edit

    
    if params[:selecter]=='company_job_id'

    
      job_upload_data=MgPlacementJobUpload.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:company=>params[:id])
     str='<option value="">Select</option>'
      job_upload_data.each do |a|
        if params[:data1].to_i==a.id
         str +="<option value='#{a.id}' selected>#{a.job_id}</option>"
       else
          str +="<option value='#{a.id}'>#{a.job_id}</option>"
       end
      end
      @object=str
      elsif params[:selecter]=='Select_Semester'
        
       course_data=MgCourse.where(:mg_wing_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:id)
       batch_data=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_data)
      str='<option value="">Select</option>'
      batch_data.each do |s|
         if params[:data1].to_i==s.id
          puts s.try(:course_batch_name)
        str +="<option value='#{s.try(:id)}' selected>#{s.try(:course_batch_name)}</option>"
        else
         
          str +="<option value='#{s.try(:id)}'>#{s.try(:course_batch_name)}</option>"
        end
      end
         @object=str
          



    end
 
    respond_to do |format|
          format.json  { render :json => {main: @object} }
        end
  end

  def readonly_data
      @job_upload_data=MgPlacementJobUpload.find_by(:id=>params[:id])
      render :layout=>false
  end
  def job_apply_create
    job_application=MgPlacementJobApplication.new(placement_joining_params)
    @placement_data=MgPlacementJobUpload.find_by(:id=>params[:job_apply][:mg_job_upload_id])
    job_application.round1_date=@placement_data.interview_date
    job_application.round1=@placement_data.round1

    job_application.pass_out_year=params[:time_table_year]

    student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
    job_application.mg_student_id=student_data.id
    job_application.mg_batch_id=student_data.mg_batch_id
    job_application.save
    redirect_to :action=>"job_apply"
  end
  def job_apply_show
    #puts sjagdjasd
  @placement_application=MgPlacementJobApplication.find_by(:id=>params[:id])
  @job_upload_data=MgPlacementRegistration.find_by(:id=>@placement_application.mg_placement_registration_id)

  @placement_job_upload=MgPlacementJobUpload.find_by(:id=>@placement_application.mg_job_upload_id)

  @resume=MgDocumentManagement.find_by(:id=>@placement_application.mg_document_management_id)
  render :layout=>false
  end
  def job_apply_edit

     @request="edit"
  @placement_application=MgPlacementJobApplication.find_by(:id=>params[:id])
  @job_upload_data=MgPlacementRegistration.find_by(:id=>@placement_application.mg_placement_registration_id)

  @placement_job_upload=MgPlacementJobUpload.find_by(:id=>@placement_application.mg_job_upload_id)
document_data=MgDocumentManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id],:document_type=>"studentCv",:is_default=>1)
   document=MgDocumentManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id],:document_type=>"studentCv",:is_default=>0)

    @document_array=Array.new
    
    document_data.each do|data|
      document_array_data=Array.new
      document_array_data.push(data.file_file_name,data.id)
      @document_array.push(document_array_data)
    end
     document.each do|data|
      document_array_datas=Array.new
      document_array_datas.push(data.file_file_name,data.id)
      @document_array.push(document_array_datas)
    end
  end
  def job_apply_update
      @placement_applications=MgPlacementJobApplication.find_by(:id=>params[:job_apply][:id])
      puts @placement_applications.inspect
      @placement_applications.update(placement_joining_params_update)
            @placement_applications.update(:pass_out_year=>params[:time_table_year])

      redirect_to :action=>"job_apply"
  end
  def job_apply_delete
    @placement_applications=MgPlacementJobApplication.find_by_id(params[:id])
    @placement_applications.is_deleted=1
    @placement_applications.save
    redirect_to :action=>'job_apply'
  end
  def student_selection
        @short_list_students=MgPlacementShortListStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end
  def student_selection_new
    @request=="new"
  end

  def select_students_on_job
      if params[:data_demo]=="demo"
  @student_job_data_pre_data=MgPlacementJobApplication.where(:mg_batch_id=>params[:id],:is_deleted=>0,:mg_job_upload_id=>params[:job_id],:mg_school_id=>session[:current_user_school_id],:pass_out_year=>params[:pass_out_year])
      @mg_interview_round_id=@student_job_data_pre_data[0].mg_interview_round_id
      @mg_interview_datess=@student_job_data_pre_data[0].next_round_date
      # dateformat = MgSchool.find(session[:current_user_school_id])
      # @next_round_date_datass = Date.strptime(@mg_interview_datess,dateformat.date_format)
        @demo_data_valid=1

      else
        @next_round_date_datass=""
        @mg_interview_round_id=0
        @demo_data_valid=0


      end
     @placement_data=MgPlacementJobUpload.find_by(:id=>params[:job_id])
     @placement_data.inspect
     student_job_data=MgPlacementJobApplication.where(:mg_batch_id=>params[:id],:is_deleted=>0,:mg_job_upload_id=>params[:job_id],:mg_school_id=>session[:current_user_school_id],:pass_out_year=>params[:pass_out_year]).order(is_round_selected: :desc).pluck(:mg_student_id).uniq
     @student_job_data_pre=MgPlacementJobApplication.where(:mg_batch_id=>params[:id],:is_deleted=>0,:mg_job_upload_id=>params[:job_id],:mg_school_id=>session[:current_user_school_id],:pass_out_year=>params[:pass_out_year])

     @array_data=Array.new
      @student_job_data_pre.each do |data| 
        (1..10).each do |i| 
           if data.public_send("round#{i}").present?

            @array_data.push(data.public_send("round#{i}"))

        end
      end
      end
      @array_datas=@array_data.uniq
      #puts "================="
      #puts student_job_data.inspect

     @student_data=MgStudent.where(:id=>student_job_data)

      @sorted_records = student_job_data.collect {|id| @student_data.detect {|x| x.id == id}}

      # => puts @sorted_records.inspect

     # puts asdasd

     @rounds_array=Array.new
     @id_array=Array.new
     @data_id_round=Array.new
     (1..10).each do |i| 
        
           
         if @placement_data.public_send("round#{i}").present?
            rounds=Array.new

            round_data=MgInterviewRound.find_by(:id=>@placement_data.public_send("round#{i}"))
             
            rounds.push(round_data.name,round_data.id)
              @rounds_array.push(rounds) 
              @data_id_round.push(round_data.id)
          @id_array.push(round_data.id)
         end
    end 

    render :layout=>false
  end
  def select_students_on_job_edit
     @student_list=MgPlacementShortListStudent.find_by(:id=>params[:placement_id])
     puts @student_list.inspect
     puts @student_list.mg_interview_round_id.inspect
     @interview=MgInterviewRound.find_by(:id=>@student_list.mg_interview_round_id)
      @placement_data_array=MgPlacementShortList.where(:mg_placement_short_list_student_id=>@student_list.id)

     @student_list.inspect
     @dateformat = MgSchool.find(session[:current_user_school_id])
     @placement_data=MgPlacementJobUpload.find_by(:id=>params[:job_id])
     @placement_data.inspect
     student_job_data=MgPlacementJobApplication.where(:mg_batch_id=>params[:id],:is_deleted=>0,:mg_job_upload_id=>params[:job_id],:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id).uniq
     @student_data=MgStudent.where(:id=>student_job_data)
     @rounds_array=Array.new
     @id_array=Array.new
     (1..10).each do |i| 
        
           
         if @placement_data.public_send("round#{i}").present?
            rounds=Array.new

            round_data=MgInterviewRound.find_by(:id=>@placement_data.public_send("round#{i}"))
             
            rounds.push(round_data.name,round_data.id)
              @rounds_array.push(rounds) 
          @id_array.push(round_data.id)
         end
    end 

    render :layout=>false
  end
  def student_selection_create
    # puts jaSGDJHAGSD
      placement_shortlist_params=MgPlacementShortListStudent.new(placement_shortlist_students_params)
      placement_shortlist_params.mg_batch_id=params[:mg_batch_id]
      placement_shortlist_params.mg_interview_round_id=params[:mg_interview_round_id]
      dateformat = MgSchool.find(session[:current_user_school_id])
      next_round_date_data = Date.strptime(params[:next_round_date],dateformat.date_format)

      placement_shortlist_params.next_round_date=next_round_date_data
     if placement_shortlist_params.save
         student_job_data=MgPlacementJobApplication.where(:mg_batch_id=>placement_shortlist_params.mg_batch_id,:is_deleted=>0,:mg_job_upload_id=>placement_shortlist_params.mg_placement_job_upload,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id).uniq
         @student_data=MgStudent.where(:id=>student_job_data)
         @student_data.each do |data|

          
           
   
            short_list=MgPlacementShortList.new()

            short_list.mg_student_id=data.id
              if params[:interview_data][data.id.to_s]!=nil

             interview_selected_date_data = Date.strptime(params[:interview_data][data.id.to_s],dateformat.date_format)

            short_list.interview_selected_date=interview_selected_date_data
            end

            if params[:student_id_data].present?
              
              if params[:student_id_data][data.id.to_s]!=nil
            
            short_list.is_round_selected=true
            subject="From Placement Head"
           description="You have shortlisted for next round It will  conduct on "+next_round_date_data.to_s
          else
        
             short_list.is_round_selected=false
             subject="From Placement Head"
             description="You have Not shortlisted for next round"
             
          end
        else
          short_list.is_round_selected=false
        
          end
            short_list.mg_placement_short_list_student_id=placement_shortlist_params.id
            short_list.is_deleted=0
            short_list.mg_school_id=session[:current_user_school_id]
            short_list.created_by=session[:user_id]
            short_list.updated_by=session[:user_id]
            short_list.save
            notification=MgNotification.send_notification(session[:user_id],data.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
            notification.save
          end
          end
   redirect_to :action=>"student_selection"
  end
  def student_selection_show
       @placement_data=MgPlacementShortListStudent.find_by(:id=>params[:id])
       @placement=MgPlacementRegistration.find_by(:id=>@placement_data.mg_placement_registration_id)
        @job=MgPlacementJobUpload.find_by(:id=>@placement_data.mg_placement_job_upload)
        @wing=MgWing.find_by(:id=>@placement_data.mg_wing_id)
        @batch=MgBatch.find_by(:id=>@placement_data.mg_batch_id)
        @course=MgCourse.find_by(:id=>@batch.mg_course_id)
        @interview=MgInterviewRound.find_by(:id=>@placement_data.mg_interview_round_id)
        @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
       placement_data_list=MgPlacementShortList.where(:mg_placement_short_list_student_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)
       @student_data=MgStudent.where(:id=>placement_data_list)
       @placement_data_array=MgPlacementShortList.where(:mg_placement_short_list_student_id=>params[:id])


  end
  def student_selection_edit
     @placement_data=MgPlacementShortListStudent.find_by(:id=>params[:id])
     placement_data_list=MgPlacementShortList.where(:mg_placement_short_list_student_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  end
   def student_selection_update
     placement_shortlist_params=MgPlacementShortListStudent.find_by(:id=>params[:shortlist_students][:id])

      placement_shortlist_params.mg_batch_id=params[:mg_batch_id]
      placement_shortlist_params.mg_placement_registration_id=params[:shortlist_students][:mg_placement_registration_id]
      placement_shortlist_params.mg_placement_job_upload=params[:shortlist_students][:mg_placement_job_upload]
      placement_shortlist_params.mg_wing_id=params[:shortlist_students][:mg_wing_id]
      placement_shortlist_params.updated_by=params[:shortlist_students][:updated_by]


      placement_shortlist_params.mg_interview_round_id=params[:mg_interview_round_id]
      dateformat = MgSchool.find(session[:current_user_school_id])
      next_round_date_data = Date.strptime(params[:next_round_date],dateformat.date_format)

      placement_shortlist_params.next_round_date=next_round_date_data
     if placement_shortlist_params.save
         student_job_data=MgPlacementJobApplication.where(:mg_batch_id=>placement_shortlist_params.mg_batch_id,:is_deleted=>0,:mg_job_upload_id=>placement_shortlist_params.mg_placement_job_upload,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id).uniq
         @student_data=MgStudent.where(:id=>student_job_data)
         @student_data.each do |data|

          
           
   
            short_list=MgPlacementShortList.find_by(:mg_student_id=>data.id,:mg_placement_short_list_student_id=>params[:shortlist_students][:id])

            short_list.mg_student_id=data.id
              if params[:interview_data][data.id.to_s]!=nil

             interview_selected_date_data = Date.strptime(params[:interview_data][data.id.to_s],dateformat.date_format)

            short_list.interview_selected_date=interview_selected_date_data
            
          else
            short_list.interview_selected_date=nil
          end

            if params[:student_id_data].present?
              
              if params[:student_id_data][data.id.to_s]!=nil
            
            short_list.is_round_selected=true
            subject="From Placement Head"
           description="You have shortlisted for next round It will  conduct on "+next_round_date_data.to_s
          else
        
             short_list.is_round_selected=false
             subject="From Placement Head"
             description="You have Not shortlisted for next round"
             
          end
        else
          short_list.is_round_selected=false
        
          end
            short_list.mg_placement_short_list_student_id=placement_shortlist_params.id
            short_list.updated_by=session[:user_id]
            short_list.save
            notification=MgNotification.send_notification(session[:user_id],data.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
            notification.save
          end
          end
  redirect_to :action=>"student_selection"

  end
  def student_selection_delete

  placement_shortlist_params=MgPlacementShortListStudent.find_by(:id=>params[:id])
  placement_shortlist_params.is_deleted=1
  if placement_shortlist_params.save
  short_list=MgPlacementShortList.where(:mg_placement_short_list_student_id=>params[:id])
  short_list.each do |data|
  data.is_deleted=1
  data.save
end
  end
  redirect_to :action=>"student_selection"
end

  # Balaji Work Starts

  def job_upload
    # @job_upload=MgAlumniJobPostingDetail.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
   if session[:user_type]=="Company"
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    @job_upload=MgPlacementJobUpload.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).paginate(page: params[:page], per_page: 10)
    company_data= MgPlacementRegistration.find_by(:mg_user_id=>session[:user_id])
    else
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    @job_upload=MgPlacementJobUpload.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    company_data= MgPlacementRegistration.find_by(:mg_user_id=>session[:user_id])
    
    end
  end


  def job_upload_new
    @action='new'
    if MgPlacementJobUpload.where(:mg_school_id=>session[:current_user_school_id]).count.zero? # empty array
          @id='1'
    else
        @id=MgPlacementJobUpload.where(:mg_school_id=>session[:current_user_school_id]).count+1
    end
    @job_id="JOB"+"#{@id}"

  end

  def job_upload_create
    # puts ddd
    @job_upload = MgPlacementJobUpload.new(job_upload_params)
    @timeformat = MgSchool.find(session[:current_user_school_id])
    last_date_application = Date.strptime(params[:job_upload_type][:last_date_application],@timeformat.date_format)
    @job_upload.last_date_application=last_date_application

    interview_date = Date.strptime(params[:job_upload_type][:interview_date],@timeformat.date_format)
    @job_upload.interview_date=interview_date
    company_data= MgPlacementRegistration.find_by(:mg_user_id=>session[:user_id])

    if session[:user_type]=="Company"
      @job_upload.company= company_data.id
      @job_upload.company_website=company_data.company_website_url
    else 
      @job_upload.company=params[:job_upload_type][:company]
      @job_upload.company_website=params[:job_upload_type][:company_website]
    end 


    if MgPlacementJobUpload.where(:mg_school_id=>session[:current_user_school_id]).count.zero? # empty array
          @id='1'
    else
        @id=MgPlacementJobUpload.where(:mg_school_id=>session[:current_user_school_id]).count+1
    end
    @job_upload.job_id="JOB"+"#{@id}"

    if params[:round].present?
      params[:round].each do |k,v|
          @job_upload.send("round#{k}=", v)
      end
    end
    @job_upload.save
    redirect_to :action=>'job_upload'
  end


  def job_upload_edit
    @action='edit'
    @job_upload=MgPlacementJobUpload.find(params[:id])
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  end

  def job_upload_show
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    @job_upload=MgPlacementJobUpload.find(params[:id])
    
  end

  def job_upload_show_student
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    @job_upload=MgPlacementJobUpload.find(params[:id])
    render :layout=>false
    
  end

  def job_upload_update
    @job_upload=MgPlacementJobUpload.find(params[:id])

    @job_upload.update(update_job_upload_params)

    @timeformat = MgSchool.find(session[:current_user_school_id])
    last_date_application = Date.strptime(params[:job_upload_type][:last_date_application],@timeformat.date_format)
    @job_upload.last_date_application=last_date_application

    interview_date = Date.strptime(params[:job_upload_type][:interview_date],@timeformat.date_format)
    @job_upload.interview_date=interview_date
    company_data= MgPlacementRegistration.find_by(:mg_user_id=>session[:user_id])

    if session[:user_type]=="Company"
      @job_upload.company= company_data.id
      @job_upload.company_website=company_data.company_website_url
    else 
      @job_upload.company=params[:job_upload_type][:company]
      @job_upload.company_website=params[:job_upload_type][:company_website]
    end
    

    round_data=MgPlacementJobUpload.find_by(:id=>params[:id]).job_id
    @job_upload.job_id=round_data


     (1..10).each do |i|
        if @job_upload.public_send("round#{i}").present? 
             @job_upload.send("round#{i}=","")     
         end 
     end 

      if params[:round].present?
        params[:round].each do |k,v|
            @job_upload.send("round#{k}=", v)
        end
      end
      @job_upload.save

    if @job_upload.update(update_job_upload_params)
      flash[:notice] = "Successfully Updated..."
    else
      flash[:error] = "Not Updated..."
    end
    redirect_to :action=>'job_upload'
  end

  def job_upload_accept
    #params zdfasdfas
    data_array= params[:id]
    data_arr=data_array.split("-")
    student= MgStudent.find_by(:mg_user_id=>session[:user_id])
    @accept_data_id_param=data_arr[1]
    puts params[:id].inspect
    #puts ashdjk
    @job_upload=MgPlacementAcceptedTrainee.find_by(:mg_placement_training_offered_id=>data_arr[0],:mg_student_id=>student.id)
    if @job_upload.present?
      @job_upload.status=params[:status]
      @job_upload.save
      # if params[:status]=="Applied"
      #   @job_upload.status="Applied"
      #   @job_upload.save
      # elsif params[:status]=="Pending"
      #   @job_upload.status="Pending"
      #   @job_upload.save
      # end
    else
      @accept_data=MgPlacementTrainingOffered.find(data_arr[0])
      @job_upload=MgPlacementAcceptedTrainee.new()
      @job_upload.is_deleted=0
      @job_upload.mg_school_id= session[:current_user_school_id]
      @job_upload.created_by= session[:user_id]
      @job_upload.updated_by= session[:user_id]
      @job_upload.mg_placement_registration_id=@accept_data.mg_placement_registration_id
      student_id= MgStudent.find_by(:mg_user_id=>session[:user_id]).id
      batch_id= MgStudent.find_by(:mg_user_id=>session[:user_id]).mg_batch_id

      @job_upload.mg_student_id=student_id
      @job_upload.mg_batch_id=batch_id

      @job_upload.mg_placement_training_offered_id=@accept_data.id
      @job_upload.status=params[:status]
      @job_upload.save
    end
    redirect_to :action=>'training_offered_student',:id=>@accept_data_id_param
  end



  def job_upload_reject
    data_array= params[:id]
     data_arr=data_array.split("-")
    @accept_data=MgPlacementTrainingOffered.find(data_arr[0])
    student= MgStudent.find_by(:mg_user_id=>session[:user_id])

    @job_upload=MgPlacementAcceptedTrainee.find_by(:mg_placement_training_offered_id=>@accept_data.id,:mg_student_id=>student.id)
   
    @job_upload.status="Pending"
    @job_upload.save

    redirect_to :action=>'training_offered_student',:id=>data_arr[1]

  end
  
  def job_upload_delete
    delete_job_upload_data=MgPlacementJobUpload.find(params[:id])
    delete_job_upload_data.is_deleted=1
    if delete_job_upload_data.save
    flash[:notice] = "Successfully Deleted..."
    else
      flash[:error]="Error Occurred..."
    end
    redirect_to :action=>"job_upload"
end

def training_offered_student 
  @data=params[:id]
  if params[:id].present?
    puts"1111111111111111111"
    puts"1111111111111111111"
    @company_registration=MgPlacementRegistration.where(:status=>'Active',:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    # @training_offered=MgPlacementTrainingOffered.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_active=>true,:mg_placement_registration_id=>@data).paginate(page: params[:page], per_page: 10)
    
    @training_offered=MgPlacementTrainingOffered.where("is_deleted=? and mg_school_id=? and is_active=? or is_active=? and mg_placement_registration_id=?",0,session[:current_user_school_id], "Approved", "Cancelled",@data).paginate(page: params[:page], per_page: 10)
    
    # Model.where("column = ? or other_column = ?", value, other_value)

    @student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
  else
    puts"2222222"
    @company_registration=MgPlacementRegistration.where(:status=>'Active', :is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    # @training_offered=MgPlacementTrainingOffered.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_active=>true).paginate(page: params[:page], per_page: 10)
    @training_offered=MgPlacementTrainingOffered.where("is_deleted=? and mg_school_id=? and (is_active=? or is_active=?) ",0,session[:current_user_school_id], "Approved", "Cancelled").paginate(page: params[:page], per_page: 10)
    @student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
  end
end

def filter_company_data
  if params[:id].present?
    @training_offered=MgPlacementTrainingOffered.where("mg_placement_registration_id=? and is_deleted=? and mg_school_id=? and (is_active=? or is_active=?)",params[:id],0,session[:current_user_school_id], "Approved", "Cancelled").paginate(page: params[:page], per_page: 10)
  else
    @training_offered=MgPlacementTrainingOffered.where("is_deleted=? and mg_school_id=? and is_active=? or is_active=?",0,session[:current_user_school_id], "Approved", "Cancelled").paginate(page: params[:page], per_page: 10)
  end
  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  @student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])

  render :layout=>false
end
def placement_training_requested
  @training_requested=MgPlacementTrainingRequired.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def placement_training_requested_show
  @training_requested=MgPlacementTrainingRequired.find(params[:id])
  render :layout=>false
end

def placement_training_status_update
  @training_requested=MgPlacementTrainingRequired.find(params[:id])
  @training_requested.status=params[:status]
  @training_requested.save

  redirect_to :action=>"placement_training_requested"

end

def training_request_accept
   @requested_training=MgPlacementTrainingRequired.find(params[:id])
    
    @requested_training.status="Accepted"
    @requested_training.save

    redirect_to :action=>'placement_training_requested'
end

def training_request_reject
    @requested_training=MgPlacementTrainingRequired.find(params[:id])
    @requested_training.status="Pending"
    @requested_training.save
    redirect_to :action=>'placement_training_requested'
  end

  # Balaji Work Ends

  def placement_training_required_index
    student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
     @training_required=MgPlacementTrainingRequired.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id],:student_id=>student_data.id).paginate(page: params[:page], per_page: 10)

  end
  
  def placement_training_required_new
     @action= 'new'
     @training_required=MgPlacementTrainingRequired.new
  end

  def placement_training_required_create
     @training_required=MgPlacementTrainingRequired.new(training_required_params)
     student=MgStudent.find_by(:mg_user_id=>session[:user_id])
     @training_required.student_id=student.id
     @training_required.mg_batch_id =student.mg_batch_id
     @training_required.save
     redirect_to :action=>"placement_training_required_index"
  end

  def placement_training_required_show
     @training_required=MgPlacementTrainingRequired.find(params[:id])
     render layout: false
  end

  def placement_training_required_edit
     @action='edit'
     @training_required=MgPlacementTrainingRequired.find(params[:id])
  end

  def placement_training_required_update
    @training_required=MgPlacementTrainingRequired.find(params[:id])
    
    if @training_required.update(training_required_params)
    redirect_to :action=>"placement_training_required_index"
    else
      render 'placement_training_required_edit'
    end

  end

  def placement_training_required_delete
    @training_required=MgPlacementTrainingRequired.find(params[:id])
    if @training_required.update(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice]="Job profile deleted successfully"
    else
      flash[:error]="Error occured,Please try later"
    end
    redirect_to :action=>"placement_training_required_index"
  end

  def placement_head_resetpassword
  @user=MgUser.where(:user_type=>"placement_cell_head",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>session[:user_id])
  @registration_data=MgPlacementRegistration.find_by(:id=>params[:id])
  # @user=MgUser.find(params[:id])
  #   render :layout=>false

  end

def change_placement_head_password
    user_data=MgUser.find_by(:id=>session[:user_id])
    
    if user_data.update(:password=>params[:PlacementHead_hashed_password])
    
      flash[:notice] = "Password Changed Successfully..."
    end
    redirect_to :action=>"placement_head_resetpassword"
  end

  def change_recruit_password
    user_data=MgUser.find_by(:id=>session[:user_id])
    
    if user_data.update(:password=>params[:recruit_hashed_password])
    
      flash[:notice] = "Password Changed Successfully..."
    end
    redirect_to :action=>"recruit_resetpassword"
  end


  def resetpassword

     render :layout=>false
  end

  def password_search_data
    user = MgUser.authenticatePasswordData(session[:user_id],params[:password]) 

    puts session[:user_id]
    if user.present?
      data=1
    else
      data=0
    end
      render :json => {:name =>data}
  end

  def recruit_resetpassword
  @user=MgUser.where(:user_type=>"recruitment_assistant",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>session[:user_id])
    
  end

  def resetpassword_recruit
     render :layout=>false
  end



  def corporate_resetpassword
  @user=MgUser.where(:user_type=>"Company",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>session[:user_id])
  end

  def resetpassword_corporate
     render :layout=>false
  end

  def change_corporate_password
    user_data=MgUser.find_by(:id=>session[:user_id])
    
    if user_data.update(:password=>params[:corporate_hashed_password])
    
      flash[:notice] = "Password Changed Successfully..."
    end
    redirect_to :action=>"corporate_resetpassword"
  end




#jayanth's

def placement_student_selection
 @job_upload_data= MgPlacementJobUpload.where(:status=>'active' ,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

end

def placement_student_selection_edit
  if params[:data].present?
    @validation_data=1
    data1=params[:data].split("-")
    @data=data1[0]
  @wing_data=data1[1]
  @mg_job_upload_id_data_datas=data1[0]
  @time_table_year=data1[2]
  @mg_batch_id_datass=data1[3]

else
@data=params[:id]
    @validation_data=0

 @wing_data=0
  @mg_job_upload_id_data_datas=0
  @time_table_year=0
  @mg_batch_id_datass=0
end

   @job_upload_data= MgPlacementJobUpload.find_by(:id=>@data)
   @placement=MgPlacementRegistration.find_by(:id=>@job_upload_data.company)
   @time_table=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)

end

def placement_student_selection_create


#puts params.inspect
#puts jghsdg
  @wing_data=params[:shortlist_students][:mg_wing_id]
  @mg_job_upload_id_data_datas=params[:job_upload_id_data]
  @time_table_year=params[:time_table_year]
  @mg_batch_id_datass=params[:mg_batch_id]
  @next_round_date_datas=params[:next_round_date]
  @mg_interview_round_id_datas=params[:mg_interview_round_id]
  @mg_interview_round_id_datas=params[:mg_placement]
data_all="#{@mg_job_upload_id_data_datas}-#{@wing_data}-#{@time_table_year}-#{@mg_batch_id_datass}"
  #@mg_interview_round_id_datas=params[:mg_interview_round_id]
 puts "================================"
  puts data_all.inspect
  #puts jhSGSGAs


  student_data=params[:student_id_data]
  interview_date=params[:interview_data]
 
   student_job_data=MgPlacementJobApplication.where(:mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_job_upload_id=>params[:mg_job_upload_id_data],:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id).uniq
         @student_data=MgStudent.where(:id=>student_job_data)
    
              dateformat = MgSchool.find(session[:current_user_school_id])

            

@student_data.each do |data|

  if params[:student_id_data].present?
  if params[:student_id_data][data.id.to_s]!=nil   

   job_application= MgPlacementJobApplication.find_by(:mg_student_id=>data.id,:mg_batch_id=>params[:mg_batch_id],:mg_job_upload_id=>params[:mg_job_upload_id_data],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
   
   job_application.mg_wing_id=params[:shortlist_students][:mg_wing_id]
   job_application.mg_interview_round_id=params[:mg_interview_round_id]
   if params[:next_round_date].present?

   next_round_date_date_demo = Date.strptime(params[:next_round_date],dateformat.date_format)

   job_application.next_round_date=next_round_date_date_demo
 end#3rd if
   job_application.is_round_selected=true
   job_upload=MgPlacementJobUpload.find_by(:id=>params[:mg_job_upload_id_data])
    if params[:student_job_selected].present?
       if params[:student_job_selected][data.id.to_s].present? 

      job_application.job_selected=true

    else
    job_application.job_selected=false

    end
     else
 
    job_application.job_selected=false

    end
    (1..10).each do |i|
         if job_upload.public_send("round#{i}").present? 
           round_data=MgInterviewRound.find_by(:id=>job_upload.public_send("round#{i}"))
          if round_data.id.to_i==params[:mg_interview_round_id].to_i
              job_application.send("round#{i}=", params[:mg_interview_round_id])
          next_round_date_date = Date.strptime(params[:interview_data][data.id.to_s],dateformat.date_format)
              job_application.send("round#{i}_date=", next_round_date_date)
           end

          end
     end

  else
   job_application= MgPlacementJobApplication.find_by(:mg_student_id=>data.id,:mg_batch_id=>params[:mg_batch_id],:mg_job_upload_id=>params[:mg_job_upload_id_data],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
   job_application.mg_wing_id=params[:shortlist_students][:mg_wing_id]
   #job_application.mg_time_table_id=params[:shortlist_students][:mg_time_table_id]
   job_application.mg_interview_round_id=params[:mg_interview_round_id]
   if params[:next_round_date].present?
   next_round_date_date_demo = Date.strptime(params[:next_round_date],dateformat.date_format)

   job_application.next_round_date=next_round_date_date_demo
 end
   #job_application.mg_wing_id=params[:mg_interview_round_id]
   job_application.is_round_selected=false
   job_upload=MgPlacementJobUpload.find_by(:id=>params[:mg_job_upload_id_data])

    if params[:student_job_selected].present?
     # puts ggsdasd
       if params[:student_job_selected][data.id.to_s].present? 
        #puts ggsdasd
      job_application.job_selected=true
    else
    job_application.job_selected=false

    end
     else
 
    job_application.job_selected=false

    end

    (1..10).each do |i|
         if job_upload.public_send("round#{i}").present? 
           round_data=MgInterviewRound.find_by(:id=>job_upload.public_send("round#{i}"))
           if round_data.id.to_i==params[:mg_interview_round_id].to_i
              job_application.send("round#{i}=", params[:mg_interview_round_id])
              job_application.send("round#{i}_date=", nil)

           end

         end
    end
  end
else#first if
  puts params[:mg_interview_round_id].present?
        # =>  puts jghsdg

  job_application= MgPlacementJobApplication.find_by(:mg_student_id=>data.id,:mg_batch_id=>params[:mg_batch_id],:mg_job_upload_id=>params[:mg_job_upload_id_data],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
      #job_application.mg_interview_round_id=0
      if params[:mg_interview_round_id].present?
         #puts jghsdg
        (1..10).each do |i|
         if job_application.public_send("round#{i}").present? 
          if job_application.public_send("round#{i}").to_i==params[:mg_interview_round_id].to_i
         #puts jghsdg

           round_data=MgInterviewRound.find_by(:id=>job_application.public_send("round#{i}"))
           if round_data.id.to_i==params[:mg_interview_round_id].to_i
              job_application.send("round#{i}=", params[:mg_interview_round_id])
              job_application.send("round#{i}_date=", nil)

           end
         end

         end
    end#do end
  else
    job_application.mg_interview_round_id=0
  end
      if params[:next_round_date].present?

   next_round_date_date_demo = Date.strptime(params[:next_round_date],dateformat.date_format)

   job_application.next_round_date=next_round_date_date_demo
 else
  job_application.next_round_date=nil
 end
   if params[:student_job_selected].present?
       if params[:student_job_selected][data.id.to_s].present? 
      job_application.job_selected=true
    else
    job_application.job_selected=false

    end
     else
 
    job_application.job_selected=false

    end
  end
  job_application.save

end
   redirect_to :action=>"placement_student_selection_edit",:data=>data_all
end


def placement_student_selection_show

   @job_upload_data= MgPlacementJobUpload.find_by(:id=>params[:id])
   @placement=MgPlacementRegistration.find_by(:id=>@job_upload_data.company)
   @time_table=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)

end

def select_students_on_job_show

 @placement_data=MgPlacementJobUpload.find_by(:id=>params[:job_id])
     @placement_data.inspect
     student_job_data=MgPlacementJobApplication.where(:mg_batch_id=>params[:id],:is_deleted=>0,:mg_job_upload_id=>params[:job_id],:mg_school_id=>session[:current_user_school_id],:pass_out_year=>params[:pass_out_year]).order(is_round_selected: :desc).pluck(:mg_student_id).uniq
     @student_job_data_pre=MgPlacementJobApplication.where(:mg_batch_id=>params[:id],:is_deleted=>0,:mg_job_upload_id=>params[:job_id],:mg_school_id=>session[:current_user_school_id],:pass_out_year=>params[:pass_out_year])

     @array_data=Array.new
      @student_job_data_pre.each do |data| 
        (1..10).each do |i| 
           if data.public_send("round#{i}").present?

            @array_data.push(data.public_send("round#{i}"))

        end
      end
      end
      @array_datas=@array_data.uniq

     @student_data=MgStudent.where(:id=>student_job_data)

      @sorted_records = student_job_data.collect {|id| @student_data.detect {|x| x.id == id}}

     @rounds_array=Array.new
     @id_array=Array.new
     @data_id_round=Array.new
     (1..10).each do |i| 
        
           
         if @placement_data.public_send("round#{i}").present?
            rounds=Array.new

            round_data=MgInterviewRound.find_by(:id=>@placement_data.public_send("round#{i}"))
             
            rounds.push(round_data.name,round_data.id)
              @rounds_array.push(rounds) 
              @data_id_round.push(round_data.id)
          @id_array.push(round_data.id)
         end
    end 

    render :layout=>false
  end

def interview_status
    @placement_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
    @student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @placement_short_list_data=MgPlacementJobApplication.where(:mg_student_id=>@student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
     
  end
  def interview_status_for_student



    @placement_registration=MgPlacementRegistration.where(:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
    @student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @placement_short_list_data=MgPlacementJobApplication.where(:mg_student_id=>@student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    placement_short_list_data_id=MgPlacementJobApplication.where(:mg_student_id=>@student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_job_upload_id).uniq
    job_data=MgPlacementJobUpload.where(:id=>placement_short_list_data_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @job_arr=Array.new
      job_data.each do |data|
        count=0
         (1..10).each do |i| 

          if data.public_send("round#{i}").present?
            
            count=count+1
          end
           
      end
       @job_arr.push(count)

    end

    puts @job_arr.max.inspect

    @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
     

  end
def student_status_report
    if params[:data].present?
      @placement_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
    @student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @placement_short_list_data=MgPlacementJobApplication.where(:mg_student_id=>@student_data.id,:mg_placement_registration_id=>params[:data],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    placement_short_list_data_id=MgPlacementJobApplication.where(:mg_student_id=>@student_data.id,:mg_placement_registration_id=>params[:data],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_job_upload_id).uniq
    job_data=MgPlacementJobUpload.where(:id=>placement_short_list_data_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @job_arr=Array.new
      job_data.each do |data|
        count=0
         (1..10).each do |i| 

          if data.public_send("round#{i}").present?
            
            count=count+1
          end
           
      end
       @job_arr.push(count)

    end

    puts @job_arr.max.inspect

    @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
    else


    @placement_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)
    @student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @placement_short_list_data=MgPlacementJobApplication.where(:mg_student_id=>@student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    placement_short_list_data_id=MgPlacementJobApplication.where(:mg_student_id=>@student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_job_upload_id).uniq
    job_data=MgPlacementJobUpload.where(:id=>placement_short_list_data_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

    @job_arr=Array.new
      job_data.each do |data|
        count=0
         (1..10).each do |i| 

          if data.public_send("round#{i}").present?
            
            count=count+1
          end
           
      end
       @job_arr.push(count)

    end

    puts @job_arr.max.inspect

    @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
     
    end
  
    render :layout=>false
end
 def placement_report
    
       batch_data=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

    @array2=Array.new
     batch_data.each do |s|
 course_data=MgCourse.find(s.mg_course_id)
    array1=Array.new

        array1.push("#{course_data.course_name}-#{s.name}",s.id)
        @array2.push(array1)
      end
  end
def select_data_based_on_semester_graph

    render :layout=>false

end
def select_data_based_on_semester_graph_data

    render :layout=>false

end
def send_notification
    puts params[:student_arr].inspect
    puts params[:date_arr].inspect
    puts params[:job_id].inspect
    puts params[:batch_data].inspect
    puts params[:interview_round].inspect

    #puts ajsgdhjd
     #student_job_data=MgPlacementJobApplication.where(:mg_batch_id=>params[:batch_data],:is_deleted=>0,:mg_job_upload_id=>params[:job_id],:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id).uniq
     @student_data=MgStudent.where(:id=>params[:student_arr])
     @placement_data=MgPlacementJobUpload.find_by(:id=>params[:job_id])
     placement_registration=MgPlacementRegistration.find_by(:id=>@placement_data.company)
     #MgInterviewRound.find_by(:id=>@placement_data)
     if @student_data.present?
     @student_data.each do |data|

     subject="From Placement Head"
     description="You have shortlisted for #{placement_registration.name_of_the_company} for job id #{@placement_data.job_id} your  interview will  conduct on "+@placement_data.interview_date.to_s
     notification=MgNotification.send_notification(session[:user_id],data.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
     notification.save


   end
   render :json => {:name => "ok "}

 else
data="0"

   render :json => {:name => data}

 end

  end

  def training_offered_list

    @placements_training=MgPlacementTrainingOffered.find_by(:id=>params[:id])
    @placement=MgPlacementRegistration.find_by(:id=>@placements_training.mg_placement_registration_id)
    @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
  #   if params[:id].present?
  #     @data=params[:id]
  # @company_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)

  #  @placement_training_offered=MgPlacementAcceptedTrainee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:status=>["Applied","Approved","Rejected"],:mg_placement_registration_id=>params[:id]).paginate(page: params[:page], per_page: 10)
  #    @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
  #  else
  #     @data=0

  #@company_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)

   @placement_training_offered=MgPlacementAcceptedTrainee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:status=>["Applied","Approved","Rejected"],:mg_placement_training_offered_id=>params[:id]).paginate(page: params[:page], per_page: 10)
     @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
   #end
  end
 def placement_training_offered_accept
     puts params[:inspect]
     #puts ajsgd

if params[:alumni_demo_data]=="Accept"
   #puts ajsgd
params[:select_data].each do |data|
placement_data=MgPlacementAcceptedTrainee.find_by(:id=>data)

placement_data.status="Approved"
 placement_data.save
end


elsif  params[:alumni_demo_data]=="Reject"
 # puts ajsgd
params[:select_data].each do |data|
placement_data=MgPlacementAcceptedTrainee.find_by(:id=>data)

placement_data.status="Rejected"
 placement_data.save
end

end
   # puts ajsdhgasd
redirect_to :back

  end

  def placement_training_offered_list
# if params[:id].present?
#       @data=params[:id]
#   @company_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name_of_the_company,:id)

#    @placement_training_offered=MgPlacementAcceptedTrainee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:status=>["Approved"],:mg_placement_registration_id=>params[:id]).paginate(page: params[:page], per_page: 10)
#      @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
#    else
#       @data=0

   @company_registration=MgPlacementRegistration.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id])
  
   @placement_training_offered=MgPlacementAcceptedTrainee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:status=>["Approved"],:mg_placement_registration_id=>@company_registration).paginate(page: params[:page], per_page: 10)
     @dateFormat = MgSchool.find_by_id(session[:current_user_school_id]).date_format
   end

  #end

  def corporate_profile
     @placements_registration=MgPlacementRegistration.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  end
  def corporate_profile_edit
    @school=MgSchool.find_by(:id=>session[:current_user_school_id])

    @placements_registration=MgPlacementRegistration.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :id=>params[:id])
    @user=MgUser.find(@placements_registration.mg_user_id)
    
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    @user_name=@user.user_name.sub(school.subdomain,"")
  end

  def corporate_profile_update
    mg_school_id=session[:current_user_school_id]

    @placements_registration=MgPlacementRegistration.find_by_id(params[:id])
    user_data=MgUser.find_by(:id=>@placements_registration.mg_user_id)

    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:user_name]
    user_data.update(:user_name=>user_name_with_domain)

    if user_data.save 
      @placements_registration.update(placements_registration_params_update)
      to_email_id=params[:placements_registration][:contact_email]
      from_email_id=MgEmail.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id,:mg_user_id=>session[:user_id]).try(:mg_email_id)
 
       if params[:placements_registration][:is_alumni].to_i==1  && params[:placements_registration][:have_alumni_id].to_i==0
          send_email(from_email_id,to_email_id,mg_school_id)
        end
      flash[:notice]="Profile updated successfully"
      redirect_to :action=>"corporate_profile",:id=>@placements_registration.id
    else
      flash[:error]="Profile updated unsuccessfull"
     redirect_to :action=>"corporate_profile",:id=>@placements_registration.id
    end
  end


  
  private
  # Bindhu Work Starts
  def placement_student_detail_params
    params.require(:student_detail).permit(:name, :resume_headline,:current_position,:date_of_birth,:last_degree,:year_of_passing,:functional_area,:educational_qualification,:experience,:technical_skills,:soft_skills,:salary_expected,:address,:contact_number,:email_id,:current_location,:preferred_location,:mg_student_id, :created_by, :updated_by, :is_deleted, :mg_school_id)
  end

  def student_resume_upload_params
     params.require(:student_resume).permit(:file,:is_default,:mg_user_id,:created_by, :updated_by, :is_deleted, :mg_school_id,:document_type)
  end

  def user_accounts_params
    params.require(:user).permit(:user_type,:password,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  # Bindhu Work Ends
  def placements_registration_params
    params.require(:placements_registration).permit(:contact_person, :is_alumni,:have_alumni_id,:alumni_id,:is_approved, :company_website_url,:location,:address,:contact_email,:contact_number,:industry,:name_of_the_company,:is_deleted,:created_by,:updated_by,:mg_school_id,:status,:reason)
    
  end

  def placements_registration_params_update
    params.require(:placements_registration).permit(:contact_person, :is_alumni,:have_alumni_id,:alumni_id,:is_approved, :company_website_url,:location,:address,:contact_email,:contact_number,:industry,:name_of_the_company,:is_deleted,:updated_by,:mg_school_id,:status,:reason)
  end

  def interview_rounds_params
    params.require(:interview_rounds).permit(:name, :description,:is_deleted,:created_by,:updated_by,:mg_school_id)
    
  end
  def placement_training_params
    params.require(:placement_training).permit(:mg_placement_registration_id, :area_of_training,:is_deleted,:created_by,:updated_by,:mg_school_id)
    
  end
  def placement_joining_params
    params.require(:job_apply).permit(:mg_placement_registration_id, :mg_job_upload_id,:mg_document_management_id,:is_deleted,:created_by,:updated_by,:mg_school_id)
    
  end
  def placement_joining_params_update
    params.require(:job_apply).permit(:mg_placement_registration_id, :mg_job_upload_id,:mg_document_management_id,:updated_by)
    
  end
   def placement_shortlist_students_params
    params.require(:shortlist_students).permit(:mg_placement_registration_id, :mg_placement_job_upload,:mg_wing_id,:is_deleted,:mg_school_id,:created_by,:updated_by)
    
  end

  def job_upload_params
    params.require(:job_upload_type).permit(:position,:job_description,:functional_area,:industry,:job_location,:edu_qual,:min_exp,:technical_skills,:soft_skills,:salary,:rel_exp,:referral_code,:interview_location,:status,:is_deleted,:created_by,:updated_by,:mg_school_id,:mg_user_id)
  end

  def update_job_upload_params
    params.require(:job_upload_type).permit(:position,:job_description,:functional_area,:industry,:job_location,:edu_qual,:min_exp,:technical_skills,:soft_skills,:salary,:rel_exp,:referral_code,:interview_location,:status,:is_deleted,:updated_by,:mg_school_id)
  end

  def training_required_params
    params.require(:training_required).permit(:area_of_training_required,:description,:status,:mg_school_id,:created_by,:updated_by,:is_deleted,:student_id,:mg_batch_id)

  end
end
