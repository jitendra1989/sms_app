class FrontOfficeManagementController < ApplicationController
  layout "mindcom"
  before_filter :login_required

  def meeting_planner
    #@meeting_planner_data=MgMeetingPlannerFom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :is_principal=>1).not(:status=>"Rejected")
    @meeting_planner_data=MgMeetingPlannerFom.where("is_deleted =? and mg_school_id =? and is_principal=? and status NOT IN (?)",0,session[:current_user_school_id],1,["Rejected"])
  end

  # def postal_records
  #   puts klsjafkl;djl
  # end
  #===================Balaji starts=============================
  def type_of_query_index
    @type_of_query_data=MgFomQueryRecord.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

def type_of_query_create
    type_of_query_params=MgFomQueryRecord.new(type_of_query_params_data)
    if type_of_query_params.save
      flash[:notice] = "Type of Query has saved..."
    else
      flash[:error] = "Type of Query has not saved..."
    end
    redirect_to :action=>"type_of_query_index"
end


def type_of_query_delete
  delete_type_of_query_data=MgFomQueryRecord.find(params[:id])
  delete_type_of_query_data.is_deleted=1
  if delete_type_of_query_data.save
    flash[:notice] = "Successfully Deleted..."
  else
    flash[:error] = "Error Occurred..."
  end
  redirect_to :action=>"type_of_query_index"
end

def type_of_query_show
    @type_of_query_data=MgFomQueryRecord.find(params[:id])
    render :layout=>false
end

def type_of_query_edit
    @type_of_query_type=MgFomQueryRecord.find(params[:id])
    render :layout=>false
end

def type_of_query_update
  update_data=MgFomQueryRecord.find(params[:id])
  if update_data.update(update_type_of_query_params_data)
    flash[:notice] = "Successfully Updated..."
  else
    flash[:error] = "Not Updated..."
  end
  redirect_to :action=>"type_of_query_index"
end

def type_of_query_new
  render :layout=>false
end


def caller_category_index
  @caller_category_data=MgCallerCategoryFom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end



def caller_category_create
  caller_category_params=MgCallerCategoryFom.new(caller_category_params_data)
  if caller_category_params.save
    flash[:notice]= "Request type has saved..."
  else
    flash[:error]= "Error Occurred..."
  end
redirect_to :action=> "caller_category_index"
end

def caller_category_delete
  delete_caller_category_data=MgCallerCategoryFom.find(params[:id])
  delete_caller_category_data.is_deleted=1
  delete_caller_category_data.save
  if flash[:notice] = "Successfully Deleted..."
  else
    flash[:error]= "Error Occurred..."
  end
  redirect_to :action=>"caller_category_index"
end

def caller_category_show
  @caller_category_data=MgCallerCategoryFom.find(params[:id])
  render :layout=>false
end

def caller_category_new
  render :layout=>false
end

def caller_category_edit
  @caller_category_type=MgCallerCategoryFom.find(params[:id])
  render :layout=>false
end

def caller_category_update
  update_data=MgCallerCategoryFom.find(params[:id])
  if update_data.update(update_caller_category_params_data)
    flash[:notice] = "Successfully Updated..."
  else
  flash[:error] = "Error Occurred..."
  end
  redirect_to :action=>"caller_category_index"
end




def query_record_index
  if params["search_date"].present?
    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
    search_date =Date.strptime(params["search_date"],current_school.date_format)
    date = Date.parse("#{search_date}")
    if session[:user_type]=="principal"
      @query_record_data=MgQueryRecord.where("is_principal_required=? and is_deleted=? and is_principal_required=? and mg_school_id=? and created_at>=? and created_at<=?",0,0,0,session[:current_user_school_id],date.beginning_of_day,date.end_of_day)
    else
      @query_record_data=MgQueryRecord.where("is_deleted=? and is_principal_required=? and mg_school_id=? and created_at>=? and created_at<=?",0,0,session[:current_user_school_id],date.beginning_of_day,date.end_of_day)
    end
  else
      # ============FOr Principal and Fom===============================
      if session[:user_type]=="principal"
        @query_record_data=MgQueryRecord.where(:is_principal_required=>0,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      else
        @query_record_data=MgQueryRecord.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      end
      # ============================================
  end
end

def query_record_new
  record_data=MgQueryRecord.where(:date_of_query=>Date.today,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).count
    if record_data>=1
      @data=record_data+1
    else
        @data=1
    end
    
end  

def query_record_create
  query_record_params=MgQueryRecord.new(query_record_params_data)
    if query_record_params.save
      if params[:submit_button]=="submit"
        query_record_params.update(:is_principal_required=>0)
      end
    flash[:notice]= "Query Record has saved..."
  else
    flash[:error]="Error Occurred..."
  end
  redirect_to :action=> "query_record_index"
end

def query_record_show
  @query_record_data=MgQueryRecord.find(params[:id])
  render :layout=>false
end


def query_record_delete
  delete_query_record_data=MgQueryRecord.find(params[:id])
  delete_query_record_data.is_deleted=1
  if delete_query_record_data.save
  flash[:notice] = "Successfully Deleted..."
  else
    flash[:error]="Error Occurred..."
  end
  redirect_to :action=>"query_record_index"
  
end


def query_record_edit
  @query_record_type=MgQueryRecord.find(params[:id])
  render :layout=>false
end



def query_record_update
  update_data=MgQueryRecord.find(params[:id])
  if update_data.update(update_query_record_params_data)
    flash[:notice] = "Successfully Updated..."
  else
  flash[:error] = "Error Occurred..."
  end
  redirect_to :action=>"query_record_index"
end


def employee_list
      @employee_array = MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_position_id=>params[:emp_profile_id])
      @employee_list=Array.new
      @employee_array.each do |emp|
        employee_data=Array.new
        employee_data.push("#{emp.employee_number}-#{emp.first_name.capitalize.to_s} #{emp.last_name.capitalize.to_s}",emp.id)
        @employee_list.push(employee_data)
      end
      @employee_array.map{ |name| name.first_name=name.employee_number.to_s+' - '+name.first_name.capitalize.to_s+' '.to_s+name.last_name.capitalize.to_s}
      #@employee_array=@employee_list.pluck(:first_name,:id)
        
      if params[:book_id].present? && params[:Transport]=="data"
      @room_booking_data=MgFomTransportBooking.find_by(:id=>params[:book_id])
      puts params[:book_id]
       end
        if params[:book_id].present? && params[:guset_room]=="data_room"
      @room_booking_data=MgGuestRoomBooking.find_by(:id=>params[:book_id])

       end
      render :layout=>false

  end



  #   def student_employe_list
  #   if params[:batch_id].present?
  #     @student_emp_obj = MgStudent.where(:is_deleted=>0,:mg_batch_id=>params[:batch_id],:mg_school_id=>session[:current_user_school_id])#.pluck(:first_name,:id)
  #     @student_emp_obj.map{ |name| name.first_name=name.admission_number.to_s+' - '+name.first_name.capitalize.to_s+' '.to_s+name.last_name.capitalize.to_s}#.reduce(:merge)
  #   else
  #     @student_emp_obj = MgEmployee.where(:is_deleted=>0,:mg_employee_department_id=>params[:emp_department_id],:mg_school_id=>session[:current_user_school_id])#.pluck(:first_name,:id)
  #     @student_emp_obj.map{ |name| name.first_name=name.employee_number.to_s+' - '+name.first_name.capitalize.to_s+' '.to_s+name.last_name.capitalize.to_s}
  #   end
  #   render :layout=>false
  # end


