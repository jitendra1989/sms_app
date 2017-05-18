class VehiclesController < ApplicationController
  before_filter :login_required
    layout "mindcom"
  def index
    school_id=session[:current_user_school_id]
    @all_vehicle_data=MgVehicle.where(:is_deleted=>0,:mg_school_id=>school_id).all.paginate(page: params[:page], per_page: 10)

  end
def new

    @school_id=session[:current_user_school_id]

  end

  def create
    begin
    MgVehicle.transaction do
    vehicle_data=MgVehicle.new(vehicle_params)
    vehicle_data.created_by=session[:user_id]
    
    if vehicle_data.save
      @timeformat = MgSchool.find(session[:current_user_school_id])
          if @timeformat.present?
              if params[:vehicle][:date_of_purchase].present?
                date_of_purchase = Date.strptime(params[:vehicle][:date_of_purchase],@timeformat.date_format)
                end
              if params[:vehicle][:Current_insurance_due_date].present?

                current_insurance_due_date = Date.strptime(params[:vehicle][:Current_insurance_due_date],@timeformat.date_format)
              end
              if params[:vehicle][:last_service_date].present?

                last_service_date = Date.strptime(params[:vehicle][:last_service_date],@timeformat.date_format)
              end
              
              if params[:vehicle][:next_service_date].present?
                next_service_date = Date.strptime(params[:vehicle][:next_service_date],@timeformat.date_format)
              end
              
              if params[:vehicle][:repair_completion_date].present?

                repair_completion_date = Date.strptime(params[:vehicle][:repair_completion_date],@timeformat.date_format)
              end
             
             vehicle_data.update(:date_of_purchase => date_of_purchase,:Current_insurance_due_date => current_insurance_due_date,:last_service_date=>last_service_date,:next_service_date=>next_service_date,:repair_completion_date=>repair_completion_date)
            
                 end
      redirect_to '/vehicles'
    else
      flash[:error]="Error: form not saved"
      redirect_to :action=>'new'
    end#if end
  end#transaction end
rescue
  flash[:error]="Error: form not saved"
      redirect_to :action=>'new'
  end#begin end
  end

  def show
    @vehicle=MgVehicle.find(params[:id])

    render :layout=>false

  
  end

  def edit
    @vehicle=MgVehicle.find(params[:id])
    render :layout=>false
  end

  def update
    begin
      MgVehicle.transaction do
    @vehicle=MgVehicle.find(params[:id])
    
    if @vehicle.update(vehicle_params)

     

       @timeformat = MgSchool.find(session[:current_user_school_id])
    if params[:vehicle][:date_of_purchase].present?
          date_of_purchase = Date.strptime(params[:vehicle][:date_of_purchase],@timeformat.date_format)
    end
     if params[:vehicle][:date_of_purchase].present?
                date_of_purchase = Date.strptime(params[:vehicle][:date_of_purchase],@timeformat.date_format)
                end
              if params[:vehicle][:Current_insurance_due_date].present?

                current_insurance_due_date = Date.strptime(params[:vehicle][:Current_insurance_due_date],@timeformat.date_format)
              end
              if params[:vehicle][:last_service_date].present?

                last_service_date = Date.strptime(params[:vehicle][:last_service_date],@timeformat.date_format)
              end
              
              if params[:vehicle][:next_service_date].present?
                next_service_date = Date.strptime(params[:vehicle][:next_service_date],@timeformat.date_format)
              end

              if params[:vehicle][:is_under_repair].to_i==0
             @vehicle.update(:repair_completion_date=>"")
            #logger.infioajj
              else
              
              if params[:vehicle][:repair_completion_date].present?

                repair_completion_date = Date.strptime(params[:vehicle][:repair_completion_date],@timeformat.date_format)
              end
            end
         @vehicle.update(:date_of_purchase => date_of_purchase,:Current_insurance_due_date => current_insurance_due_date,:last_service_date=>last_service_date,:next_service_date=>next_service_date,:repair_completion_date=>repair_completion_date)

          

    #redirect_to :action=>'index'
    redirect_to :back

  else
  flash[:error]="Error: form not Updated"

    #redirect_to :action=>'index'
    redirect_to :back

        end
      end#transaction end
     rescue Exception=>ex
        #puts ex.message
  flash[:error]="Error: form not Updated"
      #redirect_to :action=>'index'
    redirect_to :back

  end#begin end

  end

  
  

  def destroy
    @vehicle=MgVehicle.find(params[:id])
      @vehicle.is_deleted =1

      @vehicle.save

      redirect_to :action=>'index'

  end

  def report_type_index
    school_id=session[:current_user_school_id]
    @all_report_type=MgReportType.where(:is_deleted=>0,:mg_school_id=>school_id).all.paginate(page: params[:page], per_page: 10)

    
  end

  def new_report_type
    @school_id=session[:current_user_school_id]
    render :layout=>false

  end
  def report_type_create
    report_type=MgReportType.new(report_type_params)
    report_type.created_by=session[:user_id]
    report_type.save
    redirect_to :action=>'report_type_index'
   end
  def report_type_show

    @show_report_type=MgReportType.find(params[:id])

    render :layout=>false

  end

  def report_type_edit
    @report_type=MgReportType.find(params[:id])

    render :layout=>false

  end
  def report_type_update
    @update_report_type=MgReportType.find(params[:id])
    @update_report_type.update(report_type_params)
    redirect_to :action=>'report_type_index'

  end

  def report_type_destroy
    @vehicle=MgReportType.find(params[:id])
      @vehicle.is_deleted =1

      @vehicle.save

      redirect_to :action=>'report_type_index'
  end


  def payment_type_index
    school_id=session[:current_user_school_id]
    @all_payment_type=MgPaymentType.where(:is_deleted=>0,:mg_school_id=>school_id).all.paginate(page: params[:page], per_page: 10)
  end


