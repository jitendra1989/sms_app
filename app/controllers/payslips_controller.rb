class PayslipsController < ApplicationController
  before_filter :login_required
  layout "mindcom"

  def index
    
    user=MgUser.find(session[:user_id])
    if user.user_type!="principal"
    	mg_school_id=session[:current_user_school_id]
    	@department=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:department_name , :id)
      @month=Date.today.month
      @year=Date.today.year
      if params[:date_month_approve_date].present?
        split_date=params[:date_month_approve_date].split("-")
        @month=split_date[0].to_i
        @year=split_date[1].to_i
      end

      @employee_all=MgEmployeePayslipDetail.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :month=>@month, :year=> @year).includes(:mg_employee).order("mg_employees.first_name ASC")
      @salary_components=MgSalaryComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
      @payslip=@employee_all
      respond_to do |format|
        format.html
        format.xls do
          response.headers['Content-Disposition'] = 'attachment; filename="' + "#{ Date.new(@year.to_i,@month.to_i,01).strftime("%B")} #{@year.to_i.to_i} Payroll report" + '.xls"'
          render "index.xls.erb"
        end
      end
    else
      redirect_to :action=>"payslips_for_approve"
    end
  end

  def employee_list
  	mg_school_id=session[:current_user_school_id]

  	if request.xhr?
	  		if params[:data]=='employee_list'
	  			employee=MgEmployee.select(:first_name, :id, :employee_number, :last_name).where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>params[:id]).order(:first_name)#.pluck(:department_name , :id)
	   		end
   		render :json => { :employee_list => employee}
  	end
  end

  def leaves_taken_till_date_in_the_year(total_leave_taken_year, mg_school_id, mg_employee_id,start_year_date,end_of_month)
    leave_taken_type_wise=MgEmployeeAttendance.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_employee_id=>mg_employee_id,:is_approved=>1, :absent_date=>start_year_date..end_of_month)
    leave_taken_type_wise.each do |check|
      if check.is_halfday
        @total_leave_taken_year+=0.5
      else
        @total_leave_taken_year+=1.0
      end
    end
  end

  def generate_payslip
    mg_school_id=session[:current_user_school_id]
    @department=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:department_name , :id)
  end
  

  def payslips_for_employee
   
    # begin
      
 
    @school=MgSchool.find(session[:current_user_school_id])
  	@mg_employee_id=params[:mg_employee_id]
  	@date=Date.new(params[:date_grad_year].to_i,params[:date_month].to_i,1)
    start_year_date=Date.new(params[:date_grad_year].to_i,1,1)
  	@employee=MgEmployee.find(params[:mg_employee_id])
    month_date=Date.new(params[:date_grad_year].to_i,params[:date_month].to_i,1)
    mg_school_id=session[:current_user_school_id]
    employee_payslip_detail=MgEmployeePayslipDetail.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>params[:mg_employee_id], :month=>params[:date_month].to_i, :year=>params[:date_grad_year].to_i)
    # puts "date check------>"
    # puts start_year_date
    # puts "date check------>"
    @user=MgUser.find(session[:user_id])
    if employee_payslip_detail.present?

      @message="present"
      @payslip_components=MgEmployeePayslipDetail.find_by(:id=>employee_payslip_detail.id ,:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>@employee.id)     
      @component_object=MgEmployeePayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip_components.id)
      @leave_details=unpaid_leaves_report_count_calculation(mg_school_id,@employee.id,@date, @date.end_of_month)
      
      @sport_components_obj=MgSportPayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip_components.id)
      puts"alreadyyyyyyyyy presettttttt"
      puts @sport_components_obj.ids
      puts"alreadyyyyyyyyy presettttttt"
      
    else
    
            # if @employee.pay_scale.present?
            #     @salary=@employee.pay_scale.to_f/@date.end_of_month.day
            # end

        	  end_of_month =month_date.end_of_month
            if @employee.joining_date.present?
             @joining_date=Date.parse(@employee.joining_date.to_s)
            end

              if @date.end_of_month>=@joining_date.to_date
                @test_joining_date="0"
              else
                @test_joining_date="1"
              end


            start_month=month_date.strftime('%Y-%m-%d')
            end_month=end_of_month.strftime('%Y-%m-%d')
          	@no_days_in_month=month_date.end_of_month.day
          	# pay_scale=@employee.pay_scale.to_f
              @last_working_day_check='1'
            if @employee.last_working_day.present? 
                @last_working_day=Date.parse(@employee.last_working_day.to_s).strftime('%Y-%m-%d')
                @last_working_day_valid=Date.parse(@employee.last_working_day.to_s)

                  if end_of_month.to_date< @last_working_day_valid.to_date
                    @last_working_day_check='1'
                  else
                    @last_working_day_check='0'
                  end
                  last_working_day_details=last_working_day_count_calculation(@employee.id, @date)
                  if last_working_day_details['last_working_day_check']=='1'
                   @last_working_day_check=last_working_day_details['last_working_day_check']
                  end
                  @last_working_day_count=last_working_day_details['last_working_day_count']
                  @last_working_day=Date.parse(@employee.last_working_day.to_s)
            end

              
            	@employee_attendance=MgEmployeeAttendance.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_employee_id=>@employee.id,:is_approved=>1,:absent_date=>month_date..end_of_month)
            	
              @absent_day=0.0
            	@half_day_absent=0.0
            	@full_day_absent=0.0
            	@no_of_sunday
            	@no_of_satarday
            	leave_details=Array.new
              @total_leave_taken_year=0.0
              @total_leave_balance_year=0.0
              @extra_leave_taken=0.0
              @total_leave_he_have=0.0

          #Leaves Taken (till date in the year): start
              leaves_taken_till_date_in_the_year(@total_leave_taken_year, mg_school_id, @employee.id,start_year_date,end_of_month)
          #Leaves Taken (till date in the year): end




            	 employee = MgEmployee.find(params[:mg_employee_id])
          				emp_experience = employee.experience_year*12 + employee.experience_month
          				emp_gender = Array.new
                  emp_marital_status=Array.new
          				emp_gender << "all"
                  emp_marital_status << "all"
          				emp_gender << employee.gender
                  if employee.marital_status.present?
                    emp_marital_status << employee.marital_status
                  end
          				emp_type_id = employee.mg_employee_type_id
          				
          			@leave_types=MgEmployeeLeaveType.where("is_deleted  = 0 AND mg_school_id = #{session[:current_user_school_id]} AND minimum_month_experience <= ? AND gender IN (?) AND mg_employee_type_id =?  AND marital_status IN (?)",emp_experience, emp_gender, emp_type_id,emp_marital_status)
          	pay_laeave=0

            # is_leave_should_not_be_deducted
          	@leave_types.each do |leave_count|
              		emp=MgEmployeeAttendance.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_employee_id=>@employee.id,:is_approved=>1,:mg_leave_type_id=>leave_count.id,:absent_date=>start_month..end_month).count
              		
              		leve_taken=MgEmployeeLeaves.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_employee_id=>@employee.id,:mg_leave_type_id=>leave_count.id,:leave_month_year=>start_month..end_month)
              		
                  puts "leve_taken     ------#{leve_taken.inspect}"
                  if leve_taken.present?
                		if leave_count.max_leave_count > leve_taken.leave_taken-emp
                			puts "text-----1"
                			puts pay_laeave
                			puts "text-----1"
                			pay_laeave +=emp
                		end

                    if leave_count.is_leave_should_not_be_deducted
                  		leave_details.push({
                  			leave_count.leave_name+" - (#{leave_count.id})-selected-month-leave-teken" => emp,
                  			"leve_taken"=>leve_taken.leave_taken,
                  			"available_leave"=>leve_taken.available_leave,
                        "extra_leave_taken"=>leve_taken.leave_taken.to_f,
                        "is_leave_should_not_be_deducted"=>leave_count.is_leave_should_not_be_deducted,
                        "is_showable"=>leave_count.is_showable,
                        "leve_name"=>leave_count.leave_name
                  			})
                      @total_leave_balance_year +=leve_taken.available_leave.to_f
                      @total_leave_he_have +=leve_taken.leave_taken.to_f+leve_taken.available_leave.to_f
                    else
                      leave_details.push({
                        leave_count.leave_name+" - (#{leave_count.id})-selected-month-leave-teken" => emp,
                        "leve_taken"=>leve_taken.leave_taken,
                        "available_leave"=>leve_taken.available_leave,
                        "extra_leave_taken"=>leve_taken.leave_taken.to_f-leve_taken.available_leave.to_f,
                        "is_leave_should_not_be_deducted"=>leave_count.is_leave_should_not_be_deducted,
                        "is_showable"=>leave_count.is_showable,
                        "leve_name"=>leave_count.leave_name
                        })
                      @total_leave_balance_year +=leve_taken.available_leave.to_f
                      @total_leave_he_have +=leve_taken.leave_taken.to_f+leve_taken.available_leave.to_f
                      if(leve_taken.leave_taken.to_f-leve_taken.available_leave.to_f)>0
                        @extra_leave_taken +=leve_taken.leave_taken.to_f-leve_taken.available_leave.to_f
                      end

                    end
                end
          	end

            # if employee.pay_scale.present?

            #   @salary_deduction_for_leave=(employee.pay_scale.to_f/@date.end_of_month.day)*@extra_leave_taken
            # end
          	

          	@leave_details=leave_details

              @employee_attendance.each do |check|
              	if check.is_halfday
              		@half_day_absent+=0.5
                  @absent_day+=0.5
              	else
                  @absent_day+=1.0
              		@full_day_absent+=1.0
              	end
              end



              #over time calculation
              # puts "over time calculation-------------------"
              school=MgSchool.find(session[:current_user_school_id])

                school_start_time=Time.parse(school.start_time)
                school_start_end=Time.parse(school.end_time)
                school_time= (Time.parse(school_start_end.to_s) - Time.parse(school_start_time.to_s))/3600


              over_time=0.0
              left_early_time=0.0
              biometric_attendance=MgEmployeeBiometricAttendance.where(:mg_employee_id=>params[:mg_employee_id], :mg_school_id=>mg_school_id, :is_deleted=>0, :date=>start_month..end_month).order(:date)
              total_time=0
              biometric_attendance.each_with_index do |day_wise, value|

                time_diff=(Time.parse(Time.parse(day_wise.check_out.to_s).to_s) - Time.parse(Time.parse(day_wise.check_in.to_s).to_s))/3600
                   
                if biometric_attendance[value+1].present?
                    if Date.parse(biometric_attendance[value+1].date.to_s)==Date.parse(biometric_attendance[value].date.to_s)
                      total_time +=time_diff
                    else
                        total_time +=time_diff
                        if school_time <total_time
                          over_time+=total_time-school_time
                        end
                        total_time=0
                    end
                else
                  total_time +=time_diff
                  if school_time <total_time
                      over_time+=total_time-school_time
                  end
                  total_time=0
                end
              end


                 @over_time=over_time
                  @left_early_time=left_early_time
              #     puts "over_time----------------:#{over_time}"
              #     puts "left_early_time----------------:#{left_early_time}"
              # if employee.pay_scale.present?
              #     salary=employee.pay_scale.to_f/@date.end_of_month.day
              #     @over_time_rs=(over_time*salary/school_time)*2
              #     @left_early_time_rs=left_early_time*salary.to_f/school_time
              # end
              #@over_time=over_time

              

              @joining_date_count= joining_date_count_calculation(@employee.id,  @date )
              @salary_components_from_controller=salary_calculation_with_deduction(@mg_employee_id, mg_school_id, @date, @extra_leave_taken, @last_working_day_count.to_f,@joining_date_count.to_f)
              
              #=============sport salary deduction==============

              @sports_salary_component=MgSportsPayDeduction.where(:month=>params[:date_month].to_i,:year=>params[:date_grad_year].to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:id)
              if @sports_salary_component.present?
                # @sports_salary_details=MgSportsPayDeductiionList.where("mg_employee_id=? and is_deleted=? and mg_school_id=? and mg_pay_deduction_details_id=?",params[:mg_employee_id],0,session[:current_user_school_id],@sports_salary_component.id)
                @sports_deduction_list=MgSportsPayDeductiionList.where("mg_employee_id=? and is_deleted=? and mg_school_id=? and mg_pay_deduction_details_id IN(?)",params[:mg_employee_id].to_i,0,session[:current_user_school_id],@sports_salary_component).pluck(:mg_pay_deduction_details_id)
                if @sports_deduction_list.present?
                  @sports_salary_details=MgSportsPayDeduction.where("id IN(?)",@sports_deduction_list)
                end
              end
              #=============sport salary deduction==============
            	
  end
    render :layout=>false
  	
  end

 def last_working_day_count_calculation(mg_employee_id, date)
  start_month=date.strftime('%Y-%m-%d')
  end_month=date.end_of_month.strftime('%Y-%m-%d')
  no_days_in_month=date.end_of_month.day
  last_working_day_details=Hash.new

  employee=MgEmployee.find(mg_employee_id)
  last_working_day_check='0'
  last_working_day_count=0.0
  if employee.last_working_day.present? 
    @last_working_day=Date.parse(employee.last_working_day.to_s).strftime('%Y-%m-%d')
    if @last_working_day.to_date >= start_month.to_date  && @last_working_day.to_date <= end_month.to_date
        last_working_day_count=(end_month.to_date-@last_working_day.to_date).to_i
        end_month=@last_working_day
        last_working_day_check='1'
    end
  end
      last_working_day_details['last_working_day_count']=last_working_day_count
      last_working_day_details['last_working_day_check']=last_working_day_check


  return last_working_day_details

 end

  def joining_date_count_calculation(mg_employee_id, date)
    employee=MgEmployee.find(mg_employee_id)
    @joining_date_count=0.0
    if employee.joining_date.present?
      joining_date=Date.parse(employee.joining_date.to_s)
      if date.end_of_month >=joining_date.to_date && date <=joining_date.to_date
        @joining_date_count=(joining_date.to_date-date).to_i
      end
    end
    return @joining_date_count
  end



  def salary_calculation_with_deduction(mg_employee_id, mg_school_id, start_month, extra_leave_taken,last_working_day_count,joining_date_count)