def employee_position_list
      @positionList = MgEmployeePosition.where(:mg_employee_category_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:position_name,:id)
    if params[:book_id].present? && params[:Transport]=="data"
      @room_booking_data=MgFomTransportBooking.find_by(:id=>params[:book_id])
      puts params[:book_id]
       end
     if params[:book_id].present? && params[:guset_room]=="data_room"
      @room_booking_data=MgGuestRoomBooking.find_by(:id=>params[:book_id])
    end
      render :layout=>false
      
  end

def guest_room_booking_index
  @guest_room_booking_data=MgGuestRoomBooking.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  puts @guest_room_booking_data.inspect
  
end
  
def guest_room_booking_create
  guest_room_booking_params=MgGuestRoomBooking.new(guest_room_booking_params_data)
 
  @timeformat = MgSchool.find(session[:current_user_school_id])
  start_date = Date.strptime(params[:guest_room_booking_type][:start_date],@timeformat.date_format)
  end_date = Date.strptime(params[:guest_room_booking_type][:end_date],@timeformat.date_format)
  guest_room_booking_params.start_date=start_date
  guest_room_booking_params.end_date=end_date

  guest_room_booking_params.mg_employee_id=params[:mg_employee_id]
  guest_room_booking_params.mg_employee_position_id=params[:mg_employee_position_id]
    if guest_room_booking_params.save
     flash[:notice]= "Guest Room Booking has saved..."
    else
    flash[:error]="Error Occurred..."
    end
  redirect_to :action=> "guest_room_booking_index"
end



def guest_room_booking_delete
  delete_guest_room_booking_data=MgGuestRoomBooking.find(params[:id])
  delete_guest_room_booking_data.is_deleted=1
  if delete_guest_room_booking_data.save
  flash[:notice] = "Successfully Deleted..."
  else
    flash[:error]="Error Occurred..."
  end
  redirect_to :action=>"guest_room_booking_index"
end

def guest_room_booking_show
  @guest_room_booking_data=MgGuestRoomBooking.find(params[:id])
  @timeformat = MgSchool.find(session[:current_user_school_id])
  render :layout=>false
end

def guest_room_booking_edit
  @guest_room_booking_type=MgGuestRoomBooking.find(params[:id])
  render :layout=>false

end

def guest_room_booking_update
  update_data=MgGuestRoomBooking.find(params[:id])
    @timeformat = MgSchool.find(session[:current_user_school_id])

   start_date = Date.strptime(params[:guest_room_booking_type][:start_date],@timeformat.date_format)
  end_date = Date.strptime(params[:guest_room_booking_type][:end_date],@timeformat.date_format)
 update_data.mg_employee_id=params[:mg_employee_id]
 update_data.mg_employee_position_id=params[:mg_employee_position_id]
  if update_data.update(update_guest_room_booking_params_data)
    update_data.update(:start_date=>start_date,:end_date=>end_date)
    if params[:is_cancelled].present?
      update_data.update(:is_cancelled=>params[:is_cancelled])
    end
    flash[:notice] = "Successfully Updated..."
  else
  flash[:error] = "Not Updated..."
  end
  
  redirect_to :action=>"guest_room_booking_index"
end






def transport_booking_index
  @transport_booking_data=MgFomTransportBooking.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  
end

def transport_booking_create
    transport_booking_params=MgFomTransportBooking.new(transport_booking_params_data)
    @timeformat = MgSchool.find(session[:current_user_school_id])
      date_of_booking = Date.strptime(params[:transport_booking_type][:date_of_booking],@timeformat.date_format)
      transport_booking_params.date_of_booking=date_of_booking

     transport_booking_params.mg_employee_id=params[:mg_employee_id]
     transport_booking_params.mg_employee_position_id=params[:mg_employee_position_id]

    if transport_booking_params.save
     flash[:notice]= "Transport Booking has saved..."
    else
    flash[:error]="Error Occurred..."
    end
  redirect_to :action=> "transport_booking_index"

end

def transport_booking_update
  update_data=MgFomTransportBooking.find(params[:id])
    @timeformat = MgSchool.find(session[:current_user_school_id])

   date_of_booking = Date.strptime(params[:transport_booking_type][:date_of_booking],@timeformat.date_format)
  
  update_data.mg_employee_id=params[:mg_employee_id]
  update_data.mg_employee_position_id=params[:mg_employee_position_id]

  if update_data.update(update_transport_booking_params_data)
    update_data.update(:date_of_booking=>date_of_booking)
    if params[:is_cancelled].present?
      update_data.update(:is_cancelled=>params[:is_cancelled])
    end
    flash[:notice] = "Successfully Updated..."
  else
  flash[:error] = "Not Updated..."
  end
  redirect_to :action=>"transport_booking_index"
end


def transport_booking_delete
  delete_transport_booking_data=MgFomTransportBooking.find(params[:id])
  delete_transport_booking_data.is_deleted=1
  if delete_transport_booking_data.save
  flash[:notice] = "Successfully Deleted..."
  else
    flash[:error]="Error Occurred..."
  end
  redirect_to :action=>"transport_booking_index"
end


def transport_booking_show
  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  @transport_booking_data=MgFomTransportBooking.find(params[:id])
  render :layout=>false
end

def transport_booking_edit
  @transport_booking_type=MgFomTransportBooking.find(params[:id])
  render :layout=>false
end


  #===================Balaji ends=============================

  # kumar starts=================================================================
def category
  @category=MgFaqCategory.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def category_edit
  @category=MgFaqCategory.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:id=>params[:id])
  render :layout=>false
end

def category_new
  render :layout=>false
end

def category_create
  category=MgFaqCategory.new(params_faq_category)
  if category.save
  flash[:notice]="Data has saved successfully."
    else
  flash[:notice]="Data not saved."
  end
  redirect_to :action=>"category"
end

def category_update
  category=MgFaqCategory.find_by(:id=>params[:id])
  if category.update(params_faq_category)
  flash[:notice]="Data updated successfully."
  else
    flash[:notice]="Data not saved."
  end
  redirect_to :action=>"category"
end

def category_delete
  category=MgFaqCategory.find_by(:id=>params[:id])
  category.update(:is_deleted=>1, :updated_by=>session[:user_id])
  redirect_to :action=>"category"
end

  def sub_category_list
      @sub_category_list = MgFaqSubCategory.where("is_deleted=? and mg_school_id=? and mg_faq_category_id IN (?)",0,session[:current_user_school_id],params[:id])#.pluck(:id, :first_name)
      respond_to do |format|
      format.json  { render :json => @sub_category_list }
      end
  end


#========================sub category=================starts
def sub_category
  @category=MgFaqSubCategory.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def sub_category_edit
  @category=MgFaqSubCategory.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:id=>params[:id])
  render :layout=>false
end

def sub_category_new
  render :layout=>false
end

def sub_category_create
  category=MgFaqSubCategory.new(params_faq_sub_category)
  if category.save
  flash[:notice]="Data has saved successfully."
    else
  flash[:notice]="Data not saved."
  end
  redirect_to :action=>"sub_category"
end

def sub_category_update
  category=MgFaqSubCategory.find_by(:id=>params[:id])
  if category.update(params_faq_sub_category)
  flash[:notice]="Data updated successfully."
  else
    flash[:notice]="Data not saved."
  end
  redirect_to :action=>"sub_category"
end

def sub_category_delete
  category=MgFaqSubCategory.find_by(:id=>params[:id])
  category.update(:is_deleted=>1, :updated_by=>session[:user_id])
  redirect_to :action=>"sub_category"