def new_payment_type
    @school_id=session[:current_user_school_id]
    render :layout=>false

  end
  def payment_type_create
    report_type=MgPaymentType.new(payment_type_params)
    report_type.created_by=session[:user_id]
    report_type.save
    redirect_to :action=>'payment_type_index'
   end


def payment_type_show

    @show_payment_type=MgPaymentType.find(params[:id])

    render :layout=>false

  end

  def payment_type_edit
    @payment_type=MgPaymentType.find(params[:id])

    render :layout=>false

  end
  def payment_type_update
    @update_payment_type=MgPaymentType.find(params[:id])
    @update_payment_type.update(payment_type_params)
    redirect_to :action=>'payment_type_index'

  end

  def payment_type_destroy
    @vehicle=MgPaymentType.find(params[:id])
      @vehicle.is_deleted =1

      @vehicle.save

      redirect_to :action=>'payment_type_index'
  end

  def vehicle_report_index
     @school_id=session[:current_user_school_id]
    if params[:short_number_wise].present?
      if params[:short_number_wise][:mg_vehicle_id].present?
         @value=params[:short_number_wise][:mg_vehicle_id]
      else
         @value=0
      end
    else
      @value=0
    end

    if  @value!=0
      @id=params[:short_number_wise][:mg_vehicle_id]
     
    @all_vehicle_report=MgAddReport.where(:mg_vehicle_id=>params[:short_number_wise][:mg_vehicle_id],:is_deleted=>0,:mg_school_id=>@school_id).all.paginate(page: params[:page], per_page: 15)
  else
   
    @all_vehicle_report=MgAddReport.where(:is_deleted=>0,:mg_school_id=>@school_id).all.paginate(page: params[:page], per_page: 10)
    
    end
    

  end

  def vehicle_report_new
    @school_id=session[:current_user_school_id]
    @add_report_index=MgVehicle.where(:is_deleted=>0,:mg_school_id=>@school_id).pluck(:vehicle_number,:id)
    @add_report_type=MgReportType.where(:is_deleted=>0,:mg_school_id=>@school_id).pluck(:report_type_name,:id)
    @add_payment_type=MgPaymentType.where(:is_deleted=>0,:mg_school_id=>@school_id).pluck(:payment_type_name,:id)


  end

  def vehicle_report_create   

    vehicle_report=MgAddReport.new(vehicle_params_report)
    vehicle_report.entered_by=session[:user_id]
    vehicle_report.save

        @timeformat = MgSchool.find(session[:current_user_school_id])
          if @timeformat.present?
              if params[:vehicle_report][:valid_from].present?
                valid_from = Date.strptime(params[:vehicle_report][:valid_from],@timeformat.date_format)
                end
              if params[:vehicle_report][:valid_to].present?

                valid_to = Date.strptime(params[:vehicle_report][:valid_to],@timeformat.date_format)
              end
              if params[:vehicle_report][:payment_date].present?

                payment_date = Date.strptime(params[:vehicle_report][:payment_date],@timeformat.date_format)
              end
            end
             vehicle_report.update(:valid_from => valid_from,:valid_to => valid_to,:payment_date=>payment_date)

          require 'open-uri'
          @file=params[:files]
       if @file.nil?
          else
             @file.each do |a|
               @fileupload=MgDocumentManagement.new()
               @fileupload.file=a
               #puts @student.mg_user_id
               @fileupload.document_type="Report"
               @fileupload.is_deleted=0
               @fileupload.mg_school_id=session[:current_user_school_id]
               @fileupload.mg_add_report_id=vehicle_report.id
               @fileupload.save
            end
          end #File end

          @file=params[:files_report]
    if @file.nil?
          else
             @file.each do |a|
               @fileupload=MgDocumentManagement.new()
               @fileupload.file=a
               #puts @student.mg_user_id
               @fileupload.document_type="Payment"
               @fileupload.is_deleted=0
               @fileupload.mg_school_id=session[:current_user_school_id]
               @fileupload.mg_add_report_id=vehicle_report.id
               @fileupload.save
            end
          end #File end

   redirect_to :action=>'vehicle_report_index'

  end
  def vehicle_report_show
    @vehicle_report=MgAddReport.find(params[:id])

  render :layout=>false 

 end

 def vehicle_report_edit
    @vehicle_report=MgAddReport.find(params[:id])
    @school_id=session[:current_user_school_id]
    @add_report_index=MgVehicle.where(:is_deleted=>0,:mg_school_id=>@school_id).pluck(:vehicle_number,:id)
    @add_report_type=MgReportType.where(:is_deleted=>0,:mg_school_id=>@school_id).pluck(:report_type_name,:id)
    @add_payment_type=MgPaymentType.where(:is_deleted=>0,:mg_school_id=>@school_id).pluck(:payment_type_name,:id)

  render :layout=>false 

 end

 def vehicle_report_update
