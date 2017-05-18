class SportsManagementController < ApplicationController

  layout "mindcom"
    before_filter :login_required


def event_list
   
    mg_school_id=session[:current_user_school_id]
    @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>params[:id])#.pluck( :title, :id)
    # render :layout => false
    respond_to do |format|
          format.json  { render :json => @events }
      end
  end
def participant_team_list
      # MgSportTeam.where(:is_deleted)
      @course_list = MgSportTeam.where(:is_deleted=>0, :mg_sport_game_id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
      respond_to do |format|
      format.json  { render :json => @course_list }
      end
  end
  def event_list_dates
        @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])

    if params[:value_data]=="data"


      @data=params[:value_data1]
    else
      @data=0
    end
    mg_school_id=session[:current_user_school_id]
    @events=MgEvent.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>params[:id])#.pluck( :title, :id)
    @events_data=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>params[:id]).pluck( :title, :id)
    puts @events.inspect
    start_date=@events.event_date
    end_date=@events.end_date
    @no_of_days=end_date-start_date
    puts @no_of_days
    @date=Array.new
    #.strftime(@timeformat.date_format)
    for i in 0..@no_of_days
          @date1=Array.new
          
          date=@events.event_date+i
          @date1.push(date.strftime(@timeformat.date_format),date)
          @date.push(@date1)

    end
puts @date.inspect
puts @events_data
render :layout=>false
#puts ajsdga
    # render :layout => false
    # respond_to do |format|
    #       format.json  { render :json => @events }
    #   end
  end


    def results

      @results=MgSportsResult.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)

    end

    def results_new
          @events=[]

    mg_school_id=session[:current_user_school_id]
    # @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck( :title, :id)
    @event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name, :id )
    params[:mg_event_id]=params[:mg_event_id]
      if params[:mg_event_id].present?
        events=MgEvent.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :id=>params[:mg_event_id])
        params[:mg_event_committee_id]=events.mg_event_committee_id
        @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>events.mg_event_committee_id).pluck(:title, :id)
    end
      render :layout => false

    end

    def results_edit
          @events=[]
          puts "====================ajgsdghada"
        @results=MgSportsResult.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        puts @results.inspect
    mg_school_id=session[:current_user_school_id]
    # @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck( :title, :id)
    @event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name, :id )
    params[:mg_event_id]=params[:mg_event_id]
      if params[:mg_event_id].present?
        events=MgEvent.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :id=>params[:mg_event_id])
        params[:mg_event_committee_id]=events.mg_event_committee_id
        @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>events.mg_event_committee_id).pluck(:title, :id)
    end

    end

def add_student_to_result
      mg_school_id=session[:current_user_school_id]
      student_id=MgSportTeamStudent.where(:mg_sport_team_id=>params[:team_id],:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:mg_student_id)
      @student_list=MgStudent.where("is_deleted = ? and mg_school_id = ? and id IN (?)",0,session[:current_user_school_id],student_id).pluck(:first_name, :id)
      @studentsList=MgStudent.where("is_deleted = ? and mg_school_id = ? and id IN (?)",0,session[:current_user_school_id],student_id)
      @object=Array.new
      @studentsList.each do |s|
         @object1=Array.new
          @object1.push("(#{s.try(:admission_number)}) #{s.try(:first_name)} #{s.try(:last_name)} ","#{s.try(:id)}")
          @object.push(@object1)
       end
      render :layout => false
end

def result_sem_data
      puts params.inspect
      #puts ajkdgh
      mg_school_id=session[:current_user_school_id]
        course_list=MgCourse.where(:mg_wing_id=>params[:wing_id],:is_deleted=>0,:mg_school_id=>mg_school_id)
        course_list_id=MgCourse.where(:mg_wing_id=>params[:wing_id],:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:id)

        sect_list=MgBatch.where("is_deleted=? and mg_school_id=? and mg_course_id IN (?)",0,session[:current_user_school_id],course_list_id).order("mg_course_id")

          @object=Array.new
        
            sect_list.each do |s|
          @object1=Array.new

               course=MgCourse.find_by(:id=>s.mg_course_id)
              # str +="<option value='#{s.try(:id)}'>#{course.try(:course_name)} - #{s.try(:name)}</option>"
             @object1.push("#{course.try(:course_name)} - #{s.try(:name)}","#{s.try(:id)}")
            @object.push(@object1)
            end
          


           

      render :layout => false

    end

    def result_section_students
      @batchid=params[:stu_id]
      @studentsList=MgStudent.where(:mg_batch_id=>@batchid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @object=Array.new
      @studentsList.each do |s|
         @object1=Array.new
           # str +="<option value='#{s.try(:id)}'>(#{s.try(:admission_number)}) #{s.try(:first_name)} #{s.try(:last_name)}  </option>"
                  @object1.push("(#{s.try(:admission_number)}) #{s.try(:first_name)} #{s.try(:last_name)} ","#{s.try(:id)}")

                 @object.push(@object1)

       end
     
      render :layout => false

  end

 def add_employee_to_result
      mg_school_id=session[:current_user_school_id]
      employee_id=MgSportTeamEmployee.where(:mg_sport_team_id=>params[:team_id],:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:mg_employee_id)
      @employee_list=MgEmployee.where("is_deleted = ? and mg_school_id = ? and id IN (?)",0,session[:current_user_school_id],employee_id).pluck(:first_name, :id)
      @employeeslist=MgEmployee.where("is_deleted = ? and mg_school_id = ? and id IN (?)",0,session[:current_user_school_id],employee_id)
      @object=Array.new
      @employeeslist.each do |s|
         @object1=Array.new
          @object1.push("(#{s.try(:employee_number)}) #{s.try(:first_name)} #{s.try(:last_name)} ","#{s.try(:id)}")
          @object.push(@object1)
       end
      render :layout => false
end

  def result_emp_data

      mg_school_id=session[:current_user_school_id]
      employee_list=MgEmployee.where("is_deleted=? and mg_school_id=? and mg_employee_department_id IN (?)",0,session[:current_user_school_id],params[:wing_id])
     @object=Array.new

            employee_list.each do |s|
             # str +="<option value='#{s.try(:id)}'> (#{s.try(:employee_number)}) #{s.try(:first_name)}  #{s.try(:last_name)}</option>"
        @object1=Array.new
              
                  @object1.push("(#{s.try(:employee_number)}) #{s.try(:first_name)}  #{s.try(:last_name)}","#{s.try(:id)}")

                 @object.push(@object1)

            end
         # @object=str

      # respond_to do |format|
      #         format.json  { render :json => {main: @object, sub: ""} }
      #     end 
      render :layout => false
     
    end
def result_create
  # puts "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
  # puts params
  # puts "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
  # puts sasda
  #puts params.inspect
 # puts jsdjad
if params[:data_to_be_saved]=="demo"
 @timeformat = MgSchool.find(session[:current_user_school_id]).date_format

sports_data=MgSportsResult.new
sports_data.mg_event_committee_id=params[:mg_committee_id]
sports_data.mg_event_id=params[:mg_event_id]
sports_data.date_of_event=params[:date_of_event_Data]
sports_data.mg_sport_game_id=params[:game]
sports_data.updated_by=session[:user_id]
sports_data.created_by=session[:user_id]
sports_data.is_deleted=0
sports_data.sport_type="individual"
sports_data.mg_school_id=session[:current_user_school_id]
sports_data.mg_sport_team_id=params[:mg_sport_team_id]
sports_data.save
if params[:fst_place]!=""
arr_data=params[:fst_place].split(",")
if arr_data[1]=="student"

sport_student=MgSportStudentDataResult.new
sport_student.rank="1st rank"
sport_student.mg_sports_result_id=sports_data.id
sport_student.mg_students_id=arr_data[0]
sport_student.mg_students_id=arr_data[0]
sport_student.mg_sports_team_id=params[:mg_sport_team_id][0]

sport_student.updated_by=session[:user_id]
sport_student.created_by=session[:user_id]
sport_student.is_deleted=0
sport_student.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?
sport_student.save
end
  else

sport_employee=MgSportEmployeeDataResult.new
sport_employee.mg_sports_result_id=sports_data.id
sport_employee.rank="1st rank"
sport_employee.mg_employee_id=arr_data[0]
sport_employee.mg_sports_team_id=params[:mg_sport_team_id][0]

sport_employee.updated_by=session[:user_id]
sport_employee.created_by=session[:user_id]
sport_employee.is_deleted=0
sport_employee.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?
sport_employee.save
end
  end
end

if params[:snd_place]!=""
arr_data=params[:snd_place].split(",")
if arr_data[1]=="student"
sport_student=MgSportStudentDataResult.new
sport_student.rank="2nd rank"
sport_student.mg_sports_result_id=sports_data.id
sport_student.mg_students_id=arr_data[0]
sport_student.mg_sports_team_id=params[:mg_sport_team_id][1]

sport_student.updated_by=session[:user_id]
sport_student.created_by=session[:user_id]
sport_student.is_deleted=0
sport_student.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?
sport_student.save
end
else
sport_employee=MgSportEmployeeDataResult.new
sport_employee.mg_sports_result_id=sports_data.id
sport_employee.rank="2nd rank"

sport_employee.mg_employee_id=arr_data[0]
sport_employee.mg_sports_team_id=params[:mg_sport_team_id][1]

sport_employee.updated_by=session[:user_id]
sport_employee.created_by=session[:user_id]
sport_employee.is_deleted=0
sport_employee.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?
sport_employee.save
end
end
end
if params[:trd_place]!=""
arr_data=params[:trd_place].split(",")
if arr_data[1]=="student"
sport_student=MgSportStudentDataResult.new
sport_student.rank="3rd rank"
sport_student.mg_sports_result_id=sports_data.id
sport_student.mg_students_id=arr_data[0]
sport_student.mg_sports_team_id=params[:mg_sport_team_id][2]

sport_student.updated_by=session[:user_id]
sport_student.created_by=session[:user_id]
sport_student.is_deleted=0
sport_student.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?
sport_student.save
end
else
sport_employee=MgSportEmployeeDataResult.new
sport_employee.mg_sports_result_id=sports_data.id
sport_employee.rank="3rd rank"

sport_employee.mg_employee_id=arr_data[0]
sport_employee.mg_sports_team_id=params[:mg_sport_team_id][2]

sport_employee.updated_by=session[:user_id]
sport_employee.created_by=session[:user_id]
sport_employee.is_deleted=0
sport_employee.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?
sport_employee.save
end
end
end
else
   @schedule=MgSportsResult.new
    @schedule.venue=params[:venue]
    @schedule.winner=params[:winner]
    @schedule.is_deleted=0
    @schedule.created_by=session[:user_id]
    @schedule.updated_by=session[:user_id]
    @schedule.mg_school_id=session[:current_user_school_id]

    @schedule.mg_sport_team_id1=params[:mg_sport_team_id1]
    @schedule.mg_sport_team_id2=params[:mg_sport_team_id2]
    @schedule.mg_sport_game_id=params[:mg_sport_game_id]
    @schedule.game_type=params[:game_type]
    @schedule.guest_team=params[:guest_team]
    @schedule.date_of_event=params[:date_of_event_Data]
    @schedule.mg_event_committee_id=params[:mg_committee_id]
    @schedule.mg_event_id=params[:mg_event_id]

@schedule.sport_type="group"


   # @timeformat = MgSchool.find(session[:current_user_school_id])
    #start_date = Date.strptime(params[:schedule][:start_date],@timeformat.date_format)
    #end_date = Date.strptime(params[:schedule][:end_date],@timeformat.date_format)
    #@schedule.start_date=start_date
    #@schedule.end_date=end_date

    if @schedule.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
  end
redirect_to :action=>"results"

end
def result_update
 # puts JASG
 # puts "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
 # puts params
 # puts "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
 # puts params[:mg_sport_team_id]
 # puts "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
 #puts qweqw

 @timeformat = MgSchool.find(session[:current_user_school_id]).date_format

sports_data=MgSportsResult.find_by(:id=>params[:id])
#sports_data=MgSportsResult.new
sports_data.mg_event_committee_id=params[:mg_committee_id]
sports_data.mg_event_id=params[:mg_event_id]
sports_data.date_of_event=params[:date_of_event_Data]
sports_data.mg_sport_game_id=params[:game]
sports_data.updated_by=session[:user_id]
sports_data.mg_sport_team_id=params[:mg_sport_team_id]
sports_data.save

sport_student=MgSportStudentDataResult.where(:mg_sports_result_id=>params[:id])
if sport_student.present?
sport_student.each do|data|
data.destroy

end

end

sport_employee=MgSportEmployeeDataResult.where(:mg_sports_result_id=>params[:id])

if sport_employee.present?
sport_employee.each do|data|
data.destroy

end

end

if params[:fst_place]!=""
arr_data=params[:fst_place].split(",")
if arr_data[1]=="student"

sport_student=MgSportStudentDataResult.new
sport_student.rank="1st rank"
sport_student.mg_sports_result_id=sports_data.id
sport_student.mg_students_id=arr_data[0]
sport_student.updated_by=session[:user_id]
sport_student.created_by=session[:user_id]
sport_student.mg_sports_team_id=params[:mg_sport_team_id][0]

sport_student.is_deleted=0
sport_student.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?

sport_student.save
end
  else

sport_employee=MgSportEmployeeDataResult.new
sport_employee.mg_sports_result_id=sports_data.id
sport_employee.rank="1st rank"
sport_employee.mg_employee_id=arr_data[0]
sport_employee.updated_by=session[:user_id]
sport_employee.created_by=session[:user_id]
sport_employee.mg_sports_team_id=params[:mg_sport_team_id][0]

sport_employee.is_deleted=0
sport_employee.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?

sport_employee.save
end
  end
end

if params[:snd_place]!=""
arr_data=params[:snd_place].split(",")
if arr_data[1]=="student"
sport_student=MgSportStudentDataResult.new
sport_student.rank="2nd rank"
sport_student.mg_sports_result_id=sports_data.id
sport_student.mg_students_id=arr_data[0]
sport_student.updated_by=session[:user_id]
sport_student.created_by=session[:user_id]
sport_student.mg_sports_team_id=params[:mg_sport_team_id][1]

sport_student.is_deleted=0
sport_student.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?

sport_student.save
end
else
sport_employee=MgSportEmployeeDataResult.new
sport_employee.mg_sports_result_id=sports_data.id
sport_employee.rank="2nd rank"

sport_employee.mg_employee_id=arr_data[0]
sport_employee.updated_by=session[:user_id]
sport_employee.created_by=session[:user_id]
sport_employee.mg_sports_team_id=params[:mg_sport_team_id][1]

sport_employee.is_deleted=0
sport_employee.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?

sport_employee.save
end
end
end
if params[:trd_place]!=""
arr_data=params[:trd_place].split(",")
if arr_data[1]=="student"
sport_student=MgSportStudentDataResult.new
sport_student.rank="3rd rank"
sport_student.mg_sports_result_id=sports_data.id
sport_student.mg_students_id=arr_data[0]
sport_student.updated_by=session[:user_id]
sport_student.created_by=session[:user_id]
sport_student.mg_sports_team_id=params[:mg_sport_team_id][2]
sport_student.is_deleted=0
sport_student.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?

sport_student.save
end
else
sport_employee=MgSportEmployeeDataResult.new
sport_employee.mg_sports_result_id=sports_data.id
sport_employee.rank="3rd rank"

sport_employee.mg_employee_id=arr_data[0]
sport_employee.updated_by=session[:user_id]
sport_employee.created_by=session[:user_id]
sport_employee.is_deleted=0
sport_employee.mg_sports_team_id=params[:mg_sport_team_id][2]
sport_employee.mg_school_id=session[:current_user_school_id]
if arr_data[0].present?

sport_employee.save
end
end
end
  
redirect_to :action=>"results"
end
def result_show
@events=[]
          puts "====================ajgsdghada"
        @results=MgSportsResult.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    mg_school_id=session[:current_user_school_id]
    # @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck( :title, :id)
    @event_committees=MgEventCommittee.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id,:id=>@results.mg_event_committee_id)
    @events=MgEvent.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id,:id=>@results.mg_event_id)

   