end

#========================sub_category==================ends

#============================================================
def faq
  @faq=MgFaq.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def faq_edit
  @category=MgFaq.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:id=>params[:id])
end

def faq_new
end

def faq_create
 # puts asdf
  category=MgFaq.new(params_faq)
  if category.save
  flash[:notice]="Data has saved successfully."
    else
  flash[:notice]="Data not saved."
  end
  redirect_to :action=>"faq"
end

def faq_update
  category=MgFaq.find_by(:id=>params[:id])
  if category.update(params_faq)
     category.update(:mg_faq_sub_category_id=>params[:mg_faq_sub_category_id])
  flash[:notice]="Data updated successfully."
  else
    flash[:notice]="Data not saved."
  end
  redirect_to :action=>"faq"
end

def faq_delete
  category=MgFaq.find_by(:id=>params[:id])
  category.update(:is_deleted=>1, :updated_by=>session[:user_id])
  redirect_to :action=>"faq"
end

def strip_tags(html)     
  return html if html.blank?
    if html.index("<")
      text = ""
      tokenizer = HTML::Tokenizer.new(html)
      while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        text << node.to_s if node.class == HTML::Text  
      end
      text.gsub(/<!--(.*?)-->[\n]?/m, "") 
    else
      html 
    end 
end

def faq_show
  @faq=MgFaq.find_by(:id=>params[:id])
end

