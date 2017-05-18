class MgStudentAdmissionsController < ApplicationController
  before_filter :login_required
  layout "mindcom"
  def index
    @student_admission=MgStudentAdmission.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def new
    @admission=MgStudentAdmission.new
  end

  def create
    @error_msg=[]
    MgStudentAdmission.transaction do
      @admission=MgStudentAdmission.new(params_student_data)
      if @admission.save
        @status_admission = MgStudentAdmission.find_by(:id=>@admission.id)
        temp_id = "123"+"#{@admission.id}"
        #@mgcourse_id = MgBatch.find_by(:id=>@admission.mg_batch_id).mg_course_id      
        @error_msg.push(@status_admission.update(:student_temporary_id=>temp_id.to_i,:is_selected_for_entrance_test=>"pending", :is_shortlisted_for_admission=>"pending")) #,:mg_course_id=>@mgcourse_id
      end
      timeformat = MgSchool.find(session[:current_user_school_id])
      if  params[:mg_student_admission][:date_of_birth].present?
          dateOfBirth = Date.strptime(params[:mg_student_admission][:date_of_birth],timeformat.date_format)
           @error_msg.push(@admission.update(:date_of_birth => dateOfBirth))
      end
      if @error_msg.include?(false)
        raise ActiveRecord::Rollback
      end
    end

    if @error_msg.include?(false)
      flash[:error]="There is some problem"
    else
      flash[:notice]="Record Inserted Successfully"
    end
    redirect_to :controller=>'mg_student_admissions', :action=>'index'
  end

  def edit
    @admission=MgStudentAdmission.find(params[:id])
  end

  def update
    @error_msg=[]
    MgStudentAdmission.transaction do
      @admission=MgStudentAdmission.find(params[:id])
      @admission_ids = @admission.update(params_student_data)
      @error_msg.push(@admission_ids)
      # if @admission_ids
      #   @mgcourse_id = MgBatch.find_by(:id=>@admission.mg_batch_id).mg_course_id      
      #   @admission.update(:mg_course_id=>@mgcourse_id)
      # end
      timeformat = MgSchool.find(session[:current_user_school_id])

      if  params[:mg_student_admission][:date_of_birth].present?
        dateOfBirth = Date.strptime(params[:mg_student_admission][:date_of_birth],timeformat.date_format)
        @error_msg.push(@admission.update(:date_of_birth => dateOfBirth))
      end
      if @error_msg.include?(false)
        raise ActiveRecord::Rollback
      end
    end
    if @error_msg.include?(false)
      flash[:error]="There is some problem"
    else
      flash[:notice]="Record Updated Successfully"
    end

    redirect_to :controller=>'mg_student_admissions',:action=>'index'
  end

  def destroy
    @admission=MgStudentAdmission.find(params[:id])
    @admission.update(:is_deleted=>1)
    redirect_to mg_student_admissions_path
  end

  def show
    @student=MgStudentAdmission.find(params[:id])
  end

  def status    
  end
  def class_wise_report
    batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:id])
    @class_strength=0
    batches.each do |batch|
      if batch.class_strength.present?
        @class_strength=@class_strength+batch.class_strength
      end
    end
    @course_id=params[:id]
    render :layout=> false
  end

  def batches_for_selected_course
    puts "Course Id"
    puts params[:course_id]
    @batch_list=MgBatch.where(:mg_course_id=>params[:course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
 
    render :json => {:name => @batch_list }

  end

  private
  def params_student_data
    params.require(:mg_student_admission).permit(:updated_by,:created_by,:mg_school_id,:is_deleted,:mg_student_category_id,
      :first_name,:middle_name,:last_name,:mg_course_id,:date_of_birth,:gender,:blood_group,
      :birth_place,:nationality,:language,:religion,:is_sibling,:mg_c_address_line1,:mg_c_address_line2,:mg_c_street,:mg_c_landmark,:mg_c_city,:mg_c_state,:mg_c_pin_code,:mg_c_country,
      :mg_p_address_line1,:mg_p_address_line2,:mg_p_street,:mg_p_landmark,:mg_p_city,:mg_p_state,:mg_p_pin_code,:mg_p_country,
      :phone_number,:mobile_number,:mg_email_id,:is_selected_for_entrance_test,:is_shortlisted_for_admission,
      :school_name,:course,:year,:marks_obtained,:total_marks,:grade,:amount,:guardian_name,:selection_index)
  end
  
end