# end_of_month.day
    no_of_days=start_month.end_of_month.day
    no_of_days_salary=(no_of_days.to_f-extra_leave_taken.to_f-last_working_day_count.to_f-joining_date_count.to_f)
    salary_components=Array.new 
    salary_components_salary=Array.new
    total_salary=0.0
    after_deduction=0.0
    deduction_amount=0.0
    
    component=MgEmployeeGradeComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>mg_employee_id)
      component.each do |clc|
        if clc.mg_salary_component.is_deduction
            salary=clc.amount.to_f
            salary_components_salary.push({
            "component_name"=>clc.mg_salary_component.name,
            "amount"=>clc.amount.to_f,
            "is_deduction"=>true,
            "mg_salary_component_id"=>clc.mg_salary_component_id
          })
            deduction_amount +=salary.to_f
        else
          salary=((clc.amount.to_f/no_of_days.to_f)*no_of_days_salary)
          salary_components_salary.push({
            "component_name"=>clc.mg_salary_component.name,
            "amount"=>salary.to_f,
            "is_deduction"=>false,
            "mg_salary_component_id"=>clc.mg_salary_component_id
          })
            total_salary +=salary.to_f
        end
      end
      after_deduction=total_salary.to_f-deduction_amount.to_f

      salary_components.push(salary_components_salary)
      salary_components.push({
        "component_total"=>total_salary.to_f,
        "deduction_total"=>deduction_amount.to_f,
        "final_total"=>after_deduction.to_f
        })

  return salary_components
    
  end



  def header_method(pdf,school)
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top],:align => :right, :width  => pdf.bounds.width do
      pdf.font "Helvetica"
      logo=school.logo.url(:medium, timestamp: false)
      if File.exists?("#{Rails.root}/public/#{logo}") 
         pdf.image( "#{Rails.root}/public/#{logo}",:width =>  45)
      end
      pdf.move_up 15
      pdf.text school.school_name, :align => :center, :size => 18
      pdf.stroke_horizontal_rule
    end
  	
  end

  def footer_metho(pdf,school)
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 45], :width  => pdf.bounds.width do
        pdf.font "Helvetica"
        pdf.stroke_horizontal_rule
        pdf.move_down(5)
        # text " Powered By - ©", :size => 12
        pdf.move_down 12
        pdf.draw_text "Terms & Conditions| Privacy Policy| About Us| Contact Us",:at => [70,3]
        pdf.draw_text "Powered By - ©", :at => [400,3]
        pdf.image "#{Rails.root}/app/assets/images/mindcom-logo.png", :at=>[495,15], :width => 45, :align => :right
        pdf.move_down 15
        # pdf.text "This is a computer-generated salary slip. Does not require Signature.",:size=>8, :style => :italic
    end
    
  end


  def generate_payslip_pdf
  	mg_school_id=session[:current_user_school_id]
  	school=MgSchool.find(mg_school_id)
  	payslip_info=params[:id].split(",")
  	employee=MgEmployee.find(payslip_info[0])
  	@date=DateTime.parse(payslip_info[1].to_s)
    month_date=@date
    end_of_month=@date.end_of_month
    @mg_employee_id=payslip_info[0]
    @employee=MgEmployee.find(@mg_employee_id)
    deduction_total=0.0
    earnings_total=0.0
    start_year_date=Date.new(@date.year,1,1)



    @payslip=MgEmployeePayslipDetail.find(payslip_info[2])

    @component_object=MgEmployeePayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip.id) 
    #========sport salary component==============
    @sport_components_obj=MgSportPayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip.id) 
    #========sport salary component==============
    if @employee.joining_date.present?
     @joining_date=Date.parse(@employee.joining_date.to_s)
    end




    table_size={0 => 40, 1 => 400, 2 => 100 }
    border_width=0.1
 
			pdf = Prawn::Document.new 
        pdf.table([[school.school_name]],:column_widths => 540)do
          row(0).style :align => :center
          row(0).style :border_width=>border_width
        end



        
        pdf.table([["Salary Slip For : #{@date.strftime("%B")} / #{@date.year} (Month/Year) "]],:column_widths => 540)do
          row(0).style :align => :center 
          row(0).style :border_width=>border_width
        end
        pdf.table([["Name : #{@employee.employee_name}"," Designation : #{@employee.mg_employee_position.position_name}"]],:column_widths => 270)do
          row(0).style :border_width=>border_width
        end
        
        pdf.table([["DOJ : #{@joining_date.strftime(school.date_format)}"," Type of Employee : #{@employee.mg_employee_type.employee_type}"]],:column_widths => 270)do
          row(0).style :border_width=>border_width
        end
        pdf.table([["No. of Payable Days (in the month) : #{@payslip.no_of_payable_days_in_the_month.to_f.round(2)}"," No. of Unpaid Leaves (in the month) : #{@payslipextra_leave_taken.to_f.round(2)}"]],:column_widths => 270)do
          row(0).style :border_width=>border_width
        end
        pdf.table([["Leaves Taken (till date in the year) : #{@payslip.leaves_taken_till_date_in_the_year.to_f.round(2)}"," Leave Balance : #{@payslip.leave_balance.to_f.round(2) } "]],:column_widths => 270)do
          row(0).style :border_width=>border_width
        end
          pdf.table([["Overtime : #{@payslip.over_time.to_f.round(2)} hours"," "]],:column_widths => 270)do
          row(0).style :border_width=>border_width
        end

       

        @leave_details=unpaid_leaves_report_count_calculation(mg_school_id,@employee.id,@date, @date.end_of_month)

        leave_detail_gen_for_pdf(pdf,@payslip ,table_size,border_width)

        pdf.table([["Salary Details"]],:column_widths => 540)do
          row(0).style :border_width=>border_width
          row(0).style :align => :center 
        end
        pdf.table([["Sr. No."," Details ", "Amount"]],:column_widths => table_size)do
          row(0).style :align => :center
           row(0).style :border_width=>border_width
        end
        sl_count=0
      
          if @component_object.present?
            @component_object.each do |component|
              unless component.mg_salary_component.is_deduction
                    pdf.table([["#{sl_count+=1}","#{component.mg_salary_component.name}",component.amount.to_f.round(2)]] ,:column_widths => table_size)do
                    row(0).style :border_width=>border_width
                    end
              end
            end
          end
        pdf.table([["","Total Gross Salary",@payslip.total_Gross_salary.to_f.round(2)]],:column_widths => table_size)do
          row(0).background_color = 'E6E6E6'
           row(0).style :border_width=>border_width
        end
        pdf.table([["","Deduction","Amount"]],:column_widths =>table_size)do
          row(0).style :border_width=>border_width
        end 
    

          if @component_object.present?
            @component_object.each do |component|
              if component.mg_salary_component.is_deduction
                    pdf.table([["#{sl_count+=1}","#{component.mg_salary_component.name}",component.amount.to_f.round(2)]] ,:column_widths => table_size)do
                    row(0).style :border_width=>border_width
                    end
              end
            end
          end
        
        #==============================
        if @sport_components_obj.present?
          @sport_components_obj.each do |sport_amount|
          deduction_name = MgSportsPayDeduction.find_by(:id=>sport_amount.mg_sports_pay_deduction_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

          # @sport_components_obj.each do |component|
            if sport_amount.deduction
                  pdf.table([["#{sl_count+=1}","#{deduction_name.name}",sport_amount.amount.to_f.round(2)]] ,:column_widths => table_size)do
                  row(0).style :border_width=>border_width
                  end
            end
          end
        end
        #==============================
        

        pdf.table([["","Total Net amount","#{@payslip.total_net_amount.to_f.round(2)}"]],:column_widths => table_size)do
          row(0).background_color = 'E6E6E6'
           row(0).style :border_width=>border_width
        end
        pdf.table([[""]],:column_widths => 540)do
          row(0).style :border_width=>border_width
        end
        pdf.table([["Payroll Department "]],:column_widths => 540)do
          row(0).style :align => :center
          row(0).style :border_width=>border_width
        end
        pdf.table([[""]],:column_widths => 540)do
          row(0).style :border_width=>border_width
        end
        pdf.table([["Note:","This is computer generated document and does not require any signature.Some deduction may not have shown."]],:column_widths => {0 => 40, 1 => 500 })do
          row(0).style :border_width=>border_width
        end 
        pdf.table([["","",""]],:column_widths => table_size)do
          row(0).style :border_width=>border_width
        end 

    	send_data pdf.render,   :info => {
                      :Title => "Payslip",
                      :Author => "sms",
                      :Subject => "salary",
                      :Keywords => "test metadata ruby pdf dry",
                      :Creator => "sms App",
                      :Producer => "Prawn",
                      :CreationDate => Time.now
                      }, :filename => "#{@employee.employee_name} #{@date.strftime("%B")} - #{@date.year} payslip.pdf", :type => "application/pdf", :disposition => 'outline  '

  	
  end

  def leave_detail_gen_for_pdf(pdf,leave ,table_size,border_width)
    leave_object=leave.mg_payslip_leave_details(:is_deleted=>0)
    table_size={0 => 40, 1 => 200,2=>200, 3 => 100 }
    if leave_object.present?
         pdf.table([["Leave Details"]],:column_widths => 540)do
          row(0).style :border_width=>border_width
          row(0).style :align => :center 
        end
        pdf.table([[ "Sr. No.","Leave Type",  'Available Leave','Leave Taken']],:column_widths => table_size)do
           row(0).style :align => :center
           row(0).style :border_width=>border_width
        end
      leave_sl_count=0
      leave_object.each do |leave_detail|
        object=MgEmployeeLeaveType.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>leave_detail.mg_employee_leave_type_id)
        if object.present?
          if object.is_showable
              pdf.table([[ leave_sl_count+=1,object.leave_name,  leave_detail.available_leave.to_f.round(2),leave_detail.leave_taken.to_f.round(2)]],:column_widths => table_size)do
                row(0).style :border_width=>border_width
              end
          elsif leave_detail.leave_taken.to_f>0.0
              pdf.table([[ leave_sl_count+=1,leave_detail.leave_name,  leave_detail.available_leave.to_f.round(2),leave_detail.leave_taken.to_f.round(2)]],:column_widths => table_size)do
                row(0).style :border_width=>border_width
              end
          end
        end
      end
    end
  end


  def payslip_for_employee
  	mg_school_id=session[:current_user_school_id]
  	@employee=MgEmployee.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_user_id=>session[:user_id])
  	
  end

  def date_wise_employee_leave_update
        render :layout=>false
  end





  def reports
    @date=Date.today
    start_date=Date.new(@date.year, @date.month,1)
    @tech_month=@date.month
    @tech_year=@date.year
    @non_tech_month=@date.month
    @non_tech_year=@date.year
    mg_school_id=session[:current_user_school_id]
    @extra_leave_taken_all_employee_array=Hash.new 
    @employee_teach=MgEmployee.where(" last_working_day IS NULL OR last_working_day = '' OR last_working_day >= '#{start_date}'").where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Teaching Staff").id)).order(:first_name)
    @employee_non_teach=MgEmployee.where(" last_working_day IS NULL OR last_working_day = '' OR last_working_day >= '#{start_date}'").where( :is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Non Teaching Staff").id)).order(:first_name)
    @graph_teach=[]
    @all_employee_unpaid_leave=Hash.new 
    @employee=Hash.new
    @employee_non=Hash.new
     for month in 1..@date.month.to_i
        @total_amount_per_month=0.0
        @total_over_time_amount=0.0
        @total_extra_leave_amount=0.0
        @salary_according_to_grade=0.0
           start_of_month=Date.new(@date.year,month,1)
           end_of_month=start_of_month.end_of_month
           @report=MgEmployeePayslipDetail.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :month=>month, :year=>@date.year, :mg_employee_id=>@employee_teach.pluck(:id)).sum(:total_net_amount)
           if @report.to_f>0
              @total_amount_per_month=@report.to_f
           end
           @employee[@employee_teach.count.to_s+"_"+start_of_month.strftime("%B").to_s]=@total_amount_per_month.round(2)
     end
     for month in 1..@date.month.to_i
      @total_amount_per_month_non=0.0
      @total_over_time_amount_non=0.0
      @total_extra_leave_amount_non=0.0
      @salary_according_to_grade_non=0.0
          start_of_month=Date.new(@date.year,month,1)
          end_of_month=start_of_month.end_of_month
           report=MgEmployeePayslipDetail.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :month=>month, :year=>@date.year, :mg_employee_id=>@employee_non_teach.pluck(:id)).sum(:total_net_amount)
        
           if report.to_f>0
              @total_amount_per_month_non=report.to_f
           end
          @employee_non[@employee_non_teach.count.to_s+"_"+start_of_month.strftime("%B").to_s]=@total_amount_per_month_non.round(2)
    end
    if params[:hidden_date_month_teaching_stuff].present?
      split_tech_value=params[:hidden_date_month_teaching_stuff].split("-")
      @tech_month=split_tech_value[0]
      @tech_year=split_tech_value[1]
    end
    if params[:hidden_date_month_non_teaching_stuff].present?
      split_non_tech_value=params[:hidden_date_month_non_teaching_stuff].split("-")
      @non_tech_month=split_non_tech_value[0]
      @non_tech_year=split_non_tech_value[1]
    end
    @employee_list_teach_xls=MgEmployeePayslipDetail.where(:month=>@tech_month, :year=>@tech_year,:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>@employee_teach.pluck(:id)).includes(:mg_employee).order("mg_employees.first_name ASC")
    @employee_list_non_teach_xls=MgEmployeePayslipDetail.where(:month=>@non_tech_month, :year=>@non_tech_year,:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>@employee_non_teach.pluck(:id)).includes(:mg_employee).order("mg_employees.first_name ASC")
    
     @employee_list_teach=@employee_list_teach_xls.paginate(page: params[:teach], per_page: 10)
     @employee_list_non_teach=@employee_list_non_teach_xls.paginate(page: params[:non_teach], per_page: 10)
     @salary_components=MgSalaryComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
    if params[:xls_report].present?
      if params[:xls_report]=="tech"
        @employee_all=@employee_list_teach_xls
        @filename="#{ Date.new(@tech_year.to_i,@tech_month.to_i,01).strftime("%B")} #{@tech_year.to_i} Teaching Stuff"
      else
        @employee_all=@employee_list_non_teach_xls
        @filename="#{ Date.new(@non_tech_year.to_i,@non_tech_month.to_i,01).strftime("%B")} #{@non_tech_year.to_i.to_i} Non Teaching Stuff"
      end
    end
    respond_to do |format|
      format.html
      format.csv 
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="' + "#{@filename} Payroll report" + '.xls"'
        render "index.xls.erb"
      end
    end
  end

  def overtime_report
     mg_school_id=session[:current_user_school_id]
     @month=Date.today.month
     @year=Date.today.year
     @over_time_hash=Hash.new
     start_date=Date.new(@year.to_i, @month.to_i,1)
     if params[:overtime_report_date].present?
        split_date=params[:overtime_report_date].split("-")
        start_date=Date.new(split_date[1].to_i, split_date[0].to_i,1)
        @month=split_date[0].to_i
        @year=split_date[1].to_i
     end
     
    # @department=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:department_name , :id)
    @employee_list=MgEmployee.where( :is_deleted=>0, :mg_school_id=>mg_school_id).
  where(" last_working_day IS NULL OR last_working_day = '' OR last_working_day >= '#{start_date}'").order(:first_name).paginate(page: params[:page], per_page: 10)
    
    @employee_list.each do |over_time|
      over_time_hours= over_time_calculation(over_time.id,mg_school_id,start_date,start_date.end_of_month)
      @over_time_hash[over_time.id.to_s]=over_time_hours.to_f
    end
  end



  def over_time
   mg_school_id= session[:current_user_school_id]
    start_of_month=Date.new(params[:date_grad_year].to_i,params[:date_month].to_i,1)
    end_of_month=start_of_month.end_of_month
    @school=MgSchool.find(mg_school_id)
    puts "start_of_month------------>#{start_of_month}"
    puts "end_of_month------------>#{end_of_month}"
     @over_time= over_time_calculation(params[:mg_employee_id],mg_school_id,start_of_month,end_of_month)
     puts "@over_time--------------->#{@over_time}"
     @biometric_attendance=MgEmployeeBiometricAttendance.where(:mg_employee_id=>params[:mg_employee_id], :mg_school_id=>mg_school_id, :is_deleted=>0, :date=>start_of_month..end_of_month).order(:date).paginate(page: params[:page], per_page: 10)
    render :layout=>false
  end


  def over_time_calculation(mg_employee_id,mg_school_id,start_month,end_month)
        over_time=0.0
        left_early_time=0.0
        biometric_attendance=MgEmployeeBiometricAttendance.where(:mg_employee_id=>mg_employee_id, :mg_school_id=>mg_school_id, :is_deleted=>0, :date=>start_month..end_month).order(:date)
        total_time=0

        school=MgSchool.find(mg_school_id)

        school_start_time=Time.parse(school.start_time)
        school_start_end=Time.parse(school.end_time)
        school_time= (Time.parse(school_start_end.to_s) - Time.parse(school_start_time.to_s))/3600
        biometric_attendance.each_with_index do |day_wise, value|

          time_diff=(Time.parse(Time.parse(day_wise.check_out.to_s).to_s) - Time.parse(Time.parse(day_wise.check_in.to_s).to_s))/3600
           
          if biometric_attendance[value+1].present?
              if Date.parse(biometric_attendance[value+1].date.to_s)==Date.parse(biometric_attendance[value].date.to_s)
                total_time +=time_diff
              else
                  total_time +=time_diff
                  if school_time <total_time
                    over_time+=total_time-school_time
                  end
                  total_time=0
              end
          else
            total_time +=time_diff
            if school_time <total_time
                over_time+=total_time-school_time
            end
            total_time=0
          end
      end
    return over_time
    