puts params.inspect
if params[:vehicle_report][:is_payment_made].to_i==1
    @vehicle_report=MgAddReport.find(params[:id])
    @vehicle_report.update(vehicle_params_report)

    @timeformat = MgSchool.find(session[:current_user_school_id])
    if params[:vehicle_report][:valid_from].present?
        valid_from = Date.strptime(params[:vehicle_report][:valid_from],@timeformat.date_format)
    end
     if params[:vehicle_report][:valid_to].present?
        valid_to = Date.strptime(params[:vehicle_report][:valid_to],@timeformat.date_format)
                end
                if params[:vehicle_report][:payment_date].present?

                payment_date = Date.strptime(params[:vehicle_report][:payment_date],@timeformat.date_format)
              end
         @vehicle_report.update(:valid_from =>valid_from,:valid_to=>valid_to,:payment_date=>payment_date)

     require 'open-uri'
          @file=params[:files]
    if @file.nil?
          else
             @file.each do |a|
               @fileupload=MgDocumentManagement.new()
               @fileupload.file=a
               #puts @student.mg_user_id
               @fileupload.document_type="Report"
               @fileupload.is_deleted=0
               @fileupload.mg_school_id=session[:current_user_school_id]
               @fileupload.mg_add_report_id= @vehicle_report.id
               @fileupload.save
            end
          end #File end
    @file=params[:files_report]
    if @file.nil?
          else
             @file.each do |a|
               @fileupload=MgDocumentManagement.new()
               @fileupload.file=a
               #puts @student.mg_user_id
               @fileupload.document_type="Payment"
               @fileupload.is_deleted=0
               @fileupload.mg_school_id=session[:current_user_school_id]
               @fileupload.mg_add_report_id=@vehicle_report.id
               @fileupload.save
            end
          end #File end

else #code repetition
 @vehicle_report=MgAddReport.find(params[:id])

 
    @vehicle_report.update(vehicle_params_report)
    @vehicle_report.payment_date=""
    @vehicle_report.mg_payment_type_id=nil
    @vehicle_report.amount=nil
   @vehicle_report.save

    @fileuploads_data=MgDocumentManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_add_report_id=>@vehicle_report.id,:document_type=>"Payment")
@fileuploads_data.each do |data|
  @data=MgDocumentManagement.find_by(:id=>data.id)
@data.is_deleted=1
@data.save
end

    @timeformat = MgSchool.find(session[:current_user_school_id])
    if params[:vehicle_report][:valid_from].present?
        valid_from = Date.strptime(params[:vehicle_report][:valid_from],@timeformat.date_format)
    end
     if params[:vehicle_report][:valid_to].present?
        valid_to = Date.strptime(params[:vehicle_report][:valid_to],@timeformat.date_format)
                end
               
         @vehicle_report.update(:valid_from =>valid_from,:valid_to=>valid_to)
     require 'open-uri'
          @file=params[:files]
    if @file.nil?
          else
             @file.each do |a|
               @fileupload=MgDocumentManagement.new()
               @fileupload.file=a
               #puts @student.mg_user_id
               @fileupload.document_type="Report"
               @fileupload.is_deleted=0
               @fileupload.mg_school_id=session[:current_user_school_id]
               @fileupload.mg_add_report_id= @vehicle_report.id
               @fileupload.save
            end
          end #File end
  
  end


   redirect_to :action=>'vehicle_report_index'
    

 end


def delete_record
  @delete=MgDocumentManagement.find(params[:documentID])
  @delete.delete
end


def vehicle_report_destroy
    @vehicle_report=MgAddReport.find(params[:id])

    @vehicle_report.is_deleted =1

      @vehicle_report.save

      redirect_to :action=>'vehicle_report_index'

  end



  private
  def vehicle_params
      params.require(:vehicle).permit(:vehicle_number, :make, :model, :date_of_purchase, :no_of_seats, :Current_insurance_due_date ,:last_insurance_amount, :last_service_date,:next_service_date,:is_under_repair,:repair_completion_date,:vehicle_status,:is_deleted,:mg_school_id)
  end
    def report_type_params
      params.require(:report_type).permit(:report_type_name,:is_deleted,:mg_school_id)

    end
    def payment_type_params
      params.require(:payment_type).permit(:payment_type_name,:is_deleted,:mg_school_id)

    end
    def vehicle_params_report
      params.require(:vehicle_report).permit(:mg_vehicle_id,:mg_report_type_id,:vendor_name,:valid_from,:valid_to,:amount,:is_payment_made,:mg_payment_type_id,:payment_date,:comments,:is_deleted,:mg_school_id)

    end
  end