end

def result_delete
        @results=MgSportsResult.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @results.is_deleted=1
        @results.save
        student_data=MgSportStudentDataResult.where(:mg_sports_result_id=>@results.id)
        employee_data=MgSportEmployeeDataResult.where(:mg_sports_result_id=>@results.id)
          student_data.each do |data|
            data.is_deleted=1
            data.save
          end
          employee_data.each do |data|
            data.is_deleted=1
            data.save
          end
          
redirect_to :action=>"results"


  end








    
  def index
  end

  def sports_incharge_login_index
    @users=MgUser.where(:user_type=>"sports_incharge",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def new_user
    @action='new'
    parent_url = request.env['HTTP_REFERER']
    if parent_url!=nil  && (parent_url.include? "incharge")
      @user_type="sports_incharge"
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
      if params[:user][:user_type]=="sports_incharge"
        role=MgRole.find_by(:role_name=>"sports_incharge")
      end

      if role.present?
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


  def game
    @game=MgSportGame.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def game_new
    @action='new'
    render :layout=>false

  end

  def game_edit
    @action='edit'
    @game=MgSportGame.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    render :layout=>false
  end

  def game_show
    @game=MgSportGame.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    render :layout=>false
  end
  def game_create
    @game=MgSportGame.new(game_params)
    @game.game_type=params[:game_type]
    @game.activity_game_type=params[:activity_game_type]
    if @game.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"game"
  end
  def game_update
    @game=MgSportGame.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @game.update(game_update_params)
      @game.update(:game_type=>params[:game_type], :activity_game_type=>params[:activity_game_type])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"game"
  end
  def game_delete
     @game=MgSportGame.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @game.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"game"
  end




  # def bed_details
  #   @bed = MgBedDetail.where(:is_deleted=>0,:module_type=>"Sports",:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)

  #   #@bed = MgSportsBedDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  # end

  # def bed_details_new
  #   @action='new'
  #   @bed_detail = MgBedDetail.new
  #   render :layout=>false
  # end

  # def bed_details_create
  #   bed= MgBedDetail.new(bed_detail_params)
  #   bed.module_type="Sports"
  #   if bed.save
  #     flash[:notice] = "Successfully Created"
  #   else
  #     flash[:error] = "This Room Number is already Created"
  #   end
  #   redirect_to :action=>'bed_details'
  # end

  # def bed_details_show
  #   @bed = MgBedDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  #   render :layout=>false
  # end

  # def bed_details_edit
  #   @action='edit'
  #   @bed_detail = MgBedDetail.find_by(:id=>params[:id])
  #   render :layout=>false
  # end

  # def bed_details_update
  #   bed = MgBedDetail.find_by(:id=>params[:id])
  #   if bed.update(bed_detail_params)
  #     flash[:notice] = "Successfully Updated"
  #   else
  #     flash[:error] = "This Room Nnumber is already Created"
  #   end
  #   redirect_to :action=>'bed_details'
  # end

  # def bed_details_delete
  #   bed = MgBedDetail.find_by(:id=>params[:id])
  #   if bed.update(:is_deleted=>1,:updated_by=>session[:user_id])
  #     # assign_bed_details=MgSportsBedAssignment.where(:mg_sports_bed_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  #     # assign_bed_details.each do |assign_bed|
  #     #   assign_bed.update(:is_deleted=>1,:updated_by=>session[:user_id])
  #     #end
  #     flash[:notice] = "Successfully Deleted"
  #   else
  #     flash[:error] = "There is Some Problem"
  #   end
  #   redirect_to :action=>'bed_details'
  # end




def assign_bed
  if session[:user_type]=='doctor'
    @bed_assign_detail = MgBedAssignment.where(:mg_doctor_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  else
    @bed_assign_detail = MgBedAssignment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:module_type=>"Sports",:status=>"occupied").paginate(page: params[:page], per_page: 10)
  end
end

def new_assign_bed
  @action='new'
  @bed_assign_detail = MgBedAssignment.new
end

def bed_assigned_record
  @user_data=MgUser.find_by(:user_name=>params[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  if @user_data.present?
    if @user_data.user_type=="student"
      @student_data = MgStudent.find_by(:admission_number=>params[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    elsif (@user_data.user_type=="employee" || @user_data.user_type=="principal") || @user_data.user_type=="admin"
      @employee_data=MgEmployee.find_by(:employee_number=>params[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end
    render :layout=>false
  else
    @result='no_data'
    respond_to do |format|
      format.json  { render :json => @result.to_json }
    end
  end
end

def bed_availibility_details
  result = MgBedAssignment.where(:mg_bed_details_id=>params[:bed_details_id],:status=>"occupied",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  if result.present?
    @result="not present"
  else
    @result="present"
  end
  respond_to do |format|
    format.json  { render :json => @result.to_json }
  end
end

  # def bed_availibility
  #   test_obj=false
  #   @timeformat = MgSchool.find(session[:current_user_school_id])

  #   if params[:edit_action_url]=="edit_assign_bed"
  #     MgBedAssignment.transaction do
  #       if params[:admitted_date].present?
  #                 admitted_date = Date.strptime(params[:admitted_date],@timeformat.date_format)

  #       discharge_date = Date.strptime(params[:discharge_date],@timeformat.date_format)
  #    send_param=MgBedAssignment.myprm(admitted_date,discharge_date)
       
  #       @bed_assign_detail = MgBedAssignment.find_by(:id=>params[:edit_action_id])

  #       test_obj = @bed_assign_detail.update(:admitted_date=>admitted_date,:discharge_date=>discharge_date,:admitted_time=>params[:admitted_time],:discharge_time=>params[:discharge_time],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_bed_details_id=>params[:edit_action_bed_id])

  #       else
  #            test_obj=true
  #  end
  #       raise ActiveRecord::Rollback
  #     end
  #   else
  #     MgBedAssignment.transaction do
  #       admitted_date = Date.strptime(params[:admitted_date],@timeformat.date_format)
  #   discharge_date = Date.strptime(params[:discharge_date],@timeformat.date_format)
  #    send_param=MgBedAssignment.myprm(admitted_date,discharge_date)
   
  #       obj=MgBedAssignment.new
  #       obj.admitted_date=admitted_date
  #       obj.discharge_date=discharge_date
  #       obj.admitted_time=params[:admitted_time]
  #       obj.discharge_time=params[:discharge_time]
  #       obj.is_deleted=0
  #       obj.mg_school_id=session[:current_user_school_id]
  #       obj.mg_bed_details_id=params[:bed_id]
  #       test_obj=obj.save
  #       raise ActiveRecord::Rollback
  #     end
  #   end

  #   render :json=>{:test_result=>test_obj}
  # end

  def create_assign_bed
    user_obj = MgUser.find_by(:user_name=>params[:bed_assign_detail][:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    
    if user_obj.user_type=='student'
      student_obj=MgStudent.find_by(:admission_number=>params[:bed_assign_detail][:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      guardian_obj=MgGuardian.find_by(:mg_student_id=>student_obj.try(:id),:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      mg_user_id=guardian_obj.try(:mg_user_id)
      msg = "#{student_obj.admission_number}#{"-"} #{student_obj.first_name} #{student_obj.last_name} is suffering some Problem"
    elsif user_obj.user_type=='employee'
      mg_user_id=user_obj.id
      mg_emp_obj=MgEmployee.find_by(:employee_number=>params[:bed_assign_detail][:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      msg = "#{mg_emp_obj.first_name.capitalize} #{mg_emp_obj.last_name.capitalize} is suffering some Problem"
    end

    array=[]
    MgBedAssignment.transaction do
      bed_assign_detail= MgBedAssignment.new(bed_assign_details_params)
      bed_assign_detail.module_type="Sports"
      @timeformat = MgSchool.find(session[:current_user_school_id])
      admitted_date = Date.strptime(params[:bed_assign_detail][:admitted_date],@timeformat.date_format)
      # discharge_date = Date.strptime(params[:bed_assign_detail][:discharge_date],@timeformat.date_format)
      array.push(bed_assign_detail.save)
      if bed_assign_detail.save
        array.push(bed_assign_detail.update(:admitted_date=>admitted_date))
      end
      if array.include?(false) 
        raise ActiveRecord::Rollback 
      else
        if mg_user_id.present?
          send_email_create(mg_user_id,msg)
        end
      end 
    end

    if array.include?(false)
      flash[:error] = "There is Some Problem"
    else
      flash[:notice] = "Successfully Created"
    end
    redirect_to :action=>'assign_bed'
  end

  def show_assign_bed
    @bed_assign_detail = MgBedAssignment.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @date_format = MgSchool.find_by(:id=>session[:current_user_school_id]).date_format
    
    render :layout=>false
  end

  def edit_assign_bed
    @action='edit'
    @bed_assign_detail = MgBedAssignment.find_by(:id=>params[:id])
  end

  def update_assign_bed

    array=[]
    MgBedAssignment.transaction do
      bed_assign_detail = MgBedAssignment.find_by(:id=>params[:id])

      array.push(bed_assign_detail.update(update_bed_assign_details_params))
      @timeformat = MgSchool.find(session[:current_user_school_id])
      if params[:bed_assign_detail][:status]=="unoccupied"
        if params[:bed_assign_detail][:admitted_date].present? && params[:bed_assign_detail][:discharge_date].present?
          admitted_date = Date.strptime(params[:bed_assign_detail][:admitted_date],@timeformat.date_format)
          discharge_date = Date.strptime(params[:bed_assign_detail][:discharge_date],@timeformat.date_format)
          array.push(bed_assign_detail.update(:admitted_date=>admitted_date,:discharge_date=>discharge_date))
        end
      else
        admitted_date = Date.strptime(params[:bed_assign_detail][:admitted_date],@timeformat.date_format)
        array.push(bed_assign_detail.update(:admitted_date=>admitted_date,:discharge_date=>nil,:discharge_time=>nil))
      end

      if array.include?(false)
        raise ActiveRecord::Rollback 
      end
    end

    if array.include?(false)
      flash[:error] = "There is Some Problem"
    else
      flash[:notice] = "Successfully Updated"
    end
    redirect_to :action=>'assign_bed'
  end
 
  def delete_assign_bed
    bed_assign_detail = MgBedAssignment.find_by(:id=>params[:id])
    if bed_assign_detail.update(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice] = "Successfully Deleted"
    else
      flash[:error] = "There is Some Problem"
    end
    redirect_to :action=>'assign_bed'
  end


  def send_email_create(user, msg)
    #begin
      @email_from = MgEmail.where(:mg_user_id => session[:user_id])
      @message = Message.new
      @message.subject =  "Health Problem"
      @message.description =msg
      @email_to = MgEmail.where(:mg_user_id => user)
      
      if @email_to.present?
        to_user_id = @email_to[0][:mg_email_id ]
        if @email_from.present?
          from_user_id = @email_from[0][:mg_email_id ]
        else
          from_user_id = "abc@mindcomgroup.com"
        end
       # server_response = NotificationMailer.send_mail(@message).deliver!
         #begin
         notification=MgNotification.send_notification(session[:user_id],user,@message.subject,@message.description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
          notification.save
        MgNotification.send_email(from_user_id,to_user_id,@message.subject,@message.description,session[:current_user_school_id])
      
      #rescue Exception => e
       # puts e
      #end
      #:email_server_description => server_description(server_response.status) )
      else
        puts "Email id is not present"
      end
    
  end


def discipline_report_create
  MgHostelDisciplineReport.transaction do
    discipline_report=MgHostelDisciplineReport.new
    discipline_report.date_of_report=params[:discipline_report][:date_of_report]
    discipline_report.mg_hostel_details_id=params[:discipline_report][:hostel_id]
    discipline_report.reason=params[:discipline_report][:reason]
    discipline_report.action_to_be_taken=params[:discipline_report][:action_to_be_taken]
    discipline_report.status=params[:status]
    discipline_report.is_deleted=0
    discipline_report.mg_school_id=session[:current_user_school_id]
    discipline_report.created_by=session[:user_id]
    discipline_report.updated_by=session[:user_id]
    discipline_report.save
  if params[:selected_employees].present?
    params[:selected_employees].each do |data|
      discipline_report_list=MgHostelDisciplineReportList.new
      discipline_report_list.mg_student_id=data
      discipline_report_list.mg_hostel_discipline_report=discipline_report.id
      discipline_report_list.is_deleted=0
      discipline_report_list.mg_school_id=session[:current_user_school_id]
      discipline_report_list.created_by=session[:user_id]
      discipline_report_list.updated_by=session[:user_id]
      discipline_report_list.save

    end
  end

  end
redirect_to :action=>"discipline_report"
end
  def team
    @team=MgSportTeam.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end



# ==============================================================================================
  def team_list
      @team_list=MgSportTeam.where(:mg_sport_game_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#.pluck(:team_name,:id)
      # @course_list = MgCourse.where(:is_deleted=>0, :mg_wing_id=>params[:id], :mg_school_id=>session[:current_user_school_id])#.pluck(:id, :first_name)
      puts "======================================================================================================"
      puts @team_list.inspect
      puts "======================================================================================================"
      respond_to do |format|
      format.json  { render :json => @team_list }
      end
  end
# ==============================================================================================



  def team_new
    @action='new'

  end

  def team_edit
    @action='edit'
    @team=MgSportTeam.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
  end

  def team_show
    @team=MgSportTeam.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
  end
  def team_create
    
  MgSportTeam.transaction do
    @team=MgSportTeam.new(team_params)
    @team.game_type=params[:game_type]
    @team.mg_sport_game_id=params[:mg_sport_game_id]
    @team.team_of=params[:team_of]
    @team.save
  if params[:selected_students].present?
    params[:selected_students].each do |data|
      team_list=MgSportTeamStudent.new
      team_list.mg_student_id=data
      team_list.mg_sport_team_id=@team.id
      team_list.is_deleted=0
      team_list.mg_school_id=session[:current_user_school_id]
      team_list.created_by=session[:user_id]
      team_list.updated_by=session[:user_id]
      team_list.save

    end
  end

  if params[:selected_employees].present?
    params[:selected_employees].each do |data|
      team_list=MgSportTeamEmployee.new
      team_list.mg_employee_id=data
      team_list.mg_sport_team_id=@team.id
      team_list.is_deleted=0
      team_list.mg_school_id=session[:current_user_school_id]
      team_list.created_by=session[:user_id]
      team_list.updated_by=session[:user_id]
      team_list.save
    end
  end



  end

    if @team.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"team"
  end

  # begin
  #     MgCheckupType.transaction do
        
        

  #     end
  #     flash[:notice]= "Checkup Type saved successfully"
  #   rescue Exception => e
  #     flash[:error]="Error Occured please check duplicate name"
  #     puts e
  #   end
  
def team_update
    puts params[:selected_students].inspect
    puts params[:selected_employees].inspect
    #puts asdhggasf
begin

  MgSportTeam.transaction do
        @team=MgSportTeam.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
        @team.update(team_params_update)
        @team.update(:game_type=>params[:game_type])
        @team.update(:mg_sport_game_id=>params[:mg_sport_game_id])
        @team.update(:team_of=>params[:team_of])

        student_list=MgSportTeamStudent.where(:mg_sport_team_id=>@team.id)
        employee_list=MgSportTeamEmployee.where(:mg_sport_team_id=>@team.id)

        student_list.each do |data|
           data.update(:is_deleted=>1)
        end

        employee_list.each do |data|
           data.update(:is_deleted=>1)
        end
      
      if params[:team_of]=="student"  || params[:team_of]=="both"
        if params[:selected_students].present?
          params[:selected_students].each do |data|
            team_list=MgSportTeamStudent.new
            team_list.mg_student_id=data
            team_list.mg_sport_team_id=@team.id
            team_list.is_deleted=0
            team_list.mg_school_id=session[:current_user_school_id]
            team_list.created_by=session[:user_id]
            team_list.updated_by=session[:user_id]
            team_list.save
          end
      end
    end
       if params[:team_of]=="employee"  || params[:team_of]=="both"
      if params[:selected_employees].present?
        params[:selected_employees].each do |data|
          team_list=MgSportTeamEmployee.new
          team_list.mg_employee_id=data
          team_list.mg_sport_team_id=@team.id
          team_list.is_deleted=0
          team_list.mg_school_id=session[:current_user_school_id]
          team_list.created_by=session[:user_id]
          team_list.updated_by=session[:user_id]
          team_list.save
        end
      end
end
  end


    flash[:notice]= "Your request processed successfully"
    rescue Exception => e
      flash[:error]="Your  request processed unsuccessfully"
      puts e
    end

    redirect_to :action=>"team"
  end


  def team_delete
     @team=MgSportTeam.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @team.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"team"
  end


  def game_data
      @game = MgSportGame.where(:game_type=>params[:game_type],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)    
      if params[:schedule_edit].present?
        @game_data=MgSportsResult.find_by(:id=>params[:id],:game_type=>params[:game_type],:mg_sport_game_id=>params[:game_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        elsif params[:data]=="edit"
        @game_data=MgSportTeam.find_by(:id=>params[:Pid],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       
        else
        @game_data=MgSportTeam.find_by(:game_type=>params[:game_type],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        puts @game_data.inspect
        puts  params[:data].inspect
        puts "=======================================================sasadads==============="
        puts params.inspect
        puts params[:game_type]
        #puts asjdgjagsdj
      end


       render :layout=>false

  end


  def team_data
      @team = MgSportTeam.where(:game_type=>params[:game_type],:mg_sport_game_id=>params[:game_name],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:team_name,:id)    
    if params[:edit]=="data123"

@data1=params[:team_id1]
@data2=params[:team_id2]


    else

@data1=0
@data2=0


    end      
      puts @team.inspect
       render :layout=>false

  end

  def outdoor_data
     @team = MgSportTeam.where(:game_type=>params[:game_type],:mg_sport_game_id=>params[:game_name],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:team_name,:id)    
        if params[:edit]=="data009"

@data1=params[:team_id1]
@data2=params[:guest_team]


    else

@data1=0
@data2=""


    end      

       render :layout=>false
  end


  
    def add_employee_to_team
      mg_school_id=session[:current_user_school_id]
      @departments=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:department_name, :id)
      render :layout => false
    end
    def add_student_to_team
      mg_school_id=session[:current_user_school_id]
      @prgm_list=MgWing.where(:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:wing_name, :id)
      render :layout => false
    end

    def sem_data
      puts params.inspect
      #puts ajkdgh
      mg_school_id=session[:current_user_school_id]
        course_list=MgCourse.where(:mg_wing_id=>params[:wing_id],:is_deleted=>0,:mg_school_id=>mg_school_id)
        course_list_id=MgCourse.where(:mg_wing_id=>params[:wing_id],:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:id)

        sect_list=MgBatch.where("is_deleted=? and mg_school_id=? and mg_course_id IN (?)",0,session[:current_user_school_id],course_list_id).order("mg_course_id")
        
        str=""
            sect_list.each do |s|
              course=MgBatch.where(s.mg_course_id)
              str +="<option value='#{s.try(:id)}'>#{s.try(:course_name)} - #{s.try(:name)}</option>"
            end
          @object=str

      respond_to do |format|
              format.json  { render :json => {main: @object, sub: ""} }
          end 


    end

    def students_name_data
      if params[:data].present?
       
        student_data=MgSportTeamStudent.where(:mg_sport_team_id=>params[:team_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        str=""
        student_data.each do |s|
            name=MgStudent.find_by(:id=>s.mg_student_id)
            str +="<option value='#{s.try(:mg_student_id)}'>(#{name.try(:admission_number)}) #{name.try(:first_name)} #{name.try(:last_name)}  </option>"
        end

        @object=str
        respond_to do |format|
            format.json  { render :json => {main: @object, sub: ""} }
        end 
    end
  end


  def section_students
      @batchid=params[:stu_id]
      @studentsList=MgStudent.where(:mg_batch_id=>@batchid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      str=""
      @studentsList.each do |s|
            str +="<option value='#{s.try(:id)}'>(#{s.try(:admission_number)}) #{s.try(:first_name)} #{s.try(:last_name)}  </option>"
      end
      @object=str
      respond_to do |format|
            format.json  { render :json => {main: @object, sub: ""} }
      end 

  end

  def emp_name_data
      if params[:data].present?
        puts params.inspect
        student_data=MgSportTeamEmployee.where(:mg_sport_team_id=>params[:team_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        str=""
        student_data.each do |s|
            name=MgEmployee.find_by(:id=>s.mg_employee_id)
            str +="<option value='#{s.try(:mg_employee_id)}'>(#{name.try(:employee_number)}) #{name.try(:first_name)} #{name.try(:last_name)}  </option>"
        end
        @object=str
        puts str
        respond_to do |format|
              format.json  { render :json => {main: @object, sub: ""} }
        end
  end
end

  def emp_data

      mg_school_id=session[:current_user_school_id]
      employee_list=MgEmployee.where("is_deleted=? and mg_school_id=? and mg_employee_department_id IN (?)",0,session[:current_user_school_id],params[:wing_id])
      str=""
            employee_list.each do |s|
              str +="<option value='#{s.try(:id)}'> (#{s.try(:employee_number)}) #{s.try(:first_name)}  #{s.try(:last_name)}</option>"
            end
          @object=str

      respond_to do |format|
              format.json  { render :json => {main: @object, sub: ""} }
          end 
     
    end


  def schedule
    @schedule=MgSportsResult.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def schedule_new
    @action='new'
@events=[]

    mg_school_id=session[:current_user_school_id]
    # @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck( :title, :id)
    @event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name, :id )
    params[:mg_event_id]=params[:mg_event_id]
      if params[:mg_event_id].present?
        events=MgEvent.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :id=>params[:mg_event_id])
        params[:mg_event_committee_id]=events.mg_event_committee_id
        @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>events.mg_event_committee_id).pluck(:title, :id)
    end
    render :layout=>false
  end

  def schedule_edit
    @action='edit'
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @schedule=MgSportsResult.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params[:id])
  
    @events=[]

    mg_school_id=session[:current_user_school_id]
    # @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck( :title, :id)
    @event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name, :id )
    params[:mg_event_id]=params[:mg_event_id]
      if params[:mg_event_id].present?
        events=MgEvent.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :id=>params[:mg_event_id])
        params[:mg_event_committee_id]=events.mg_event_committee_id
        @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>events.mg_event_committee_id).pluck(:title, :id)
    end
  end

  def schedule_show
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @schedule=MgSportsResult.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
  end
  def schedule_create
   
    #@schedule=MgSportSchedule.new(schedule_params)
    @schedule=MgSportsResult.new(schedule_params)
    @schedule.mg_sport_team_id1=params[:mg_sport_team_id1]
    @schedule.mg_sport_team_id2=params[:mg_sport_team_id2]
    @schedule.mg_sport_game_id=params[:mg_sport_game_id]
    @schedule.game_type=params[:game_type]
    @schedule.guest_team=params[:guest_team]
    @schedule.date_of_event=params[:date_of_event_Data]
    @schedule.mg_event_committee_id=params[:mg_committee_id]
    @schedule.mg_event_id=params[:mg_event_id]

@schedule.sport_type="group"


   # @timeformat = MgSchool.find(session[:current_user_school_id])
    #start_date = Date.strptime(params[:schedule][:start_date],@timeformat.date_format)
    #end_date = Date.strptime(params[:schedule][:end_date],@timeformat.date_format)
    #@schedule.start_date=start_date
    #@schedule.end_date=end_date

    if @schedule.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"results"
  end
  def schedule_update
   # puts ajsdghd
    @schedule=MgSportsResult.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    
    @schedule.mg_sport_team_id1=params[:mg_sport_team_id1]
    @schedule.mg_sport_team_id2=params[:mg_sport_team_id2]
    @schedule.mg_sport_game_id=params[:mg_sport_game_id]
    @schedule.game_type=params[:game_type]
    @schedule.guest_team=params[:guest_team]
    @schedule.date_of_event=params[:date_of_event_Data]
    @schedule.mg_event_committee_id=params[:mg_committee_id]
    @schedule.mg_event_id=params[:mg_event_id]
    @schedule.winner=params[:schedule][:winner]
    @schedule.venue=params[:schedule][:venue]



    if @schedule.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"results"
  end
  def schedule_delete
     @schedule=MgSportSchedule.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @schedule.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"schedule"
  end



#=================================Pranow Works Start==========================================================================
def disciplinary_action
    if session[:user_type]=="employee"
        puts "========================================================="
        employee_id=MgEmployee.find_by(:mg_user_id=>session[:user_id])
        puts employee_id.try(:id)
        batches=MgBatch.find_by(:mg_employee_id=>employee_id.try(:id))
        puts "---------------------------------------------------------"
        puts batches.try(:id)
        @discipline_data=MgDisciplinaryAction.where(:mg_batches_id=>batches.try(:id),:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    
        puts "========================================================="
    else
        @discipline_data=MgDisciplinaryAction.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    end
    end

    def disciplinary_action_new
      @action= 'new'
      
    end

    def disciplinary_action_create
      MgDisciplinaryAction.transaction do

        @discipline_data=MgDisciplinaryAction.new(disciplinary_action_params)
        @discipline_data.mg_batches_id=params[:batches_id]
       
         if @discipline_data.save
          
           if params[:transportSelectedStudents].present?
            student_list=params[:transportSelectedStudents]
            student_list.each do |student_id|
        student_data=MgDisciplinaryActionStudent.new
        student_data.mg_disciplinary_action_id=@discipline_data.id
        student_data.is_deleted=0
        student_data.mg_school_id=session[:current_user_school_id]
        student_data.created_by=session[:user_id]
        student_data.updated_by=session[:user_id]
        student_data.mg_student_id=student_id
        student_data.save
           end
          end
         end
       end
       redirect_to :action=>"disciplinary_action"
    end

    def disciplinary_action_show
       @discipline_data=MgDisciplinaryAction.find_by_id(params[:id])
       @student_data=MgDisciplinaryActionStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_disciplinary_action_id=>params[:id])
    end

    def disciplinary_action_edit
       @action= 'edit'
       @discipline_data=MgDisciplinaryAction.find_by_id(params[:id])
       @student_data=MgDisciplinaryActionStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_disciplinary_action_id=>params[:id]).pluck(:mg_student_id)
      
       @course_data_val=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>@discipline_data.mg_wing_id).pluck(:id)
     @course_datass=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@course_data_val)
      puts @course_data_val.inspect
      puts @course_datass.inspect


     @course_data=Array.new
     @course_datass.each do |data|
      course_data_val1=MgCourse.find_by(:id=>data.mg_course_id)

      @data=Array.new
      @data.push("#{course_data_val1.course_name}-#{data.name}",data.id)
      @course_data.push(@data)
     end

     puts params.inspect
    @students_data=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>@discipline_data.mg_batches_id).where("id NOT in (?)",@student_data)
    @students=Array.new
     @students_data.each do |data|
      @data=Array.new
      @data.push("(#{data.admission_number})#{data.first_name} #{data.last_name}",data.id)
      @students.push(@data)
     end
     puts params.inspect
    @students_data=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>@student_data)
    @students_dat=Array.new
     @students_data.each do |data|
      @data=Array.new
      @data.push("(#{data.admission_number})#{data.first_name} #{data.last_name}",data.id)
      @students_dat.push(@data)
     end
        #@course_data=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
        #@batch_data=MgDisciplinaryAction.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        
    end

    def disciplinary_action_update
      
       

        @discipline_data=MgDisciplinaryAction.find(params[:id])
        @discipline_data.remark=params[:discipline_form][:remark]
        @discipline_data.status=params[:discipline_form][:status]
        @discipline_data.subject=params[:discipline_form][:subject]
         if  params[:discipline_form][:action_taken].present?
        @discipline_data.action_taken=params[:discipline_form][:action_taken]
        end

        
        @discipline_data.save
        @discipline_data_rep=MgDisciplinaryActionStudent.where(:mg_disciplinary_action_id=>params[:id])
        @discipline_data_rep.each do |data|
          data.destroy
        end
             student_list=params[:transportSelectedStudents]
            student_list.each do |student_id|
        student_data=MgDisciplinaryActionStudent.new
        student_data.mg_disciplinary_action_id=@discipline_data.id
        student_data.is_deleted=0
        student_data.mg_school_id=session[:current_user_school_id]
        student_data.created_by=session[:user_id]
        student_data.updated_by=session[:user_id]
        student_data.mg_student_id=student_id
        student_data.save
           end
          
       
          
         
       
       redirect_to :action=>"disciplinary_action"
    end

    def disciplinary_action_delete
      discipline_data=MgDisciplinaryAction.find(params[:id])
      discipline_data.update(:is_deleted=>1)
      redirect_to :action=>"disciplinary_action"
    end
    ###########################
def hod_disciplinary_action_index
 @discipline_data=MgDisciplinaryAction.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10) 
end

def hod_disciplinary_action_show
  @discipline_data=MgDisciplinaryAction.find_by_id(params[:id])
  @student_data=MgDisciplinaryActionStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_disciplinary_action_id=>params[:id])
end

def hod_disciplinary_action_update
  @discipline_data=MgDisciplinaryAction.find_by_id(params[:id])
  @student_data=MgDisciplinaryActionStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_disciplinary_action_id=>params[:id]).pluck(:mg_student_id)
  @discipline_data.status=params[:status]
  @discipline_data.action_taken=params[:act_data]
  @discipline_data.save

  redirect_to :action=>"hod_disciplinary_action_index"
end
#############
    def wing_wise_course_list
      #puts asjdgh
      
      puts @course_data.inspect

      if params[:method]=="edit"
        @course_data_val=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:mg_wing_id]).pluck(:id)
     @course_datass=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@course_data_val)
      puts @course_data_val.inspect
      puts @course_datass.inspect


     @course_data=Array.new
     @course_datass.each do |data|
      course_data_val1=MgCourse.find_by(:id=>data.mg_course_id)

      @data=Array.new
      @data.push("#{course_data_val1.course_name}-#{data.name}",data.id)
      @course_data.push(@data)
     end

    @batch_data=MgDisciplinaryAction.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       

       else
     @course_data_val=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:mg_wing_id]).pluck(:id)
     @course_datass=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@course_data_val)
      puts @course_data_val.inspect
      puts @course_datass.inspect


     @course_data=Array.new
     @course_datass.each do |data|
      course_data_val1=MgCourse.find_by(:id=>data.mg_course_id)

      @data=Array.new
      @data.push("#{course_data_val1.course_name}-#{data.name}",data.id)
      @course_data.push(@data)
     end

       end
     render :layout=>false
    end
################
    def department_wise_employee_list
     @employees=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>params[:mg_department_id])
     render :layout=>false
    end

   # def batch_wise_student_list
   #  puts params.inspect
   #  @students_data=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>params[:mg_batches_id])
   #  @students=Array.new
   #   @students_data.each do |data|
   #    @data=Array.new
   #    @data.push("(#{data.admission_number})#{data.first_name} #{data.last_name}",data.id)
   #    @students.push(@data)
   #   end
   #  puts @students.inspect


   #  render :layout=>false
   # end
   # def course_wise_batch_list
   #   @course=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:mg_wing_id])
   #   @course_data=MgCourse.where(:id=>@course)
   #   render :layout=>false
   # end

 

  def generate_fine
    #@sports_fine=MgSportsFine.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    @fineparticular=MgFeeFineParticular.where("is_deleted=? and mg_school_id=? and fine_from=?",0,session[:current_user_school_id],"Sports").paginate(page: params[:page], per_page: 5)

  end

  def generate_fine_new
     @action= 'new'
mg_school_id=session[:current_user_school_id]
      @prgm_list=MgWing.where(:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:wing_name, :id)
  end

  def generate_fine_create
    @params=params[:selected_students]
      for i in 0...@params.size
       puts"inside if save particular"
       @feeParticularObj=MgFeeFineParticular.new(fine_particular_params) 
       @feeParticularObj.fine_from="Sports"
       @data=MgStudent.find(@params[i])
       @batchID=@data.mg_batch_id
        @feeParticularObj.mg_batch_id=@batchID
        @feeParticularObj.mg_student_id= @data.id
       @current_school_obj = MgSchool.find(session[:current_user_school_id])
       @startDate = Date.strptime(params[:generate_fine][:start_date],@current_school_obj.date_format)
        @endDate = Date.strptime(params[:generate_fine][:end_date],@current_school_obj.date_format)
        @dueDate = Date.strptime(params[:generate_fine][:due_date],@current_school_obj.date_format)
       @feeParticularObj.start_date=@startDate
        @feeParticularObj.end_date=@endDate
        @feeParticularObj.due_date=@dueDate
        if params[:generate_fine][:mg_account_id].present?
          if params[:generate_fine][:mg_account_id]=="central"
            @feeParticularObj.is_to_central=1
          else
            @feeParticularObj.mg_account_id=params[:generate_fine][:mg_account_id]
          end
        end
       @feeParticularObj.save
     end
        redirect_to :action=>"generate_fine"
      end
  
  def generate_fine_edit
    @action= 'edit'
    @sports_fine=MgSportsFine.find_by_id(params[:id])
    @student_data=MgSportsFineStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_sports_fine_id=>params[:id])
    @student_ids=MgSportsFineStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_sports_fine_id=>params[:id]).pluck(:mg_student_id)
  end

  def generate_fine_update
    MgSportsFine.transaction do
     @sports_fine=MgSportsFine.find(params[:id])
      if @sports_fine.update(generate_fine_params)
          
         if params[:studentIds].present?
          student_list=params[:studentIds]
          student_list.each do |student_id|
          
        student_data=MgSportsFineStudent.new
        student_data.mg_sports_fine_id=@sports_fine.id
        student_data.mg_student_id=student_id
        student_data.mg_school_id=session[:current_user_school_id]
        student_data.is_deleted=0
        
        student_data.updated_by=session[:user_id]
        student_data.save
           end
          end
         end
        end
        redirect_to :action=>"generate_fine"
      end
   
  def generate_fine_show
    @sports_fine=MgSportsFine.find_by_id(params[:id])
    @student_data=MgSportsFineStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_sports_fine_id=>params[:id])
  end

  def generate_fine_delete
    sports_fine=MgSportsFine.find(params[:id])
    sports_fine.update(:is_deleted=>1)
    redirect_to :action=>"generate_fine"
  end
 def edit_fine_fee_particular
  @fesses2 = MgFeeFineParticular.find(params[:id])
  
  @cceID=Array.new
  
    
     @cceID.push(@fesses2.mg_batch_id)

    render :layout => false