end

def unpaid_leaves_report
  mg_school_id=session[:current_user_school_id]
    @month=Date.today.month
     @year=Date.today.year
     @unpaid_leaves_report=Hash.new
     start_date=Date.new(@year.to_i, @month.to_i,1)
     if params[:unpaid_report_date].present?
        split_date=params[:unpaid_report_date].split("-")
        start_date=Date.new(split_date[1].to_i, split_date[0].to_i,1)
        @month=split_date[0].to_i
        @year=split_date[1].to_i
     end

  @employee_list=MgEmployee.where( :is_deleted=>0, :mg_school_id=>mg_school_id).where(" last_working_day IS NULL OR last_working_day = '' OR last_working_day >= '#{start_date}'").order(:first_name).paginate(page: params[:page], per_page: 10)    
  @employee_list.each do |over_time|
      unpaid_leaves_count= unpaid_leaves_report_count_calculation(mg_school_id,over_time.id,start_date,start_date.end_of_month)
      @unpaid_leaves_report[over_time.id.to_s]=unpaid_leaves_count[1].to_f
  end

end

def unpaid_leaves_report_count_calculation
    mg_school_id= session[:current_user_school_id]
    start_of_month=Date.new(params[:date_grad_year].to_i,params[:date_month].to_i,1)
    end_of_month=start_of_month.end_of_month
    @school=MgSchool.find(mg_school_id)
    @leave_details=unpaid_leaves_report_count_calculation(mg_school_id,params[:mg_employee_id],start_of_month, end_of_month)
  render :layout=>false
  
