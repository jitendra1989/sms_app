class EmployeeBiometricAttendancesController < ApplicationController
	 before_filter :login_required
		layout "mindcom"
		def new 
			@employee_biometric_attendances=MgEmployeeBiometricAttendance.new
			render :layout => false
		end
	
		def index
		  	@employee_biometric_attendances = MgEmployeeBiometricAttendance.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
		end
		
		def create
			mg_school_id=session[:current_user_school_id]
			school=MgSchool.find(mg_school_id)
		  	@employee_biometric_attendances=MgEmployeeBiometricAttendance.new
		  	# (employee_biometric_attendances_params)
		  	@employee_biometric_attendances.mg_employee_id=params[:mg_employee_id]
		  	@employee_biometric_attendances.created_by=session[:user_id]
		  	@employee_biometric_attendances.updated_by=session[:user_id]
		  	@employee_biometric_attendances.date=Date.strptime(params[:date],school.date_format)
		  	@employee_biometric_attendances.mg_school_id=mg_school_id
		  	@employee_biometric_attendances.check_in=params[:check_in]
		  	@employee_biometric_attendances.check_out=params[:check_out]		  
		  	@employee_biometric_attendances.is_deleted=0
				
			  	if @employee_biometric_attendances.save
			    @value=true
			    # redirect_to :action => "show", :id => @subjects.id
			  	else
			    @value=false
			    end


			 respond_to do |format|
        		format.json  { render :json => {'validation'=> @value } }
      		end


		end

		def select_employees
			school_id=session[:current_user_school_id]
			@employee_data=MgEmployee.where(:mg_employee_department_id=>params[:dept_data],:is_deleted=>0,:mg_school_id=>school_id)
			render :layout => false

		end
		def show
		  	@employee_biometric_attendances = MgEmployeeBiometricAttendance.find(params[:id])
		  	render :layout => false
		  	
		end
  		def edit
  			@school=MgSchool.find(session[:current_user_school_id])
	 	@employee_biometric_attendances = MgEmployeeBiometricAttendance.find(params[:id])
	 	render :layout => false

		end
		def update
			school=MgSchool.find(session[:current_user_school_id])
		  	@employee_biometric_attendances = MgEmployeeBiometricAttendance.find(params[:id])

		  	# @employee_biometric_attendances.date=Date.strptime(params[:employee_biometric_attendances][:date],school.date_format)
		 	# @employee_biometric_attendances.check_in=params[:employee_biometric_attendances][:check_in]
		 	# @employee_biometric_attendances.check_out=params[:employee_biometric_attendances][:check_out]

		 	# @employee_biometric_attendances.mg_employee_id=params[:mg_employee_id]
		  	# @employee_biometric_attendances.created_by=session[:user_id]
		  	@employee_biometric_attendances.updated_by=session[:user_id]
		  	@employee_biometric_attendances.date=Date.strptime(params[:date],school.date_format)
		  	# @employee_biometric_attendances.mg_school_id=mg_school_id
		  	@employee_biometric_attendances.check_in=params[:check_in]
		  	@employee_biometric_attendances.check_out=params[:check_out]		  
		  	# @employee_biometric_attendances.is_deleted=0

		  if @employee_biometric_attendances.save

		    @value=true
		  else
		    @value=false
		    
		  end
		  respond_to do |format|
        		format.json  { render :json => {'validation'=> @value } }
      		end


		end
		def delete
			 @employee_biometric_attendances=MgEmployeeBiometricAttendance.find_by_id(params[:id])

			@employee_biometric_attendances.is_deleted =1
			@employee_biometric_attendances.save

		  redirect_to employee_biometric_attendances_path
		end

		def import

		end
		def import_data
			require 'mime/types'

			school_id=session[:current_user_school_id]
  		 begin
  			 MgEmployeeBiometricAttendance.transaction do
  		
  	
    
    

    #@datainfo=MgEmployeeBiometricAttendance.uploadfile(params[:upload])
    
        
   @file_name= params[:upload]['datafile'].original_filename
   #if  @post==".xls"
   	require 'roo'
require 'zip'
#Zip::File.open("upload/public/data/demo.xlsx") 
    # do something with file
  
@s = Roo::Excel.new( params[:upload]['datafile'].path,nil,:ignore)
 @s.default_sheet=@s.sheets[0]
 logger.info(@data.inspect)
 #CREATING the header hash object to save 1st row having column names
@headerinfo = Hash.new
@s.row(1).each_with_index {|header,i| @headerinfo[header] = i} 
#used for the iteration from first row to last row
((@s.first_row + 1)..@s.last_row).each do |row|
   
@date = @s.row(row)[@headerinfo['date']] 

@check_in = @s.row(row)[@headerinfo['check_in']]
@check_out=@s.row(row)[@headerinfo['check_out']]
@employee_id=@s.row(row)[@headerinfo['employee_id']]

@employee=MgEmployee.find_by(:employee_number=>@employee_id,:is_deleted=>0,:mg_school_id=>school_id)
#@employee_data=MgEmployee.where(:id=>@employee.employee_number,:is_deleted=>0,:mg_school_id=>school_id)

@user_data=MgEmployeeBiometricAttendance.where(:mg_employee_id=>@employee.id,:date=>@date,:is_deleted=>0,:mg_school_id=>school_id)
			

						puts @user_data.size
					@check_in_validate=Time.parse(@check_in.to_s)
					@check_out_validate=Time.parse(@check_out.to_s)
					puts "-------------------------------------------------------"
					puts "----@check_in_validate---------------------#{@check_in_validate}------------------------------"
					puts "----@check_OUT_validate---------------------#{@check_out_validate}------------------------------"

					puts "-------------------------------------------------------"

					if @check_in_validate.to_time<= @check_out_validate.to_time

						 if @user_data.size<=0

						 @user=MgEmployeeBiometricAttendance.new

						 @user.date=@date

						 @user.check_in=@check_in
						 @user.check_out=@check_out
						 @user.is_deleted=0
						 @user.mg_school_id=school_id
						 @user.mg_employee_id=@employee.id
						 @success=@user.save
						 
						end
					else
						@time_validation="not_valid"
					end#time validation end

			#end
			 

			end
		end#transaction end
		if @success
			flash[:success]="Data has been saved Successfully"

		else
			if @time_validation=="not_valid"
			flash[:error]="Attendance is not imported, check out time should be greater then check in time"

			else
			flash[:error]="Attendance is not imported, please provide unique time range"
			end

			# puts nkbnfghnrghikrhi
		end
		rescue Exception => e
   			puts e
  			flash[:error]="Attendance is not imported, please contact administration"
  		end
	redirect_to :controller=>'employee_biometric_attendances',:action=>'import'
	end
 private
  def employee_biometric_attendances_params
    params.require(:employee_biometric_attendances).permit(:date, :check_in, :check_out, :is_deleted)
  end

end