end

def show_fine_fee_particular
    @fine_particular = MgFeeFineParticular.find(params[:id])
    render :layout => false
  end

  def destroy_fee_fine_particular
    @fees=MgFeeFineParticular.find_by_id(params[:id])
    @fees.is_deleted =1
    @fees.save
 redirect_to :action=>"generate_fine"  end
 def update_fee_fine_particular
   @feeParticularObj = MgFeeFineParticular.find(params[:id])
   @timeformat = MgSchool.find(session[:current_user_school_id])
    @startDate = Date.strptime(params[:fesses2][:start_date],@timeformat.date_format)
    @endDate = Date.strptime(params[:fesses2][:end_date],@timeformat.date_format)
    @dueDate = Date.strptime(params[:fesses2][:due_date],@timeformat.date_format)

    @feeParticularObj.update(:start_date=>@startDate, :end_date=>@endDate, :due_date=>@dueDate)

    @feefineParticularParams = update_fine_particular_params
    @params=params[:selectedStudents]

    if(params[:fesses2][:value1]=='All')
    #@feefineParticularParams[:admission_no] = ''
    @feefineParticularParams[:mg_student_category_id] =''
    end

    if(params[:fesses2][:value1]=='demo')
      

    #@feefineParticularParams[:admission_no] =  params[:fesses2][:admission_no] 
    @feefineParticularParams[:mg_student_category_id] =''
    end

    if(params[:fesses2][:value1]=='demo2')         
     #@feefineParticularParams[:admission_no] = ''  
     @feefineParticularParams[:mg_student_category_id] =params[:fesses2][:mg_student_category_id]
    end
         
    @feeParticularObj.update(@feefineParticularParams)
 redirect_to :action=>"generate_fine"
   end

  def sports_stock
    @items=MgSportsItemManagement.where(:is_deleted=>0,:mg_inventory_item_category_id=>1,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end
  def sports_stock_new
    #@item_ctg=MgInventoryItemCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:name=>sports)    
  end
#======================================================================================================================= 
  def item_name_based_on_item_category
    @items=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:mg_inventory_item_category_id]).pluck(:name,:id)
    render :layout=>false
  end
  def items_unit
  @item_list=MgInventoryItem.where(:id=>params[:item_id]).pluck(:mg_item_unit_id)
  @unit=MgLabUnit.find_by(:id=>@item_list)
  @req_value=@unit.try(:unit_name)
      respond_to do |format|
      format.json  { render :json => {:str=>@req_value} }
    end