end

def unpaid_leaves_report_count_calculation(mg_school_id,mg_employee_id,start_month, end_month)
    pay_laeave=0.0
    leave_details=[]
    all_leave_details=[]
    @extra_leave_taken=0.0
    employee = MgEmployee.find(mg_employee_id)
    if employee.experience_year.present? && employee.experience_month.present?
        emp_experience = employee.experience_year*12 + employee.experience_month
        emp_gender = Array.new
        emp_marital_status=Array.new
        emp_gender << "all"
        emp_marital_status << "all"
        emp_gender << employee.gender
        if employee.marital_status.present?
          emp_marital_status << employee.marital_status
        end
        emp_type_id = employee.mg_employee_type_id
        
    @leave_types=MgEmployeeLeaveType.where("is_deleted  = 0 AND mg_school_id = #{session[:current_user_school_id]} AND minimum_month_experience <= ? AND gender IN (?) AND mg_employee_type_id =?   AND marital_status IN (?)",emp_experience, emp_gender, emp_type_id,emp_marital_status)
    
    @leave_types.each do |leave_count|
        emp=MgEmployeeAttendance.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_employee_id=>mg_employee_id,:is_approved=>1,:mg_leave_type_id=>leave_count.id,:absent_date=>start_month..end_month).count
        
        leve_taken=MgEmployeeLeaves.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_employee_id=>mg_employee_id,:mg_leave_type_id=>leave_count.id,:leave_month_year=>start_month..end_month)
        puts "leve_taken     ------#{leve_taken.inspect}"
          if leve_taken.present?
              if leave_count.max_leave_count > leve_taken.leave_taken-emp
                puts "text-----1"
                puts pay_laeave
                puts "text-----1"
                pay_laeave +=emp
              end

              if leave_count.is_leave_should_not_be_deducted
                leave_details.push({
                  "leave_type"=>leave_count.leave_name,
                  "leave_type_id"=>leave_count.id,
                  leave_count.leave_name => emp,
                  "leve_taken"=>leve_taken.leave_taken,
                  "available_leave"=>leve_taken.available_leave ,
                  "extra_leave_taken"=>leve_taken.leave_taken.to_f,
                  "is_leave_should_not_be_deducted"=>leave_count.is_leave_should_not_be_deducted,
                  "is_showable"=>leave_count.is_showable
                  })
                 # @total_leave_balance_year +=leve_taken.available_leave.to_f
                    # @total_leave_he_have +=leve_taken.leave_taken.to_f+leve_taken.available_leave.to_f
              else
                leave_details.push({
                  "leave_type"=>leave_count.leave_name,
                  "leave_type_id"=>leave_count.id,
                  leave_count.leave_name => emp,
                  "leve_taken"=>leve_taken.leave_taken,
                  "available_leave"=>leve_taken.available_leave,
                  "extra_leave_taken"=>leve_taken.leave_taken.to_f-leve_taken.available_leave.to_f,
                  "is_leave_should_not_be_deducted"=>leave_count.is_leave_should_not_be_deducted,
                   "is_showable"=>leave_count.is_showable
                  })
                 # @total_leave_balance_year +=leve_taken.available_leave.to_f
                    # @total_leave_he_have +=leve_taken.leave_taken.to_f+leve_taken.available_leave.to_f
                   if(leve_taken.leave_taken.to_f-leve_taken.available_leave.to_f)>0
                     @extra_leave_taken +=leve_taken.leave_taken.to_f-leve_taken.available_leave.to_f
                  end
              end
          end
      end

    end

      puts "------------------------------------------------------------------"
      puts leave_details.inspect
      puts "@extra_leave_taken------>#{@extra_leave_taken}"
      puts "------------------------------------------------------------------"
      all_leave_details.push(leave_details)
      all_leave_details.push(@extra_leave_taken)

      return all_leave_details