def faq_view
end

  def faq_status
    if params[:sub_category_id]=="not_selected"
      @sub_category="not_selected"
      @category_id=params[:category_id]
      @faq=MgFaq.where(:mg_faq_category_id=>params[:category_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('created_at DESC').pluck(:mg_faq_sub_category_id).uniq
    else
      @sub_category="selected"
      @faq=MgFaq.where(:mg_faq_category_id=>params[:category_id],:mg_faq_sub_category_id=>params[:sub_category_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('created_at DESC')
    end
    render :layout=> false
  end
#=============================================================




  def meeting_planner_data
    if request.xhr?
          # @events = MgEvent.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id])
          sql="select a.meeting_with 'title', CONCAT(a.date_of_meeting,'T',a.start_time) 'start',
          CONCAT(a.date_of_meeting,'T', a.end_time) 'end',a.status 'color', a.purpose 'description', a.id, a.is_reschedule from mg_meeting_planner_foms a where a.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} "
          @abc=MgMeetingPlannerFom.find_by_sql sql
          objArray = @abc.as_json
          puts  objArray.inspect
          arr=[]

          objArray.each do |obj|
            # obj.each do ||
            hash=Hash.new
            hash['start']=obj['start']
            hash['end']=obj['end']
            hash['title']=obj['title']
            hash['description']=obj['description']
            hash['id']=obj['id']

            puts obj
            puts "k===> #{obj['color']}  "
             
            if obj['is_reschedule']==false
              hash['color']='yellow'
            elsif obj['color'].to_s=="Pending"
              hash['color']='red'
            elsif obj['color'].to_s=="Accepted"
              hash['color']='green'
            # elsif obj['color'].to_s=="Rejected"
            #   hash['color']='yellow'
            end

            arr.push(hash)
          end
          
          puts objArray.inspect
          render :json=> arr

        end
  end

  def meeting_planner_new
  @school=MgSchool.find(session[:current_user_school_id])
  
  @date = Date.parse(params[:currentDate]).strftime(@school.date_format)

  puts "========================= #{params[:currentDate]}"
  render :layout=>false#, :params=>{:date=>params[:currentDate]}
end


  def meeting_planner_create
    meeting_planner_data=MgMeetingPlannerFom.new(meeting_planner_datas)
    puts "=================================================="
    puts params
    puts "=================================================="
    start_time_hour=params[:start_time]["game_time(4i)"]
    start_time_hour_min=params[:start_time]["game_time(5i)"]
    start_time=start_time_hour+":"+start_time_hour_min+":00";
    end_time_hour=params[:end_time]["game_time(4i)"]
    end_time_hour_min=params[:end_time]["game_time(5i)"]
    end_time=end_time_hour+":"+end_time_hour_min+":00";
    meeting_planner_data.start_time=start_time
    meeting_planner_data.end_time=end_time
    if session[:user_type]=="principal"
      meeting_planner_data.status="Accepted"
    else
      meeting_planner_data.status="Pending"
    end
    
    
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @date = Date.strptime(params[:meeting_planner][:date_of_meeting],@timeformat.date_format)
    meeting_planner_data.date_of_meeting=@date
    meeting_planner_data.is_principal=1

    if meeting_planner_data.save
     # meeting_planner_data.update(:start_date_of_meeting=>date_start,:end_date_of_meeting=>date_end,:is_principal=>1)
      flash[:notice]="Data has saved successfully."
    else
      flash[:notice]="Meeting time overlapping,please create meeting with other times."
    end
    redirect_to :action=>"meeting_planner"
  end

  def meeting_planner_edit
    @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
    render :layout=>false
  end


  def meeting_planner_update
    meeting_planner_data=MgMeetingPlannerFom.find_by(:id=>params[:id])

    if meeting_planner_data.update(meeting_planner_datas)

      start_time_hour=params[:meeting_planner]["start_time(4i)"]
      start_time_hour_min=params[:meeting_planner]["start_time(5i)"]
      end_time_hour=params[:meeting_planner]["end_time(4i)"]
      end_time_hour_min=params[:meeting_planner]["end_time(5i)"]  

      if start_time_hour.present? && start_time_hour_min.present? && end_time_hour.present? && end_time_hour_min.present?
        start_time=start_time_hour + ":" + start_time_hour_min + ":00"
        end_time=end_time_hour + ":" + end_time_hour_min + ":00"
        meeting_planner_data.update(:start_time=>start_time,:end_time=>end_time)
      end

      @timeformat = MgSchool.find(session[:current_user_school_id])
      @date = Date.strptime(params[:meeting_planner][:date_of_meeting],@timeformat.date_format)
      meeting_planner_data.update(:date_of_meeting=>@date)

      if params[:is_cancelled].present?
        if params[:is_cancelled]
          meeting_planner_data.update(:status=>"Cancelled")
        else
        # meeting_planner_data.status="Pending"
        end
      end

      if params[:is_reschedule].present?
        if params[:is_reschedule]
          meeting_planner_data.update(:is_reschedule=>0)
        else
        # meeting_planner_data.status="Pending"
        end
      end

      flash[:notice]="Data updated successfully."
    else
      flash[:notice]="Meeting has already been scheduled for same date and time."
    end
    redirect_to :action=>"meeting_planner"
  end

  

  def meeting_planner_show
     @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
  end

def meeting_planner_delete
  @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
  @meeting_planner.update(:is_deleted=>1, :updated_by=>session[:user_id])
  redirect_to :action=>"meeting_planner"
end


# Added By Bindhu For Changing the date format starts

# =================Meeting starts===============??

def meeting
    @meeting_planner_data=MgMeetingPlannerFom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :is_principal=>1)
  end

def meeting_new
  #@school=MgSchool.find(session[:current_user_school_id])
  
  #@date = Date.parse(params[:currentDate]).strftime(@school.date_format)

  #puts "========================= #{params[:currentDate]}"
  #render :layout=>false#, :params=>{:date=>params[:currentDate]}
end


  def meeting_create
    meeting_planner_data=MgMeetingPlannerFom.new(meeting_planner_datas)
    puts "=================================================="
    puts params
    puts "=================================================="
    start_time_hour=params[:start_time]["game_time(4i)"]
    start_time_hour_min=params[:start_time]["game_time(5i)"]
    start_time=start_time_hour+":"+start_time_hour_min+":00";
    end_time_hour=params[:end_time]["game_time(4i)"]
    end_time_hour_min=params[:end_time]["game_time(5i)"]
    end_time=end_time_hour+":"+end_time_hour_min+":00";
    meeting_planner_data.start_time=start_time
    meeting_planner_data.end_time=end_time
    if session[:user_type]=="principal"
      meeting_planner_data.status="Accepted"
    else
      meeting_planner_data.status="Pending"
    end
    
    
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @date = Date.strptime(params[:meeting_planner][:date_of_meeting],@timeformat.date_format)
    meeting_planner_data.date_of_meeting=@date
    meeting_planner_data.is_principal=1

    if meeting_planner_data.save
     # meeting_planner_data.update(:start_date_of_meeting=>date_start,:end_date_of_meeting=>date_end,:is_principal=>1)
      flash[:notice]="Data has saved successfully."
    else
      flash[:notice]="Meeting time overlapping,please create meeting with other times."
    end
    redirect_to :action=>"meeting"
  end

  def meeting_edit
    @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
   # render :layout=>false
  end


  def meeting_update
    meeting_planner_data=MgMeetingPlannerFom.find_by(:id=>params[:id])

    if meeting_planner_data.update(meeting_planner_datas)

      start_time_hour=params[:meeting_planner]["start_time(4i)"]
      start_time_hour_min=params[:meeting_planner]["start_time(5i)"]
      end_time_hour=params[:meeting_planner]["end_time(4i)"]
      end_time_hour_min=params[:meeting_planner]["end_time(5i)"]  

      if start_time_hour.present? && start_time_hour_min.present? && end_time_hour.present? && end_time_hour_min.present?
        start_time=start_time_hour + ":" + start_time_hour_min + ":00"
        end_time=end_time_hour + ":" + end_time_hour_min + ":00"
        meeting_planner_data.update(:start_time=>start_time,:end_time=>end_time)
      end

      @timeformat = MgSchool.find(session[:current_user_school_id])
      @date = Date.strptime(params[:meeting_planner][:date_of_meeting],@timeformat.date_format)
      meeting_planner_data.update(:date_of_meeting=>@date)

      if params[:is_cancelled].present?
        if params[:is_cancelled]
          meeting_planner_data.update(:status=>"Cancelled")
        else
        # meeting_planner_data.status="Pending"
        end
      end

      if params[:is_reschedule].present?
        if params[:is_reschedule]
          meeting_planner_data.update(:is_reschedule=>0)
        else
        # meeting_planner_data.status="Pending"
        end
      end

      flash[:notice]="Data updated successfully."
    else
      flash[:notice]="Meeting has already been scheduled for same date and time."
    end
    redirect_to :action=>"meeting"
  end

  

  def meeting_show
     @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
  end

def meeting_delete
  @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
  @meeting_planner.update(:is_deleted=>1, :updated_by=>session[:user_id])
  redirect_to :action=>"meeting"
end
# ===================Meeting over=================





  def change_date_format(start_date_time,end_date_time)
    @timeformat = MgSchool.find(session[:current_user_school_id])
    start_date = start_date_time.strftime(@timeformat.date_format)
    start_time =start_date_time.strftime("%k:%M")
    date_time_start=start_date.to_s+ " " + start_time.to_s
    date_start = DateTime.parse("#{date_time_start}")

    end_date = end_date_time.strftime(@timeformat.date_format)
    end_time =end_date_time.strftime("%k:%M")
    date_time_end=end_date.to_s+ " " + end_time.to_s
    date_end = DateTime.parse("#{date_time_end}")

    return date_start,date_end
  # Added By Bindhu For Changing the date format ends
  end

# ============================================

def meeting_plan
    @meeting_planner_data=MgMeetingPlannerFom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_principal=>0)
end

def meeting_plan_new
end


def meeting_plan_create
  meeting_planner_data=MgMeetingPlannerFom.new(meeting_planner_datas)
  # start_time_hour=params[:start_time]["game_time(4i)"]
  # start_time_hour_min=params[:start_time]["game_time(5i)"]
  # start_time=start_time_hour+":"+start_time_hour_min+":00";
  # end_time_hour=params[:end_time]["game_time(4i)"]
  # end_time_hour_min=params[:end_time]["game_time(5i)"]
  # end_time=end_time_hour+":"+end_time_hour_min+":00";
  # meeting_planner_data.start_time=start_time
  # meeting_planner_data.end_time=end_time
  #meeting_planner_data.status="Pending"
  start_date_time=DateTime.parse(params[:meeting_planner][:start_date_of_meeting])
  end_date_time=DateTime.parse(params[:meeting_planner][:end_date_of_meeting])
  date_start,date_end=change_date_format(start_date_time,end_date_time)

  if meeting_planner_data.save
    meeting_planner_data.update(:start_date_of_meeting=>date_start,:end_date_of_meeting=>date_end,:is_principal=>0)
    flash[:notice]="Data has saved successfully."
  else
    flash[:notice]="Data not saved."
  end
  redirect_to :action=>"meeting_plan"
end

def meeting_plan_edit
  @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
end


def meeting_plan_update
  meeting_planner_data=MgMeetingPlannerFom.find_by(:id=>params[:id])
  if meeting_planner_data.update(meeting_planner_datas)
    # start_time_hour=params[:start_time]["game_time(4i)"]
    # start_time_hour_min=params[:start_time]["game_time(5i)"]
    # start_time=start_time_hour+":"+start_time_hour_min+":00";
    # end_time_hour=params[:end_time]["game_time(4i)"]
    # end_time_hour_min=params[:end_time]["game_time(5i)"]
    # end_time=end_time_hour+":"+end_time_hour_min+":00";
    # meeting_planner_data.update(:start_time=>start_time,:end_time=>end_time)
    # #meeting_planner_data.end_time=end_time
    # #meeting_planner_data.status="Pending"
    # @timeformat = MgSchool.find(session[:current_user_school_id])
    # @date = Date.strptime(params[:meeting_planner][:date_of_meeting],@timeformat.date_format)
    # #if meeting_planner_data.save
    start_date_time=DateTime.parse(params[:meeting_planner][:start_date_of_meeting])
    end_date_time=DateTime.parse(params[:meeting_planner][:end_date_of_meeting])
    date_start,date_end=change_date_format(start_date_time,end_date_time)

    meeting_planner_data.update(:start_date_of_meeting=>date_start,:end_date_of_meeting=>date_end)
    flash[:notice]="Data updated successfully."
  else
    flash[:notice]="Data not saved."
  end
redirect_to :action=>"meeting_plan"
end


def meeting_plan_show
   @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
end

def meeting_plan_delete
  @meeting_planner=MgMeetingPlannerFom.find_by(:id=>params[:id])
  @meeting_planner.update(:is_deleted=>1, :updated_by=>session[:user_id])
  redirect_to :action=>"meeting_plan"
end


# ================================================



  def index
    @front_office_manager=MgUser.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:user_type=>"front_office_manager").paginate(page: params[:page], per_page: 10)
  end

  def new
    render :layout=>false
  end

  def create
    school_subdomain= MgSchool.where(:id=>session[:current_user_school_id],:is_deleted=>0)
    @subdomain = school_subdomain[0].subdomain
    @user_name = @subdomain + params[:financial_manager][:user_name]
    @user_role_save=[] #add
    MgUser.transaction do #add
      front_office_manager=MgUser.new(params_user)
      front_office_manager.user_name=@user_name
      @user_role_save.push(front_office_manager.save) #add
      role=MgRole.find_by(:role_name=>"front_office_manager")
      if role.id.present?
        @user_role = front_office_manager.mg_user_roles.build(:mg_role_id => role.id)
        @user_role_save.push(@user_role.save) #add
      end
      if @user_role_save.include?(false) #add
        raise ActiveRecord::Rollback #add
      end #add
    end

    if @user_role_save.include?(false) #add
      flash[:error] = "There is some problem" #add
    else #add
      flash[:notice] = "Front Office Manager Created Successfully" #add
    end #add
    redirect_to :action=> "index"
  end

  def show
    @front_office_obj=MgUser.find_by(:id=>params[:id])
    render :layout=>false
  end

  def change_front_office_manager_password

    @boolean_val=false
    @fff = params[:financial_manager]
    @curr = @fff[:name]
    id=@fff[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)
      @pass = params[:financial_manager]
      @passw = @pass[:password]  #new pass
      @rpass = params[:financial_manager]  
      @rpassw = @rpass[:hashed_password] #confirm pass
      if @passw==@rpassw
        if @user
          @userMe=MgUser.find(id)
          @userMe.update(password_params)
        end  
      else
        flash[:notice] = "Re Entered password didn't matched !"
      end
      flash[:notice] = "Password Change Successfully..."
    #if params[:change_financial_password]=="change_password_by_admins"
      redirect_to :action => "index"
    # elsif params[:change_financial_password]=="change_password_by_manager"
    #   redirect_to :action => "change_credential"
    # end

  end

  def edit
    @financial_manager=MgUser.find_by(:id=>params[:id])
    render :layout=>false
  end

  def update
    @user_name = params[:subdomain] + params[:financial_manager][:user_name]
    financial_manager=MgUser.find_by(:id=>params[:financial_manager][:id])
    #financial_manager.update(params_user_update)

    if financial_manager.update(:user_name=>@user_name)
      flash[:notice]="Manager updated successfully."
    else
      flash[:error]="Error occured,Please try later."
    end
    # if params[:change_financial_username]=="change_username_by_admins"
      redirect_to :action=> "index"
    # elsif params[:change_financial_username]=="change_username_by_manager"
    #   redirect_to :action=> "change_credential"
    # end
        
  end

  def delete
    front_office_manager=MgUser.find_by(:id=>params[:id])
    front_office_manager.update(:is_deleted=>1)
    redirect_to :action=> "index"
  end

    def unique_username
    school_subdomain= MgSchool.where(:id=>session[:current_user_school_id],:is_deleted=>0)
    @subdomain = school_subdomain[0].subdomain
    @user_name = @subdomain + params[:user_name]
    @user_validate = MgUser.where("is_deleted=? and mg_school_id=? and user_name=?",0,session[:current_user_school_id],@user_name)
    if @user_validate.present?
      @data=1
    else
      @data=0
    end
    respond_to do |format|
      format.json  { render :json => @data.to_json }
    end
  end


  # kumar ends=================================================================
  def directory_search
  end

  def fom_all_search_data
    split_data=params[:temp_val]
    array_data=split_data.to_s.split(" ")
    str=""
    if (params[:search_by]=="Name")
      for s in 0..array_data.size-1
        str +=" first_name LIKE '%#{array_data[s]}%' or last_name LIKE '%#{array_data[s]}%'"
        if s<array_data.size-1
          str+=" or "
        end
      end

      @student_data=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
      puts @student_data.inspect
      @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
      puts @employee_data.inspect


      @guardian_data=MgGuardian.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
      puts @guardian_data.inspect


      @address_book_data=MgAddressBookFom.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(" name LIKE ?","%#{params[:temp_val]}%")
      puts @address_book_data.inspect

        #puts agsjdgasdjg
    elsif(params[:search_by]=="phone number")

   
      for s in 0..array_data.size-1
        str +=" phone_number LIKE '%#{array_data[s]}%'"
        if s<array_data.size-1
          str+=" or "
        end
      end


      phone_data=MgPhone.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str).pluck(:mg_user_id)

      @student_data=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
      puts @student_data.inspect
      @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
      puts @employee_data.inspect


      @guardian_data=MgGuardian.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
      puts @guardian_data.inspect


      @address_book_data=MgAddressBookFom.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where("contact_number LIKE ?","%#{params[:temp_val]}%")
      puts @address_book_data.inspect
    elsif(params[:search_by]=="email_id")

   
      for s in 0..array_data.size-1
        str +=" mg_email_id LIKE '%#{array_data[s]}%'"
        if s<array_data.size-1
          str+=" or "
        end
      end


      phone_data=MgEmail.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str).pluck(:mg_user_id)

      @student_data=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
      puts @student_data.inspect
      @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
      puts @employee_data.inspect


      @guardian_data=MgGuardian.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
      puts @guardian_data.inspect


      @address_book_data=MgAddressBookFom.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where("email_id LIKE ?","%#{params[:temp_val]}%")
      puts @address_book_data.inspect
    elsif(params[:search_by]=="Designation")
      for s in 0..array_data.size-1
        str +=" user_type LIKE '%#{array_data[s]}%'"
        if s<array_data.size-1
          str+=" or "
        end
      end


      user_data=MgUser.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str).pluck(:id)
      
      
      hod_data=MgExaminationHodLogin.where(:mg_user_id=>user_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_id).uniq
      library_employee=MgLibraryEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where( "designation LIKE '%#{array_data[s]}%'").pluck(:mg_employee_id)

      @student_data=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>user_data)
      puts @student_data.inspect
      if hod_data.present?
        @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>hod_data)
        puts @employee_data.inspect
      elsif library_employee.present?
        @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>library_employee)
      else
        @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>user_data)
      end
      @guardian_data=MgGuardian.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>user_data)
      puts @guardian_data.inspect
      @address_book_data=MgAddressBookFom.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where("designation LIKE ?","%#{params[:temp_val]}%")
      puts @address_book_data.inspect
    end
    render :layout=>false
  end

  def address_book
  @address_book_data=MgAddressBookFom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def address_book_new

  end

  def address_book_create
  address_book_data=MgAddressBookFom.new(address_book_params)

  if address_book_data.save
    flash[:notice]="Successfully saved"
    redirect_to :action=>"address_book"

    else
      flash[:notice]="Data not saved"
    redirect_to :action=>"address_book_new"

    end
  end

  def address_book_show
    @show_address_book_data=MgAddressBookFom.find_by(:id=>params[:id])
    render :layout=>false
  end

  def address_book_edit
    @address_book=MgAddressBookFom.find_by(:id=>params[:id])
  end

  def address_book_update
    address_data_update=MgAddressBookFom.find_by(:id=>params[:id])
    if address_data_update.update(address_book_params_update)
      flash[:notice]="Successfully updated"
   else
    flash[:notice]="Data has not updated"
   end
   redirect_to :action=>"address_book"
  end
  def address_book_destroy
    address_data_update=MgAddressBookFom.find_by(:id=>params[:id])
    address_data_update.is_deleted=1
    if address_data_update.save
      flash[:notice]="Record has successfully deleted"
    else
      flash[:notice]="Record has not deleted"
   end
    redirect_to :action=>"address_book"
  end

  def postal_records
    @postal_recordz = MgPostalRecord.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#.order("received_date DESC").paginate(page: params[:page], per_page: 10)
  end

  def new_postal_record
    @postal_record = MgPostalRecord.new
  end

  def create_postal_record
    variabl = []
    @postal_record =MgPostalRecord.new(postal_record)
    if @postal_record.save
      if params[:postal_record][:received_date] .present?
        current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
        received_date =Date.strptime(params[:postal_record][:received_date],current_school.date_format)
        @postal_record.update(:received_date=>received_date)
        variabl.push(true)
      end
      if params[:postal_record][:user_type]=="student" && params[:postal_record][:transaction_flow]=="outbound"
        @postal_record.update(:user_type=>params[:postal_record][:user_type],:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id])
      elsif params[:postal_record][:user_type]=="employee" && params[:postal_record][:transaction_flow]=="outbound"
        @postal_record.update(:user_type=>params[:postal_record][:user_type],:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id])
      end
      # ===========================================================================================
      if params[:postal_record][:user_type]=="student" && params[:postal_record][:transaction_flow]=="inbound"
        @postal_record.update(:user_type=>params[:postal_record][:user_type],:mg_batch_id=>params[:mg_inbound_batch_id],:mg_student_id=>params[:mg_inbound_student_id],:recipient_name=>params[:inbound_recipient_name],:address=>params[:inbound_address])
      elsif params[:postal_record][:user_type]=="employee" && params[:postal_record][:transaction_flow]=="inbound"
        @postal_record.update(:user_type=>params[:postal_record][:user_type],:mg_employee_department_id=>params[:mg_inbound_employee_department_id],:mg_employee_id=>params[:mg_inbound_employee_id],:recipient_name=>params[:inbound_recipient_name],:address=>params[:inbound_address])
      end
      # ===========================================================================================
    end
    if variabl.include?(true)
      flash[:notice]="Successfully Created"
    else
      flash[:error]="There is some problem"
    end
    redirect_to :action=>'postal_records'
  end

  def show_postal_record
    @postal_record = MgPostalRecord.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def edit_postal_record
    @postal_record = MgPostalRecord.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def update_postal_record
    variabl = []
    postal_records = MgPostalRecord.where(:id=>params[:id])
    #@postal_record =postal_record.update(postal_record)
    if postal_records[0].update(postal_record)
      if params[:postal_record][:received_date] .present?
        current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
        received_date =Date.strptime(params[:postal_record][:received_date],current_school.date_format)
        postal_records[0].update(:received_date=>received_date)
        variabl.push(true)
      end
      if params[:postal_record][:user_type]=="student" && params[:postal_record][:transaction_flow]=="outbound"
        postal_records[0].update(:user_type=>params[:postal_record][:user_type],:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id])
      elsif params[:postal_record][:user_type]=="employee" && params[:postal_record][:transaction_flow]=="outbound"
        postal_records[0].update(:user_type=>params[:postal_record][:user_type],:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id])
      end
      # ===========================================================================================
      if params[:postal_record][:user_type]=="student" && params[:postal_record][:transaction_flow]=="inbound"
        postal_records[0].update(:user_type=>params[:postal_record][:user_type],:mg_batch_id=>params[:mg_inbound_batch_id],:mg_student_id=>params[:mg_inbound_student_id],:recipient_name=>params[:inbound_recipient_name],:address=>params[:inbound_address])
      elsif params[:postal_record][:user_type]=="employee" && params[:postal_record][:transaction_flow]=="inbound"
        postal_records[0].update(:user_type=>params[:postal_record][:user_type],:mg_employee_department_id=>params[:mg_inbound_employee_department_id],:mg_employee_id=>params[:mg_inbound_employee_id],:recipient_name=>params[:inbound_recipient_name],:address=>params[:inbound_address])
      end
      # ===========================================================================================
    end
    if variabl.include?(true)
      flash[:notice]="Successfully Updated"
    else
      flash[:error]="There is some problem"
    end
    redirect_to :action=>'postal_records'
  end

  def delete_postal_record
    postal_record = MgPostalRecord.find_by(:id=>params[:id])
    postal_record.update(:is_deleted=>1,:updated_by=>session[:user_id])
    flash[:notice]="Successfully deleted"
    redirect_to :action=>'postal_records'
  end

  def record_excel
    puts "1111111111111111111111111111"
    puts params[:array].split(',')
    puts "1111111111111111111111111111"

    if params[:array].present?
      @postal_record=MgPostalRecord.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],params[:array].split(','))
      #@inventory_proposals=MgPostalRecord.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],params[:array])
    end

    respond_to do |format|
      format.html
      format.xls do
        # response.headers['Content-Disposition'] = 'attachment; filename="' + " Payroll report" + '.xls"'
        response.headers['Content-Disposition'] = 'attachment; filename="' + "Postal Record" + '.xls"'
        render "record_excel.xls.erb"
      end
    end
  end


  

  def query_record_excel
    @ids=params[:array].split(",")
    @ids.each do |ids|
      puts"1111111111111111"
      MgQueryRecord.find_by(:id=>ids).update(:is_principal_required=>0,:updated_by=>session[:user_id])
    end
    flash[:notice]="Successfully Updated"
    redirect_to :back
  #   mg_school_id=session[:current_user_school_id]
      #puts params[:array]
  #   FoQuery.new(mg_school_id,params[:array])
  #   send_file File.exists?(File.join(Rails.root, "public/xlsx_files", "foquery.xlsx")) ? File.join(Rails.root, "public/xlsx_files", "foquery.xlsx") : File.join(Rails.root, "public/xlsx_files", "gate_pass_error.xlsx"), :type => "application/vnd.ms-excel", :filename => "(#{Date.today})foquery.xlsx", :stream => false#, :readonly=>true
  #

  end




  def room_creation_index
    @room_creation_data=MgMeetingRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order(:room_no)
  end

  def room_creation_new
    render :layout=>false
  end

  def room_creation_create
    room_creation_params=MgMeetingRoom.new(room_creation_params_data)
    if room_creation_params.save
      flash[:notice]= "Room Number has saved..."
    else
      flash[:notice]="Room Number has not saved..."
    end
  redirect_to :action=> "room_creation_index"
  end


  def room_creation_delete
    delete_room_creation_data=MgMeetingRoom.find(params[:id])
    delete_room_creation_data.is_deleted=1
    delete_room_creation_data.save
    flash[:notice] = "Successfully Deleted..."

    redirect_to :action=>"room_creation_index"
    
  end

  def room_creation_update
    update_data=MgMeetingRoom.find(params[:id])
    if update_data.update(update_room_creation_params_data)
      flash[:notice] = "Successfully Updated..."
    else
    flash[:notice] = "Not Updated..."
    end
    redirect_to :action=>"room_creation_index"
  end

  def room_creation_edit
    @room_creation_type=MgMeetingRoom.find(params[:id])
    render :layout=>false
  end

  def meeting_detail
    @meeting_detail = MgMeetingDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def room_book
    @room_list = MgMeetingRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:room_no,:id)
    # @employee_list = MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:first_name,:id)

    @employee_array = MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @employee_list=Array.new
    @employee_array.each do |emp|
      employee_data=Array.new
      employee_data.push("#{emp.employee_number}-#{emp.first_name.capitalize.to_s} #{emp.last_name.capitalize.to_s}",emp.id)
      @employee_list.push(employee_data)
    end

  end

  def room_list
    @room_list = MgMeetingRoom.where("is_deleted=? and mg_school_id=? and capacity>=?",0,session[:current_user_school_id],params[:number_of_attendees]).order(:capacity)
    @room_list.map{|roomObj| roomObj.room_no=roomObj.room_no.to_s + " (".to_s + roomObj.capacity.to_s + ")".to_s}
    respond_to do |format|
      format.json  { render :json => @room_list}
    end
  end

  def create_booking
    variabl = []
    @meeting_detail =MgMeetingDetail.new(meeting_detail_params)
    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
    start_date =Date.strptime(params[:meeting_detail][:start_date],current_school.date_format)
    end_date =Date.strptime(params[:meeting_detail][:end_date],current_school.date_format)
    @meeting_detail.start_date=start_date
    @meeting_detail.end_date=end_date
    #@meeting_detail.update(:start_date=>start_date,:end_date=>end_date)
    if @meeting_detail.save
      if params[:meeting_detail][:start_date] .present? && params[:meeting_detail][:end_date] .present?
        # current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
        # start_date =Date.strptime(params[:meeting_detail][:start_date],current_school.date_format)
        # end_date =Date.strptime(params[:meeting_detail][:end_date],current_school.date_format)
        # @meeting_detail.update(:start_date=>start_date,:end_date=>end_date)
        variabl.push(true)
      end
      @meeting_detail.update(:is_cancelled=>0)
    end
    if variabl.include?(true)
      flash[:notice]="Successfully Created"
    else
      flash[:error]="start time end time should not overlap"
    end
    redirect_to :action=>'meeting_detail'
  end
  def edit_booking
    @meeting_detail = MgMeetingDetail.find_by(:id=>params[:id])
    @room_list = MgMeetingRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#.pluck(:room_no,:id)
    @room_list.map{|roomObj| roomObj.room_no=roomObj.room_no.to_s + " (".to_s + roomObj.capacity.to_s + ")".to_s}
    bigArray=[]
    @room_list.each do |roomobj|
      smallArray=[]
      smallArray.push("#{roomobj.room_no}")
      smallArray.push("#{roomobj.id}")
    bigArray.push(smallArray)
    end
    @room_list=bigArray
    @employee_list = MgEmployee.where(:id=>@meeting_detail.mg_employee_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:first_name,:id)
  end

  def update_booking
    variabl = []
    @meeting_detail = MgMeetingDetail.find_by(:id=>params[:id])
    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
    start_date =Date.strptime(params[:meeting_detail][:start_date],current_school.date_format)
    end_date =Date.strptime(params[:meeting_detail][:end_date],current_school.date_format)
    @meeting_detail.update(:start_date=>start_date,:end_date=>end_date)
    if params[:is_cancelled].present?
      @meeting_detail.update(:is_cancelled=>params[:is_cancelled])
    end
    variabl.push(@meeting_detail.update(update_meeting_detail_params))
      # if params[:meeting_detail][:start_date] .present? && params[:meeting_detail][:end_date] .present?
      #   current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
      #   start_date =Date.strptime(params[:meeting_detail][:start_date],current_school.date_format)
      #   end_date =Date.strptime(params[:meeting_detail][:end_date],current_school.date_format)
      #   @meeting_detail.update(:start_date=>start_date,:end_date=>end_date)
      #   variabl.push(true)
      # end
    if variabl.include?(true)
      flash[:notice]="Successfully Updated"
    else
      flash[:error]="There is some problem"
    end
    redirect_to :action=>'meeting_detail'
  end

  def show_meeting_detail
    @meeting_detail = MgMeetingDetail.find_by(:id=>params[:id],:is_deleted=>0)
  end

  def delete_booking
    meeting_detail = MgMeetingDetail.find_by(:id=>params[:id])
    meeting_detail.update(:is_deleted=>1,:updated_by=>session[:user_id])
    flash[:notice]="Successfully deleted"
    redirect_to :action=>'meeting_detail'
  end
  
  def caller_category
    @caller_category = MgCallerCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def new_caller_category
    @caller_category = MgCallerCategory.new
    render :layout=>false
  end

  def create_caller_category
    caller_category=MgCallerCategory.new(caller_category_params)
    if caller_category.save
      flash[:notice]="Successfully Created"
    else
      flash[:error]="There is some problem"
    end
    redirect_to :action=>'caller_category'
  end

  def edit_caller_category
    @caller_category=MgCallerCategory.find_by(:id=>params[:id])
    render :layout=>false
  end

  def update_caller_category
    caller_category=MgCallerCategory.find_by(:id=>params[:id])
    if caller_category.update(caller_category_params)
      flash[:notice]="Successfully Updated"
    else
      flash[:error]="There is some problem"
    end
    redirect_to :action=>'caller_category'
  end

  def show_caller_category
    @caller_category=MgCallerCategory.find_by(:id=>params[:id])
    render :layout=>false
  end
  def delete_caller_category
    caller_category=MgCallerCategory.find_by(:id=>params[:id])
    if caller_category.update(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice]="Successfully Deleted"
    else
      flash[:error]="There is some problem"
    end
    redirect_to :action=>'caller_category'
  end

  def user_detail
    @user_detail=MgUser.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:user_type=>"front_office_manager")
  end

  def edit_user_detail
    @user_id=MgUser.find_by(:id=>params[:id])
    render :layout=>false
  end

  def update_user_detail
    puts params
    @fff = params[:front_office_pass]
    id=@fff[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)
    @pass = params[:front_office_pass]
    @passw = @pass[:password]  
    @rpass = params[:front_office_pass]  
    @rpassw = @rpass[:hashed_password] 
    if @passw==@rpassw
      if @user
        @userMe=MgUser.find(id)
        @userMe.update(pass_change_params)
      end  
    else
      flash[:notice] = "Re Entered password didn't matched !"
    end
    flash[:notice] = "Password Change Successfully..."
    redirect_to :action => "user_detail"
  end

  def room_overlapping_details
    puts "================================================================"
    @timeformat = MgSchool.find(session[:current_user_school_id])
    start_date = Date.strptime(params[:start_date],@timeformat.date_format)
    if params[:end_date].present?
      end_date = Date.strptime(params[:end_date],@timeformat.date_format)
    end
    if params[:is_start_date]=="yes"
      puts "0000000000000000000000000000000000000000000000"
      if params[:end_date].present?
        puts "end date present;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
          @overlapObj=MgMeetingDetail.where("((start_date <= '#{end_date}' AND end_date >= '#{end_date}') OR (start_date <= '#{start_date}' AND end_date >= '#{start_date}')) AND mg_meeting_room_id=#{params[:room_id]} AND is_deleted=#{0} AND mg_school_id=#{session[:current_user_school_id]} ")
      else
        puts "end date not present;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"

          @overlapObj=MgMeetingDetail.where("start_date <= '#{start_date}' AND end_date >= '#{start_date}' AND mg_meeting_room_id=#{params[:room_id]} AND is_deleted=#{0} AND mg_school_id=#{session[:current_user_school_id]}")
      end
    elsif params[:is_start_date]=="no"
      end_date = Date.strptime(params[:end_date],@timeformat.date_format)
      # @overlapObj=MgMeetingDetail.where("((start_date <= '#{end_date}' AND end_date >= '#{end_date}') OR (start_date <= '#{start_date}' AND end_date >= '#{start_date}')) AND mg_meeting_room_id=#{params[:room_id]} AND is_deleted=#{0} AND mg_school_id=#{session[:current_user_school_id]} ")
      @overlapObj=MgMeetingDetail.where("((end_date >= '#{start_date}' AND end_date <= '#{end_date}') OR (start_date >= '#{start_date}' AND start_date <= '#{end_date}') OR (start_date <= '#{end_date}' AND end_date >= '#{end_date}') OR (start_date <= '#{start_date}' AND end_date >= '#{start_date}')) AND mg_meeting_room_id=#{params[:room_id]} AND is_deleted=#{0} AND mg_school_id=#{session[:current_user_school_id]} ")
      
    end
    render :layout=>false
  end
 
  def room_availibility
    test_obj=false
    @timeformat = MgSchool.find(session[:current_user_school_id])
    start_date = Date.strptime(params[:start_date],@timeformat.date_format)
    end_date = Date.strptime(params[:end_date],@timeformat.date_format)
    send_param=MgMeetingDetail.myprm(start_date,end_date)
    # puts asd
    if params[:update_url]!="update_url"
      MgMeetingDetail.transaction do
        obj=MgMeetingDetail.new
        obj.start_date=start_date
        obj.end_date=end_date
        obj.start_time=params[:start_time]
        obj.end_time=params[:end_time]
        obj.is_deleted=0
        obj.mg_school_id=session[:current_user_school_id]
        obj.mg_meeting_room_id=params[:room_id]
        test_obj=obj.save
        raise ActiveRecord::Rollback#, "Call tech support!"
      end
    else
      MgMeetingDetail.transaction do
        @meeting_detail = MgMeetingDetail.find_by(:id=>params[:id])
        test_obj = @meeting_detail.update(:start_date=>start_date,:end_date=>end_date,:start_time=>params[:start_time],:end_time=>params[:end_time],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_meeting_room_id=>params[:room_id])
        raise ActiveRecord::Rollback#, "Call tech support!"
      end
    end

    render :json=>{:test_result=>test_obj}
  end