end

  def rack_based_on_room
    @racks=InventoryStackManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_room_management_id=>params[:mg_inventory_room_id]).pluck(:rack_no,:id)
    render :layout=>false
  end

  def room_based_on_item
    room_id=MgSportsItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>params[:mg_inventory_item_id]).pluck(:mg_inventory_room_id)
    @rooms=MgInventoryRoomManagement.where("is_deleted=0 AND mg_school_id=? AND id IN (?)",session[:current_user_school_id],room_id).pluck(:room_no,:id)
    render :layout=>false
  end

  def rack_based_on_room_and_item
    rack_ids=MgSportsItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_room_id=>params[:mg_inventory_room_id],:mg_inventory_item_id=>params[:mg_inventory_item_id]).where("quantity_available > 0").pluck(:mg_inventory_rack_id)
    @racks=InventoryStackManagement.where("is_deleted=0 AND mg_school_id=? AND id IN (?)",session[:current_user_school_id],rack_ids).pluck(:rack_no,:id)
    render :layout=>false
  end

  def auto_generating_id_from_prefix
    item=MgInventoryItem.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:mg_inventory_item_id])
    item_count=MgSportsItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>params[:mg_inventory_item_id]).count
    increment_count=item_count.to_i+1
    @auto_generated_id=item.prefix+""+increment_count.to_s
    respond_to do |format|
      format.json  { render :json =>@auto_generated_id.to_json}
    end
    # render :layout=>false
  end
