class AdmissionManagementsController < ApplicationController

  before_filter :login_required
  layout "mindcom"

  def index
    @classes =MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
  end

  def class_student
    @class_student = MgStudentAdmission.where(:mg_course_id=>params[:mg_course_id],:is_selected_for_entrance_test=>'accepted',:is_shortlisted_for_admission=>"accepted", :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    @mg_course_id = params[:mg_course_id]
    render :layout=>false
  end

  def student_fee_particulars
    collection_data=MgFeeCollection.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>params[:batch_id]).pluck(:mg_fee_category_id).uniq
    @particular_data=MgFeeParticular.where(:fee_category=>collection_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>params[:batch_id]) #added mg_batch_id
  
    render :layout=>false
  end

  def show
    @students_admissions_ids = params[:id]
    @student_admission_id=@students_admissions_ids.split("-")
    puts params[:id].inspect
    #puts askldjlajkd
    @student_admission_object = MgStudentAdmission.find_by(:id=>@student_admission_id[0])
    #@admission_no = MgStudent.find_by(:mg_student_admission_id=>@student_admission_id[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).admission_number
    
    #@student_id = MgStudent.find_by(:mg_student_admission_id=>@student_admission_id[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).id
    # @fee_describe = MgFeeCollectionParticular.where(:mg_student_id=>@student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    # @total_fee = MgFeeCollectionParticular.where(:mg_student_id=>@student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum(:mg_fee_particular_amount)

    # big_array = Array.new
    # @fee_describe.each do |fee|
    #   small_array = Hash[]

    #   @fee_category_id = MgFeeCollection.find_by(:id=>fee.mg_fee_collection_id).mg_fee_category_id
    #   @category_name = MgFeeCategory.where(:id=>@fee_category_id,:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    #   if @category_name.present?
    #     small_array["name"] = @category_name[0].try(:name)
    #     small_array["description"] = @category_name[0].try(:description)
    #     small_array["amount"] = fee.try(:mg_fee_particular_amount)
    #     big_array.push(small_array)
    #   end     
    # end     
    
    # @fee_detail = big_array
  end  

  def fee_details       
  end

  def pay_fees
    begin
      @student_addmission_id = params[:student_addmission_id]
      @mg_school_id=session[:current_user_school_id]
      @session_user=session[:user_id]
      stu_id = params[:student_addmission_id]
      mg_batch_id = params[:mg_batch_id]
      puts stu_id.inspect
      @sub_status=[]
      @mg_student = MgStudentAdmission.find_by(:id=>stu_id)
      @mg_users = MgUser.find_by(:mg_student_admission_id=>stu_id)
      MgFinanceTransaction.transaction do 

     if @mg_users.present?
       @update_mg_user = @mg_users.update(:is_deleted=>0)
       @sub_status.push(@update_mg_user)

       @update_mg_student=MgStudent.find_by(:mg_student_admission_id=>stu_id).update(:is_deleted=>0)
       @sub_status.push(@update_mg_student)
     else
        @subdomain = MgSchool.where(:id=>session[:current_user_school_id]).pluck(:subdomain)     
        user= MgUser.where(:mg_school_id=>session[:current_user_school_id],:user_type=>'student').last
        @user = user.user_name.split('S').last
        @users =(@user.to_i + 1 ).to_s
        @users_name = @subdomain[0]+'S'+@users
        
        @mg_user_id = MgUser.new(:password=>"student123", :user_type=>'student',:user_name=>@users_name,:first_name=>@mg_student.first_name,:middle_name=>@mg_student.middle_name,:last_name=>@mg_student.last_name,
                      :email=>@mg_student.mg_email_id,:mg_student_admission_id=>stu_id,:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:created_by=>session[:user_id],:updated_by=>session[:user_id])
        @sub_status.push(@mg_user_id.save)
        students = MgStudent.students(@users_name,@mg_user_id,@mg_student,@mg_school_id,@session_user,mg_batch_id)
      end
      params[:data].each_with_index do |data,i|
        collection_particular_data=MgFeeCollectionParticular.new
        collection_data= MgFeeCollection.find_by(:mg_fee_category_id=>data,:mg_batch_id=>params[:mg_batch_id]) #use mg_batch_id
        collection_particular_data.mg_fee_particular_name=params[:data1][i]
        collection_particular_data.mg_fee_particular_amount=params[:data2][i]
        collection_particular_data.mg_fee_collection_id=collection_data.id

        student_data=MgStudent.find_by(:mg_student_admission_id=>@student_addmission_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        collection_particular_data.mg_student_admission_number=student_data.admission_number
        collection_particular_data.mg_student_id=student_data.id
        collection_particular_data.is_deleted=0
        collection_particular_data.mg_school_id=session[:current_user_school_id]
        collection_particular_data.created_by=session[:user_id]
        collection_particular_data.updated_by=session[:user_id]
        @sub_status.push(collection_particular_data.save)
      end

      @student_admission_obj = MgStudentAdmission.find_by(:id=>@student_addmission_id) 
      @student_obj = MgStudent.find_by(:mg_student_admission_id=>@student_addmission_id)
      @mg_users_obj = MgUser.find_by(:mg_student_admission_id=>@student_addmission_id)
      @mg_collection_id = MgFeeCollectionParticular.where(:mg_student_id=>@student_obj.id)
      @mg_school_id = session[:current_user_school_id]
      @session_user = session[:user_id]

      #MgFinanceTransaction.transaction do 
        mgtransaction = MgFinanceTransaction.new(:fees_from=>'mg_student_admission',:title=>"Receipt No:",:amount=>params[:amount],:category_id=>@student_admission_obj.mg_student_category_id,:mg_student_id=>@student_obj.id,:transaction_date=>Date.today,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])              
        @sub_status.push(mgtransaction.save)
        mgtransaction_id = mgtransaction.id
      @mg_collection_id.each_with_index do |data,i|
        @mg_finance_transaction = MgFinanceTransactionDetail.new(:is_partial_payment=>0,:mg_fee_particular_id=>data.id,:mg_collection_id=>data.mg_fee_collection_id,:mg_transaction_id=>mgtransaction_id,:mg_student_id=>@student_obj.id,:paid_amount=>data.mg_fee_particular_amount,:detail_type=>"particular",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
        @sub_status.push(@mg_finance_transaction.save)
        @mg_finance_fee = MgFinanceFee.new(:mg_fee_collection_id=>data.mg_fee_collection_id,:transaction_id=>mgtransaction_id,:is_paid=>1,:student_id=>@student_obj.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
        @sub_status.push(@mg_finance_fee.save)
        @sub_status.push(@student_admission_obj.update(:has_paid=>1)) 
      end
        @permanent_address = MgAddress.permanentaddress(@student_admission_obj,@mg_users_obj,@mg_school_id,@session_user)
        @permanent_address.save
        @temporary_address = MgAddress.temporaryaddress(@student_admission_obj,@mg_users_obj,@mg_school_id,@session_user)
        @temporary_address.save              
        @email = MgEmail.email_address(@student_admission_obj,@mg_users_obj,@mg_school_id,@session_user)
        @email.save
        
        @phone = MgPhone.phone_detail(@student_admission_obj,@mg_users_obj,@mg_school_id,@session_user)
        @phone.save
        mobile = MgPhone.mobile_detail(@student_admission_obj,@mg_users_obj,@mg_school_id,@session_user)
        mobile.save
        
        if !@sub_status.include?(true)
          raise ActiveRecord::Rollback
        end
      end #transaction end

      if !@sub_status.include?(false)
        flash[:notice]="Fee Paid Successfully"
      else
        flash[:e1]="There is some problem to pay Fee"
      end

    rescue Exception => e
      flash[:error]= "There is some problem to pay Fee"
    end
    redirect_to :controller=>'admission_managements',:action=>'index'     
  end  
end