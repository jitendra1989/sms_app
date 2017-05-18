class DashboardsController < ApplicationController

  # before_filter :login_required

  layout "mindcom"
  #com
def search_vehicle_status


end 


def query_record_index_data


  
  if params[:search_by_date]=="search_by_date"
    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
    search_date =Date.strptime(params["search_date"],current_school.date_format)
    date = Date.parse("#{search_date}")
    puts"1111111111111"
    puts params
    puts"1111111111111"
    @query_record_data=MgQueryRecord.where("is_deleted=? and is_principal_required=? and mg_school_id=? and created_at >= ? AND created_at <= ?",0,0,session[:current_user_school_id],date.beginning_of_day,date.end_of_day)
  else
    @query_record_data=MgQueryRecord.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_principal_required=>0)
  end
  render :layout=>false
end

def vehicle_information
  @school=MgSchool.find_by(:id=>session[:current_user_school_id])
@inventory=MgVehicle.find_by(:id=>params[:id])

    render :layout => false

  end

def employee_library_search
  if params[:id]=="search"
  mg_school_id=session[:current_user_school_id]
  @name=params[:name]
  @category=params[:resorce_category]
  @type=params[:select_type]
  @number=params[:resource_no]
  @author=params[:author]
  @year=params[:year]
  @publications=params[:publication]
  @class=params[:select_class]
  @subject=params[:subject]
  @volume=params[:volume]
  @isbn=params[:isbn]
  @str="is_deleted=0"
  if params[:name].present?
     @str += " and name='#{params[:name]}'"
  end
   if params[:resorce_category].present?
     @str += " and mg_resource_category_id='#{params[:resorce_category]}'"
  end
   if params[:select_type].present?
     @str += " and mg_resource_type_id='#{params[:select_type]}'"
  end
   if params[:resource_no].present?
     @str += " and resource_number='#{params[:resource_no]}'"
  end 
  if params[:author].present?
     @str += " and author='#{params[:author]}'"
  end
   if params[:year].present?
     @str += " and year='#{params[:year]}'"
  end
   if params[:publication].present?
     @str += " and publication='#{params[:publication]}'"
  end
   if params[:select_class].present?
     @str += " and mg_course_id='#{params[:select_class]}'"
  end
   if params[:subject].present?
     @str += " and mg_subject_id='#{params[:subject]}'"
  end
   if params[:volume].present?
     @str += " and volume='#{params[:volume]}'"
  end
   if params[:isbn].present?
     @str += " and isbn='#{params[:isbn]}'"
  end

 @category_type_data=MgResourceType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  @object=MgResourceInventory.where( :mg_school_id=>mg_school_id,:is_deleted=>0,:non_issuable=>0).where(@str)

  # @object1=MgResourceInventory.where( :mg_school_id=>mg_school_id)

else
  @demo="data1"
  end
end
   def select_stop_name

  
    render :layout => false
  
end

def transport_facility

  id=session[:user_id]
    @guardian=MgGuardian.find_by(:mg_user_id=>"#{id}")
    logger.info("=================================================")
    logger.info(id)
    @sql = "SELECT S.first_name ,S.last_name,S.admission_number, S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.has_login_access=1 And M.mg_guardians_id  = #{@guardian.id} And S.id = M.mg_student_id and G.id = M.mg_guardians_id"

    @StudentListQuery=MgStudent.find_by_sql(@sql)
    arry=Array.new
    @StudentListQuery.each do |students|
      arry.push(students.id)
    end
    # @second_data=MgGuardianTransportRequisition.where(:mg_student_id=>arry,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)
    @second_data_id=MgGuardianTransportRequisition.where(:mg_student_id=>arry,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    
    
end
def transport_facility_new
  @id=params[:id]
@school_id=session[:current_user_school_id]
    render :layout => false

  end
  def transport_facility_create
   # logger.infoasdghasd
    @student_guardian=MgGuardianTransportRequisition.new()
    @student_guardian.mg_student_id=params[:id]
    @student_guardian.mg_transport_id=params[:mg_transport_routes_ids]
    @student_guardian.mg_vehicle_id=params[:mg_routes_ids]
    @student_guardian.mg_transport_time_management_id=params[:mgss_route_ids]
    @student_guardian.confirmation_status=params[:status]
    @student_guardian.applied_date=Date.today
    @student_guardian.is_deleted=0
    @student_guardian.mg_school_id=session[:current_user_school_id]
    @student_guardian.created_by=session[:user_id]
    @student_guardian.save
 redirect_to :action=>'transport_facility'
  end
  def transport_facility_edit
    @datas=MgGuardianTransportRequisition.find(params[:id])
    render :layout => false
    
  end
  def transport_facility_update
    @datas=MgGuardianTransportRequisition.find(params[:id])
    @datas.mg_transport_id=params[:mg_routes_ids]
    @datas.mg_transport_time_management_id=params[:mgs_transports_id]
    @datas.save
 redirect_to :action=>'transport_facility'

  end
  def transport_facility_destroy
    @datas=MgGuardianTransportRequisition.find(params[:id])
    @datas.is_deleted=1
    @datas.updated_by=session[:user_id]
    @datas.save
 redirect_to :action=>'transport_facility'
    
  end
  #com
  def admission_report_for_principle
    
  end

  def cloud_admin
    puts "cloud_admin"
  end

  # , "resorce_category"=>"1", "select_resource_type"=>"1", 
  # "resource_no"=>"dswd", "name"=>"sdf", "author"=>"fsd",
  #  "volume"=>"fd", "year"=>"fd",
  #  "publication"=>"f", "isbn"=>"d", 
  #  "select_class"=>"1", "subject"=>"fd"}
 def search_reserve_books_index
  if params[:id]=="search"
  mg_school_id=session[:current_user_school_id]
  @name=params[:name]
  @category=params[:resorce_category]
  @type=params[:select_resource_type]
  @number=params[:resource_no]
  @author=params[:author]
  @year=params[:year]
  @publications=params[:publication]
  @class=params[:select_class]
  @subject=params[:subject]
  @volume=params[:volume]
  @isbn=params[:isbn]
  @str="is_deleted=0"
  if params[:name].present?
     @str += " and name='#{params[:name]}'"
  end
   if params[:resorce_category].present?
     @str += " and mg_resource_category_id='#{params[:resorce_category]}'"
  end
   if params[:select_resource_type].present?
     @str += " and mg_resource_type_id='#{params[:select_resource_type]}'"
  end
   if params[:resource_no].present?
     @str += " and resource_number='#{params[:resource_no]}'"
  end 
  if params[:author].present?
     @str += " and author='#{params[:author]}'"
  end
   if params[:year].present?
     @str += " and year='#{params[:year]}'"
  end
   if params[:publication].present?
     @str += " and publication='#{params[:publication]}'"
  end
   if params[:select_class].present?
     @str += " and mg_course_id='#{params[:select_class]}'"
  end
   if params[:subject].present?
     @str += " and mg_subject_id='#{params[:subject]}'"
  end
   if params[:volume].present?
     @str += " and volume='#{params[:volume]}'"
  end
   if params[:isbn].present?
     @str += " and isbn='#{params[:isbn]}'"
  end

 @category_type_data=MgResourceType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  @object=MgResourceInventory.where( :mg_school_id=>mg_school_id,:non_issuable=>0,:is_deleted=>0).where(@str)

  # @object1=MgResourceInventory.where( :mg_school_id=>mg_school_id)
else
  @demo="data1"
  end
end

def select_category_type
 @category_type_data=MgResourceType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_resource_category_id=>params[:data]).pluck(:name,:id)
  render :layout=>false
  end

  def library_search_results

    # params[:]
  end
  def reserve_books_index