#===================================================================================================================
  def sports_stock_create
   
    item=MgSportsItemManagement.new(sports_stock_params)
    if item.save
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      updated_date_of_expiry=Date.strptime(params[:mg_inventory_item_management][:date_of_expiry],school.date_format)
      item.update(:date_of_expiry=>updated_date_of_expiry)
      item.update(:quantity_available=>item.quantity)
      flash[:notice]="Stock added successfully"
      redirect_to :action=>"sports_stock"
    end
  end
  
  def sports_stock_edit
    @item=MgSportsItemManagement.find(params[:id])
  end
  
  def sports_stock_update
    item=MgSportsItemManagement.find(params[:id])
    if item.update(sports_stock_updated_params)
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      if params[:mg_sports_item_management][:date_of_expiry].present?
      updated_date_of_expiry=Date.strptime(params[:mg_sports_item_management][:date_of_expiry],school.date_format)
      end
      item.update(:date_of_expiry=>updated_date_of_expiry)
      item.update(:quantity_available=>item.quantity)
      flash[:notice]="Stock updated successfully"
      redirect_to :action=>"sports_stock"
    end
  end
  def sports_stock_show
    @item=MgSportsItemManagement.find(params[:id])
    render :layout=>false
  end
  def sports_stock_delete
    item=MgSportsItemManagement.find(params[:id])
    if item.update(:is_deleted=>1)
      redirect_to :action=>"sports_stock"
    end
  end