# ====================Action Required============================

  def action_required_index
    @action_required_data=MgActionRequired.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def action_required_new
    render :layout=>false
  end

  def action_required_create
    action_req_par=MgActionRequired.new(action_required_params_data)
    if action_req_par.save
      flash[:notice]= "Action required saved successfully"
    else
      flash[:notice]="Action required has not saved..."
    end
    redirect_to :action=> "action_required_index"
  end


  def action_required_delete
    delete_action_required_data=MgActionRequired.find(params[:id])
    delete_action_required_data.is_deleted=1
    delete_action_required_data.save
    flash[:notice] = "Successfully Deleted..."
    redirect_to :action=>"action_required_index"
  end

  def action_required_update
    update_data=MgActionRequired.find(params[:id])
    if update_data.update(update_action_required_params_data)
      flash[:notice] = "Successfully Updated..."
    else
    flash[:notice] = "Not Updated..."
    end
    redirect_to :action=>"action_required_index"
  end

  def action_required_edit
    @action_required_type=MgActionRequired.find(params[:id])
    render :layout=>false
  end

  def action_required_show
    @action_required_data=MgActionRequired.find(params[:id])
    render :layout=>false
  end

# ====================================================================

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



  private
  def address_book_params
    params.require(:address_book).permit(:name,:Address,:contact_number,:designation,:email_id,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end
  def address_book_params_update
    params.require(:address_book).permit(:name,:Address,:contact_number,:designation,:email_id,:updated_by)
  end
  def meeting_planner_datas
    params.require(:meeting_planner).permit(:meeting_with,:purpose,:description,:status,:remark,:principal_remark,:mg_school_id,:created_by,:updated_by,:is_deleted)
  end
  def postal_record
    params.require(:postal_record).permit(:recipient_name,:address,:dispatch_number,:transaction_flow,:received_date,
      :mode_of_dispatch,:category,:dispatcher,:mg_school_id,:created_by,:updated_by,:is_deleted)
  end
  def room_creation_params_data
    params.require(:room_creation_type).permit(:type_of_room,:capacity,:room_no,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end


  
  def update_room_creation_params_data
    params.require(:room_creation_type).permit(:type_of_room,:capacity,:room_no,:is_deleted,:mg_school_id,:updated_by)
  end

  def meeting_detail_params
    params.require(:meeting_detail).permit(:number_of_attendees,:mg_meeting_room_id,:start_date,:start_time,:end_date,:end_time,:mg_employee_id,:meeting_purpose,:is_deleted,:mg_school_id,:updated_by,:created_by)
  end

  def update_meeting_detail_params
    params.require(:meeting_detail).permit(:number_of_attendees,:mg_meeting_room_id,:start_time,:end_time,:mg_employee_id,:meeting_purpose,:is_deleted,:mg_school_id,:updated_by,:created_by)
  end

  def password_params
    params.require(:financial_manager).permit(:password)
  end

  def type_of_query_params_data
    params.require(:type_of_query_type).permit(:name,:description,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end
  def update_type_of_query_params_data
    params.require(:type_of_query_type).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by)
  end

  def caller_category_params_data
    params.require(:caller_category_type).permit(:name, :description, :is_deleted,:mg_school_id,:created_by,:updated_by)
  end

  def update_caller_category_params_data
    params.require(:caller_category_type).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by)
  end

  def query_record_params_data
    params.require(:query_record_type).permit(:mg_caller_category_id,:query_number,:date_of_query,:caller_name, :phone_number,:mg_caller_category_fom_id,:query,:mg_fom_query_record_id,:response_given,:follow_up_action,:action_required,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end

  def update_query_record_params_data
    params.require(:query_record_type).permit(:query_number,:caller_name, :phone_number,:mg_caller_category_fom_id,:query,:mg_fom_query_record_id,:response_given,:follow_up_action,:action_required,:is_deleted,:mg_school_id,:updated_by)
  end

  def guest_room_booking_params_data
    params.require(:guest_room_booking_type).permit(:remark,:mg_fom_room_creation_id,:mg_employee_category_id,:purpose,:status,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end

  def update_guest_room_booking_params_data
    params.require(:guest_room_booking_type).permit(:remark,:mg_fom_room_creation_id,:mg_employee_category_id,:purpose,:status,:is_deleted,:mg_school_id,:updated_by)
  end

  def transport_booking_params_data
    params.require(:transport_booking_type).permit(:date_of_booking,:transport_time,:place_from,:place_to,:way_mode,:purpose,:mg_employee_category_id,:status,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end

  def update_transport_booking_params_data
    params.require(:transport_booking_type).permit(:remark,:date_of_booking,:transport_time,:place_from,:place_to,:way_mode,:purpose,:mg_employee_category_id,:status,:mg_school_id,:is_deleted,:updated_by)
    
  end

  def caller_category_params
    params.require(:caller_category).permit(:name,:description,:mg_school_id,:is_deleted,:updated_by,:created_by)
  end
  def params_faq_category
    params.require(:category).permit(:category_name, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end

  def params_faq_sub_category
    params.require(:category).permit(:mg_faq_category_id, :sub_category_name, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end

  def params_faq
    params.require(:category).permit(:question, :answer, :mg_faq_category_id, :mg_faq_sub_category_id, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end

  def pass_change_params
    params.require(:front_office_pass).permit(:password)
  end

  def params_user
    params.require(:financial_manager).permit(:is_deleted,:mg_school_id,:created_by,:updated_by,:user_type,:user_name,:password)
  end

  def action_required_params_data
    params.require(:action_required_type).permit(:description,:action_required,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end

  def update_action_required_params_data
    params.require(:action_required_type).permit(:description,:action_required,:is_deleted,:mg_school_id,:updated_by)
  end

end