end
def books_information_data_for_student
@inventory_data=MgBooksInventory.find(params[:book_id])
@student_id=MgStudent.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
puts @student_id.id
puts session[:user_id]
@student_lib_inforamtion=MgBooksInventory.where("issued_to=? or reserved_by=?",@student_id.id,@student_id.id)

#puts @student_lib_inforamtion
render :layout=>false
end
def search_books_for_student
  @value=params[:Value]
    
    data=params[:Data]
    @school_id=session[:current_user_school_id]
    if @value=="book_name"
      #@data = MgBooksInventory.where("book_name LIKE :book_name",{:book_name => "#{data}%"}).paginate(page: params[:page], per_page: 10)
     @sql="select id, book_no,book_name,status,author,publisher,edition,cost,mg_books_category_id,mg_course_id from mg_books_inventories where book_name LIKE '%#{data}%' and is_deleted='0' and mg_school_id='#{@school_id}' and non_issuable='0' and is_damaged='0'and is_lost='0'"
    elsif @value=="publisher"
      #@data = MgBooksInventory.where("book_name LIKE :book_name",{:book_name => "#{data}%"}).paginate(page: params[:page], per_page: 10)
        @sql="select id, book_no,book_name,status,author,publisher,edition,cost,mg_books_category_id,mg_course_id from mg_books_inventories where publisher LIKE '%#{data}%' and is_deleted='0' and mg_school_id='#{@school_id}' and non_issuable='0' and is_damaged='0'and is_lost='0'"
    else
      #@data = MgBooksInventory.where("book_name LIKE :book_name",{:book_name => "#{data}%"}).paginate(page: params[:page], per_page: 10)
       @sql="select id,book_no, book_name,author,status,publisher,edition,cost,mg_books_category_id,mg_course_id from mg_books_inventories where author LIKE '%#{data}%' and is_deleted='0' and mg_school_id='#{@school_id}' and non_issuable='0' and is_damaged='0'and is_lost='0'" 
    end

      @data=MgBooksInventory.find_by_sql(@sql)
      #logger.infosdhkj
      #puts @data.inspect
      render :layout=>false

  end

  def employee
#leave status
  school_id=session[:current_user_school_id]
   previous_month=Date.today#.ago(1.month)
      start_from=previous_month.beginning_of_month
      end_to=previous_month.end_of_month

      @month_start=start_from.strftime('%Y-%m-%d')
      @month_end=end_to.strftime('%Y-%m-%d')
  @school=MgSchool.find(school_id)
  employee = MgEmployee.find_by(:mg_user_id=>session[:user_id])
  @employee=employee
        emp_experience = employee.experience_year*12 + employee.experience_month
        emp_gender = Array.new
        emp_gender << "all"
        emp_gender << employee.gender
        emp_type_id = employee.mg_employee_type_id
        
      @mg_employee_leave_types=MgEmployeeLeaveType.where("is_deleted  = 0 AND mg_school_id = #{session[:current_user_school_id]} AND minimum_month_experience <= ? AND gender IN (?) AND mg_employee_type_id =?",emp_experience, emp_gender, emp_type_id)


      #attendance
        @chart_dataHash=Hash.new
        @current_month=Date.today.strftime("%m")
        @current_Year=Date.today.strftime("%Y")
        @days = Time.days_in_month(@current_month.to_i,@current_Year.to_i)
        department= MgEmployeeDepartment.find(employee.mg_employee_department_id)
        @absent_student_count=MgEmployeeAttendance.where(:is_approved=>1, :mg_employee_id=>employee.id, :is_deleted=>0).where('extract(MONTH from absent_date )=MONTH(now())').count
        @present_day_count=@days-@absent_student_count
        array=Array.new
        full_name=employee.first_name+' '+employee.last_name
        array.push("Present",full_name)
        @chart_dataHash[array]=@present_day_count
        array=Array.new
        array.push("Absent",full_name)
        @chart_dataHash[array]=-@absent_student_count

        #show notification
        @notifications = MgNotification.where(:to_user_id => session[:user_id], :is_deleted=>0, :mg_school_id=>school_id).order(:status).last(10)
        @notifi = MgNotification.where(:to_user_id => session[:user_id],:status => false ).all
        @size = @notifi.size
        @user = MgUser.find(session[:user_id])
        @user_type = @user[:user_type]

        #timetable
        @employee_id=session[:user_id]
        @employee=MgEmployee.find_by(:mg_user_id=>@employee_id)
        dayCheck= Date.new()
        dayName=dayCheck.strftime("%A")
        mg_weekday_id=MgWeekday.where(:is_deleted=>0, :mg_school_id=>school_id, :weekday=>Date.today.strftime("%w")).pluck(:id)
        puts mg_weekday_id.inspect
        @timetables=MgTimeTableEntry.where(:mg_weekday_id=>(mg_weekday_id),:mg_employee_id=>@employee.id,:is_deleted=>0, :mg_school_id => session[:current_user_school_id])
        employee_test=MgEmployee.find_by(:mg_user_id=>session[:user_id], :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>'Teaching Staff')))
        if employee_test.present?
        
        @event_privacy=MgInvitation.where( :is_deleted=>0, :mg_school_id=>school_id, :mg_employee_department_id=>employee_test.mg_employee_department_id).where("teacher=1").pluck(:mg_event_id)

        else
          employee=MgEmployee.find_by(:mg_user_id=>session[:user_id], :is_deleted=>0, :mg_school_id=>school_id)
        @event_privacy=MgInvitation.where( :is_deleted=>0, :mg_school_id=>school_id, :mg_employee_department_id=>employee.mg_employee_department_id).where("employee=1").pluck(:mg_event_id)
        
        end
        @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>school_id, :event_date=>Date.today()-1...Date.today()+7, :id=>@event_privacy).last(10)
  
  #time table
  
  
    academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    # if academic_years.present?

      timetables=ShowTimetable.new
      time_table_arr=timetables.employee_time_table_show(@employee.id, school_id, academic_years[0].try(:id))
      if time_table_arr.present?
        @timetable=time_table_arr[0]
        @big_weekday=time_table_arr[1]
      end
    # end
end

  def guardian_profile_address_edit
    id=session[:user_id]
    @guardian = MgGuardian.where(:mg_user_id =>id)
    @Permanent = MgAddress.where(:mg_user_id => id, :address_type => 'Permanent')

    @Permanent = @Permanent[0]
    puts @Permanent[0].inspect
    render :layout => false
  end

  def guardian_change_password
    # id=session[:user_id]
    # @guardian = MgGuardian.where(:mg_user_id =>id)
    # @user = MgUser.where(:id =>id)
    render :layout => false
    
  end

  def guardian_changed_password
    puts "444444444444"
    @fff = params[:guardian]
    @curr = @fff[:name]
    id=session[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)
puts "8888888888"
puts user_name
puts "88888888888888"
puts "check"
puts user_name
puts @curr
@bool=@user.authenticate(user_name, @curr)
puts @bool.inspect
puts "7777777777777777777"

if  @bool==nil

  puts "ifn7777800000000"
  flash.now.alert = "Please enter correct password !"
   flash[:notice] = "Please enter correct password !"
   puts "777777777777777777777777777777777777777777777777"
   # redirect_to :action => "employee_profiles"
   # @fff.hhh
   # redirect_to :action => "employee_change_password"
