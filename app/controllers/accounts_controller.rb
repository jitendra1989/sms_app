class AccountsController < ApplicationController
  before_filter :login_required
  # before_filter :authorization, :except => [:index, :incharge]
  layout "mindcom"
  

  def central_receivable_excel_report
      mg_school_id=session[:current_user_school_id]
    begin
      if File.exists?(File.join(Rails.root, "public/xlsx_files", "central_receivable_excel_report.xlsx"))
        File.delete(File.join(Rails.root, "public/xlsx_files", "central_receivable_excel_report.xlsx"))
      end

      puts params[:mg_inventory_proposal_item_id].inspect
      CentralReceivableExcelReport.new(mg_school_id,params[:f_date], params[:t_date], params[:amount_transfer_type], params[:mg_user_id_acc_rev])
      send_file File.exists?(File.join(Rails.root, "public/xlsx_files", "central_receivable_excel_report.xlsx")) ? File.join(Rails.root, "public/xlsx_files", "central_receivable_excel_report.xlsx") : File.join(Rails.root, "public/xlsx_files", "gate_pass_error.xlsx"), :type => "application/vnd.ms-excel", :filename => "central receivable report-(#{Date.today}).xlsx", :stream => false#, :readonly=>true
    rescue Exception => e
      puts e
      if File.exists?(File.join(Rails.root, "public/xlsx_files", "gate_pass_error.xlsx"))
        send_file File.join(Rails.root, "public/xlsx_files", "gate_pass_error.xlsx"), :type => "application/vnd.ms-excel", :filename => "gate_pass-(#{Date.today}).xlsx", :stream => false#, :readonly=>true
      end
    end
  end
  def employee_list
    @employee_list = MgEmployee.where(:is_deleted=>0, :mg_employee_department_id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
    respond_to do |format|
      format.json  { render :json => @employee_list }
    end
  end

  def index
    @account_incharge=MgUser.where(:user_type=>"central_account_incharge",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @incharge_count=MgUser.where(:user_type=>"central_account_incharge",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).count
    # @account=MgAccountCentralIncharge.where(:status=>"Incharge",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    # @account_count=MgAccountCentralIncharge.where(:status=>"Incharge",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).count
  end

  def new
    # @account=MgAccountCentralIncharge.new
    render :layout=>false
  end

  def edit
    @incharge=MgUser.find(params[:id])
    # @account=MgAccountCentralIncharge.find(params[:id])
    render :layout=>false
  end

  def update
    incharge=MgUser.find(params[:id])
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:incharge][:user_name]
    incharge.update(:user_name=>user_name_with_domain)
    # @account=MgAccountCentralIncharge.find(params[:id])
    # @account.update(:mg_employee_department_id=>params[:account][:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:updated_by=>session[:user_id])
    redirect_to :back
  end

  def show
    @account=MgAccountCentralIncharge.find(params[:id])
    render :layout=>false
  end

  def delete
    MgUser.transaction do
      incharge=MgUser.find(params[:id])
      incharge.update(:is_deleted=>1)
      account=MgAccountCentralIncharge.find_by(:mg_user_id=>params[:id])
      account.update(:is_deleted=>1)
    end
    redirect_to :back
  end

  def create
    MgUser.transaction do
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(user_accounts_params)
      user_name_with_subdomain=school.subdomain + params[:account][:user_name]
      user.save
      user.update(:user_name=>user_name_with_subdomain)
      role=MgRole.find_by(:role_name=>"central_account_incharge")
      if role.id.present?
        user_role = user.mg_user_roles.build(:mg_role_id => role.id)
        user_role.save 
      end
      @account=MgAccountCentralIncharge.new(central_accounts_params)
      @account.save
      @account.update(:mg_user_id=>user.id,:status=>"Incharge")
    end
    redirect_to :back
  end

  #Bindhu Added starts
  def central_incharge_change_password
    @incharge=MgUser.find(params[:id])
    render :layout=>false
  end

  def change_password
    temp=false
    old_password = params[:incharge][:name]
    user_id=params[:incharge][:user_id]
    user_name = MgUser.where(:id =>user_id).pluck(:user_name)
    @user=MgUser.where(:id =>user_id)
    is_user=@user.authenticate(user_name, old_password)

    if  is_user==nil
      # flash[:error] = "Please enter correct password !"
      temp=true
    else
      new_password = params[:incharge][:password] 
      re_new_password =  params[:incharge][:hashed_password] 
      if new_password==re_new_password
        if @user
          @userMe=MgUser.find(user_id)
          @userMe.update(:password=>new_password)
          flash[:notice] = "Password changed successfully." 
        end 
      else
        flash[:error] = "Re Entered password didn't matched !"
      end
    end
    if temp==true
      flash[:error] = "Invalid Password..."
      redirect_to :back
    else
      redirect_to :back
    end
  end
  #Bindhu Added Ends
# ==================================Incharge actions=====================================

  def incharge
    @account_incharge=MgUser.where(:user_type=>"central_account_assistant_incharge",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    # @account=MgAccountCentralIncharge.where(:status=>"Assistant",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def incharge_new
    @incharge=MgUser.new
    # @account=MgAccountCentralIncharge.new
    render :layout=>false
  end

  def incharge_edit
    @incharge=MgUser.find(params[:id])
    #@account=MgAccountCentralIncharge.find(params[:id])
    render :layout=>false
  end

  def incharge_update
    incharge=MgUser.find(params[:id])
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:incharge][:user_name]
    incharge.update(:user_name=>user_name_with_domain)
    redirect_to :back
  end

  def incharge_show
    @account=MgAccountCentralIncharge.find(params[:id])
    render :layout=>false
  end

  def incharge_delete
    MgUser.transaction do
      incharge=Mguser.find(params[:id])
      incharge.update(:is_deleted=>1)
      account=MgAccountCentralIncharge.find_by(:mg_user_id=>params[:id])
      account.update(:is_deleted=>1)
    end
    redirect_to :back
  end

  def incharge_create
     MgUser.transaction do
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(user_accounts_params)
      user_name_with_subdomain=school.subdomain + params[:account][:user_name]
      user.save
      user.update(:user_name=>user_name_with_subdomain)
      role=MgRole.find_by(:role_name=>"central_account_assistant_incharge")
      if role.id.present?
        user_role = user.mg_user_roles.build(:mg_role_id => role.id)
        user_role.save 
      end
      @account=MgAccountCentralIncharge.new(central_accounts_params)
      @account.save
      @account.update(:mg_user_id=>user.id,:status=>"Assistant")
    end
    redirect_to :back
  end
  # ===============================Central Assistant Incharge========================

  def transfer
    @account=MgCentralAccountTransaction.where(:created_by=>session[:user_id],:amount_transfer_type=>"debited",:for_module=>"central",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def transfer_new
    @account=MgCentralAccountTransaction.new
    render :layout=>false
  end

  def transfer_create
    from_account_id=""
    to_account_id=params[:account][:mg_to_account_id]
    amount=params[:account][:amount]
    purpose=params[:account][:purpose]
    current_date=Time.now
    for_module="central"
    particular_id=""#params[:account][:id]
    transaction_type="payable"
    amount_transfer_type="debited"
    account_transaction=MgCentralAccountTransaction.add_transaction(purpose,from_account_id,to_account_id,amount,current_date,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
    account_transaction.save
    # =============================================================================================
      begin
        @central_incharge=MgAccountCentralIncharge.where(:status=>"Incharge",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @central_incharge.each do |officer|
        employee=MgEmployee.find_by(:id=>officer.mg_employee_id)
        sender=MgEmployee.find_by(:mg_user_id=>session[:user_id])
        subject="Account transfer request from "+sender.try(:first_name)+" "+sender.try(:last_name)
        if params[:account][:purpose].present?
            description=params[:account][:purpose]
        else
            description=""
        end
        notification=MgNotification.send_notification(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
        notification.save

        email=MgNotification.send_email(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id])
        email.save
        end
      rescue
      end
      # =============================================================================================
  
    redirect_to :action=>"transfer"
  end

  def transfer_edit
    @account=MgCentralAccountTransaction.find(params[:id])
    render :layout=>false
  end

  def transfer_update
      if params[:is_status]=="accepted"
      else
        @account=MgCentralAccountTransaction.find(params[:id])
        @account.update(:mg_to_account_id=>params[:account][:mg_to_account_id],:amount=>params[:account][:amount],:updated_by=>session[:user_id],:purpose=>params[:account][:purpose])
      end
    redirect_to :action=>"transfer"
  end

  def transfer_delete
    @account=MgCentralAccountTransaction.find(params[:id])
    @account.update(:is_deleted=>1)
    redirect_to :action=>"transfer"
    
  end

  def transfer_show
    @account=MgCentralAccountTransaction.find(params[:id])
    render :layout=>false
  end

  def review
    @account=MgCentralAccountTransaction.where(:amount_transfer_type=>"debited",:for_module=>"central",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def review_edit
    @account=MgCentralAccountTransaction.find_by(:id=>params[:id])
  end

  def review_update
    @account=MgCentralAccountTransaction.find_by(:id=>params[:ids])
    if params[:account][:status].present?
      @account.update(:status=>params[:account][:status],:Reason=>params[:account][:Reason])
      if params[:account][:status]=="rejected"
       # =============================================================================================
        begin
          @central_incharge=MgAccountCentralIncharge.where(:status=>"Incharge",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          @central_incharge.each do |officer|
          employee=MgEmployee.find_by(:id=>params[:assistant_incharge_user_id])
          sender=MgEmployee.find_by(:mg_user_id=>session[:user_id])
          subject="Account transfer request is rejected "#+sender.try(:first_name)+" "+sender.try(:last_name)
          if params[:account][:Reason].present?
              description=params[:account][:Reason]
          else
              description=""
          end
          notification=MgNotification.send_notification(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
          notification.save

          email=MgNotification.send_email(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id])
          email.save
          end
        rescue
        end
        # =============================================================================================
      end
    end
    redirect_to :action=>"review"
  end
  # =================================================================================

  def review_show
    @account=MgCentralAccountTransaction.find(params[:id])
  end

  def revert
    @account=MgCentralAccountTransaction.find(params[:id])
    @account.update(:status=>"pending")
    redirect_to :action=>"review"
  end


  def central_receivable
    
  end

  def central_receivable_generation
    @timeformat = MgSchool.find(session[:current_user_school_id])
    f_date= Date.strptime(params[:from_date],@timeformat.date_format)
    t_date= Date.strptime(params[:to_date],@timeformat.date_format)
    params[:f_date]=f_date
    params[:t_date]=t_date
    params[:amount_transfer_type]=params[:amount_transfer_type]
    if(params[:amount_transfer_type].present?)
      @transaction=MgCentralAccountTransaction.where(:current_date=>f_date..t_date, :transaction_type=>'receivable', :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :amount_transfer_type=>params[:amount_transfer_type])
    else
      @transaction=MgCentralAccountTransaction.where(:current_date=>f_date..t_date, :transaction_type=>'receivable', :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    end
   # @inventory_projection=MgInventoryProjection.where(:date=>f_date..t_date, :status=>'accepted', :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
   render :layout=>false
  end

  def accounts_review
  
  end

  def accounts_review_generation
    @timeformat = MgSchool.find(session[:current_user_school_id])
    f_date= Date.strptime(params[:from_date],@timeformat.date_format)
    t_date= Date.strptime(params[:to_date],@timeformat.date_format)
    params[:f_date]=f_date
    params[:t_date]=t_date


    #employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    # user=MgUser.find_by(:id=>session[:user_id])
    account_id=MgAccount.where(:mg_user_id=>session[:user_id],:is_deleted=>0).pluck(:id)
    if params[:amount_transfer_type]=="all"
      @transaction=MgAccountTransaction.where("current_date IN (?) and is_deleted=? and mg_school_id=? and (mg_to_account_id IN (?) or mg_from_account_id IN (?))",f_date..t_date,0,session[:current_user_school_id],account_id,account_id).order(:for_module)
    else
      @transaction=MgAccountTransaction.where("amount_transfer_type=? and current_date IN (?) and is_deleted=? and mg_school_id=? and (mg_to_account_id IN (?) or mg_from_account_id IN (?))",params[:amount_transfer_type],f_date..t_date,0,session[:current_user_school_id],account_id,account_id).order(:for_module)
    end
    params[:amount_transfer_type]= params[:amount_transfer_type]=="all" ? "" : params[:amount_transfer_type]

    render :layout=>false
  end

  #Bindhu Work Starts
  def account_index
    @accounts=MgAccount.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def account_new
    #render :layout=>false
  end

  def account_create
    MgUser.transaction do 
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(user_accounts_params)
      user_name_with_subdomain=school.subdomain + params[:account][:user_name]
      user.save
      user.update(:user_name=>user_name_with_subdomain)
      role=MgRole.find_by(:role_name=>"account_incharge")
      if role.id.present?
        user_role = user.mg_user_roles.build(:mg_role_id => role.id)
        user_role.save 
      end
      account=MgAccount.new(new_account_params)
      if account.save
        account.update(:mg_user_id=>user.id)
        flash[:notice]="Account Created Successfully."
        redirect_to account_index_path
      else
        flash[:error]="Account name dublication"
        redirect_to account_index_path
        raise ActiveRecord::Rollback
      end
    end
  end

  def account_edit
    @account=MgAccount.find(params[:id])
    render :layout=>false
  end

  def account_update
    MgAccount.transaction do
      account=MgAccount.find(params[:id])
      user=MgUser.find_by(:id=>account.mg_user_id)
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user_name_with_subdomain=school.subdomain + params[:account][:user_name]
      user.update(:user_name=>user_name_with_subdomain)
      if account.update(new_account_params)
        flash[:notice]="Account Updated Successfully."
        redirect_to account_index_path
      else
        flash[:error]="Account name dublication"
        redirect_to account_index_path
        raise ActiveRecord::Rollback
      end
    end
  end

  def account_show
    @account=MgAccount.find(params[:id])
    render :layout=>false
  end

  def account_delete
    MgAccount.transaction do
      account=MgAccount.find(params[:id])
      user=MgUser.find_by(:id=>account.mg_user_id)
      if account.update(:is_deleted=>1)
        if user.present?
          user.update(:is_deleted=>1)
        end
        flash[:notice]="Account Deleted Successfully."
        redirect_to account_index_path
      else
        flash[:error]="Error,Please try later"
        redirect_to account_index_path
        raise ActiveRecord::Rollback
      end
    end
  end
  #Bindhu Work Ends

  private
  def accounts_params
    params.require(:account).permit(:mg_employee_department_id,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def user_accounts_params
    params.require(:account).permit(:user_type,:password,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def accounts_transfer_params
    params.require(:account).permit(:mg_to_account_id,:amount,:purpose,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  #Bindhu Works starts for params
  def new_account_params
    params.require(:account).permit(:mg_account_name,:description,:is_deleted,:mg_school_id,:created_by,:updated_by,:mg_school_id)
  end

  def central_accounts_params
    params.require(:account).permit(:mg_school_id,:is_deleted,:created_by,:updated_by)
  end
  #Bindhu Works ends for params

end