end

def salary_according_to_grade(mg_school_id,mg_employee_id,start_month,end_month)
  employee=MgEmployee.find(mg_employee_id)
  @total=0.0
  earnings_total=0.0
  earnings_deduction=0.0
  # total=0.0
  if employee.mg_employee_grade_id.present?
    @salary_components=MgGradeComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_grade_id=>employee.mg_employee_grade_id)
    # @total=salary_according_to_grade_name( @salary_components)
     if @salary_components.present?
       @salary_components.each do |salary_components|

         if salary_components.mg_salary_component.is_deduction
            earnings_deduction +=salary_components.amount.to_f
          else
            earnings_total +=salary_components.amount.to_f
        end
      end
    end
    
  end
     if earnings_total-earnings_deduction>0
      @total=earnings_total-earnings_deduction
     end
  return @total
end

def create

  begin
  @notice=""

  user=MgUser.find(session[:user_id])
  mg_school_id=session[:current_user_school_id]
  created_by=session[:user_id]
  @date=Date.new(params[:year].to_i,params[:month].to_i,01)
  MgEmployeePayslipDetail.transaction do
  @payslip=MgEmployeePayslipDetail.find_by(:mg_employee_id=>params[:mg_employee_id], :month=>params[:month], :year=>params[:year], :mg_school_id=>mg_school_id, :is_deleted=>0)
  if @payslip.present?
      @payslip.no_of_payable_days_in_the_month=params[:no_of_payable_days_in_the_month]
      @payslip.leaves_taken_till_date_in_the_year=params[:leaves_taken_till_date_in_the_year]
      @payslip.leave_balance=params[:leave_balance]
      @payslip.total_leave=params[:total_leave]
      @payslip.total_Gross_salary=params[:total_Gross_salary]
      @payslip.total_net_amount=params[:total_net_amount]
      # @payslip.reason=params[:reason]
      # @payslip.is_editable=params[:is_editable]

      if user.user_type=="principal"
        @payslip.is_approved=params[:is_approved]
        if params[:is_approved].present?
          if  params[:is_approved]=="Reject"
            @notice=send_mail_payslip_reject_mail(params[:mg_employee_id], params[:reason])
          end
        end
        if params[:reason].present?
          @payslip.reason=params[:reason]
        end
      end
      @payslip_save=@payslip.save
      object=@payslip.mg_employee_payslip_components.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
      object.update_all(:is_deleted=>1)
      if params[:salary_component].present?
        params[:salary_component].each_with_index do |components,grade|
         employee_payslip_components_object= MgEmployeePayslipComponent.find_by(:mg_employee_payslip_detail_id=>@payslip.id,:mg_school_id=>mg_school_id, :mg_salary_component_id=>components[0])
          if employee_payslip_components_object.present?
              employee_payslip_components_object.update(:is_deleted=>0, :amount=>components[1], :updated_by=>created_by, :reason=>params[:reason_component][components[0]])
          else
              new_obj=MgEmployeePayslipComponent.new(:mg_employee_payslip_detail_id=>@payslip.id,:mg_school_id=>mg_school_id, :is_deleted=>0, :mg_salary_component_id=>components[0], :amount=>components[1], :reason=>params[:reason_component][components[0]], :created_by=>created_by, :updated_by=>created_by)  
              new_obj.save
          end
        end
      end
    #===================for sport payroll deduction=======================
    if params[:sport_salary_component].present?
      params[:sport_salary_component].each do |key,val|
        sports_payslip_obj= MgSportPayslipComponent.find_by(:mg_employee_payslip_detail_id=>@payslip.id, :id=>key,:mg_school_id=>session[:current_user_school_id], :is_deleted=>0)
        if sports_payslip_obj.present?
            sports_payslip_obj.update(:is_deleted=>0, :amount=>val, :updated_by=>session[:user_id])
        end
      end
    end

    #===================for sport payroll deduction=======================
	
  else
    @payslip=MgEmployeePayslipDetail.new(:is_approved=>'pending',:mg_employee_id=>params[:mg_employee_id], :extra_leave_taken=>params[:extra_leave_taken], :month=>params[:month], :year=>params[:year], :mg_school_id=>mg_school_id, :is_deleted=>0, :created_by=>created_by, :updated_by=>created_by)
    
    @payslip.no_of_payable_days_in_the_month=params[:no_of_payable_days_in_the_month]
    @payslip.leaves_taken_till_date_in_the_year=params[:leaves_taken_till_date_in_the_year]
    @payslip.leave_balance=params[:leave_balance]
    @payslip.total_leave=params[:total_leave]
    @payslip.total_Gross_salary=params[:total_Gross_salary]
    @payslip.total_net_amount=params[:total_net_amount]
    @payslip.over_time=params[:over_time]
    # @payslip.reason=params[:reason]
    # @payslip.is_editable=params[:is_editable]


    @payslip_create_save=@payslip.save
 
   

    @leave_details= unpaid_leaves_report_count_calculation(mg_school_id,params[:mg_employee_id],@date, @date.end_of_month)

    if @leave_details[0].present?
      @leave_details[0].each do |value|
       object= @payslip.mg_payslip_leave_details.build(:mg_employee_leave_type_id=>value["leave_type_id"], :leave_taken=>value["leve_taken"], :available_leave=>value["available_leave"],:is_deleted=>0, :mg_school_id=>mg_school_id, :created_by=>created_by, :updated_by=>created_by)
        object.save
      end
    end

    # params[:leave_details]
    if params[:salary_component].present?
      params[:salary_component].each_with_index do |components,grade|
       object= @payslip.mg_employee_payslip_components.build(:mg_school_id=>mg_school_id, :is_deleted=>0, :mg_salary_component_id=>components[0], :amount=>components[1], :reason=>params[:reason_component][components[0]], :created_by=>created_by, :updated_by=>created_by)
       object.save
      end
    end

    #===================for sport payroll deduction=======================
    if params[:sport_salary_component].present?
      params[:sport_salary_component].each do |key,val|
        new_obj=MgSportPayslipComponent.new(:mg_employee_payslip_detail_id=>@payslip.id,:deduction=>params[:sport_salary_component_deduction][key], :mg_sports_pay_deduction_id=>key,:mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :amount=>val, :created_by=>created_by, :updated_by=>created_by)  
        new_obj.save
      end
    end

    #===================for sport payroll deduction=======================
  end