else
  

    @pass = params[:guardian]
    @passw = @pass[:password]

    @rpass = params[:guardian]
    @rpassw = @rpass[:hashed_password]


    if @passw==@rpassw



      if @user
        puts "@user.inspect"
        puts @user.inspect
        puts "@user.inspect"


            @userMe=MgUser.find(session[:user_id])

       @userMe.update(password_params)
       # respond_to do |format|
       #      format.js {}
       #  end
    end  


    else

    flash.now.alert = "Re Entered password didn't matched !"
    end



end

    # user = find_by_user_name(user_name)
 
    # if user && user.hashed_password == BCrypt::Engine.hash_secret(@curr, user.salt)
    #   #user 
    #   puts "if part hai"
    # else
    #   #nil  
    #   puts "else part hai"
    # end
  

    flash.now.alert = "Invalid Password..."
   
    redirect_to :action => "guardian_profile"
  end



def student_change_password
    
    render :layout => false
    
  end

  def student_changed_password
    @fff = params[:student]
    @curr = @fff[:name]
    id=session[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)
puts "8888888888"
puts user_name
puts "88888888888888"
puts "check"
puts user_name
puts @curr
@bool=@user.authenticate(user_name, @curr)
puts @bool.inspect
puts "7777777777777777777"

if  @bool==nil

  puts "ifn7777800000000"
  flash.now.alert = "Please enter correct password !"
else
  

    @pass = params[:student]
    @passw = @pass[:password]

    @rpass = params[:student]
    @rpassw = @rpass[:hashed_password]


    if @passw==@rpassw



      if @user
        puts "@user.inspect"
        puts @user.inspect
        puts "@user.inspect"


            @userMe=MgUser.find(session[:user_id])

       @userMe.update(password_param)
       # respond_to do |format|
       #      format.js {}
       #  end
    end  


    else

    flash.now.alert = "Re Entered password didn't matched !"
    end



end

    # user = find_by_user_name(user_name)
 
    # if user && user.hashed_password == BCrypt::Engine.hash_secret(@curr, user.salt)
    #   #user 
    #   puts "if part hai"
    # else
    #   #nil  
    #   puts "else part hai"
    # end
  

    flash.now.alert = "Invalid Password..."
   
    redirect_to :action => "show"
  end


  def employee_change_password
    
    render :layout => false
    
  end

  def employee_changed_password
    @@a=false
    @fff = params[:employee]
    @curr = @fff[:name]
    id=session[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)
puts "8888888888"
puts user_name
puts "88888888888888"
puts "check"
puts user_name
puts @curr
@bool=@user.authenticate(user_name, @curr)
puts @bool.inspect
puts "7777777777777777777"

if  @bool==nil

  puts "ifn7777800000000"
  flash.now.alert = "Please enter correct password !"
  @@a=true
    
else
  

    @pass = params[:employee]
    @passw = @pass[:password]

    @rpass = params[:employee]
    @rpassw = @rpass[:hashed_password]


    if @passw==@rpassw



      if @user
        puts "@user.inspect"
        puts @user.inspect
        puts "@user.inspect"


            @userMe=MgUser.find(session[:user_id])

       @userMe.update(password_par)
       # respond_to do |format|
       #      format.js {}
       #  end
    end  


    else

    flash.now.alert = "Re Entered password didn't matched !"
    end



end

    # user = find_by_user_name(user_name)
 
    # if user && user.hashed_password == BCrypt::Engine.hash_secret(@curr, user.salt)
    #   #user 
    #   puts "if part hai"
    # else
    #   #nil  
    #   puts "else part hai"
    # end
  
    flash.now.alert = "Invalid Password..."
   if @@a==true
    redirect_to emp_pro_url
  else
    redirect_to :action => "employee_profile"
  end
  end



def principle_change_password
    
    render :layout => false
    
  end

  def principle_changed_password
    @fff = params[:principle]
    @curr = @fff[:name]
    id=session[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)
puts "8888888888"
puts user_name
puts "88888888888888"
puts "check"
puts user_name
puts @curr
@bool=@user.authenticate(user_name, @curr)
puts @bool.inspect
puts "7777777777777777777"

if  @bool==nil

  puts "ifn7777800000000"
  flash.now.alert = "Please enter correct password !"
else
  

    @pass = params[:principle]
    @passw = @pass[:password]

    @rpass = params[:principle]
    @rpassw = @rpass[:hashed_password]


    if @passw==@rpassw



      if @user
        puts "@user.inspect"
        puts @user.inspect
        puts "@user.inspect"


            @userMe=MgUser.find(session[:user_id])

       @userMe.update(password_pa)
       # respond_to do |format|
       #      format.js {}
       #  end
    end  


    else

    flash.now.alert = "Re Entered password didn't matched !"
    end



end

    # user = find_by_user_name(user_name)
 
    # if user && user.hashed_password == BCrypt::Engine.hash_secret(@curr, user.salt)
    #   #user 
    #   puts "if part hai"
    # else
    #   #nil  
    #   puts "else part hai"
    # end
  
    flash.now.alert = "Invalid Password..."
   
    redirect_to :action => "principal_profile"
  end







  def guardian_profile_contact_edit

    puts "Methos calling"
    id=session[:user_id]
    puts "id is"
    puts id
    @guardian = MgGuardian.where(:mg_user_id =>id)

    @phone = MgPhone.where(:mg_user_id => id, :phone_type => 'phone')
    puts @phone.inspect


    @mobile = MgPhone.where(:mg_user_id => id, :phone_type => 'mobile')
     puts @mobile.inspect

    @email = MgEmail.where(:mg_user_id => id, :email_type => 'home')

    @phone = @phone[0]

    puts "Step -------------------------------- "
    puts @phone.inspect
    puts "Step -------------------------------- "


    @mobile = @mobile[0]

    puts "Step -------------------------------- "
    puts @mobile.inspect
    puts "Step -------------------------------- "

    @email = @email[0]

  #  puts @Permanent[0].inspect
    render :layout => false
  end

  def guardian_student_profile_contact_edit
    studentID=params[:id]
    @student=MgStudent.where(:id=> studentID)
    user_id=@student[0].mg_user_id
     @phone = MgPhone.where(:mg_user_id => @student[0].mg_user_id, :phone_type => 'phone')
    @mobile = MgPhone.where(:mg_user_id => @student[0].mg_user_id, :phone_type => 'mobile')

    @email = MgEmail.where(:mg_user_id => @student[0].mg_user_id)

    @phone = @phone[0]
    @mobile = @mobile[0]
    @email = @email[0]
    puts @email[0]





    render :layout => false
    
  end
  def guardian_student_profile_addres_edit
    studentID=params[:id]
     @student=MgStudent.where(:id=> studentID)
    user_id=@student[0].mg_user_id
    
    @Permanent = MgAddress.where(:mg_user_id => user_id, :address_type => 'Permanent')

    @Permanent = @Permanent[0]
    puts @Permanent[0].inspect
    render :layout => false
    
  end

  def guardian_student_profile_correspondanceaddress_address_edit
    studentID=params[:id]
    puts studentID
    @student=MgStudent.where(:id=> studentID)
    user_id=@student[0].mg_user_id
    puts user_id
    @Correspondance = MgAddress.where(:mg_user_id => user_id, :address_type => 'Correspondance')
    @Correspondance = @Correspondance[0]
    # puts @Permanent[0].inspect
    render :layout => false
    
  end

  def edit_employee_contact
    puts "Methos calling"
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id)

    @phone = MgPhone.where(:mg_user_id => id, :phone_type => 'phone')
    @mobile = MgPhone.where(:mg_user_id => id, :phone_type => 'mobile')

    @email = MgEmail.where(:mg_user_id => id, :email_type => 'home')

    @phone = @phone[0]
    @mobile = @mobile[0]
    @email = @email[0]

  #  puts @Permanent[0].inspect
    render :layout => false
    
  end

  def edit_employee_permanent_address
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id)
    puts @employee.inspect
    
    @Permanent = MgAddress.where(:mg_user_id => id, :address_type => 'Permanent')

    @Permanent = @Permanent[0]
    puts @Permanent[0].inspect
    render :layout => false
  end

  def edit_employee_correspondnce_address
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id)
    puts @employee.inspect
    
    @Temporary = MgAddress.where(:mg_user_id => id, :address_type => 'Temporary')

    @Temporary = @Temporary[0]
    puts @Temporary[0].inspect
    render :layout => false
  end

  def edit_principal_contact
    puts "Methos calling"
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id)

    @phone = MgPhone.where(:mg_user_id => id, :phone_type => 'phone')
    @mobile = MgPhone.where(:mg_user_id => id, :phone_type => 'mobile')

    @email = MgEmail.where(:mg_user_id => id, :email_type => 'home')

    @phone = @phone[0]
    @mobile = @mobile[0]
    @email = @email[0]

  #  puts @Permanent[0].inspect
    render :layout => false
    
  end

  def edit_principal_permanent_address
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id)
    puts @employee.inspect
    
    @Permanent = MgAddress.where(:mg_user_id => id, :address_type => 'Permanent')

    @Permanent = @Permanent[0]
    puts @Permanent[0].inspect
    render :layout => false
    
  end

  def edit_principal_correspondnce_address
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id)
    puts @employee.inspect
    
    @Temporary = MgAddress.where(:mg_user_id => id, :address_type => 'Temporary')

    @Temporary = @Temporary[0]
    puts @Temporary[0].inspect
    render :layout => false
  end

  def index
    puts "----------- dashboards -------- "


      logger.info(@user.inspect)
      id=session[:user_id]
      logger.info("===============index id==============")
      logger.info(id.inspect)
      #logger.info(session[:user_id])
       @sql = "select A.id, A.role_name from mg_roles A,mg_user_roles B where B.mg_role_id=A.id AND B.mg_user_id=#{id}"

        
           #@sql = "select G.model_name, F.action_name,  A.id, A.model_id, A.action_id from permissions A,users B,user_roles C, roles D,roles_permissions E, actions F , models G Where B.id = C.user_id AND C.role_id = D.id AND D.id = E.role_id AND E.permission_id = A.id  AND A.action_id = F.id AND A.model_id = G.id AND B.id =#{@user.id}"
          

     @query=MgRole.find_by_sql(@sql)
     logger.info("--------------------------------------------------")
     @query=@query.as_json
     @rollnamequery=@query[0]

    @roleName =  @rollnamequery['role_name']
   #SessionsController.instance_variable_get(:'@ModelData')
      # logger.info  SessionsController.instance_variable_get(:'@ModelData')
      # puts session[:model_data]

      # notifications
  end