#================================================================================

  def sports_item_consumption_index
    @consumption_items=MgSportsItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def sports_item_consumption_new
  end

  def auto_generating_id_from_prefix_consumption
    item=MgInventoryItem.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:mg_inventory_item_id])
    item_count=MgSportsItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>params[:mg_inventory_item_id]).count
    increment_count=item_count.to_i+1
    @auto_generated_id=item.prefix+""+increment_count.to_s
    respond_to do |format|
      format.json  { render :json =>@auto_generated_id.to_json}
    end
  end

  def item_available_quantity
    @available_quantity,@total_quantity=quantity_available_method(params[:mg_inventory_item_id],params[:mg_inventory_rack_id])
    puts @available_quantity
    puts @total_quantity
    respond_to do |format|
      format.json  { render :json => [@available_quantity,@total_quantity] }
      # format.json  { render :json =>[@available_quantity.to_json,@total_quantity.to_json]}
    end
  end

  def sports_item_consumption_create
    # =================================================================================================
    MgInventoryItemConsumption.transaction do
      # item_consumption=MgInventoryItemConsumption.new(item_consumption_params)
      item_consumption=MgInventoryItemConsumption.new(sports_item_consumption_params)
      if item_consumption.save
        school=MgSchool.find_by(:id=>session[:current_user_school_id])
        updated_consumption_date=Date.strptime(params[:mg_inventory_item_consumption][:consumption_date],school.date_format)
        item_consumption.update(:consumption_date=>updated_consumption_date)
        item_in_stock=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_rack_id=>item_consumption.mg_inventory_rack_id,:mg_inventory_item_id=>item_consumption.mg_inventory_item_id)
        total_quantity_available_manage=item_consumption.quantity_available.to_i - item_consumption.quantity_consumed.to_i
        item_in_stock.each do |item_manage|
          item_manage.update(:quantity_available=>total_quantity_available_manage)
        end
        if item_consumption.consumption_type=="issued"
          if params[:studentIds].present?
            student_list=params[:studentIds]
            student_list.each do |student_id|
              issued_item_consumption=MgInventoryIssuedItemConsumption.new
              issued_item_consumption.mg_inventory_item_consumption_id=item_consumption.id
              issued_item_consumption.mg_consumer_type=params[:mg_consumer_type_id]
              issued_item_consumption.mg_student_id=student_id
              issued_item_consumption.mg_batch_id=params[:mg_batch_id]
              issued_item_consumption.mg_school_id=session[:current_user_school_id]
              issued_item_consumption.is_deleted=0
              issued_item_consumption.created_by=session[:user_id]
              issued_item_consumption.updated_by=session[:user_id]
              issued_item_consumption.save
            end
          end
            if params[:employeeIds].present?
            employee_list=params[:employeeIds]
            employee_list.each do |employee_id|
              issued_item_consumption_employee=MgInventoryIssuedItemConsumption.new
              issued_item_consumption_employee.mg_inventory_item_consumption_id=item_consumption.id
              issued_item_consumption_employee.mg_consumer_type=params[:mg_consumer_type_id]
              issued_item_consumption_employee.mg_employee_id=employee_id
              issued_item_consumption_employee.mg_department_id=params[:mg_department_id]
              issued_item_consumption_employee.mg_school_id=session[:current_user_school_id]
              issued_item_consumption_employee.is_deleted=0
              issued_item_consumption_employee.created_by=session[:user_id]
              issued_item_consumption_employee.updated_by=session[:user_id]
              issued_item_consumption_employee.save
            end
          end
        end
      end
    end
        # =================================================================================
    MgSportsItemConsumption.transaction do
      item_consumption=MgSportsItemConsumption.new(sports_item_consumption_params)
      if item_consumption.save
        school=MgSchool.find_by(:id=>session[:current_user_school_id])
        updated_consumption_date=Date.strptime(params[:mg_inventory_item_consumption][:consumption_date],school.date_format)
        item_consumption.update(:consumption_date=>updated_consumption_date)

        item_in_stock=MgSportsItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_rack_id=>item_consumption.mg_inventory_rack_id,:mg_inventory_item_id=>item_consumption.mg_inventory_item_id)
        total_quantity_available_manage=item_consumption.quantity_available.to_i - item_consumption.quantity_consumed.to_i
        item_in_stock.each do |item_manage|
          item_manage.update(:quantity_available=>total_quantity_available_manage)
        end

        if item_consumption.consumption_type=="issued"
          #if item Consumption is issued for students Code Starts
          if params[:studentIds].present?
            student_list=params[:studentIds]
            student_list.each do |student_id|
              issued_item_consumption=MgInventoryIssuedItemConsumption.new
              issued_item_consumption.mg_inventory_item_consumption_id=item_consumption.id
              issued_item_consumption.mg_consumer_type=params[:mg_consumer_type_id]
              issued_item_consumption.mg_student_id=student_id
              issued_item_consumption.mg_batch_id=params[:mg_batch_id]
              issued_item_consumption.mg_school_id=session[:current_user_school_id]
              issued_item_consumption.is_deleted=0
              issued_item_consumption.created_by=session[:user_id]
              issued_item_consumption.updated_by=session[:user_id]
              issued_item_consumption.save
            end
          end
          #if item Consumption is issued for students Code Ends

          #if item Consumption is issued for employees Code starts
            if params[:employeeIds].present?
            employee_list=params[:employeeIds]
            employee_list.each do |employee_id|
              issued_item_consumption_employee=MgInventoryIssuedItemConsumption.new
              issued_item_consumption_employee.mg_inventory_item_consumption_id=item_consumption.id
              issued_item_consumption_employee.mg_consumer_type=params[:mg_consumer_type_id]
              issued_item_consumption_employee.mg_employee_id=employee_id
              issued_item_consumption_employee.mg_department_id=params[:mg_department_id]
              issued_item_consumption_employee.mg_school_id=session[:current_user_school_id]
              issued_item_consumption_employee.is_deleted=0
              issued_item_consumption_employee.created_by=session[:user_id]
              issued_item_consumption_employee.updated_by=session[:user_id]
              issued_item_consumption_employee.save
            end
          end
          #if item Consumption is issued for employees Code Ends
        end

        #For Notification
        quantity_available,total_quantity_available=quantity_available_method(item_consumption.mg_inventory_item_id,item_consumption.mg_inventory_rack_id)
        item_minimum_quantity_required=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>item_consumption.mg_inventory_item_id)
        
        if total_quantity_available.to_i < item_minimum_quantity_required[0].minimum_quantity_required.to_i
          #Notification will go to Store Manager
          item=MgInventoryItem.find_by(:id=>item_consumption.mg_inventory_item_id)
          subject="Item Threshold"
          description="Dear Sir/Madam,#{item.name} availablity is below minimum required."
          room=MgInventoryRoomManagement.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>item_consumption.mg_inventory_room_id)
          store_manager_id=MgInventoryStoreManager.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_store_management_id=>room.mg_inventory_store_management_id)
          to_employee=MgEmployee.where(:id=>store_manager_id.mg_employee_id)
          to_employee.each do |employee|
            notification=MgNotification.send_notification(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
            notification.save
            puts "notification Success"
          end
        end
        flash[:notice]="Item Consumption Added Successfully"
        redirect_to :action=>"sports_item_consumption_index"
      else
        flash[:notice]="Error Occured"
        redirect_to :action=>"sports_item_consumption_index"
      end
    end
  end

  def sports_item_consumption_edit
    @item_consumption=MgSportsItemConsumption.find(params[:id])
    @available_quantity,@total_quantity=quantity_available_method(@item_consumption.mg_inventory_item_id,@item_consumption.mg_inventory_rack_id)
    if @item_consumption.consumption_type=="issued"
      @item_issued_detail=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
      @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
      @department=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:department_name,:id)
      @employee_ids=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
      @student_ids=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
    end
    if @item_consumption.consumption_type=="onshelf"
      @item_damaged_return=MgInventoryItemDamaged.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
      @item_return=MgInventoryItemReturn.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
      if (@item_damaged_return.present?)
        if @item_damaged_return.mg_student_id.present?
          @consumer_type="student"
          damaged_student_ids=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
          @damaged_student_list=MgStudent.where("id IN (?)",damaged_student_ids).pluck(:first_name,:id)
          return_student_ids=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
          @return_student_list=MgStudent.where("id IN (?)",return_student_ids).pluck(:first_name,:id) 
        elsif @item_damaged_return.mg_employee_id.present?
          @consumer_type="employee"
          damaged_employee_ids=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
          @damaged_employee_list=MgEmployee.where("id IN (?)",damaged_employee_ids).pluck(:first_name,:id)
          return_employee_ids=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
          @return_employee_list=MgEmployee.where("id IN (?)",return_employee_ids).pluck(:first_name,:id)
        end
        @return_date=@item_damaged_return.return_date
      end
      if (@item_return.present?)
        @return_date=@item_return.return_date
        if @item_return.mg_student_id.present?
          @consumer_type="student"
          damaged_student_ids=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
          @damaged_student_list=MgStudent.where("id IN (?)",damaged_student_ids).pluck(:first_name,:id)
          return_student_ids=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
          @return_student_list=MgStudent.where("id IN (?)",return_student_ids).pluck(:first_name,:id)
        elsif @item_return.mg_employee_id.present?
          @consumer_type="employee"
          damaged_employee_ids=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
          @damaged_employee_list=MgEmployee.where("id IN (?)",damaged_employee_ids).pluck(:first_name,:id)
          return_employee_ids=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
          @return_employee_list=MgEmployee.where("id IN (?)",return_employee_ids).pluck(:first_name,:id)
        end
      end
    end
  end

  def sports_item_consumption_update
    # =============================================================================================================
    #   MgInventoryItemConsumption.transaction do
    #   item_consumption=MgInventoryItemConsumption.find_by(:id=>params[:id])
    #   if item_consumption.update(sports_item_consumption_params_updated)
    #     school=MgSchool.find_by(:id=>session[:current_user_school_id])
    #     updated_consumption_date=Date.strptime(params[:mg_sports_item_consumption][:consumption_date],school.date_format)
    #     item_consumption.update(:consumption_date=>updated_consumption_date)

    #     item_in_stock=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_rack_id=>item_consumption.mg_inventory_rack_id,:mg_inventory_item_id=>item_consumption.mg_inventory_item_id)
    #     total_quantity_available_manage=item_consumption.quantity_available.to_i - item_consumption.quantity_consumed.to_i
    #     item_in_stock.each do |item_manage|
    #       item_manage.update(:quantity_available=>total_quantity_available_manage)
    #     end
    #     #For Onshelf
    #     if(item_consumption.consumption_type=="onshelf")
    #       if(params[:damagedIds]).present?
    #         if(params[:consumer_type]=="employee")
    #           damaged_employee_list=params[:damagedIds]
    #           damaged_employee_list.each do |employee_id|
    #             is_employee_present_in_return=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
    #             if is_employee_present_in_return.present?
    #               is_employee_present_in_return.update(:is_deleted=>1)
    #             end
    #             is_employee_present_in_damaged=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
    #             if is_employee_present_in_damaged.present?
    #               is_employee_present_in_damaged.update(:is_deleted=>0)
    #             else
    #               item_damaged=MgInventoryItemDamaged.new
    #               item_damaged.mg_employee_id=employee_id
    #               adding_audit_fields(item_damaged,params[:id],params[:return_date])
    #             end
    #           end
    #         elsif (params[:consumer_type]=="student")
    #           damaged_student_list=params[:damagedIds]
    #           damaged_student_list.each do |student_id|
    #             is_student_present_in_return=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
    #             if is_student_present_in_return.present?
    #               is_student_present_in_return.update(:is_deleted=>1)
    #             end
    #             is_student_present_in_damaged=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
    #             if is_student_present_in_damaged.present?
    #               is_student_present_in_damaged.update(:is_deleted=>0)
    #             else
    #               item_damaged=MgInventoryItemDamaged.new
    #               item_damaged.mg_student_id=student_id
    #               adding_audit_fields(item_damaged,params[:id],params[:return_date])
    #            end
    #           end
    #          end
    #       end

    #       if(params[:returnIds]).present?
    #         if(params[:consumer_type]=="employee")
    #           return_employee_list=params[:returnIds]
    #           return_employee_list.each do |employee_id|
    #             is_employee_present_in_return=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
    #             if is_employee_present_in_return.present?

    #               is_employee_present_in_return.update(:is_deleted=>1)
    #             end
    #             is_employee_present_in_damaged=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
    #             if is_employee_present_in_damaged.present?
    #               is_employee_present_in_damaged.update(:is_deleted=>0)
    #             else
    #               item_return=MgInventoryItemReturn.new
    #               item_return.mg_employee_id=employee_id
    #               adding_audit_fields(item_return,params[:id],params[:return_date])
    #             end
    #           end
    #         elsif (params[:consumer_type]=="student")
    #           return_student_list=params[:returnIds]
    #           return_student_list.each do |student_id|
    #             is_student_present_in_return=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
    #             if is_student_present_in_return.present?
    #               is_student_present_in_return.update(:is_deleted=>1)
    #             end
    #             is_student_present_in_damaged=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
    #             if is_student_present_in_damaged.present?
    #               is_student_present_in_damaged.update(:is_deleted=>0)
    #             else
    #               item_return=MgInventoryItemReturn.new
    #               item_return.mg_student_id=student_id
    #               adding_audit_fields(item_return,params[:id],params[:return_date])
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    # end
    # =============================================================================================================

    MgSportsItemConsumption.transaction do
      item_consumption=MgSportsItemConsumption.find(params[:id])
      if item_consumption.update(sports_item_consumption_params_updated)
        school=MgSchool.find_by(:id=>session[:current_user_school_id])
        updated_consumption_date=Date.strptime(params[:mg_sports_item_consumption][:consumption_date],school.date_format)
        item_consumption.update(:consumption_date=>updated_consumption_date)

        item_in_stock=MgSportsItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_rack_id=>item_consumption.mg_inventory_rack_id,:mg_inventory_item_id=>item_consumption.mg_inventory_item_id)
        total_quantity_available_manage=item_consumption.quantity_available.to_i - item_consumption.quantity_consumed.to_i
        item_in_stock.each do |item_manage|
          item_manage.update(:quantity_available=>total_quantity_available_manage)
        end
        #For Onshelf
        if(item_consumption.consumption_type=="onshelf")
          if(params[:damagedIds]).present?
            if(params[:consumer_type]=="employee")
              damaged_employee_list=params[:damagedIds]
              damaged_employee_list.each do |employee_id|
                is_employee_present_in_return=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
                if is_employee_present_in_return.present?
                  is_employee_present_in_return.update(:is_deleted=>1)
                end
                is_employee_present_in_damaged=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
                if is_employee_present_in_damaged.present?
                  is_employee_present_in_damaged.update(:is_deleted=>0)
                else
                  item_damaged=MgInventoryItemDamaged.new
                  item_damaged.mg_employee_id=employee_id
                  adding_audit_fields(item_damaged,params[:id],params[:return_date])
                end
              end
            elsif (params[:consumer_type]=="student")
              damaged_student_list=params[:damagedIds]
              damaged_student_list.each do |student_id|
                is_student_present_in_return=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
                if is_student_present_in_return.present?
                  is_student_present_in_return.update(:is_deleted=>1)
                end
                is_student_present_in_damaged=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
                if is_student_present_in_damaged.present?
                  is_student_present_in_damaged.update(:is_deleted=>0)
                else
                  item_damaged=MgInventoryItemDamaged.new
                  item_damaged.mg_student_id=student_id
                  adding_audit_fields(item_damaged,params[:id],params[:return_date])
               end
              end
             end
          end

          if(params[:returnIds]).present?
            if(params[:consumer_type]=="employee")
              return_employee_list=params[:returnIds]
              return_employee_list.each do |employee_id|
                is_employee_present_in_return=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
                if is_employee_present_in_return.present?

                  is_employee_present_in_return.update(:is_deleted=>1)
                end
                is_employee_present_in_damaged=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
                if is_employee_present_in_damaged.present?
                  is_employee_present_in_damaged.update(:is_deleted=>0)
                else
                  item_return=MgInventoryItemReturn.new
                  item_return.mg_employee_id=employee_id
                  adding_audit_fields(item_return,params[:id],params[:return_date])
                end
              end
            elsif (params[:consumer_type]=="student")
              return_student_list=params[:returnIds]
              return_student_list.each do |student_id|
                is_student_present_in_return=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
                if is_student_present_in_return.present?
                  is_student_present_in_return.update(:is_deleted=>1)
                end
                is_student_present_in_damaged=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
                if is_student_present_in_damaged.present?
                  is_student_present_in_damaged.update(:is_deleted=>0)
                else
                  item_return=MgInventoryItemReturn.new
                  item_return.mg_student_id=student_id
                  adding_audit_fields(item_return,params[:id],params[:return_date])
                end
              end
            end
          end
        end
      end
      flash[:notce]="Item Consumption Updated Successfully"
      redirect_to :action=>"sports_item_consumption_index"
    end
  end

  def adding_audit_fields(object,item_consumption_id,return_date)
    object.mg_inventory_item_consumption_id=item_consumption_id
    object.mg_school_id=session[:current_user_school_id]
    object.is_deleted=0
    object.created_by=session[:user_id]
    object.updated_by=session[:user_id]
    object.save
    if return_date.present?
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      returnDate = Date.strptime(return_date,school.date_format)
      object.update(:return_date=>returnDate)
    end
  end

  def sports_item_consumption_show
    @item=MgSportsItemConsumption.find(params[:id])
    if @item.consumption_type=="issued"
      @item_issued=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
    end
    @item_damaged=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
    @item_returned=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
    if @item_damaged.present?
      if @item_damaged[0].mg_student_id.present?
        @consumer_type="student"
      elsif @item_damaged[0].mg_employee_id.present?
        @consumer_type="employee"
      end
    end
    if @item_returned.present?
      if @item_returned[0].mg_student_id.present?
        @consumer_type="student"
      elsif @item_returned[0].mg_employee_id.present?
        @consumer_type="employee"
      end
    end
    # render :layout=>false
  end

  def sports_item_consumption_delete
    item_consumption=MgSportsItemConsumption.find(params[:id])
    item_consumption.update(:is_deleted=>1)
    redirect_to :action=>"sports_item_consumption_index"
  end

  def quantity_available_method(item_id,rack_id)
    item_quantity=MgSportsItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>item_id,:mg_inventory_rack_id=>rack_id)
    total_item_quantity=MgSportsItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>item_id)
    
    total_quantity=0
    quantity_available=0
    
    total_item_quantity.each do |i_quantity|
      # quantity_available=quantity_available.to_i + i_quantity.quantity.to_i
      total_quantity=total_quantity.to_i + i_quantity.quantity.to_i
    end

    item_quantity.each do |i_quantity|
      quantity_available=quantity_available.to_i + i_quantity.quantity.to_i
      # total_quantity=total_quantity.to_i + i_quantity.quantity.to_i
    end
    
    item_consumed=MgSportsItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>item_id,:mg_inventory_rack_id=>rack_id)
    total_item_consumed=MgSportsItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>item_id)
    
    total_consumed_value=0
    consumed_value=0
    
    item_consumed.each do |item|
      consumed_value=consumed_value.to_i + item.quantity_consumed.to_i
    end

    total_item_consumed.each do |item|
      total_consumed_value=total_consumed_value.to_i + item.quantity_consumed.to_i
    end

    @available_quantity=quantity_available - consumed_value
    @total_available_quantity=total_quantity - total_consumed_value
    
    # puts quantity_available
    # puts consumed_value
    
    puts @available_quantity
    puts @total_available_quantity

    return @available_quantity,@total_available_quantity
  end
  #==================================================================================
  def inventory_consumption_type_changes
    render :layout=>false
  end

  def inventory_consumption_for_employee
    @department=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:department_name,:id)
    render :layout=>false
  end

  def inventory_consumption_for_student
    @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    render :layout=>false
  end

  def department_wise_employee_list
    @employees=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>params[:mg_department_id])
    render :layout=>false

  end

  def batch_wise_student_list
    puts params.inspect
    @students_data=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>params[:mg_batches_id])
    @students=Array.new
     @students_data.each do |data|
      @data=Array.new
      @data.push("(#{data.admission_number})#{data.first_name} #{data.last_name}",data.id)
      @students.push(@data)
     end
    puts @students.inspect
    

    render :layout=>false
   end

  def item_consumption_onshelf
    item_consumption_onshelf=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:mg_item_consumption_id])
    @consumer_type=item_consumption_onshelf[0].mg_consumer_type
    if @consumer_type=="student"
      student_ids=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:mg_item_consumption_id]).pluck(:mg_student_id)
      @issued_list=MgStudent.where("id in (?)",student_ids).pluck(:first_name,:id)
    elsif @consumer_type=="employee"
      employee_ids=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:mg_item_consumption_id]).pluck(:mg_employee_id)
      @issued_list=MgEmployee.where("id in (?)",employee_ids).pluck(:first_name,:id)
    else
    end
    render :layout=>false
  end

  def inventory_item_report
    @items=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page],per_page: 10)
    @item_category_list=MgInventoryItemCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  end

  def inventory_item_report_by_category
    if (params[:item_category_id]=="all")||(params[:item_category_id]=="")
      @items=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page],per_page: 10)
    else 
      @items=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:item_category_id]).paginate(page: params[:page],per_page: 10)
    end
    render :layout=>false
  end
  #===================================================================================
  
  def payroll_deduction_index
    @pay_deduction=MgSportsPayDeduction.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def payroll_deduction_new
  end

  def payroll_deduction_ajax
    if params[:floor]=="floor"
   dept_data= MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
 str=""
   dept_data.each do |s|

        str +="<option value='#{s.try(:id)}'>#{s.try(:department_name)}</option>"
        
      end
 @object=str