end
  if @payslip_create_save 
    flash[:notice]="Payslip generated successfully"
  end
  if @payslip_save 
    flash[:notice]="Payslip updated successfully,"+" "+@notice.to_s
  end

  if session[:user_type]=="principal"
    redirect_to :action => "payslips_for_approve"
  else
    redirect_to :action => "index"
  end

  rescue Exception => e
    flash[:error]="Error occured, please contact administrator" 
    if session[:user_type]=="principal"
        redirect_to :action => "payslips_for_approve"
      else
      redirect_to :action => "index"
    end
  end

end

def send_mail_payslip_reject_mail(mg_employee_id, reason)
 school=MgSchool.find_by(:id=>session[:current_user_school_id])

  user_emp=MgEmployee.find_by(:is_deleted=>0, :id=>mg_employee_id)
  user=MgUser.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :user_type=>'admin')
  if user.present?

    msg="Dear Sir/Madam \n\n\n"
    msg="\t Employee Number #{user_emp.employee_number}"
    msg +="\t payslip is rejected because "

    msg +=" #{reason.to_s} \n\n\n"
    msg +="Thanks & Regards \n #{school.school_name}"


      begin
      @email_from = MgEmail.where(:mg_user_id => session[:user_id])
      @message = Message.new
      @message.subject =  "Payslip rejection details"
      @message.description =msg.to_s

            # all_user.each do |user|
                @email_to = MgEmail.where(:mg_user_id => user.id)

                      if @email_to.present?
                        @message.to_user_id = @email_to[0][:mg_email_id ]
                        @message.from_user_id = @email_from[0][:mg_email_id ]
                  
                        db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                                  :to_user_id => user.id.to_i,
                                  :subject => @message.subject,
                                  :description => @message.description,
                                  :is_deleted => 0,
                                  :from_user_id =>session[:user_id],
                                  :status => 0)
                        server_response = NotificationMailer.send_mail(@message).deliver!
                        @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                    :email_addrs_to => @message.to_user_id,
                                                    # current school Id will come here
                                          :mg_school_id => session[:current_user_school_id] ,
                                                    :email_addrs_by => @message.from_user_id,
                                                    :email_subject => 'test',
                                                   :email_server_description => server_description(server_response.status) )
                      else
                        puts "Email id is not present"
                      end

            # end
              return @notice="Mail Sent Successfully"
            rescue Net::SMTPFatalError => e
              return @notice= 'Email-Id is not valid.'
              puts e
            rescue ArgumentError=>e
              puts e
              return @notice='Email to address is not present.'
            rescue Exception=>e
              puts e
             return  @notice='Error while sending email,Please contact admin.'
            end
      



  end