def student
    @mg_school_id=session[:current_user_school_id]
    @school=MgSchool.find( @mg_school_id)
   @notifications = MgNotification.where(:to_user_id => session[:user_id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).order(:status).last(10)

    @notifi = MgNotification.where(:to_user_id => session[:user_id],:status => false ).all

    @size = @notifi.size
    
    @user = MgUser.find(session[:user_id])

    @user_type = @user[:user_type]


    #time table start

      @student_id=session[:user_id]
      @student=MgStudent.find_by(:mg_user_id=>@student_id)
      @batch=MgBatch.find( @student.mg_batch_id)
      @course=MgCourse.find(@batch.mg_course_id)

        # @employee=MgEmployee.find_by(:mg_user_id=>@employee_id)
        # dayCheck= Date.new()
        # dayName=dayCheck.strftime("%A")
        mg_weekday_id=MgWeekday.where(:mg_wing_id=>@course.mg_wing_id,:is_deleted=>0, :mg_school_id=>@mg_school_id).pluck(:id)
        puts mg_weekday_id.inspect
        @timetables=MgTimeTableEntry.where(:mg_batch_id=>@student.mg_batch_id,:mg_weekday_id=>(mg_weekday_id),:is_deleted=>0, :mg_school_id => @mg_school_id)
#     render :layout => false
    #timetable end
         user=MgStudent.find_by(:is_deleted=>0, :mg_school_id=> @mg_school_id,:mg_user_id=>session[:user_id])

            event=MgInvitation.where(:student=>1, :is_deleted=>0, :mg_school_id=> @mg_school_id, :mg_batch_id=>user.mg_batch_id).pluck(:mg_event_id)
        @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>@mg_school_id, :event_date=>Date.today()...Date.today()+7, :id=>event).last(10)


 @academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>@mg_school_id)
    # time_table_arr=student_time_table_show(@batch_id, mg_school_id)
    

    timetables=ShowTimetable.new
    time_table_arr=timetables.student_show_time_table(@student.mg_batch_id, @mg_school_id, @academic_years[0].try(:id))
    if time_table_arr.present?
      @timetable=time_table_arr[0]
      @big_weekday=time_table_arr[1]
    end

end

def student_messages
  render :layout => false
end

def student_news
#  render :layout => false
end




# start employee