elsif params[:room]=="room"
  rooms_data=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_category_id=>params[:floor_data],:mg_employee_department_id=>params[:room_id])
 str=""
   rooms_data.each do |s|

        str +="<option value='#{s.try(:id)}'>(#{s.try(:employee_number)})#{s.try(:first_name)} #{s.try(:last_name)}  </option>"
        
      end
 @object=str
end
respond_to do |format|
          format.json  { render :json => {main: @object, sub: ""} }
        end
  end 

  def payroll_deduction_create
    month_year=params[:mm_yyyy].split(" ")
    
    # puts"000000000000000"
    # puts Date::MONTHNAMES.index(month_year[0].to_s) 
    # puts"000000000000000"
    # puts ljkj

    MgSportsPayDeduction.transaction do
      amount=params[:payroll_deduction][:amount]
      pay_deduction=MgSportsPayDeduction.new
      pay_deduction.mm_yyyy=params[:mm_yyyy].to_s
      pay_deduction.month=Date::MONTHNAMES.index(month_year[0].to_s) 
      pay_deduction.year=month_year[1].to_i
      pay_deduction.name=params[:payroll_deduction][:name]
      pay_deduction.amount=params[:payroll_deduction][:amount]
      pay_deduction.deduction=params[:payroll_deduction][:deduction]
      pay_deduction.is_deleted=0
      pay_deduction.mg_school_id=session[:current_user_school_id]
      pay_deduction.created_by=session[:user_id]
      pay_deduction.updated_by=session[:user_id]
      pay_deduction.save
      if params[:payroll_deduction][:mg_account_id]=='central'
          pay_deduction.update(:is_central=>true)
          central_account_transaction=MgCentralAccountTransaction.send_sports_transaction(pay_deduction.id,params[:payroll_deduction][:mg_account_id],amount,session[:current_user_school_id],session[:user_id],session[:user_id])
          central_account_transaction.save
      else
          pay_deduction.update(:is_account=>true)
          account_transaction=MgAccountTransaction.add_sports_transaction(pay_deduction.id,params[:payroll_deduction][:mg_account_id],amount,session[:current_user_school_id],session[:user_id],session[:user_id])
          account_transaction.save
      end
      params[:selected_employees].each do |data|
        pay_deduction_list=MgSportsPayDeductiionList.new
        pay_deduction_list.mg_employee_id=data
        pay_deduction_list.mg_pay_deduction_details_id=pay_deduction.id
        pay_deduction_list.is_deleted=0
        pay_deduction_list.mg_school_id=session[:current_user_school_id]
        pay_deduction_list.created_by=session[:user_id]
        pay_deduction_list.updated_by=session[:user_id]
        pay_deduction_list.save
      end
    end
    redirect_to :action=>"payroll_deduction_index"
  end

  def payroll_deduction_show
    @pay_deduction=MgSportsPayDeduction.find_by(:id=>params[:id])

    puts @pay_deduction.inspect

  end


  def payroll_deduction_edit
    @pay_deduction=MgSportsPayDeduction.find_by(:id=>params[:id])
    @account=MgSportsPayDeduction.find_by(:id=>params[:id])
    if @pay_deduction.is_central==true
      @account_data_id='central'
    elsif @pay_deduction.is_account==true
      @account_data_id=MgAccountTransaction.where(:for_module=>'sports_managements',:mg_particular_id=>@pay_deduction.id).pluck(:mg_to_account_id)
    end
  end

  def payroll_deduction_update
   report_data=MgSportsPayDeduction.find_by(:id=>params[:id])
   # report_data.amount=params[:amount]
   month_year=params[:payroll_deduction_data][:mm_yyyy].split(" ") 
   report_data.mm_yyyy=params[:payroll_deduction_data][:mm_yyyy]
   report_data.month=Date::MONTHNAMES.index(month_year[0].to_s)
   report_data.year=month_year[1]
   report_data.name=params[:payroll_deduction_data][:name]
   report_data.deduction=params[:payroll_deduction_data][:deduction]
   report_data.save

   @params=params[:selected_employees_final]
 
   school_id=session[:current_user_school_id]
   for j in 0...@params.size

   list_data=MgSportsPayDeductiionList.where('mg_pay_deduction_details_id=? and mg_school_id=? and  mg_employee_id=?', params[:id],school_id,@params[j])

   if list_data.size<1

      @data=MgSportsPayDeductiionList.new()
      @data.is_deleted=0
      @data.created_by=session[:user_id]
      @data.mg_employee_id=@params[j]
      @data.mg_pay_deduction_details_id=params[:id]
      @data.mg_school_id=school_id

      @data.save
   else
      list_data[0].update(:is_deleted=>0,:mg_school_id=>school_id)
   end
  end

  list_data=MgSportsPayDeductiionList.where('mg_pay_deduction_details_id=? and is_deleted=? and mg_school_id=? and  mg_employee_id  NOT IN (?)',params[:id],0,school_id,params[:selected_employees_final])

  if list_data.length>0
    for j in 0...list_data.length
     
     data=MgSportsPayDeductiionList.find_by(:id=>list_data[j].id)
     if data.present?
     data.update(:is_deleted=>1)
     end
    end
  end

   redirect_to :action=>'payroll_deduction_index'

  end

  

  def payroll_deduction_delete
    pay_deduction=MgSportsPayDeduction.find_by(:id=>params[:id])
    pay_deduction.is_deleted=1
    pay_deduction.save
    deduction_list=MgSportsPayDeductiionList.where(:mg_pay_deduction_details_id =>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    deduction_list.each do |list|
    list.is_deleted=1
    list.save
  end
    redirect_to :action=>"payroll_deduction_index"
  end


#===================================PRANOW Work END======================================================


  private

  def user_accounts_params
    params.require(:user).permit(:user_type,:password,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end


  def game_params
    params.require(:game).permit(:name, :description,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def game_update_params
    params.require(:game).permit(:name, :description,:is_deleted,:updated_by,:mg_school_id)
  end

  def bed_detail_params
    params.require(:bed_detail).permit(:bed_no,:description,:status,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end
  
  def bed_assign_details_params
    params.require(:bed_assign_detail).permit(:mg_bed_details_id,:admitted_date,:admitted_time,:discharge_date,:discharge_time,:user_id,:status,:mg_doctor_id,:comments,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end

  def update_bed_assign_details_params
    params.require(:bed_assign_detail).permit(:mg_bed_details_id,:admitted_time,:discharge_time,:user_id,:mg_doctor_id,:comments,:status,:mg_school_id,:is_deleted,:updated_by)
  end

  def team_params
    params.require(:team).permit(:team_name,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def team_params_update
    params.require(:team).permit(:team_name,:is_deleted,:updated_by,:mg_school_id)
  end

  def schedule_params
    params.require(:schedule).permit(:start_time,:end_time,:venue,:winner,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  #==================Pranav Works START==================================================================
   def disciplinary_action_params
    params.require(:discipline_form).permit(:subject,:mg_wing_id, :mg_batches_id,:mg_student_id,:remark,:action_taken,:status,:is_deleted,:created_by,:updated_by,:mg_school_id)
    end
    def disciplinary_action_params_updated
    params.require(:discipline_form).permit(:subject,:mg_wing_id, :mg_batches_id,:mg_student_id,:remark,:action_taken,:status,:is_deleted,:updated_by,:mg_school_id)
    end

    def generate_fine_params
     params.require(:generate_fine).permit(:fine_name,:description,:mg_account_id,:amount,:mg_batches_id,:mg_student_id,:is_deleted,:created_by,:updated_by,:mg_school_id)
    end
    def generate_fine_params_updated
     params.require(:generate_fine).permit(:fine_name,:description,:mg_account_id,:amount,:mg_batches_id,:mg_student_id,:is_deleted,:updated_by,:mg_school_id)
    end

    def sports_stock_params
      params.require(:mg_inventory_item_management).permit(:mg_inventory_item_category_id,:mg_inventory_item_id,:item_prefix,:label_text,:mg_inventory_room_id,:mg_inventory_rack_id,:quantity,:quantity_available,:date_of_expiry,:remark,:is_deleted,:created_by,:updated_by,:mg_school_id)
    end
    def sports_stock_updated_params
      params.require(:mg_sports_item_management).permit(:mg_inventory_item_category_id,:mg_inventory_item_id,:item_prefix,:label_text,:mg_inventory_room_id,:mg_inventory_rack_id,:quantity,:quantity_available,:date_of_expiry,:remark,:is_deleted,:updated_by,:mg_school_id)
    end
    def sports_item_consumption_params
      params.require(:mg_inventory_item_consumption).permit(:mg_inventory_item_category_id, :mg_inventory_item_id, :item_prefix,:item_type,:mg_inventory_room_id,:mg_inventory_rack_id,:quantity_available,:quantity_consumed,:consumption_date,:consumption_type,:is_deleted,:created_by,:updated_by,:mg_school_id,:description)
    end
    def sports_item_consumption_params_updated
      params.require(:mg_sports_item_consumption).permit(:mg_inventory_item_category_id, :mg_inventory_item_id, :item_prefix,:item_type,:mg_inventory_room_id,:mg_inventory_rack_id,:quantity_available,:quantity_consumed,:consumption_date,:consumption_type,:is_deleted,:updated_by,:mg_school_id,:description)
    end
  #==================Pranav work End===============================================================
  def fine_particular_params
    params.require(:generate_fine).permit(:fine_name,:description,:fine_from,:is_deleted, :mg_school_id,:amount,
     :created_by, :updated_by)
  end
  def update_fine_particular_params
    params.require(:fesses2).permit(:fine_name,:description,:fine_from,:is_deleted, :mg_school_id,:amount,
     :mg_student_category_id)
  end
end