end


def unpaid_leaves_report_count
    mg_school_id= session[:current_user_school_id]
    start_of_month=Date.new(params[:date_grad_year].to_i,params[:date_month].to_i,1)
    end_of_month=start_of_month.end_of_month
    @school=MgSchool.find(mg_school_id)
    @leave_details=unpaid_leaves_report_count_calculation(mg_school_id,params[:mg_employee_id],start_of_month, end_of_month)
  render :layout=>false
  
end

def edit
  
  @school=MgSchool.find(session[:current_user_school_id])
    mg_school_id=session[:current_user_school_id]
    @payslip_components=MgEmployeePayslipDetail.find(params[:id])     
    @component_object=MgEmployeePayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip_components.id) 
    #========sport salary component==============
    @sport_components_obj=MgSportPayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip_components.id) 
    #========sport salary component==============
    @date=Date.new(@payslip_components.year.to_i,@payslip_components.month.to_i,1)
    @employee=MgEmployee.find(@payslip_components.mg_employee_id)
    @user=MgUser.find(session[:user_id])

     @leave_details=unpaid_leaves_report_count_calculation(mg_school_id,@payslip_components.mg_employee_id,@date, @date.end_of_month)
  render :layout=>false
end

def payslips_for_approve
    mg_school_id=session[:current_user_school_id]
     @month=Date.today.month
     @year=Date.today.year
      if params[:date_month_approve_date].present?
        split_date=params[:date_month_approve_date].split("-")
        @month=split_date[0].to_i
        @year=split_date[1].to_i
      end

      @employee_all=MgEmployeePayslipDetail.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :month=>@month, :year=> @year).includes(:mg_employee).order("mg_employees.first_name ASC")
      
      @salary_components=MgSalaryComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
      @payslip=@employee_all.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="' + "#{ Date.new(@year.to_i,@month.to_i,01).strftime("%B")} #{@year.to_i.to_i} Payroll report" + '.xls"'
        render "index.xls.erb"
      end
    end