def employee_profile
                 id=session[:user_id]

    @sqls="select  A.employee_number,A.mg_user_id, A.joining_date,A.first_name,A.middle_name,A.last_name,A.gender,A.job_title,A.date_of_birth,A.qualification,A.mg_school_id,A.experience_year,A.marital_status,A.blood_group,A.father_name,A.mother_name from mg_employees A,mg_users B where A.mg_user_id=B.id AND B.id=#{id}"
  #  @sqls="select * from mg_employees A,mg_users B where A.mg_user_id=B.id AND B.id=#{id}"
              @studentquery=MgEmployee.find_by_sql(@sqls)
              
                puts id
               @employee=MgEmployee.find_by(:mg_user_id=>"#{id}")
               puts @employee.inspect
               
              @queryst=@studentquery.as_json
              logger.info("=----------------------------------------studentprofile1------------------------")
        
              @employeequery=@queryst[0]

              @employeeUserId= @employeequery['mg_user_id']

              @address=MgAddress.where(mg_user_id: @employeeUserId)

              @contact=MgPhone.where(mg_user_id: @employeeUserId)
              @email=MgEmail.where(mg_user_id: @employeeUserId)

   #render :layout => false
  end

  def principal
    
    @mg_school_id=session[:current_user_school_id]
    @school=MgSchool.find(@mg_school_id)
   
    @students=MgBatch.pluck(:name,:id)
        @employee = MgEmployee.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id]).where("id != ?", 3)

        @employeeCategory = MgEmployeeCategory.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id])

        @employeeAttendance = MgEmployeeAttendance.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id])

        @employeeDept = MgEmployeeDepartment.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id])


      #attendance
      @employee_list=MgEmployeeAttendance.where(:is_deleted=>0,:absent_date=>Date.today(), :mg_school_id=>@mg_school_id).pluck(:mg_employee_id)
      @attendance_teach= MgEmployee.where(:is_deleted=>0, :mg_school_id=>@mg_school_id, :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>'Teaching Staff').id), :id=>@employee_list)
     puts "values"
     puts @attendance_teach.inspect
      
      @attendance= MgEmployee.where(:is_deleted=>0, :mg_school_id=>@mg_school_id, :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>'Non Teaching Staff').id), :id=>@employee_list)
      #LEAVE
      @category=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>@mg_school_id).pluck(:department_name,:id)

      @leave_for_today=MgEmployeeLeaveApplication.where(:from_date=>Date.today(), :is_deleted=>0, :mg_school_id=>@mg_school_id, :status=>'Approved')
 
      #time_table

        @mg_weekday_id=MgWeekday.where(:is_deleted=>0, :mg_school_id=>@mg_school_id, :weekday=>Date.today.strftime("%w")).pluck(:id)
        # puts mg_weekday_id.inspect
        @wings=MgWing.where(:is_deleted=>0, :mg_school_id=>@mg_school_id)
        @timetables=MgTimeTableEntry.where(:mg_weekday_id=>( @mg_weekday_id),:is_deleted=>0, :mg_school_id => @mg_school_id)

      

        # event start
        @events=MgEvent.select(:title, :mg_event_type_id, :event_date, :end_date, :start_time, :end_time, :event_description).where(:is_deleted=>0, :mg_school_id=>@mg_school_id, :event_date=>Date.today()...Date.today()+7).uniq.last(10)
        # event end

        #Notification Start
       @notifications = MgNotification.where(:to_user_id => session[:user_id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).order(:status).last(10)

        @notifi = MgNotification.where(:to_user_id => session[:user_id],:status => false ).all

        @size = @notifi.size
        
        @user = MgUser.find(session[:user_id])

        @user_type = @user[:user_type]
        #Notification end
        puts "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
  end

  def sublect_and_class_for_employee
    mg_employee_id=params[:id]
    mg_school_id=session[:current_user_school_id]
    employee=MgEmployeeSubject.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_id=>params[:id]).pluck(:mg_subject_id)
  puts "employee.inspect"
  puts mg_employee_id
     @subject=MgSubject.where(:id=>employee, :is_deleted=>0, :mg_school_id=>mg_school_id)
  render :layout => false
    
  end
  def student_piechart
    
          # @startDate=params[:start_date]
          # @endDate=params[:end_date]
           @batch=params[:batch]
        
       @schoolObj=MgSchool.find_by_id(session[:current_user_school_id]) 



      @startDate = Date.strptime(params[:start_date],@schoolObj.date_format)
      @endDate = Date.strptime(params[:end_date],@schoolObj.date_format)

      puts @startDate
      puts @endDate 

           @studentDetails=MgStudentAttendance.where(:absent_date => @startDate..@endDate,:mg_batch_id=>params[:batch])
           
           


    render :layout => false

  end

  def principle_events
    
  end
  def principle_messages
    
  end
  def principle_news
    
  end
  def principle_attendance

  end

 
  def principal_profile

        id=session[:user_id]

    @sqls="select  A.employee_number,A.mg_user_id, A.joining_date,A.first_name,A.middle_name,A.last_name,A.gender,A.job_title,A.date_of_birth,A.qualification,A.mg_school_id,A.experience_year,A.marital_status,A.blood_group,A.father_name,A.mother_name from mg_employees A,mg_users B where A.mg_user_id=B.id AND B.id=#{id}"
  #  @sqls="select * from mg_employees A,mg_users B where A.mg_user_id=B.id AND B.id=#{id}"
              @studentquery=MgEmployee.find_by_sql(@sqls)
              puts "0000666666666666666666666666666666666660"
              puts @studentquery.inspect
              puts "00000666666666666666666666666666666666666000000"
                puts id
               @employee=MgEmployee.find_by_mg_user_id(session[:user_id])
               puts @employee.inspect
               puts "7777777777777777777"
              @queryst=@studentquery.as_json
              logger.info("=----------------------------------------studentprofile1------------------------")
        
              @employeequery=@queryst[0]
              puts "000000000000000000000000000000000000000000000000"
              puts session[:user_id]
              puts @employee.inspect
              puts "000000000000000000000000000000000000000000000000"
              puts @studentquery.inspect
              if @employeequery.nil?
              else
              @employeeUserId= @employeequery['mg_user_id']

              @address=MgAddress.where(mg_user_id: @employeeUserId)

              @contact=MgPhone.where(mg_user_id: @employeeUserId)
              @email=MgEmail.where(mg_user_id: @employeeUserId)
            end
    
  end

  def guardian
     @mg_school_id=session[:current_user_school_id]
    @school=MgSchool.find( @mg_school_id)
   
    id=session[:user_id]
    @guardian=MgGuardian.find_by(:mg_user_id=>"#{id}")
    logger.info("=================================================")
    logger.info(id)
    @sql = "SELECT S.first_name ,S.last_name,S.admission_number, S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.mg_guardians_id  = #{@guardian.id} And S.id = M.mg_student_id and G.id = M.mg_guardians_id"

    @StudentListQuery=MgStudent.find_by_sql(@sql)

    # notification start
   @notifications = MgNotification.where(:to_user_id => session[:user_id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).order(:status).last(10)
    @notifi = MgNotification.where(:to_user_id => session[:user_id],:status => false ).all
    @size = @notifi.size
    @user = MgUser.find(session[:user_id])
    @user_type = @user[:user_type]
    #notification End

    #fee start
    id=session[:user_id]
    @guardian=MgGuardian.find_by(:mg_user_id=>"#{id}")
    @sql = "SELECT S.first_name ,S.last_name,S.admission_number, S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.mg_guardians_id  = #{@guardian.id} And S.id = M.mg_student_id and G.id = M.mg_guardians_id"

    @StudentListQuery=MgStudent.find_by_sql(@sql)
    #fee end
     @sql = "SELECT S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.mg_guardians_id  = #{@guardian.id} And S.id = M.mg_student_id and G.id = M.mg_guardians_id"

    @studentListQuery_fee=MgStudent.find_by_sql(@sql)

    @finance_fee_hash=MgFinanceFee.where(:student_id=>@studentListQuery_fee)
    @student=MgStudent.where(:id=>@studentListQuery_fee)
 # event start
        # @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>@mg_school_id, :event_date=>Date.today()...Date.today()+7, :event_privacy=>"guardian").last(10)
        @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>@mg_school_id, :event_date=>Date.today()...Date.today()+7, :event_privacy=>"guardian").last(10)
       
        # event end

    
  end

def employee_events

#  render :layout => false
  end

def employee_messages

  render :layout => false
  end

def employee_news

   # render :layout => false
  end

def guardian_profile
 	 id=session[:user_id]

	#@sqls="select A.first_name, A.middle_name,A.last_name,A.dob,A.relation,A.occupation,A.income from mg_guardians A,mg_users B where A.mg_user_id=B.id AND B.id=#{id}"
	@guardian=MgGuardian.find_by(:mg_user_id=>"#{id}")
	#@studentquery=MgGuardian.find_by_sql(@sqls)
	   
	#@queryst=@studentquery.as_json
	logger.info("=----------------------------------------@guardian------------------------")
	#@guardianquery=@queryst[0]
	logger.info(@guardian.inspect)

	@guardianUserId= @guardian.mg_user_id
	@address=MgAddress.where(mg_user_id: @guardianUserId)
  @phone_number=MgPhone.where(mg_user_id: @guardianUserId,:phone_type=>"phone")
  @mobile_number=MgPhone.where(mg_user_id: @guardianUserId,:phone_type=>"mobile")
	# @contact=MgPhone.where(mg_user_id: @guardianUserId)
	@email=MgEmail.where(mg_user_id: @guardianUserId)

 #   render :layout => false
end

def guardian_events
#render :layout => false
end
def student_event
#render :layout => false
end




def fees_submission_batch
    if request.get?
      @studentId=params[:id]
      @checkForFeePaid=MgFinanceFee.where(:student_id=>@studentId)
      @collection_particular_list=MgFeeCollectionParticular.where(:mg_student_id=>params[:id])
      @studentBatch=MgStudent.select(:mg_batch_id).where(:id=>params[:id])
      @particular_discount_list=MgFeeCollectionDiscount.select(:mg_discount_name, :mg_discount).where(:mg_discount_type=>"Batch", :mg_discount_receiver_id=>@studentBatch[0].mg_batch_id)
    end

    if request.post?
      @mg_finance_fee_id=MgFinanceFee.where(:student_id=>params[:fees_submission_batch][:student_id])
      puts"@mg_finance_fee_id"
      puts @mg_finance_fee_id.inspect
      if(@mg_finance_fee_id.length>0)
        mgFinanceFeeId=@mg_finance_fee_id[0].id
      else
        mgFinanceFeeId=''
      end
      # :finance_fee_id=>@mg_finance_fee_id[0].id,
      #logger.info " @mg_finance_fee_id"  
      #logger.info  @mg_finance_fee_id.inspect
      @mg_finance_transaction=MgFinanceTransaction.new(:amount => params[:fees_submission_batch][:fee_amount], :mg_student_id=> params[:fees_submission_batch][:student_id], :finance_fee_id=>mgFinanceFeeId, :transaction_date=> params[:fees_submission_batch][:transaction_date], :is_deleted=> params[:fees_submission_batch][:is_deleted], :mg_school_id => session[:current_user_school_id] )
       
     if @mg_finance_transaction.save 

      @mg_finance_fee_id.update_all(:transaction_id=>@mg_finance_transaction.id, :is_paid=>1) 

     end   
      #redirect_to :action=>'fee_collection'
      render :layout => false
    end
    render :layout => false
  end #ends of def fees_submission_batch



def guardian_students
    id=session[:user_id]
    @guardian=MgGuardian.find_by(:mg_user_id=>"#{id}")
    logger.info("=================================================")
    logger.info(id)
    @sql = "SELECT S.first_name ,S.last_name,S.admission_number, S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.has_login_access=1 And M.mg_guardians_id  = #{@guardian.id} And S.id = M.mg_student_id and G.id = M.mg_guardians_id"

    @StudentListQuery=MgStudent.find_by_sql(@sql)

  render :layout => false
end
 
def guardian_leave
   id=session[:user_id]
    @guardian=MgGuardian.find_by(:mg_user_id=>"#{id}")
    logger.info("=================================================")
    logger.info(id)
    @sql = "SELECT S.first_name ,S.last_name,S.admission_number, S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.has_login_access=1 And M.mg_guardians_id  = #{@guardian.id} And S.id = M.mg_student_id and G.id = M.mg_guardians_id"

    @StudentListQuery=MgStudent.find_by_sql(@sql)

end
def guardian_show
@student=MgStudent.find(params[:id])
logger.info params[:id]
@studentUserId= @student.mg_user_id
   @studentCategoryId= @student.mg_student_catagory_id

    @address=MgAddress.where(mg_user_id: @studentUserId)
    
    @contact=MgPhone.where(mg_user_id: @studentUserId)
    @email=MgEmail.where(mg_user_id: @studentUserId)
    @studentCategory=MgStudentCategory.where(id: @studentCategoryId)


    


render :layout => false
end


def guardian_news
#render :layout => false
end
#end employee



  def show
    puts "nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnlyuk"
id=session[:user_id]

    
   #@sqls="select A.admission_number,A.mg_user_id,A.mg_student_catagory_id, A.class_roll_number,A.admission_date,A.first_name,A.middle_name,A.last_name,A.date_of_birth,A.gender,A.blood_group,A.birth_place,A.language,A.religion from mg_students A,mg_users B where A.mg_user_id=B.id AND B.id=#{id}"
   #@studentquery=MgStudent.find_by_sql(@sqls)


   @student=MgStudent.find_by(:mg_user_id=>"#{id}")

   @studentUserId= @student.mg_user_id
   @studentCategoryId= @student.mg_student_catagory_id

    @address=MgAddress.where(mg_user_id: @studentUserId)
    
    @contact=MgPhone.where(mg_user_id: @studentUserId)
    @email=MgEmail.where(mg_user_id: @studentUserId)
    @studentCategory=MgStudentCategory.where(id: @studentCategoryId)
    @dbdatas = MgCommonCustomField.where(model_name: "student")

         @customData = MgCustomFieldsData.where(mg_user_id:@student.mg_user_id)

    

    @dbdatas = MgCommonCustomField.where(model_name: "student")

         @customData = MgCustomFieldsData.where(mg_user_id:@student.mg_user_id)
   
  end

  def student_timetable
    @student_id=session[:user_id]
    mg_school_id=session[:current_user_school_id]
    @student=MgStudent.find_by(:mg_user_id=>@student_id)
    @batch_id=@student.mg_batch_id
    @academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>mg_school_id)
    # time_table_arr=student_time_table_show(@batch_id, mg_school_id)
    

    timetables=ShowTimetable.new
    time_table_arr=timetables.student_show_time_table(@batch_id, mg_school_id, @academic_years[0].try(:id))
    if time_table_arr.present?
      @timetable=time_table_arr[0]
      @big_weekday=time_table_arr[1]
    end
end

# def student_time_table_show(batch_id,mg_school_id)
#    weekday_arr=[]
    
#     @timetables=MgTimeTableEntry.where(:mg_batch_id=>batch_id,:is_deleted=>0, :mg_school_id => session[:current_user_school_id])
#     mg_wing_id=MgBatch.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>batch_id).mg_wing_id_for_batch
#     class_timings=MgClassTiming.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_wing_id=>mg_wing_id, :is_break=>0).includes(:mg_weekday).order("mg_weekdays.weekday asc")
#     weekday_arr=class_timings.pluck(:mg_weekday_id)
#     puts "weekday_arr--->1<---#{weekday_arr.inspect}"
#     weekday_arr=weekday_arr.uniq
#     puts "weekday_arr--->2<---#{weekday_arr.inspect}"
    
#     @count_hash=Hash.new
#     for i in 0...weekday_arr.size
#       count=0
#       class_timings.where(:mg_weekday_id=>weekday_arr[i]).each do |t_loop|
#         count+=1
#       end
#       @count_hash[weekday_arr[i]]=count
#     end
    
#     @big_weekday=find_big_hsah(@count_hash)
#     @timetable=Hash.new
#     for i in 0...weekday_arr.size
#       each_day_hash=Hash.new
#       each_period_count=0
#       weekday_name=""
#       class_timings.where(:mg_weekday_id=>weekday_arr[i]).order(:start_time).each do |cls|
#           table_entry_obj=MgTimeTableEntry.find_by(:mg_class_timings_id=>cls.id,:is_deleted=>0, :mg_batch_id=>batch_id, :mg_school_id=>mg_school_id, :mg_weekday_id=>weekday_arr[i])
#           if table_entry_obj.present?
#              table_entry_re_obj=MgTimeTableChangeEntry.find_by(:mg_time_table_entry_id=>table_entry_obj.id,:is_deleted=>0, :mg_school_id=>mg_school_id)
#             if table_entry_re_obj.present?
#               table_entry_obj=table_entry_re_obj
#             end
#             each_day_hash[each_period_count+=1]={
#               "subject_name"=>table_entry_obj.mg_subject.try(:subject_name),
#               "employee_name"=>table_entry_obj.mg_employee.try(:employee_name),
#               "time"=>cls.try(:start_time).strftime("%k:%M%p").to_s+"-"+cls.try(:end_time).strftime("%k:%M%p").to_s,
#               "employee_number"=>table_entry_obj.mg_employee.try(:employee_number)