end

def delete
  @payslip=MgEmployeePayslipDetail.find(params[:id])
  @payslip.is_deleted=1
  @payslip.updated_by=session[:user_id]
  @payslip.save

redirect_to :action=>'index'
end


def show
   @school=MgSchool.find(session[:current_user_school_id])
    mg_school_id=session[:current_user_school_id]
    @payslip_components=MgEmployeePayslipDetail.find(params[:id])     
    @component_object=MgEmployeePayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip_components.id) 
    #========sport salary component==============
    @sport_components_obj=MgSportPayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip_components.id) 
    #========sport salary component==============
    @date=Date.new(@payslip_components.year.to_i,@payslip_components.month.to_i,1)
    @employee=MgEmployee.find(@payslip_components.mg_employee_id)
    @user=MgUser.find(session[:user_id])
  render :layout=>false
end


def show_payslip_for_employee

   @school=MgSchool.find(session[:current_user_school_id])
    mg_school_id=session[:current_user_school_id]
    @payslip_components=MgEmployeePayslipDetail.find_by(:mg_employee_id=>params[:mg_employee_id],:month=>params[:date_month], :year=>params[:date_grad_year], :is_approved=>'approved', :is_released=>1)     
    if @payslip_components.present?

    @component_object=MgEmployeePayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>@payslip_components.id) 
    @date=Date.new(@payslip_components.year.to_i,@payslip_components.month.to_i,1)
    @employee=MgEmployee.find(@payslip_components.mg_employee_id)
    @user=MgUser.find(session[:user_id])

    else
      @payslip="not_generated"
    end
  render :layout=>false
end

def payslip_approval
 @save=false
 if params[:payslip_approved].present?
    for i in 0...params[:payslip_approved].size
      object=MgEmployeePayslipDetail.find_by(:id=>params[:payslip_approved][i])
      if object.present?
        if params[:is_rejected].present?
          @save=object.is_approved="Reject"
          @notice="Payslip rejected successfully"
        else
          @save=object.is_approved="approved"
          @notice="Payslip approved successfully"
        end
          object.save
      end
    end
  end
  if @save
    flash[:notice]=@notice
  else
    flash[:error]="Please select check box."
  end
  redirect_to :action=>'payslips_for_approve'
end

def payslip_release

  puts params[:payslip_approved].inspect

     @save=false
  if params[:payslip_approved].present?
    for i in 0...params[:payslip_approved].size
      object=MgEmployeePayslipDetail.find_by(:id=>params[:payslip_approved][i], :is_approved=>'approved')
      if object.present?
          object.is_released=true
          @save=object.save
      end
      if object.present? && object.is_released
        object.mg_employee_payslip_components.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).each do |a|
          puts a.mg_salary_component_id
          salary_component=MgSalaryComponent.find_by(:id=>a.mg_salary_component_id)
          #Bindhu Added for account starts
          amount=a.amount
          to_account_id=""
          if salary_component.is_deduction
            amount_transfer_type="credited"
          else
            amount_transfer_type="debited"
          end
          for_module="payslip"
          particular_id=object.id
          transaction_type="payable"
          if salary_component.is_from_central
            from_account_id=""
            central_account_transaction=MgCentralAccountTransaction.send_transaction(from_account_id,to_account_id,amount.abs,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
            central_account_transaction.save
          elsif salary_component.mg_account_id.present?
            from_account_id=salary_component.mg_account_id
            account_transaction=MgAccountTransaction.add_transaction(from_account_id,to_account_id,amount.abs,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
            account_transaction.save
          end
          #Bindhu Added for account ends
          # puts "kghhfsgkhdfkgk"
        end
      end
    end
  end

  if @save
    flash[:notice]="Payslip released successfully"
  else
    flash[:error]="Please select check box."
  end
  redirect_to :action=>'index'
end

def salary_deduction
  puts params[:id]
  mg_school_id=session[:current_user_school_id]
  @salary_deduction=MgSalaryComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :is_deduction=>1)
  if params[:month].present?
    @month=params[:month]
  else
    @month=Date.today.month
  end

  if params[:year].present?
    @year=params[:year]
  else
    @year=Date.today.year
  end


  puts params[:salary_deduction].inspect
  if params[:salary_deduction].present?

    @payslip=MgEmployeePayslipDetail.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :is_approved=>"approved", :month=>@month, :year=>@year)
    payslip=@payslip.pluck(:id)
    # mg_employee_payslip_detail_id
    # mg_salary_component_id
    @salary_components=MgSalaryComponent.where(:id=>params[:salary_deduction].split(","), :is_deleted=>0, :mg_school_id=>mg_school_id)
    puts @salary_components.inspect
    # @component=MgEmployeePayslipComponent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_payslip_detail_id=>payslip, :mg_salary_component_id=>params[:salary_deduction].split(","))
  end

  respond_to do |format|
    format.html
    format.xls do
      # response.headers['Content-Disposition'] = 'attachment; filename="' + " Payroll report" + '.xls"'
      response.headers['Content-Disposition'] = 'attachment; filename="' + "#{ Date.new(@year.to_i,@month.to_i,01).strftime("%B")} #{@year.to_i.to_i} Payroll deduction report" + '.xls"'

      render "salary_deduction.xls.erb"
    end
  end
  
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


end