#             }
#           else
#             each_day_hash[each_period_count+=1]={
#               "subject_name"=>"",
#               "employee_name"=>"",
#               "time"=>cls.try(:start_time).strftime("%k:%M%p").to_s+"-"+cls.try(:end_time).strftime("%k:%M%p").to_s,
#               "employee_number"=>""
#             }
#           end

#           weekday_name=cls.weekday_name
#       end
#       @timetable[weekday_name]=each_day_hash
#     end

#     return [@timetable, @big_weekday]
# end



# def find_big_hsah(count_hash)
#     big=0
#     big_value_id=nil
#     for i in 0...count_hash.length
#       if count_hash[i].to_i >= big
#         big=count_hash[i].to_i
#         big_value_id=i
#       end
#     end
#     return big
# end
  #work for employee time_table
def employee_time_table
  @employee_id=session[:user_id]
    mg_school_id = session[:current_user_school_id]
    @employee=MgEmployee.find_by(:mg_user_id=>@employee_id)
    @timetables=MgTimeTableEntry.where(:mg_employee_id=>@employee.id,:is_deleted=>0, :mg_school_id => mg_school_id)
    # employee_time_table_show(@employee.id, mg_school_id)
  academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      # if academic_years.present?
      timetables=ShowTimetable.new
        time_table_arr=timetables.employee_time_table_show(@employee.id, mg_school_id, academic_years[0].id)

        if time_table_arr.present?
          @timetable=time_table_arr[0]
          @big_weekday=time_table_arr[1]
        end
    # end
end


# def employee_time_table_show(mg_employee_id,mg_school_id, mg_timetable_id)
#     weekday_arr=[]
#     timetables=MgTimeTableEntry.where(:mg_employee_id=>mg_employee_id,:is_deleted=>0, :mg_school_id => mg_school_id, :mg_timetable_id=>mg_timetable_id)
#     mg_class_timings_id=timetables.pluck(:mg_class_timings_id)
#     class_timings=MgClassTiming.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :is_break=>0, :id=>mg_class_timings_id).includes(:mg_weekday).order("mg_weekdays.weekday asc")
#     weekday_arr=class_timings.pluck(:mg_weekday_id)
#      puts "weekday_arr--->1<---#{weekday_arr.inspect}"
#      weekday_arr=weekday_arr.uniq
#      puts "weekday_arr--->2<---#{weekday_arr.inspect}"
     
#     @count_hash=Hash.new
#     for i in 0...weekday_arr.size
#       count=0
#       class_timings.where(:mg_weekday_id=>weekday_arr[i]).each do |t_loop|
#         count+=1
#       end
#       @count_hash[weekday_arr[i]]=count
#     end
    
#      @big_weekday=find_big_hsah(@count_hash)

#      puts "@big_weekday-----> #{@big_weekday.inspect}"
#      @timetable=Hash.new
#     for i in 0...weekday_arr.size
#       each_day_hash=Hash.new
#       each_period_count=0
#       weekday_name=""
#       class_timings.where(:mg_weekday_id=>weekday_arr[i]).order(:start_time).each do |cls|
#           table_entry_obj=MgTimeTableEntry.find_by(:mg_class_timings_id=>cls.id,:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_weekday_id=>weekday_arr[i], :mg_employee_id=>mg_employee_id)
#           if table_entry_obj.present?
#              table_entry_re_obj=MgTimeTableChangeEntry.find_by(:mg_time_table_entry_id=>table_entry_obj.id,:is_deleted=>0, :mg_school_id=>mg_school_id)
#             if table_entry_re_obj.present?
#               table_entry_obj=table_entry_re_obj
#             end
#             each_day_hash[each_period_count+=1]={
#               "subject_name"=>table_entry_obj.mg_subject.try(:subject_name),
#               "employee_name"=>table_entry_obj.mg_employee.try(:employee_name),
#               "time"=>cls.try(:start_time).strftime("%k:%M%p").to_s+"-"+cls.try(:end_time).strftime("%k:%M%p").to_s,
#               "employee_number"=>table_entry_obj.mg_employee.try(:employee_number),
#               "batch_name"=>table_entry_obj.mg_batch.try(:course_batch_name)

#             }
#           else
#             each_day_hash[each_period_count+=1]={
#               "subject_name"=>"",
#               "employee_name"=>"",
#               "time"=>cls.try(:start_time).strftime("%k:%M%p").to_s+"-"+cls.try(:end_time).strftime("%k:%M%p").to_s,
#               "employee_number"=>""
#             }
#           end

#           weekday_name=cls.weekday_name
#       end

#       @timetable[weekday_name]=each_day_hash#sort_according_to_time(each_day_hash)
#     end

#     return [@timetable, @big_weekday]
# end

# def sort_according_to_time(each_day_hash)
#   puts "========================================================================="
#   puts ""
#   puts each_day_hash.inspect
#   puts ""
#   each_day_hash1=Hash[each_day_hash.sort_by{|k,v| 
#     puts "k-->"+k.to_s
#     puts "v--->"+v.to_s
#     v['time']}]
#   puts ""
#   puts each_day_hash1.inspect

#   puts "========================================================================="

#   return each_day_hash1
# end



   
   
def create
  
end

def admin_events
    render :layout => false
 end
def admin_messages
    render :layout => false
end

 def admin_news
  render :layout => false
end
def admin_mail
  render :layout => false
end

def admin_calendar
  @batches=MgBatch.where(:is_deleted=>0, :mg_school_id => session[:current_user_school_id]).pluck(:name,:id)
  render :layout => false
end

def guardians_student_fee
  #render :layout => false
  id=session[:user_id]
    @guardian=MgGuardian.find_by(:mg_user_id=>"#{id}")
    @sql = "SELECT S.first_name ,S.last_name,S.admission_number, S.id from mg_students S,mg_guardians G ,mg_student_guardians M Where M.has_login_access=1 And M.mg_guardians_id  = #{@guardian.id} And S.id = M.mg_student_id and G.id = M.mg_guardians_id"

    @StudentListQuery=MgStudent.find_by_sql(@sql)

end

def student_calender
  
end
  # "Public" ,"Public"],["Teacher" ,"Teacher"],["Admin","Admin"],["Guardian","Guardian"],["Student","Student"]]


def allevents
  mg_school_id=session[:current_user_school_id]
   from_date=Date.today();
        to_date=Date.today()+7;

   if request.xhr?
    if(params[:calenderType]=='Student')

            if session[:user_type]=='student'

            user=MgStudent.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id,:mg_user_id=>session[:user_id])

            event=MgInvitation.where(:student=>1, :is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>user.mg_batch_id).pluck(:mg_event_id)
            else
            event=MgInvitation.where(:student=>1, :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_event_id)

            end
            
            sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id  in(#{event.present? ? event.compact.map(&:inspect).join(', ') : 0})"


            @studentcalender=MgEvent.find_by_sql sql
            student_array = @studentcalender.as_json

            render :json=> student_array#, objArray

      elsif (params[:calenderType]=='Guardian')

            if session[:user_type]=='guardian'
            guardian=MgGuardian.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id,:mg_user_id=>session[:user_id]) 
            student_ids=MgStudentGuardian.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_guardians_id=>guardian.id).pluck(:mg_student_id)
            student=MgStudent.where(:is_deleted=>0, :mg_school_id=>mg_school_id,:id=>student_ids).pluck(:mg_batch_id)
            event=MgInvitation.where(:guardian=>1, :is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>student).pluck(:mg_event_id)
            else
            event=MgInvitation.where(:guardian=>1, :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_event_id)

            end
            sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id  in(#{event.present? ? event.compact.map(&:inspect).join(', ') : 0})"

            @studentcalender=MgEvent.find_by_sql sql
            student_array = @studentcalender.as_json

            
            render :json=> student_array#, objArray


      elsif (params[:calenderType]=='Employee')

            

            user=MgEmployee.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id], :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Non Teaching Staff").id))
            user_tech=MgEmployee.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id], :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Teaching Staff").id))

        if session[:user_type] !='employee'
              event=MgInvitation.where( :is_deleted=>0, :mg_school_id=>mg_school_id).where("teacher=1 or employee=1").pluck(:mg_event_id)
              puts event.inspect
              sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id in( #{event.present? ? event.compact.map(&:inspect).join(', ') : 0 })"
              @studentcalender=MgEvent.find_by_sql sql
        else
            if user[0].present?
              event=MgInvitation.where(:employee=>1, :is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>user[0].mg_employee_department_id).pluck(:mg_event_id)
              sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id in( #{event.present? ? event.compact.map(&:inspect).join(', ') : 0 })"
              @studentcalender=MgEvent.find_by_sql sql
            else
              event=MgInvitation.where(:teacher=>1, :is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>user_tech[0].mg_employee_department_id).pluck(:mg_event_id)
              # select mg_emg_invitation

               # sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',
               #  CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and (event_privacy='public' or event_privacy='teacher') and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
                  sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id in( #{event.present? ? event.compact.map(&:inspect).join(', ') : 0 })"

                @studentcalender=MgEvent.find_by_sql sql
                # @studentcalender=@studentcalender.find_by_id(event.present? ? event : [])
 # 
            end

        end
            student_array = @studentcalender.as_json

           
            render :json=> student_array#, objArray
            
      elsif (params[:calenderType]=='Admin')

        # sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',
        #     CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color', a.id  from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
           
                sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id}"


            @studentcalender=MgEvent.find_by_sql sql
            student_array = @studentcalender.as_json

            
            render :json=> student_array
      elsif (params[:calenderType]=='Principal_dashboard')
       
        # sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',
            # CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color', a.id  from mg_events a , mg_event_types b where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
           sql ="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start', CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s'))'end', b.event_color 'color', a.id  
from mg_events a , mg_event_types b where (a.event_date BETWEEN '#{from_date}' AND '#{to_date}') and  a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id}

"

            @studentcalender=MgEvent.find_by_sql sql
            student_array = @studentcalender.as_json

            
            render :json=> student_array
      elsif (params[:calenderType]=='Employee_dashboard')
        user=MgEmployee.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id], :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Non Teaching Staff").id))
            if user[0].present?
                # sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',
                # CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where (a.event_date BETWEEN '#{from_date}' AND '#{to_date}') and a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and (event_privacy='public' or event_privacy='employee') and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
                sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b, mg_event_privacies c where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id  in(SELECT c.mg_event_id FROM mg_event_privacies where c.privacy='employee' and c.is_deleted=0 and c.mg_school_id=#{mg_school_id})"
                
                @studentcalender=MgEvent.find_by_sql sql
            else
               # sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',
               #  CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where (a.event_date BETWEEN '#{from_date}' AND '#{to_date}') and a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and (event_privacy='public' or event_privacy='teacher') and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
                
                  sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b, mg_event_privacies c where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id  in(SELECT c.mg_event_id FROM mg_event_privacies where c.privacy='teacher' and c.is_deleted=0 and c.mg_school_id=#{mg_school_id})"


                @studentcalender=MgEvent.find_by_sql sql
            end
            student_array = @studentcalender.as_json

           
            render :json=> student_array
      elsif(params[:calenderType]=='Student_dashboard')

    
            # sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',
            # CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where (a.event_date BETWEEN '#{from_date}' AND '#{to_date}') and a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and (event_privacy='public' or event_privacy='student') and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
                sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b, mg_event_privacies c where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id  in(SELECT c.mg_event_id FROM mg_event_privacies where c.privacy='student' and c.is_deleted=0 and c.mg_school_id=#{mg_school_id})"
            
            @studentcalender=MgEvent.find_by_sql sql
            student_array = @studentcalender.as_json

            render :json=> student_array

       elsif (params[:calenderType]=='Guardian_dashboard')
            # sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',
            # CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b where (a.event_date BETWEEN '#{from_date}' AND '#{to_date}') and a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and (event_privacy='public' or event_privacy='guardian' or event_privacy='student')and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
            sql="select a.title, CONCAT(a.event_date,'T', DATE_FORMAT(a.start_time,'%H:%m:%s')) 'start',CONCAT(a.end_date,'T', DATE_FORMAT(end_time,'%H:%m:%s')) 'end', b.event_color 'color' , a.id from mg_events a , mg_event_types b, mg_event_privacies c where a.mg_event_type_id=b.id and a.is_deleted=0 and b.is_deleted=0 and  a.mg_school_id=#{mg_school_id} and b.mg_school_id=#{mg_school_id} and a.id  in(SELECT c.mg_event_id FROM mg_event_privacies where (c.privacy='student' or c.privacy='guardian') and c.is_deleted=0 and c.mg_school_id=#{mg_school_id})"
            
            @studentcalender=MgEvent.find_by_sql sql
            student_array = @studentcalender.as_json

            
            render :json=> student_array

      else
        
      end


    end
    
end
def file_upload
  id=session[:user_id]
  @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
  @document_managements = MgDocumentManagement.where(:is_deleted=>0, :mg_employee_id=>@employee[0], :mg_school_id => session[:current_user_school_id])
  
end 

def guardian_student_results
  guardian_id=MgGuardian.where(:mg_user_id=>session[:user_id]).pluck(:id)
  puts "Guardian ID==="
  puts guardian_id
  @students_list=MgStudentGuardian.where(:mg_guardians_id=>guardian_id[0],:has_login_access=>1)
  puts "Student List"
  puts @students_list.inspect
end


private
def password_params
    params.require(:guardian).permit(:password)
    
  end

def file_upload_new
    @document_managements = MgDocumentManagement.new
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
  render :layout => false
end

  def password_param
    params.require(:student).permit(:password)
    
  end


  def password_par
    params.require(:employee).permit(:password)
    
  end

  def password_pa
    params.require(:principle).permit(:password)
    
  end



#end

def file_upload_create
 require 'mime/types'

   @document_managements = MgDocumentManagement.new(document_managements_params)

    if @document_managements.save
      redirect_to action: 'file_upload'#, notice: 'User was successfully created.'
    else
      render action: 'file_upload'#, alert: 'User could not be created' 
    end
  
end

def file_upload_edit
  
  
end

def file_upload_delete
  @document_managements=MgDocumentManagement.find_by_id(params[:id])
      @document_managements.is_deleted =1
      @document_managements.save
      redirect_to action: 'file_upload'#, notice: 'User was successfully created.'
end

 def principal_employee_calender
    
end

def principal_student_calender
  
end

def principal_guardian_calender
  
end

def new_folder
   @document_managements = MgDocumentManagement.new
    # @folder=MgEmployeeFolder.new
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
    render :layout => false
 
  
end

def create_folder
  @file=params[:document_managements]

  # dir = File.dirname("#{Rails.root}/public/#{@file[:name]}/abc.txt")
  # FileUtils.mkdir_p(dir) unless File.directory?(dir)
  # redirect_to action: 'file_upload'#, notice: 'User was successfully created.'
end
    




private
    # def employee_folder_params
      
    # end
    # Never trust parameters from the scary internet, only allow the white list through.
    def document_managements_params
      params.require(:document_managements).permit(:name, :file, :mg_employee_id, :is_deleted, :mg_school_id)
    end



end
