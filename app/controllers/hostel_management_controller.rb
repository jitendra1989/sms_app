class HostelManagementController < ApplicationController

  before_filter :login_required
     layout "mindcom"

def discipline_report_admin
  if params[:id].present?
@data=params[:id]
  else
@data=0
  end
@discipline_report=MgHostelDisciplineReport.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])


end


def filter_hostel_data
if params[:id].present?
@discipline_report=MgHostelDisciplineReport.where(:mg_hostel_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
else
  @discipline_report=MgHostelDisciplineReport.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

end


render :layout=>false
end


def discipline_report_admin_show
  @discipline_report=MgHostelDisciplineReport.find_by(:id=>params[:id])
  render :layout=>false
end

def discipline_report_admin_update
  puts"0000000000000000000000"
  puts params
  puts"0000000000000000000000"
  report_data=MgHostelDisciplineReport.find_by(:id=>params[:id])
  report_data.action_to_be_taken=params[:action_to_be_taken]
  report_data.status=params[:status_data_admin]
  report_data.save
  redirect_to :action=>"discipline_report_admin",:id=>report_data.mg_hostel_details_id
end

def hostel_admin_complain_hostel_show
  @complain_hostel=MgComplainHostel.find(params[:id])
  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  @student_form_data=MgAllocateRoomList.find_by(:mg_student_id=>@complain_hostel.mg_student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @allocate_room_data=MgAllocateRoom.find_by(:id=>@student_form_data.mg_allocate_room_id)
  render :layout=>false
end


def hostel_issues_list
  if params[:id].present?
      @data=params[:id]
      @complain_hostel=MgComplainHostel.where(:mg_hostel_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @health_name_data1=MgComplainHostel.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).uniq(:mg_hostel_details_id).pluck(:mg_hostel_details_id)
      @hostel_uniq_data=MgHostelDetails.where("id IN (?)",@health_name_data1).pluck(:name,:id)
  else
      @data=0
      @complain_hostel=MgComplainHostel.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @health_name_data1=MgComplainHostel.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).uniq(:mg_hostel_details_id).pluck(:mg_hostel_details_id)
      @hostel_uniq_data=MgHostelDetails.where("id IN (?)",@health_name_data1).pluck(:name,:id)
  end
end

def discipline_report
  hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])        

@discipline_report=MgHostelDisciplineReport.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id)

end

def discipline_report_new


end

def discipline_report_ajax
    if params[:floor]=="floor"
      rooms_data=MgHostelRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>params[:hostel_id],:mg_hostel_floor_id=>params[:floor_data])
      str=""
        rooms_data.each do |s|
          str +="<option value='#{s.try(:id)}'>#{s.try(:name)}</option>"
        end

   @object=str

    elsif params[:room]=="room"
      rooms_data=MgAllocateRoomList.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_floor_id=>params[:floor_data],:mg_hostel_room_id=>params[:room_id]).pluck(:mg_student_id).uniq
      student_data=MgStudent.where(:id=>rooms_data)

      str=""

      student_data.each do |s|
            str +="<option value='#{s.try(:id)}'>(#{s.try(:admission_number)})#{s.try(:first_name)} #{s.try(:last_name)}  </option>"
      end

      @object=str

    end

    respond_to do |format|
            format.json  { render :json => {main: @object, sub: ""} }
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

def disciplanary_report_show
@discipline_report=MgHostelDisciplineReport.find_by(:id=>params[:id])

  end

  def disciplanary_report_edit
@discipline_report=MgHostelDisciplineReport.find_by(:id=>params[:id])

  end

  def discipline_report_update


    report_data=MgHostelDisciplineReport.find_by(:id=>params[:id])
     report_data.reason=params[:reason] 
     report_data.save
 @params=params[:selected_employees]
 # puts params[:selected_employees].inspect
 #logger.infoJHDG

  school_id=session[:current_user_school_id]
 for j in 0...@params.size

   list_data=MgHostelDisciplineReportList.where('mg_hostel_discipline_report=? and mg_school_id=? and  mg_student_id=?', params[:id],school_id,@params[j])

 if list_data.size<1

    @data=MgHostelDisciplineReportList.new()
    @data.is_deleted=0
    @data.created_by=session[:user_id]
    @data.mg_student_id=@params[j]
    @data.mg_hostel_discipline_report=params[:id]
    @data.mg_school_id=school_id

    @data.save
  else
        list_data[0].update(:is_deleted=>0,:mg_school_id=>school_id)

      end
    end

  list_data=MgHostelDisciplineReportList.where('mg_hostel_discipline_report=? and is_deleted=? and mg_school_id=? and  mg_student_id  NOT IN (?)',params[:id],0,school_id,params[:selected_employees])
  #     puts library_employee_data.inspect 

 if list_data.length>0
    for j in 0...list_data.length
     
     data=MgHostelDisciplineReportList.find_by(:id=>list_data[j].id)
     if data.present?
    data.update(:is_deleted=>1)
   end
  end
   end
    #flash[:success]="Data has Updated"

   redirect_to :action=>'discipline_report'

  end
  def discipline_report_destroy

    report_data=MgHostelDisciplineReport.find_by(:id=>params[:id])
    report_data.is_deleted=1
    report_data.save
    lists_data=MgHostelDisciplineReportList.where(:mg_hostel_discipline_report=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    lists_data.each do |list|
    list.is_deleted=1
    list.save
  end
     redirect_to :action=>'discipline_report'

  end
def warden_re_allocate_rooms
hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

@reallotment_request=MgHostelReallotmentRequest.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:status=>"Applied",:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id)
end
def reallocation_show
@student_details_data=MgHostelReallotmentRequest.find_by(:id=>params[:id])
render :layout=>false
end



def room_reallotment_request
  student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
  # @student_details_data=MgHostelReallotmentRequest.find_by(:mg_student_id=>student_data.id)
  # @student_details_data=MgHostelReallotmentRequest.find_by(:mg_student_id=>student_data.id)
  @student_details_data=MgHostelReallotmentRequest.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:mg_student_id=>student_data.id).paginate(page: params[:page], per_page: 10)
end



def room_reallotment_form_show
    @student_details_data=MgHostelReallotmentRequest.find_by(:id=>params[:id])
    # @student_details_data=MgHostelReallotmentRequest.find_by(:mg_student_id=>student_data.id)
end


def room_reallotment_form_delete
    @student_details_data=MgHostelReallotmentRequest.find_by(:id=>params[:id])
    @student_details_data.update(:is_deleted=>1)
    redirect_to :back
    # @student_details_data=MgHostelReallotmentRequest.find_by(:mg_student_id=>student_data.id)
end





  def room_reallotment_request_update
      if params[:status_data]=="Rejected"
      allotment_request=MgHostelReallotmentRequest.find_by(:id=>params[:reallotment])
      allotment_request.status="Rejected"
      allotment_request.save
      elsif params[:status_data]=="Accepted"
          rooms_data=MgHostelRoom.find_by(:id=>params[:previous_room])
          rooms_data.availability=rooms_data.availability+1
          rooms_data.save
          rooms=MgHostelRoom.find_by(:id=>params[:mg_hostel_room])
          rooms.availability=rooms.availability-1
          rooms.save

          allotment_request=MgHostelReallotmentRequest.find_by(:id=>params[:reallotment])
          allotment_request.status="Accepted"
          allotment_request.mg_hostel_room_id=params[:previous_room]
          allotment_request.mg_hostel_floor_id=rooms.mg_hostel_floor_id
          allotment_request.mg_hostel_room_type_id=rooms.mg_hostel_room_type_id
          allotment_request.reallocated_room__number=params[:mg_hostel_room]
          allotment_request.save
          
          reallotment_request=MgAllocateRoomList.find_by(:mg_student_id=>allotment_request.mg_student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          reallotment_request.mg_hostel_room_id=allotment_request.mg_hostel_room_id
          reallotment_request.mg_hostel_room_type_id=allotment_request.mg_hostel_room_type_id
          reallotment_request.mg_hostel_floor_id=allotment_request.mg_hostel_floor_id
          reallotment_request.save
          #Start of email 
hostel_room=MgHostelRoom.find_by(:id=>allotment_request.mg_hostel_room_id)
hostel_details=MgHostelDetails.find_by(:id=>hostel_room.mg_hostel_details_id)
student_data=MgStudent.find_by(:id=>allotment_request.mg_student_id)
  #begin
      @email_from = MgEmail.where(:mg_user_id => session[:user_id])
      @message = Message.new
      @message.subject =  "Room ReAllotment"
      @message.description ="Room has been ReAlloted hostel:'#{hostel_details.name}', hostel_room_no: '#{hostel_room.name}'"
      @email_to = MgEmail.where(:mg_user_id => student_data.mg_user_id)
      
      if @email_to.present?
        @message.to_user_id = @email_to[0][:mg_email_id ]
        if @email_from.present?
          @message.from_user_id = @email_from[0][:mg_email_id ]
        else
          @message.from_user_id = "abc@mindcomgroup.com"
        end
        server_response = NotificationMailer.send_mail(@message).deliver!
        
        db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                  :to_user_id => student_data.mg_user_id.to_i,
                  :subject => @message.subject,
                  :description => @message.description,
                  :is_deleted => 0,
                  :from_user_id =>session[:user_id],
                  :status => 0)
        @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                    :email_addrs_to => @message.to_user_id,
                              :mg_school_id => session[:current_user_school_id] ,
                                    :email_addrs_by => @message.from_user_id,
                                    :email_subject => 'test',
                                   :email_server_description => server_description(server_response.status) )
      else
        puts "Email id is not present"
      end
    #   return @notice="Mail Sent Successfully."
    # rescue Net::SMTPFatalError => e
    #   puts "inside Exception in principal"
    #   puts e
    #   return @notice="Email Id is not valid."
    # rescue ArgumentError => e
    #   puts "inside Exception in principal"
    #   puts e
    #   return @notice="Email to address is not present."
    # rescue Exception => e
    #   puts e
    #   puts "inside Exception in principal"
    #   return @notice="Error while sending email,Please contact admin."
    # end


    #end of email
        # details_id=MgHostelDetails.find_by(:id=>params[:hostel_details])
        # details_id.availability=details_id.availability
      end
    redirect_to :action=>"warden_re_allocate_rooms"

     end

     def room_reallotment_form
      if params[:id].present?
        @action='edit'
        student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
        @student_application_form=MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @allocate_room_data=MgAllocateRoom.find_by(:id=>@student_application_form.mg_allocate_room_id)
        @reallotment_list=MgHostelReallotmentRequest.find_by(:id=>params[:id])

      else
      @action='new'
      student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
      @student_application_form=MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @allocate_room_data=MgAllocateRoom.find_by(:id=>@student_application_form.try(:mg_allocate_room_id))
     end
     end
  def room_reallotment_create
reallotment=MgHostelReallotmentRequest.new(room_reallotment_params)
reallotment.reason=params[:reason]
reallotment.save
redirect_to :action=>"room_reallotment_request"
end

def room_reallotment_update
reallotment=MgHostelReallotmentRequest.find_by(:id=>params[:id])
reallotment.reason=params[:reason]
reallotment.status=params[:status_data]
reallotment.save
redirect_to :action=>"room_reallotment_request"
end
def allocate_rooms_create

allocate_rooms_data=MgAllocateRoom.find_by(:mg_hostel_details_id=>params[:allocate_rooms][:hostel_id],:mg_wing_id=>params[:mg_wing_id])

if allocate_rooms_data.present?

if allocate_rooms_data.destroy
room_list_data=MgAllocateRoomList.where(:mg_allocate_room_id=>allocate_rooms_data.id)
room_list_data.each do |data|
data.destroy
  end


end

end


allocate_rooms=MgAllocateRoom.new
allocate_rooms.is_deleted=0
allocate_rooms.mg_school_id=session[:current_user_school_id]
allocate_rooms.created_by=session[:user_id]
allocate_rooms.updated_by=session[:user_id]
allocate_rooms.mg_hostel_details_id=params[:allocate_rooms][:hostel_id]
allocate_rooms.mg_wing_id=params[:mg_wing_id]
allocate_rooms.mg_user_id=session[:user_id]

if allocate_rooms.save

puts "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
puts params[:mg_room_type_id]
puts "==============================================================="
puts  params[:is_allocated]
puts "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"



  params[:mg_room_type_id].each_with_index do |data,i|
if params[:is_allocated].present?



  puts "11111111111111111111111111111111111111111111111111111111111111111111111"

  room_list=MgAllocateRoomList.new
  room_list.mg_allocate_room_id=allocate_rooms.id
  room_list.mg_student_id=params[:is_allocated][i.to_s]


#Start of email
hostel_room=MgHostelRoom.find_by(:id=>params[:mg_room_no_id][i.to_s])
hostel_details=MgHostelDetails.find_by(:id=>allocate_rooms.mg_hostel_details_id)
student_data=MgStudent.find_by(:id=>params[:is_allocated][i.to_s])
  #begin
      @email_from = MgEmail.where(:mg_user_id => session[:user_id])
      @message = Message.new
      @message.subject =  "Room Allotment"
      @message.description ="Room has been Alloted hostel:'#{hostel_details.try(:name)}', hostel_room_no: '#{hostel_room.try(:name)}'"
      @email_to = MgEmail.where(:mg_user_id => student_data.try(:mg_user_id))
      
      # ====================================================================================
      # if @email_to.present?
      #   @message.to_user_id = @email_to[0][:mg_email_id ]
      #   if @email_from.present?
      #     @message.from_user_id = @email_from[0][:mg_email_id ]
      #   else
      #     @message.from_user_id = "abc@mindcomgroup.com"
      #   end
        # server_response = NotificationMailer.send_mail(@message).deliver!
        
        # db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
        #           :to_user_id => student_data.mg_user_id.to_i,
        #           :subject => @message.subject,
        #           :description => @message.description,
        #           :is_deleted => 0,
        #           :from_user_id =>session[:user_id],
        #           :status => 0)
        # @event_mail = MgMailStatus.create(:status_code => server_response.status,
        #                             :email_addrs_to => @message.to_user_id,
        #                       :mg_school_id => session[:current_user_school_id] ,
        #                             :email_addrs_by => @message.from_user_id,
        #                             :email_subject => 'test',
        #                            :email_server_description => server_description(server_response.status) )
      # else
      #   puts "Email id is not present"
      # end
      # ====================================================================================


    #   return @notice="Mail Sent Successfully."
    # rescue Net::SMTPFatalError => e
    #   puts "inside Exception in principal"
    #   puts e
    #   return @notice="Email Id is not valid."
    # rescue ArgumentError => e
    #   puts "inside Exception in principal"
    #   puts e
    #   return @notice="Email to address is not present."
    # rescue Exception => e
    #   puts e
    #   puts "inside Exception in principal"
    #   return @notice="Error while sending email,Please contact admin."
    # end


    #end of email


  room_list.mg_hostel_floor_id=params[:mg_floor_id][i.to_s]
  room_list.mg_hostel_room_type_id=params[:mg_room_type_id][i.to_s]
  room_list.mg_hostel_room_id=params[:mg_room_no_id][i.to_s]
  room_list.is_deleted=0
  room_list.mg_school_id=session[:current_user_school_id]
  room_list.created_by=session[:user_id]
  room_list.updated_by=session[:user_id]
  room_list.is_allocated=1

  puts "44444444444444444444444444444444444444444444444444444444444444444444444444444444444"
  puts room_list
  puts "44444444444444444444444444444444444444444444444444444444444444444444444444444444444"

  room_list.save
end

end

end
redirect_to :action=>"allocate_rooms_new",:id=>"#{allocate_rooms.mg_hostel_details_id}-#{allocate_rooms.mg_wing_id}"
end
  

def allocate_rooms

@hostel_rooms=MgAllocateRoom.where(:is_deleted=>1,:mg_school_id=>session[:current_user_school_id])
end
def allocate_rooms_new
if params[:id].present?
  data=params[:id].split("-")
  puts  params[:id].inspect
@hostel_rooms=MgAllocateRoom.find_by(:mg_hostel_details_id=>data[0],:mg_wing_id=>data[1])
puts @hostel_rooms.inspect
 # puts asjdgasg

@room_student_list=MgAllocateRoomList.find_by(:mg_allocate_room_id=>@hostel_rooms.id)

#MgAllocateRoomList
else
  
end

end
def allocate_rooms_student_lists
  if params[:main_id].present?
course_data=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:id)
@student_list=MgStudentHostelApplicationForm.where(:mg_hostel_details_id=>params[:hostel_id],:mg_course_id=>course_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

else
course_data=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:id)
@student_list=MgStudentHostelApplicationForm.where(:mg_hostel_details_id=>params[:hostel_id],:mg_course_id=>course_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@hostel_rooms_data=MgAllocateRoom.find_by(:mg_hostel_details_id=>params[:hostel_id],:mg_wing_id=>params[:wing_id])
# puts @hostel_rooms_data.inspect
# puts gaHDSAGDG

end
# puts course_data.inspect

# puts @student_list.inspect
# puts adh
render :layout=>false
end



def manage_central_data
  if params[:data]=="floor"
    rooms_data=MgHostelRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>params[:hostel_id],:mg_hostel_floor_id=>params[:floor_data]).pluck(:mg_hostel_room_type_id).uniq
    room_type_data=MgHostelRoomType.where(:id=>rooms_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    str='<option value="">Select</option>'
    room_type_data.each do |s|
      str +="<option value='#{s.try(:id)}'>#{s.try(:name)}</option>"
    end
    @object=str
  elsif params[:data]=="edit_floor"
    rooms_data=MgHostelRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>params[:hostel_id],:mg_hostel_floor_id=>params[:floor_data]).pluck(:mg_hostel_room_type_id).uniq
    room_type_data=MgHostelRoomType.where(:id=>rooms_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    str='<option value="">Select</option>'
    room_type_data.each do |s|
      if params[:room_type].to_i==s.id
            str +="<option value='#{s.try(:id)}' selected>#{s.try(:name)}</option>"
      else
        str +="<option value='#{s.try(:id)}'>#{s.try(:name)}</option>"
      end
    end
    @object=str
  elsif params[:data]=="room"
    rooms_data=MgHostelRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>params[:hostel_id],:mg_hostel_room_type_id=>params[:type_data],:mg_hostel_floor_id=>params[:floor_data],:is_occupiable=>1)
    str='<option value="">Select</option>'
    rooms_data.each do |s|
      str +="<option value='#{s.try(:id)}'>#{s.try(:name)}</option>"
    end
    @object=str
  elsif params[:data]=="edit_room"
    rooms_data=MgHostelRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>params[:hostel_id],:mg_hostel_room_type_id=>params[:type_data],:mg_hostel_floor_id=>params[:floor_data])
    str='<option value="">Select</option>'
    puts rooms_data.inspect
    rooms_data.each do |s|
      if params[:room_no].to_i==s.id
        str +="<option value='#{s.try(:id)}' selected>#{s.try(:name)}</option>"
      else
        str +="<option value='#{s.try(:id)}'>#{s.try(:name)}</option>"
      end
    end
    @object=str
  elsif params[:data]=="capacity"
    @rooms_data=MgHostelRoom.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:id_data])
    @object=@rooms_data.capacity
  
  elsif params[:data]=="check_box"
    @rooms_data=MgHostelRoom.find_by(:id=>params[:room_id])
    @hostel_details=MgHostelDetails.find_by(:id=>params[:hostel_id])
    @hostel_details.availability=@hostel_details.availability-1
    @hostel_details.save
    @rooms_data.availability=@rooms_data.availability-1
    @rooms_data.save
    @object=@rooms_data.availability
  elsif params[:data]=="un_check_box"
    @rooms_data=MgHostelRoom.find_by(:id=>params[:room_id])
    @hostel_details=MgHostelDetails.find_by(:id=>params[:hostel_id])
    @hostel_details.availability=@hostel_details.availability+1
    @hostel_details.save
    @rooms_data.availability=@rooms_data.availability+1
    @rooms_data.save
    @object=@rooms_data.availability
  elsif params[:data]=="hostel_data_capacity"
    @rooms_data=MgHostelRoom.find_by(:id=>params[:room_id])
    @object=@rooms_data.availability
  end
  respond_to do |format|
    format.json  { render :json => {main: @object, sub: ""} }
  end
end



def hostel_application_form_index
    @school=MgSchool.find(session[:current_user_school_id])
    student_id=MgStudent.where(:mg_user_id=>session[:user_id]).pluck(:id)
    @student_details_data=MgStudentHostelApplicationForm.find_by(:mg_student_id=>student_id[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    if @student_details_data.present?
      @student_detail=MgStudent.find_by(:id=>@student_details_data.mg_student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end
  end
def hostel_application_form

  @action='new' 
    @student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @student_detail=MgPlacementStudentDetail.new

end
def hostel_application_form_create
      student_application=MgStudentHostelApplicationForm.new(hostel_application_form_params)
      student_application.save
      redirect_to :action=>'hostel_application_form_index'
end

def hostel_application_list
if params[:id].present?
@data=params[:id].split("-")

else
  @data=Array.new
@data[0]=0


end

end

def select_programme_data
  programme_quota=MgHostelProgrammeQuota.where(:is_deleted=>0,:mg_hostel_details_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
 str='<option value="">Select</option>'
    if params[:data1]=="data"
      programme_quota.each do |s|
         wing_data=MgWing.find_by(:id=>s.programme,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

        if params[:wing_data].to_i==wing_data.id
         str +="<option value='#{wing_data.try(:id)}-#{s.try(:id)}' selected>#{wing_data.try(:wing_name)} #{s.try(:last_name)}</option>"

       else
        str +="<option value='#{wing_data.try(:id)}-#{s.try(:id)}'>#{wing_data.try(:wing_name)} #{s.try(:last_name)}</option>"
       end
      end
      @object=str
    else
    programme_quota.each do |s|
      wing_data=MgWing.find_by(:id=>s.programme,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      str +="<option value='#{wing_data.try(:id)}-#{s.try(:id)}'>#{wing_data.try(:wing_name)} #{s.try(:last_name)}</option>"
    end
 @object=str
end
  
  respond_to do |format|
  format.json  { render :json => {main: @object, sub: ""} }
end

  end

  def select_student_list_data

    @programme_quota=MgHostelProgrammeQuota.find_by(:is_deleted=>0,:id=>params[:quota_id],:mg_school_id=>session[:current_user_school_id])
    @wing_data=MgWing.find_by(:id=>params[:wing_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @hostel=MgHostelDetails.find_by(:is_deleted=>0,:id=>@programme_quota.mg_hostel_details_id,:mg_school_id=>session[:current_user_school_id])
    course_data=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:id)
    puts "==============================================================================="
    puts course_data
    puts "==============================================================================="
    # puts qwertyu
    @hostel_list=MgStudentHostelApplicationForm.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_data,:mg_hostel_details_id=>[@hostel.id,nil],:status=>["Pending","Rejected","Waiting List","Approved"]).order(:date_of_application)
    @hostel_list_rejected_student=MgStudentHostelApplicationForm.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_data,:status=>["Rejected"]).order(:date_of_application)
    
    puts @hostel.try(:mg_hostel_details_id).inspect
    #puts asgdjgas
    #puts @hostel_list.inspect
    @hostel_list_count=MgStudentHostelApplicationForm.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_data,:status=>["Approved"],:mg_hostel_details_id=>[@hostel.try(:id),nil]).count

    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])

    allocatedata=MgAllocateRoom.find_by(:mg_wing_id=>@wing_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]);
    @count=MgAllocateRoomList.where(:mg_allocate_room_id=>allocatedata.try(:id)).count
    render :layout=>false
  end

  def rejected_reason
    @data=MgStudentHostelApplicationForm.find_by(:id=>params[:id])
    render :layout=>false
  end

def student_hostel_reject
    data=params[:id].split("=")
    @student_id=data[0]
    @id_data=data[1]
    render :layout=>false
end

def select_student_rejected_list_data_create
  student_list=params[:placement_data][:student_ids].split(",")
  student_list.each do |data|
    hostel_data=MgStudentHostelApplicationForm.find_by(:id=>data)
    hostel_data.status="Rejected"
    hostel_data.rejected_by=params[:placement_data][:rejected_by]
    hostel_data.reason=params[:placement_data][:reason]
    hostel_data.mg_hostel_details_id=params[:hostel_id]
    hostel_data.save
  end
  redirect_to :action=>"hostel_application_list",:id=>params[:id_data]
end

def select_student_list_data_create
 puts params[:inspect]
     #puts ajsgd
id_data="#{params[:hostel_id]}-#{params[:programme_id]}"
#puts ajsgd
if params[:alumni_demo_data]=="Accept"
   #puts ajsgd
params[:select_data].each do |data|
hostel_data=MgStudentHostelApplicationForm.find_by(:id=>data)

hostel_data.status="Approved"
hostel_data.mg_hostel_details_id=params[:hostel_id]

 hostel_data.save
end


elsif  params[:alumni_demo_data]=="Reject"
 # puts ajsgd
params[:select_data].each do |data|
hostel_data=MgStudentHostelApplicationForm.find_by(:id=>data)

hostel_data.status="Rejected"
hostel_data.mg_hostel_details_id=params[:hostel_id]

 hostel_data.save
end
elsif  params[:alumni_demo_data]=="Waiting List"
  params[:select_data].each do |data|
hostel_data=MgStudentHostelApplicationForm.find_by(:id=>data)

hostel_data.status="Waiting List"
hostel_data.mg_hostel_details_id=params[:hostel_id]
 hostel_data.save
end
end
   # puts ajsdhgasd
redirect_to :action=>"hostel_application_list",:id=>id_data

end


     def warden_edit_user
    @action='edit'
    @user=MgUser.find(params[:id])
   
    @warden=MgHostelWarden.find_by(:mg_user_id=>@user.id)
    
    render :layout=>false

   end

   def warden_update_user
   user=MgUser.find(params[:id])
    hostel_warden=MgHostelWarden.find_by(:mg_user_id=>user.id)

    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:user][:user_name]
    user.update(:user_name=>user_name_with_domain)

    hostel_warden.mg_hostel_details_id=params[:mg_hostel_details_id]
      hostel_warden.mg_employee_department_id=params[:mg_employee_department_id]
      hostel_warden.mg_employee_id=params[:mg_employee_id]
      hostel_warden.user_name=school.subdomain + params[:user][:user_name]
      hostel_warden.save
    redirect_to :back
   end



def hostel_warden_login_index
@users=MgUser.where(:user_type=>"hostel_warden",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])


end
  #hostel 
def new_hostel_warden_user
  #puts jkashd
@action='new'
   
    
      @user_type="hostel_warden"
   
    @user=MgUser.new
    render :layout=>false
end

def hostel_warden_login_create
MgUser.transaction do
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(user_warden_accounts_params)
      user_name_with_subdomain=school.subdomain + params[:user][:user_name]
      user.save
      user.update(:user_name=>user_name_with_subdomain)
      

     
        role=MgRole.find_by(:role_name=>"hostel_warden")
      

      if role.id.present?
        user_role = user.mg_user_roles.build(:mg_role_id => role.id)
        user_role.save 
      end

      hostel_warden=MgHostelWarden.new
      hostel_warden.is_deleted=0
      hostel_warden.mg_school_id=session[:current_user_school_id]
      hostel_warden.created_by=session[:user_id]
      hostel_warden.updated_by=session[:user_id]
      hostel_warden.mg_hostel_details_id=params[:mg_hostel_details_id]
      hostel_warden.mg_employee_department_id=params[:mg_employee_department_id]
      hostel_warden.mg_employee_id=params[:mg_employee_id]
      hostel_warden.user_name=school.subdomain + params[:user][:user_name]
      hostel_warden.mg_user_id=user.id
      hostel_warden.save

    end
        redirect_to :back

end
  
def select_employee
   employee_data=MgEmployee.where(:mg_employee_department_id=>params[:department],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    if params[:user_id].present?
  str='<option value="">Select</option>'
      employee_data.each do |s|

        if params[:user_id].to_i==s.id
         str +="<option value='#{s.try(:id)}' selected>#{s.try(:first_name)} #{s.try(:last_name)}</option>"
       else
        str +="<option value='#{s.try(:id)}'>#{s.try(:first_name)} #{s.try(:last_name)}</option>"
       end
      end
      @object=str

    else
        str='<option value="">Select</option>'
      employee_data.each do |s|
        str +="<option value='#{s.try(:id)}'>#{s.try(:first_name)} #{s.try(:last_name)}</option>"
      end
      @object=str
end
          respond_to do |format|
          format.json  { render :json => {main: @object, sub: ""} }
        end


end

def hostel_details
    #puts ddd
    @hostel_details=MgHostelDetails.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    #puts @hostel_details

  end

  def hostel_details_new
    @action='new'
    

  end

  def hostel_details_create
      begin
      MgHostelDetails.transaction do
        @hostel_data=MgHostelDetails.new(hostel_params)
        @hostel_data.total=0
        @hostel_data.occupancy=0
        @hostel_data.availability=0
        @hostel_data.save
        if params[:visible_to_student]=="yes"
          @hostel_data.update(:visible_to_student=>true)
        else
          @hostel_data.update(:visible_to_student=>false)
        end

        @programmeData=params[:programme]
        @occupancyData=params[:max_occupancy]

        @nameData=params[:name]
        @descData=params[:description]

      
        if params[:programme].present?
            params[:programme].each do |k,v|
              @saveHostelData=MgHostelProgrammeQuota.new()
              @saveHostelData.programme=v
              @saveHostelData.max_occupancy=@occupancyData[k].to_i
              @saveHostelData.mg_hostel_details_id=@hostel_data.id
              @saveHostelData.is_deleted=0
              @saveHostelData.created_by=session[:user_id]
              @saveHostelData.updated_by=session[:user_id]
              @saveHostelData.mg_school_id=session[:current_user_school_id]
              @saveHostelData.save
            end
         end

         if params[:name].present?
            params[:name].each do |k,v|
              @saveHostelData=MgHostelRule.new()
              @saveHostelData.name=v
              @saveHostelData.description=@descData[k]
              @saveHostelData.mg_hostel_details_id=@hostel_data.id
              @saveHostelData.is_deleted=0
              @saveHostelData.created_by=session[:user_id]
              @saveHostelData.updated_by=session[:user_id]
              @saveHostelData.mg_school_id=session[:current_user_school_id]
              @saveHostelData.save
            end
         end

       flash[:notice]= "Hostel Data saved successfully"
      end
    rescue Exception => e
      flash[:error]="Hostel Data saved unsuccessfully"
      puts e
    end
  redirect_to :action=> "hostel_details"

  end

def students_particular_hostel_details
    @school=MgSchool.find(session[:current_user_school_id])
    student_id=MgStudent.where(:mg_user_id=>session[:user_id]).pluck(:id)
    @student_id=student_id[0]
    @student_details_data=MgStudentHostelApplicationForm.find_by(:mg_student_id=>student_id[0],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    if @student_details_data.present?
      @student_detail=MgStudent.find_by(:id=>@student_details_data.mg_student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end
end

        


def hostel_details_update


        @hostel_data=MgHostelDetails.find_by_id(params[:id])
        @hostel_data.update(hostel_params_update)
        @hostel_data.save
        if params[:visible_to_student]=="yes"
          @hostel_data.update(:visible_to_student=>true)
        else
          @hostel_data.update(:visible_to_student=>false)
        end

        update_prgmdata=MgHostelProgrammeQuota.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>params[:id])
        update_prgmdata.update_all(:is_deleted=>1)

        update_ruledata=MgHostelRule.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>params[:id])
        update_ruledata.update_all(:is_deleted=>1)

        @programmeData=params[:programme]
        @occupancyData=params[:max_occupancy]

        @nameData=params[:name]
        @descData=params[:description]

      
        if params[:programme].present?
            params[:programme].each do |k,v|
              @saveHostelData=MgHostelProgrammeQuota.new()
              @saveHostelData.programme=v
              @saveHostelData.max_occupancy=@occupancyData[k].to_i
              @saveHostelData.mg_hostel_details_id=@hostel_data.id
              @saveHostelData.is_deleted=0
              @saveHostelData.created_by=session[:user_id]
              @saveHostelData.updated_by=session[:user_id]
              @saveHostelData.mg_school_id=session[:current_user_school_id]
              @saveHostelData.save
            end
         end

         if params[:name].present?
            params[:name].each do |k,v|
              @saveHostelData=MgHostelRule.new()
              @saveHostelData.name=v
              @saveHostelData.description=@descData[k]
              @saveHostelData.mg_hostel_details_id=@hostel_data.id
              @saveHostelData.is_deleted=0
              @saveHostelData.created_by=session[:user_id]
              @saveHostelData.updated_by=session[:user_id]
              @saveHostelData.mg_school_id=session[:current_user_school_id]
              @saveHostelData.save
            end
         end

       
  redirect_to :action=> "hostel_details"

 
  end


  def hostel_details_edit
    @action='edit'
    @hostel_data=MgHostelDetails.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    @prgm_data=MgHostelProgrammeQuota.where(:mg_hostel_details_id=>params[:id], :mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    @rule_data=MgHostelRule.where(:mg_hostel_details_id=>params[:id], :mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
  end

  def hostel_details_show
    @hostel_data=MgHostelDetails.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
  end

  
  
def hostel_details_delete
     hostel_data=MgHostelDetails.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if hostel_data.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=> "hostel_details"
  end





  def room_type
    hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @room_type=MgHostelRoomType.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id).paginate(page: params[:page], per_page: 10)
  end

  def room_type_new
    @action='new'
    render :layout=>false

  end

  def room_type_edit

    @action='edit'
    @room_type=MgHostelRoomType.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    render :layout=>false
  end

  def room_type_show
    @room_type=MgHostelRoomType.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    render :layout=>false
  end
  def room_type_create
    @room_type=MgHostelRoomType.new(room_type_params)
    hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @room_type.mg_hostel_details_id=hostel_warden.mg_hostel_details_id
    @room_type.mg_user_id=session[:user_id]
    if @room_type.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Error occured please check duplicate name"
    end
    redirect_to :action=>'room_type'
  end
  def room_type_update
    @room_type=MgHostelRoomType.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @room_type.update(room_type_update_params)
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Error occured please check duplicate name"
    end
    redirect_to :back
  end
  def room_type_delete
     @room_type=MgHostelRoomType.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @room_type.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :back
  end





def hostel_floor
       hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @hostel_floor=MgHostelFloor.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id).paginate(page: params[:page], per_page: 10)
  end

  def hostel_floor_new
    @action='new'
    render :layout=>false

  end

  def hostel_floor_edit
    @action='edit'
    @hostel_floor=MgHostelFloor.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    render :layout=>false
  end

  def hostel_floor_show
    @hostel_floor=MgHostelFloor.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    render :layout=>false
  end
  def hostel_floor_create
    @hostel_floor=MgHostelFloor.new(hostel_floor_params)
     hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @hostel_floor.mg_hostel_details_id=hostel_warden.mg_hostel_details_id
    @hostel_floor.mg_user_id=session[:user_id]
    if @hostel_floor.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Error occured please check duplicate name"
    end
    redirect_to :action=>'hostel_floor'
  end
  def hostel_floor_update
    @hostel_floor=MgHostelFloor.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @hostel_floor.update(hostel_floor_update_params)
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Error occured please check duplicate name"
    end
    redirect_to :back
  end
  
  def hostel_floor_delete
     @hostel_floor=MgHostelFloor.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @hostel_floor.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :back
  end



def hostel_rooms_admin
  if params[:id].present?
      @data=params[:id]
      @hostel_rooms=MgHostelRoom.where(:mg_hostel_details_id=>params[:id],:is_deleted => 0, :mg_school_id=>session[:current_user_school_id],:is_occupiable=>0).paginate(page: params[:page], per_page: 10)
      @health_name_data1=MgHostelRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).uniq(:mg_hostel_details_id).pluck(:mg_hostel_details_id)
      @hostel_uniq_data=MgHostelDetails.where("id IN (?)",@health_name_data1).pluck(:name,:id)
  else
      @data=0
      @hostel_rooms=MgHostelRoom.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id],:is_occupiable=>0).paginate(page: params[:page], per_page: 10)
      @health_name_data1=MgHostelRoom.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).uniq(:mg_hostel_details_id).pluck(:mg_hostel_details_id)
      @hostel_uniq_data=MgHostelDetails.where("id IN (?)",@health_name_data1).pluck(:name,:id)
  end
end


   def hostel_rooms_admin_show
     @hostel_rooms=MgHostelRoom.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
      render :layout=>false
    #@hostel_rooms=MgHostelRoom.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id],:is_occupiable=>0).paginate(page: params[:page], per_page: 10)
  end




  def hostel_rooms
      hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

    @hostel_rooms=MgHostelRoom.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id).paginate(page: params[:page], per_page: 10)
  
  end

  def hostel_rooms_new
    @action='new'

  end

  def hostel_rooms_edit
    @action='edit'
    @hostel_rooms=MgHostelRoom.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
  end

  def hostel_rooms_show
     @hostel_rooms=MgHostelRoom.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
  end
  def hostel_rooms_create
   puts params[:hostel_rooms][:is_occupiable].inspect
    @hostel_rooms=MgHostelRoom.new(hostel_rooms_params)
     capacity_data=MgHostelRoomType.find_by(:id=>params[:hostel_rooms][:mg_hostel_room_type_id]).capacity
    @hostel_rooms.capacity=capacity_data
    @hostel_rooms.availability=capacity_data

    hostel_details=MgHostelDetails.find_by(:id=>params[:hostel_rooms][:mg_hostel_details_id])
    if @hostel_rooms.save 
      if params[:hostel_rooms][:is_occupiable]=='1' 
        hostel_details.update(:total=>hostel_details.total.to_i+capacity_data.to_i,:availability=>hostel_details.total.to_i+capacity_data.to_i)
      end
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your request processed unsuccessfully"
    end
    redirect_to :action=> "hostel_rooms"
  end

  def hostel_rooms_update
    @hostel_rooms=MgHostelRoom.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    puts @hostel_rooms.inspect
    if @hostel_rooms.update(hostel_rooms_update_params)
            #       puts @hostel_rooms.is_occupiable_old.inspect

            # puts asjd
       capacity_data=MgHostelRoomType.find_by(:id=>params[:room_capacity]).capacity
       @hostel_rooms.update(:availability=>capacity_data)

      # @hostel_rooms.update(:capacity=>capacity_data)
      puts "lasdlsdsad======================="
      puts params[:hostel_rooms][:mg_hostel_details_id]
      #puts ajsdbvgjasgdhj
hostel_details=MgHostelDetails.find_by(:id=>params[:hostel_rooms][:mg_hostel_details_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      
       if params[:hostel_rooms][:is_occupiable]=="1"
        
         if (true!=@hostel_rooms.is_occupiable_old)
     # puts "asdjk123"
     # puts asjd
      #if params[:hostel_rooms][:is_occupiable]=="1"
        hostel_details.update(:total=>hostel_details.total.to_i+capacity_data.to_i,:availability=>hostel_details.total.to_i+capacity_data.to_i)
        @hostel_rooms.reason=""
        @hostel_rooms.is_occupiable_old=true
        @hostel_rooms.is_occupiable=true
        @hostel_rooms.save
      else
        # puts asjd
      end
       elsif params[:hostel_rooms][:is_occupiable]=="0"

        
  if (false!=@hostel_rooms.is_occupiable_old)
     # puts "asdjk123234"
     # puts asjd

        hostel_details.update(:total=>hostel_details.total.to_i-capacity_data.to_i,:availability=>hostel_details.total.to_i-capacity_data.to_i)
        @hostel_rooms.is_occupiable_old=false
        @hostel_rooms.is_occupiable=false
        @hostel_rooms.save
        if  params[:hostel_rooms][:reason].present?
          @hostel_rooms.update(:reason=>params[:hostel_rooms][:reason])
        end
else
   #puts asjd
      end

   #     elsif (params[:hostel_rooms][:is_occupiable]!=@hostel_rooms.is_occupiable_old)
   #    #if params[:hostel_rooms][:is_occupiable]=="1"
   #      hostel_details.update(:total=>hostel_details.total.to_i+capacity_data.to_i,:availability=>hostel_details.total.to_i+capacity_data.to_i)
   #      @hostel_rooms.reason=""
   #      @hostel_rooms.is_occupiable_old=true
   #      @hostel_rooms.is_occupiable=true
   #      @hostel_rooms.save
   #   # else
   # elsif (params[:hostel_rooms][:is_occupiable]!=@hostel_rooms.is_occupiable_old)
   #      hostel_details.update(:total=>hostel_details.total.to_i-capacity_data.to_i,:availability=>hostel_details.total.to_i-capacity_data.to_i)
   #      @hostel_rooms.is_occupiable_old=false
   #      @hostel_rooms.is_occupiable=false
   #      if  params[:hostel_rooms][:reason].present?
   #        @hostel_rooms.update(:reason=>params[:hostel_rooms][:reason])
   #      end
   
    end

      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=> "hostel_rooms"
  end
  def hostel_rooms_delete
     @hostel_rooms=MgHostelRoom.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @hostel_rooms.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=> "hostel_rooms"
  end

  def room_type_capacity 
      @capacity = MgHostelRoomType.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).try(:capacity)
      render :layout=>false
  end

  def going_out_provision_warden

    hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])        
    @provision=MgHostelGoingOutProvision.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id).paginate(page: params[:page], per_page: 10)
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  
    end

  def going_out_provision_warden_show
    @provision=MgHostelGoingOutProvision.find(params[:id])
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    render :layout=>false
  end

  def going_out_provision_warden_update
    puts params[:status]
    @provision=MgHostelGoingOutProvision.find(params[:id])
    @provision.status=params[:status]
    @provision.save
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    
    if params[:status]=="approved"
# hostel_room=MgHostelRoom.find_by(:id=>allotment_request.mg_hostel_room_id)
# hostel_details=MgHostelDetails.find_by(:id=>hostel_room.mg_hostel_details_id)
student_data=MgStudent.find_by(:id=>@provision.mg_student_id)
  #begin
      @email_from = MgEmail.where(:mg_user_id => session[:user_id])
      @message = Message.new
      @message.subject =  "Going Out Provision"
      @message.description ="You have been given permission to go out from '#{@provision.try(:from_date).strftime(@timeformat.date_format)}' '#{@provision.try(:start_time).try(:strftime,"%l:%M%P")}' to '#{@provision.try(:to_date).strftime(@timeformat.date_format)}' '#{@provision.try(:end_time).try(:strftime,"%l:%M%P")}'"
      @email_to = MgEmail.where(:mg_user_id => student_data.mg_user_id)
      
      if @email_to.present?
        @message.to_user_id = @email_to[0][:mg_email_id ]
        if @email_from.present?
          @message.from_user_id = @email_from[0][:mg_email_id ]
        else
          @message.from_user_id = "abc@mindcomgroup.com"
        end
        server_response = NotificationMailer.send_mail(@message).deliver!
        
        db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                  :to_user_id => student_data.mg_user_id.to_i,
                  :subject => @message.subject,
                  :description => @message.description,
                  :is_deleted => 0,
                  :from_user_id =>session[:user_id],
                  :status => 0)
        @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                    :email_addrs_to => @message.to_user_id,
                              :mg_school_id => session[:current_user_school_id] ,
                                    :email_addrs_by => @message.from_user_id,
                                    :email_subject => 'test',
                                   :email_server_description => server_description(server_response.status) )
      else
        puts "Email id is not present"
      end
    #   return @notice="Mail Sent Successfully."
    # rescue Net::SMTPFatalError => e
    #   puts "inside Exception in principal"
    #   puts e
    #   return @notice="Email Id is not valid."
    # rescue ArgumentError => e
    #   puts "inside Exception in principal"
    #   puts e
    #   return @notice="Email to address is not present."
    # rescue Exception => e
    #   puts e
    #   puts "inside Exception in principal"
    #   return @notice="Error while sending email,Please contact admin."
    # end


    #end of email
  end
    redirect_to :action=>"going_out_provision_warden"

  end

  



  def going_out_provision
    student=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @provision=MgHostelGoingOutProvision.where(:mg_student_id=>student.id,:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  end

  


  def going_out_provision_new
    @action='new'
    student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])

   @student_details_data=MgHostelReallotmentRequest.find_by(:mg_student_id=>student_data.id)
   @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  end

  def going_out_provision_create

    @provision=MgHostelGoingOutProvision.new(provision_params)
    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])

    start_date =Date.strptime(params[:going_out_prov][:from_date],current_school.date_format)

    end_date =Date.strptime(params[:going_out_prov][:to_date],current_school.date_format)

    @provision.from_date=start_date

    @provision.to_date=end_date

    student=MgStudent.find_by(:mg_user_id=>session[:user_id])
    @provision.mg_student_id=student.id

   @student_details_data=MgHostelReallotmentRequest.find_by(:mg_student_id=>student.id)
   hostel_details=MgHostelDetails.find_by(:id=>@student_details_data.mg_hostel_details_id)
    @provision.mg_hostel_details_id=hostel_details.id
    if @provision.save
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"going_out_provision"

  end

  def going_out_provision_edit
    @action='edit'
    student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])

   @student_details_data=MgHostelReallotmentRequest.find_by(:mg_student_id=>student_data.id)

    @provision=MgHostelGoingOutProvision.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])

  end

  def going_out_provision_update
    @provision=MgHostelGoingOutProvision.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    

    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])

    start_date =Date.strptime(params[:going_out_prov][:from_date],current_school.date_format)

    end_date =Date.strptime(params[:going_out_prov][:to_date],current_school.date_format)

    @provision.update(:from_date=>start_date)

    @provision.update(:to_date=>end_date)

    if @provision.update(provision_params_update)
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your  request processed unsuccessfully"
    end
    redirect_to :action=>"going_out_provision"


  end

  def going_out_provision_show
    @provision=MgHostelGoingOutProvision.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    
  end

  def going_out_provision_delete
    @provision=MgHostelGoingOutProvision.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    if @provision.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your request processed unsuccessfully"
    end
    redirect_to :action=> "going_out_provision"
  end




#health Management 

  def health_management
    hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])        

    @health_data=MgHostelHealthManagement.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id).paginate(page: params[:page], per_page: 10)
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  end

  def health_management_new
    @action='new'
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])

  end

  def health_management_create
      @health_data=MgHostelHealthManagement.new(health_mgmt_params)
      current_school=MgSchool.find_by(:id=>session[:current_user_school_id])

      date =Date.strptime(params[:date],current_school.date_format)

      @health_data.date=date

      @health_data.mg_hostel_room_id=params[:mg_hostel_room_id]
      @health_data.mg_hostel_floor_id=params[:mg_hostel_floor_id]
      @health_data.mg_student_id=params[:mg_student_id]

      if @health_data.save
        flash[:notice]="Your request processed successfully"
      else
        flash[:error]="Your  request processed unsuccessfully"
      end
      redirect_to :action=>"health_management"

  end

  def health_management_edit
    @action='edit'
    @health_data=MgHostelHealthManagement.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])

  end

  def health_management_update
      @health_data=MgHostelHealthManagement.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["health_management"]["id"])
      current_school=MgSchool.find_by(:id=>session[:current_user_school_id])
      date =Date.strptime(params[:date],current_school.date_format)

      @health_data.update(:date=>date)

      @health_data.update(:mg_hostel_room_id=>params[:mg_hostel_room_id])
      @health_data.update(:mg_hostel_floor_id=>params[:mg_hostel_floor_id])
      @health_data.update(:mg_student_id=>params[:mg_student_id])
      @health_data.update(:status=>params[:status])

      if @health_data.update(health_mgmt_params_update)
        flash[:notice]="Your request processed successfully"
      else
        flash[:error]="Your  request processed unsuccessfully"
      end
      redirect_to :action=>"health_management"


  end

  def health_management_show
    @health_data=MgHostelHealthManagement.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    
  end

  def health_management_delete
    @health_data=MgHostelHealthManagement.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params["id"])
     if @health_data.update(:is_deleted=>1, :updated_by=>session[:user_id])
      flash[:notice]="Your request processed successfully"
    else
      flash[:error]="Your request processed unsuccessfully"
    end
    redirect_to :action=> "health_management"
  end

  def room_number 
      @room = MgHostelRoom.where(:mg_hostel_details_id=>params[:hostel_id],:mg_hostel_floor_id=>params[:floor_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
      if params[:hostel_id].present?  &&  params[:data]=="edit" 
        @room_data=MgHostelRoom.find_by(:id=>params[:room_id],:mg_school_id=>session[:current_user_school_id])
      end

       render :layout=>false
  end


  def wing_floor_data 
      
      @floor_data = MgHostelRoom.where(:mg_hostel_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_hostel_floor_id).uniq
      floor_data=MgHostelFloor.where(:id=>@floor_data)
       @floor=Array.new
       floor_data.each do |data|
         array3=Array.new
         array3.push("#{data.name}",data.id)
         @floor.push(array3)
       end

       if params[:floor_id].present? && params[:data]=="edit"
        @floor_name=MgHostelFloor.find_by(:id=>params[:floor_id])
      end

       render :layout=>false
  end


  def student_data 
      student_data = MgAllocateRoomList.where(:mg_hostel_room_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id).uniq
       s_name=MgStudent.where(:id=>student_data)
       @data=Array.new
       s_name.each do |data|
         array2=Array.new
         array2.push("(#{data.admission_number})-#{data.first_name} #{data.last_name}",data.id)
         @data.push(array2)
        end

        if params[:data].present?
          @student_name=MgStudent.find_by(:id=>params[:studentId])
       end

      #student=Array.new
      #id_data=Array.new
       
      #student_id = MgAllocateRoomList.where(:mg_hostel_room_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:id).uniq
      # for i in 0...student_data.length
            #   s_name=MgStudent.find_by(:id=>student_data[i]).first_name + " " + MgStudent.find_by(:id=>student_data[i]).last_name

      #   student.push(s_name)
      # end

      # for j in 0...student_id.length
      #   id_data.push(student_id[j])
      # end

      # @data=[]

      # for k in 0...student_data.length
      #     @data[k]=[]
      #     @data[k].push(student[k])
      #     @data[k].push(student_id[k])
      # end

      render :layout=>false
  end



  def health_management_admin
    if params[:id].present?
      @data=params[:id]
      @health_data=MgHostelHealthManagement.where(:mg_hostel_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
      @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
      # @health_name_data=MgHostelHealthManagement.where(:mg_student_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id,:id)
      @health_name_data1=MgHostelHealthManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).uniq(:mg_hostel_details_id).pluck(:mg_hostel_details_id)
      @student_data=MgHostelDetails.where("id IN (?)",@health_name_data1).pluck(:name,:id)
    else
      @data=0
      @health_data=MgHostelHealthManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
      @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
      # @health_name_data=MgHostelHealthManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).uniq(:mg_student_id).pluck(:mg_student_id,:id)
      @health_name_data1=MgHostelHealthManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).uniq(:mg_hostel_details_id).pluck(:mg_hostel_details_id)
      @student_data=MgHostelDetails.where("id IN (?)",@health_name_data1).pluck(:name,:id)
    end
  end





  def health_management_admin_show
    @health_data=MgHostelHealthManagement.find(params[:id])
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    render :layout=>false
  end

  def health_management_admin_update
    @health_data=MgHostelHealthManagement.find(params[:id])
    @health_data.status=params[:status]
    @health_data.save
    redirect_to :action=>"health_management_admin"

  end


  #health



#fees







  def hostel_fee_category
   
  end
  def hostel_fee_category_new
    @feesquery=MgBatch.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id, :mg_course_id)
  
   render :layout => false
  end
  def hostel_fee_category_create
    @selected_batches = params[:selected_batches]
    @feedetails=MgFeeCategory.new(subject_params)
    @feedetails.item_category_name="Hostel Management"
    @feedetails.save
    settings_data=MgSchool.find_by(:is_deleted=>0,:id=>session[:current_user_school_id])
    settings_data.exam_mg_fee_category_id=@feedetails.id
    settings_data.save
                     @particularData=params[:particulars]
                     
                     for i in 0...@particularData.size
                      @saveParticular=MgParticularType.new()
                      @saveParticular.particular_name=@particularData[i]
                      @saveParticular.mg_fee_category_id=@feedetails.id
                      @saveParticular.is_deleted=0
                      @saveParticular.mg_school_id=session[:current_user_school_id]
                      @saveParticular.save
                     end
   
    redirect_to :action => "hostel_fee_category"

  end
  def hostel_fee_category_show
     @feeCategory = MgFeeCategory.find(params[:id])
    render :layout => false
  end
def hostel_fee_category_edit
  @hostel_fees = MgFeeCategory.find(params[:id])
    
    @mg_batch_list=MgBatch.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id]).pluck(:name,:id, :mg_course_id) 

    @mg_fee_category_batch_list=MgFeeCategoryBatches.where(:mg_fee_id=>params[:id]).pluck(:mg_batch_id,:id)
    @dueFine=MgParticularType.where(:mg_fee_category_id=>params[:id])
    

    render :layout => false 
end
def hostel_fee_category_update
  @feeCategoryObj = MgFeeCategory.find(params[:id])
             
  @updateparticulars=params[:particulars]
  @particulartypeId=params[:particularstype]
                
  for i in 0 ... @updateparticulars.size
    @particulartype=MgParticularType.find_by(:mg_fee_category_id=>params[:id],:id=>@particulartypeId[i])                

  if !(@particulartype.nil?)
    @particulartype.update(:particular_name=>@updateparticulars[i])
  else
     @particular=MgParticularType.new()
     @particular.particular_name=@updateparticulars[i]
     @particular.mg_fee_category_id=params[:id]
     @particular.is_deleted=0
     @particular.mg_school_id=session[:current_user_school_id]
     @particular.save
  end
end

     if @feeCategoryObj.update(subject_params)
       redirect_to :action=>'hostel_fee_category'
     else
       render 'hostel_fee_category_edit'
     end
  end

  def delete_hostel_fee_category
    @fees=MgFeeCategory.find_by_id(params[:id])
    @fees.is_deleted =1
    @fees.save
    @particularType=MgParticularType.where(:mg_fee_category_id=>params[:id])
    @particularType.each do |delete|
      delete.is_deleted=1
      delete.save
    end
    redirect_to :action=>'hostel_fee_category'
  end

def manage_hostel_particulars

    if params[:id].nil? 
        @particular_list=MgFeeParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:fee_category=>session[:feedetails_id]).paginate(page: params[:page], per_page: 5)
      else
        @particular_list=MgFeeParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:fee_category=>params[:id]).paginate(page: params[:page], per_page: 5)
        @fee_category=MgFeeCategory.find(params[:id])
        session[:feedetails_id] = @fee_category.id
      end

  end

  def manage_hostel_particulars_new
    @subjects=MgFeeParticular.new()
    render :layout => false
  end
 
  def manage_hostel_particulars_create
     @selected_batches1 = params[:selected_batches1]
    @params=params[:selectedStudents]
      for i in 0...@params.size
        @feeParticularObj=MgFeeParticular.new(particular_params) 
        @feeParticularObj.name="Hostel Fee"
        @data=MgStudent.find(@params[i])
        @batchID=@data.mg_batch_id
        @feeParticularObj.mg_batch_id=@batchID
        @feeParticularObj.admission_no= @data.admission_number
        save_account_id(params[:fesses2][:selected_account_id],params[:mg_account_id],@feeParticularObj)
        @feeParticularObj.save
      end
  
    redirect_to :action=>'manage_hostel_particulars',:controller=>'hostel_management',:id=>params[:id]
  end

  def save_account_id(selected_account_id,new_account_id,fees_particular_object)
    if selected_account_id.present?
      if selected_account_id=="central"
        fees_particular_object.is_to_central=1
      else
        fees_particular_object.mg_account_id=selected_account_id
      end
    elsif new_account_id.present?
      if new_account_id=="central"
        fees_particular_object.is_to_central=1
      else
        fees_particular_object.mg_account_id=new_account_id
      end
    end
  end
  def hostel_edit_fee_particular
    @fesses2 = MgFeeParticular.find(params[:id])
    @cceID=Array.new
    @cceID.push(@fesses2.mg_batch_id)
    logger.info @fesses2.inspect
    render :layout => false
  end
  def hostel_update_fee_particular
    @feeParticularObj = MgFeeParticular.find(params[:id])
    @feeParticularParams = update_particular_params
    @params=params[:selectedStudents]
    if(params[:fesses2][:value1]=='All')
      @feeParticularParams[:admission_no] = ''
      @feeParticularParams[:mg_student_category_id] =''
    end
    if(params[:fesses2][:value1]=='demo')
      @feeParticularParams[:admission_no] =  params[:fesses2][:admission_no] 
      @feeParticularParams[:mg_student_category_id] =''
    end
    if(params[:fesses2][:value1]=='demo2')         
      @feeParticularParams[:admission_no] = ''  
      @feeParticularParams[:mg_student_category_id] =params[:fesses2][:mg_student_category_id]
    end
    @feeParticularObj.update(@feeParticularParams)
    redirect_to :action=>'manage_hostel_particulars',:id=>@feeParticularObj.fee_category
  end

  def hostel_destroy_fee_particular
    @feesparticular=MgFeeParticular.find(params[:id])
    @feesparticular.is_deleted =1
    @feesparticular.save
    redirect_to :action=>'manage_hostel_particulars',:id=>@feesparticular.fee_category
  end



  def hostel_fee_schedule
    @fee_collection_list=MgFeeCollection.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id],:collection_type=>"hostel_management").paginate(page: params[:page], per_page: 5)
  end

  def hostel_delete_fee_schedule
    @fee_fine_schedule=MgFeeCollection.find_by_id(params[:id])
    @fee_fine_schedule.update(:is_deleted=>1)
    redirect_to :action=>'hostel_fee_schedule'
  end


  # balaji added - end 










  def index
  end

  def new
    # puts "================================================================================"
    # puts params
    # puts "================================================================================"
    # puts jglk
    mg_school_id=session[:current_user_school_id]
    # @deptId = params[:mg_employee_departments_id]
    date_student_id = params[:date_student_id]
    @mg_hostel_details_id =params[:mg_hostel_list]
    @mg_wing_id =params[:programme_list]
    employeeAttendanceDatePickerID =params[:employeeAttendanceDatePickerID]
    
    date_student_id = params[:date_student_id]
    month = params[:month]
    logger.info("month :"+month);
    year = params[:year]
    logger.info("year :"+year);
    
    logger.info(date_student_id.inspect)

    date_student_id=date_student_id.split(",")
    logger.info(date_student_id.inspect)
    date=date_student_id[0] 
    @day=date
    @student_id=date_student_id[1]
    logger.info(date)
    logger.info(@student_id)
    @final_date=date+"-"+month+"-"+year
    logger.info(@final_date)
    @mororeve=params[:mororeve]

     employee = MgStudent.find(@student_id)
       # employee = MgEmployee.find(@student_id)
        # emp_experience = employee.experience_year*12 + employee.experience_month
        # emp_gender = Array.new
        # emp_marital_status= Array.new
        # emp_gender << "all"
        # emp_gender << employee.gender
        # emp_marital_status << "all"
        # if employee.marital_status.present?
        #   emp_marital_status << employee.marital_status
        # end
        # emp_type_id = employee.mg_employee_type_id
        
      # @leave_types=MgEmployeeLeaveType.where("is_deleted  = 0 AND mg_school_id = #{session[:current_user_school_id]} AND minimum_month_experience <= ? AND gender IN (?) AND mg_employee_type_id =? AND marital_status IN (?)",emp_experience, emp_gender, emp_type_id,emp_marital_status)#.pluck(:id, :leave_name)
      # puts  @leave_types.inspect

        weekday=[0,1,2,3,4,5,6]
        my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
        @school_employee_weekday_arr=weekday-my_days
        
  render :layout => false
  
end


 def attendance_validation
     mg_school_id=session[:current_user_school_id]
      weekday=[0,1,2,3,4,5,6]
     my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     my_days=weekday-my_days

     weekdays_hash=Hash.new

      
      weekdays_hash[1]='Monday'
      weekdays_hash[2]='Tuesday'
      weekdays_hash[3]='Wednesday'
      weekdays_hash[4]='Thursday'
      weekdays_hash[5]='Friday'
      weekdays_hash[6]='Saturday'
      weekdays_hash[0]="Sunday"


    if request.xhr?
      notice=""
    puts params[:mg_employee_id]
    # puts params[:is_halfday]
    puts params[:is_late]
    
    if params[:is_late]=='false'
    # if params[:is_halfday]=='false' && params[:is_late]=='false'
      no_of_days=params[:no_of_days].to_i
    else
      no_of_days=1
    end
    if params[:no_of_days].present?
    $dayCount=0
      for i in 0..params[:no_of_days].to_i  
          date=params[:absent_date]
                arr = date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
                
                $dayCheck= Date.new(year,month,day)+$dayCount
                dayName=$dayCheck.strftime("%A")

                  for i in 1..7
                    if i==7
                      count=0
                     else
                     count=i
                    end
                    if dayName=="#{weekdays_hash[count]}" && my_days.include?(count)   
                      $dayCount +=1
                      $dayCheck= Date.new(year,month,day)+$dayCount
                      dayName=$dayCheck.strftime("%A")
                    end
                  end
                  
                     $dayCheck= Date.new(year,month,day) + $dayCount
                     @last_date=$dayCheck
                     puts $dayCheck
                     $dayCount +=1
      end
    end

     # date_array=((from_date)..to_date).map{|d|[d.year, d.month] }




                        # is_late: is_late
        arr = params[:absent_date].split('-');
                    month= arr[1].to_i
                    year=arr[2].to_i
                    day =arr[0].to_i
        from_date=Date.new(year,month,day)
        to_date= Date.new(year,month,day)+no_of_days
        employee_joing_date=MgEmployee.where(:id=>params[:mg_employee_id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
       # puts "from_date--------------:#{from_date}"
       # puts "to_date--------------:#{to_date}"
       # puts "joining_date--------------:#{Date.parse(employee_joing_date[0].joining_date.to_s)}"
       
      
        if from_date.to_date<=Date.parse(employee_joing_date[0].joining_date.to_s).to_date
          notice="date_equal_to_absent_date"
          puts "if"
       
        end
        @fulldayObject=MgEmployeeAttendance.where(:mg_employee_id=>params[:mg_employee_id], :absent_date=>from_date.to_date...@last_date, :is_deleted=>0, :is_approved=>[1,0]) 
        if @fulldayObject.present?
          notice="absent_date_present"
        end

        # puts jugvubdasrbkgkdrgni
    notice_msg = Hash["notice" => notice]

    render :json=> notice_msg
  end


    
  end
#==================================================================Create starts==============


def create
    @no_of_days_arr=[]
    @last_date
    previous_month=Date.today#.ago(1.month)
    start_from=previous_month.beginning_of_month
    end_to=previous_month.end_of_month
    month_start=start_from.strftime('%Y-%m-%d')
    month_end=end_to.strftime('%Y-%m-%d')
    # @all_data= params.permit(:mg_employee_id, :mg_leave_type_id, :absent_date, :mg_employee_department_id, :reason, :is_halfday, :is_afternoon, :is_deleted, :is_approved, :leave_type, :abcent_without_notice, :is_late_come, :time)
    @all_data= params.permit(:morning_reason, :mororeve, :mg_employee_id, :mg_wing_id, :absent_date, :mg_hostel_detail_id, :reason, :is_deleted, :absent_without_notice, :is_late_come, :time)

    

    # puts "start======================================================================================="
    #               puts params
    #               puts "000000000000000000000000000000000000000000000000"
    #               puts @all_data[:mororeve]
    #               puts "111111111111111111111111111111111111111111111111"
    #               puts params
    #             puts "end======================================================================================="
    #             puts qwejkl








    this_mont=Date.parse(@all_data[:absent_date])
    this_mont_start=this_mont.beginning_of_month
    this_mont_end=this_mont.end_of_month
    this_mont_start=this_mont_start.strftime('%Y-%m-%d')
    this_mont_end=this_mont_end.strftime('%Y-%m-%d')

    mg_school_id=session[:current_user_school_id]

     weekday=[0,1,2,3,4,5,6]
     my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     my_days=weekday-my_days

      weekdays_hash=Hash.new

      
      weekdays_hash[1]='Monday'
      weekdays_hash[2]='Tuesday'
      weekdays_hash[3]='Wednesday'
      weekdays_hash[4]='Thursday'
      weekdays_hash[5]='Friday'
      weekdays_hash[6]='Saturday'
      weekdays_hash[0]="Sunday"

    @no_of_days= params.permit(:no_of_days, :absent_date)
    no_of_days=@no_of_days[:no_of_days]
    no_of_days=no_of_days.to_i
    
    @school=MgSchool.find(session[:current_user_school_id])

    if @all_data[:is_late_come].present?
      @time=@all_data[:time]
      # puts "@time if"
      # puts @time
    else
      @time=@school.start_time
      # puts "@time else"
      # puts @time
    end
    no_of_days=1.to_i
    if(no_of_days != 0)
                
          $dayCount=0
          $dayCheck= Date.new

      for i in 0..no_of_days
                date=@all_data[:absent_date]
                # puts "absent_date"
                # puts date
                arr = date.split('-');
                month= arr[1].to_i
                year=arr[2].to_i
                day =arr[0].to_i
                # puts "day"
                # puts day
                # puts "month"
                # puts month
                # puts "year"
                # puts year
                
                $dayCheck= Date.new(year,month,day)+$dayCount
                dayName=$dayCheck.strftime("%A")
                # puts 'i try to get day name'
                # puts dayName
                # puts 'i got day name'
               

                 # if dayName=='Sunday'

                  for i in 1..7
                    if i==7
                      count=0
                     else
                     count=i
                    end
                    if dayName=="#{weekdays_hash[count]}" && my_days.include?(count)   
                      $dayCount +=1
                      $dayCheck= Date.new(year,month,day)+$dayCount
                      dayName=$dayCheck.strftime("%A")
                    end
                  end

                  
                  
                 
                  
                     $dayCheck= Date.new(year,month,day) + $dayCount
                     @last_date=$dayCheck
                     puts $dayCheck
                     $dayCount +=1
                    puts "i am in if condition   ----else----"

                     puts "step ----1-----"
                  #end
                     puts $dayCheck.strftime("%A")
                     puts "step -----2------"
                savedate=$dayCheck.to_s

                # @employees_attendanc=MgHostelAttendance.new(:mg_wing_id=>@all_data[:mg_wing_id],:mg_hostel_detail_id=>@all_data[:mg_hostel_detail_id], :absent_date=>savedate, :mg_student_id=>@all_data[:mg_employee_id], :reason=>@all_data[:reason], :is_deleted=>0, :absent_without_notice=>@all_data[:absent_without_notice], :is_late_come=>@all_data[:is_late_come], :time=>@time, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id])
                # @employees_attendanc.save



                # if @all_data[:mororeve]=='morning'
                #       @employees_attendanc.update(:is_morning=>true, :morning_reason=>@all_data[:morning_reason].to_s)
                # elsif 
                #       @employees_attendanc.update(:is_evening=>true, :evening_reason=>@all_data[:morning_reason].to_s)
                # else
                # end 
                # =====================================================

                # puts "start======================================================================================="
                #   puts params
                #   puts "000000000000000000000000000000000000000000000000"
                #   puts @all_data[:mororeve]
                #   puts "111111111111111111111111111111111111111111111111"
                #   puts params
                # puts "end======================================================================================="
                # puts qwejkl
                puts "========================================================================================================================="
                puts @all_data[:mg_employee_id]
                puts "========================================================================================================================="
                puts kjghjkg
                if @all_data[:mororeve]=='morning'
                    same_day_absent= MgHostelAttendance.find_by(:is_evening=>true,:absent_date=>savedate, :mg_student_id=>@all_data[:mg_employee_id])
                    if same_day_absent.present?
                        same_day_absent.update(:is_morning=>true,:mg_wing_id=>@all_data[:mg_wing_id],:mg_hostel_detail_id=>@all_data[:mg_hostel_detail_id], :absent_date=>savedate, :mg_student_id=>@all_data[:mg_employee_id], :morning_reason=>@all_data[:reason], :is_deleted=>0, :absent_without_notice=>@all_data[:absent_without_notice], :is_late_come=>@all_data[:is_late_come], :time=>@time, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id])
                        if @all_data[:is_late_come]=="true"
                            same_day_absent.update(:morning_late_reason=>@all_data[:morning_reason])
                        end
                    else

                          employees_attendanc=MgHostelAttendance.new(:is_morning=>true,:mg_wing_id=>@all_data[:mg_wing_id],:mg_hostel_detail_id=>@all_data[:mg_hostel_detail_id], :absent_date=>savedate, :mg_student_id=>@all_data[:mg_employee_id], :morning_reason=>@all_data[:reason], :is_deleted=>0, :absent_without_notice=>@all_data[:absent_without_notice], :is_late_come=>@all_data[:is_late_come], :time=>@time, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id])
                          employees_attendanc.save
                          if @all_data[:is_late_come]=="true"
                            employees_attendanc.update(:morning_late_reason=>@all_data[:morning_reason])
                          end
                    end
                    #====================================================
                    
                elsif @all_data[:mororeve]=='evening'
                      same_day_absent= MgHostelAttendance.find_by(:is_morning=>true,:absent_date=>savedate, :mg_student_id=>@all_data[:mg_employee_id])
                    if same_day_absent.present?
                        same_day_absent.update(:is_evening=>true,:mg_wing_id=>@all_data[:mg_wing_id],:mg_hostel_detail_id=>@all_data[:mg_hostel_detail_id], :absent_date=>savedate, :mg_student_id=>@all_data[:mg_employee_id], :evening_reason=>@all_data[:reason], :is_deleted=>0, :absent_without_notice=>@all_data[:absent_without_notice], :is_evening_late_come=>@all_data[:is_late_come], :evening_late_time=>@time, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id])
                        if @all_data[:is_late_come]=="true"
                            same_day_absent.update(:evening_late_reason=>@all_data[:morning_reason])
                        end
                    else
                          employees_attendanc=MgHostelAttendance.new(:is_evening=>true,:mg_wing_id=>@all_data[:mg_wing_id],:mg_hostel_detail_id=>@all_data[:mg_hostel_detail_id], :absent_date=>savedate, :mg_student_id=>@all_data[:mg_employee_id], :evening_reason=>@all_data[:reason], :is_deleted=>0, :absent_without_notice=>@all_data[:absent_without_notice], :is_evening_late_come=>@all_data[:is_late_come], :evening_late_time=>@time, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id])
                          employees_attendanc.save
                          if @all_data[:is_late_come]=="true"
                            employees_attendanc.update(:evening_late_reason=>@all_data[:morning_reason])
                          end
                    end
                end


                # elsif @all_data[:mororeve]=='evening'
                #   same_day_absent= MgHostelAttendance.where(:is_morning=>true,:absent_date=>savedate, :mg_student_id=>@all_data[:mg_employee_id])
                #   if same_day_absent.present?
                #       @employees_attendanc.update(:is_morning=>true)
                #   end

                # end
                break
      end  


       # absent_date=Date.parse(@all_data[:absent_date])
       #            result=no_of_sunday(absent_date,(absent_date+$dayCount.to_i-1))
       #            # @no_of_days_arr=$dayCount-2
                  

       #             from_date=Date.parse(@all_data[:absent_date])
       #             # @last_date
       #             puts "---------test date difference------------------"
       #             puts "from_date-----#{from_date}"
       #             puts "@last_date-----#{@last_date}"
       #             puts "---------test date difference------------------"

       #             # @timeformat=MgSchool.find(session[:current_user_school_id])
       #             #  @from_date = Date.strptime(absent_date.to_s,@timeformat.date_format)
       #             #  puts @from_date
       #              # @last_date = Date.strptime( @last_date,@timeformat.date_format)
                  

       #              @no_of_days_arr=(@last_date.to_date-from_date.to_date).to_i
       #             # (from_date-@last_date)
       #             # @no_of_days_arr+=1
       #                puts @no_of_days_arr
       #               # puts last_datehhhh
       #             to_date=from_date+no_of_days-1+result
       #             date_array=((from_date)..to_date).map{|d|[d.year, d.month] }
       #            date_wise_employee_leave_update(date_array,@all_data,my_days.count)


    else
        
        # @employees_attendances.updated_by=session[:user_id]
        # @employees_attendances.created_by=session[:user_id]
        # @employees_attendances.is_approved=1
        # @employees_attendances.time=@time
        # @employees_attendances.mg_school_id=session[:current_user_school_id]
        # @employees_attendances.save
        # @count_leave=MgEmployeeLeaves.where(:mg_employee_id => @all_data[:mg_employee_id], :mg_leave_type_id=> @all_data[:leave_type], :mg_school_id=>session[:current_user_school_id], :leave_month_year=>this_mont_start...this_mont_end)
        #   # if  @count_leave.length > 0
          #   @updateEmployeeLeves=MgEmployeeLeaves.find(@count_leave[0].id)
          #   @updateEmployeeLeves.leave_taken +=0.5
          #   @updateEmployeeLeves.updated_by=session[:user_id]
          #   @updateEmployeeLeves.mg_school_id=session[:current_user_school_id]
          #   @updateEmployeeLeves.save
          # else
          #   @updateEmployeeLeves=MgEmployeeLeaves.new(:mg_employee_id=>@all_data[:mg_employee_id],:mg_leave_type_id=>@all_data[:leave_type], :leave_taken=>0.5, :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id] , :leave_month_year=>this_mont_start)
          #   @updateEmployeeLeves.save
          #  end
          # break

    end  
    user=MgUser.find(session[:user_id])
    usertype=user.user_type
    puts "User Type====="
    puts usertype.inspect

    #Notification Starts for admin
    # begin
    #   if(usertype == "admin") 
    #     puts "Inside Notification===="
    #     not_sub ="Employee Attendance"
    #     employee=MgEmployee.find(@all_data[:mg_employee_id])
    #     school=MgSchool.find(session[:current_user_school_id])
    #     principal_user_id=MgUser.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:user_type=>"principal").pluck(:id)
    #     not_des ="#{employee.first_name} #{employee.middle_name} #{employee.last_name} has taken leave on #{@all_data[:absent_date]} because of #{@all_data[:reason]}."
    #     db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id],:to_user_id =>principal_user_id[0] , :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
    #     @message = Message.new
    #     @email_from = MgEmail.where(:mg_user_id => session[:user_id])
    #     @message.subject =  not_sub
    #     @message.description = not_des
    #     @email_to = MgEmail.where(:mg_user_id => principal_user_id[0])
    #     @message.to_user_id = @email_to[0][:mg_email_id ]
    #     @message.from_user_id = @email_from[0][:mg_email_id ]
    #     server_response = NotificationMailer.send_mail(@message).deliver!
    #     @event_mail = MgMailStatus.create(:status_code => server_response.status,
    #                                       :email_addrs_to => @message.to_user_id,
    #                                       :mg_school_id => session[:current_user_school_id] ,
    #                                       :email_addrs_by => @message.from_user_id,
    #                                       :email_subject => not_sub,
    #                                       :email_server_description => server_description(server_response.status) 
    #                                       )

        
    # end
    # rescue Net::SMTPFatalError => e
    #   puts "inside Exception in principal"
    #   flash.now[:notice]="Email Id is not valid"
    #   flash.keep(:notice)
    # rescue ArgumentError => e
    #   puts "inside Exception in principal"
    #   flash.now[:notice]="Email to address is not present."
    #   flash.keep(:notice)
    # rescue Exception => e
    #   puts "inside Exception in principal"
    #   flash.now[:notice]="Error while sending email, please contact admin."
    #   flash.keep(:notice)
    # end
    # #Notification Ends for admin

    # #Notification Start for principal
    # begin
    #   if(usertype == "principal")
    #   puts "inside principal"
    #   puts params[:is_lock]
    #   if(params[:is_lock]=="true")
    #       puts "Inside Principal Notification===="
         
    #       employee=MgEmployee.find(params[:mg_employee_id])
    #       school=MgSchool.find(session[:current_user_school_id])
    #       not_sub ="Employee Attendance Unlock to edit"
    #       not_des ="#{employee.first_name} #{employee.middle_name} #{employee.last_name} attendance on #{params[:absent_date]} can be edited."
    #       to_user_id=MgUser.where(:user_type=>"admin",:mg_school_id=>session[:current_user_school_id],:is_deleted=>0).pluck(:id)
    #       db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id],:to_user_id =>to_user_id[0], :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
    #       @message = Message.new
    #       @email_from = MgEmail.where(:mg_user_id => session[:user_id])
    #       @message.subject =  not_sub
    #       @message.description = not_des
    #       @email_to = MgEmail.where(:mg_user_id => to_user_id[0])
    #       @message.to_user_id = @email_to[0][:mg_email_id ]
    #       @message.from_user_id = @email_from[0][:mg_email_id ]
    #       server_response = NotificationMailer.send_mail(@message).deliver!
    #       @event_mail = MgMailStatus.create(:status_code => server_response.status,
    #                                         :email_addrs_to => @message.to_user_id,
    #                                         :mg_school_id => session[:current_user_school_id] ,
    #                                         :email_addrs_by => @message.from_user_id,
    #                                         :email_subject => not_sub,
    #                                         :email_server_description => server_description(server_response.status) 
    #                                       )
    #     end
    # end
    # rescue Net::SMTPFatalError => e
    #   puts "inside Exception in principal"
    #   flash.now[:notice]="Email Id is not valid"
    #   flash.keep(:notice)
    # rescue ArgumentError => e
    #   puts "inside Exception in principal"
    #   flash.now[:notice]="Email to address is not present."
    #   flash.keep(:notice)
    # rescue Exception => e
    #   puts "inside Exception in principal"
    #   flash.now[:notice]="Error while sending email, please contact admin."
    #   flash.keep(:notice)

    # end
    # #Notification ends for principal


      # render :layout => false
     respond_to do |format|
            format.json  { render :json => @no_of_days_arr }
        end
  end

  def edit
  end

  def delete
  end

  def show
  end

  def update
  end

  def hostel_admin_login_index
    @users=MgUser.where(:user_type=>"hostel_admin",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    puts @users.inspect
   # puts asdjhjk
  end

  def hostel_admin_login_create
MgUser.transaction do
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(user_accounts_params)
      user_name_with_subdomain=school.subdomain + params[:user][:user_name]
      user.save
      user.update(:user_name=>user_name_with_subdomain)
      
     
        role=MgRole.find_by(:role_name=>"hostel_admin")
      

      if role.id.present?
        user_role = user.mg_user_roles.build(:mg_role_id => role.id)
        user_role.save 
      end
    end
        redirect_to :back

  end
  def hostel_admin_login_edit

  end

  def hostel_admin_login_update

  end
  def hostel_admin_login_new
  end
  def hostel_admin_login_show
  end
  def hostel_admin_login_destroy

  end


  def new_user
@action='new'
   
    
      @user_type="hostel_admin"
   
    @user=MgUser.new
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
def edit_user
     @action='edit'
    @user=MgUser.find(params[:id])
    render :layout=>false
end
 def change_password
    @user=MgUser.find(params[:id])
    render :layout=>false
  end

def update_user_data
   user=MgUser.find(params[:id])
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:user][:user_name]
    user.update(:user_name=>user_name_with_domain)
    redirect_to :back

  end
  def delete_user
    user=MgUser.find(params[:id])
    user.update(:is_deleted=>1,:updated_by=>session[:user_id])
    if params[:warden].present?
    warden=MgHostelWarden.find_by(:mg_user_id=>user.id)
        warden.update(:is_deleted=>1,:updated_by=>session[:user_id])

    end
    redirect_to :back 
  end
  #==========Pranav Work Start=================================
  def complain_hostel_index
  student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  @complain_hostel=MgComplainHostel.where(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @student_form_data=MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  if @student_form_data.present?
    @allocate_room_data=MgAllocateRoom.find_by(:id=>@student_form_data.mg_allocate_room_id)
  end
  end

def complain_hostel_new
  @action= 'new'
  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
  @hostel_name= MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).try(:admission_number).to_i
  

  @room_no=MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).try(:mg_hostel_room_id).to_i
  @student_form_data=MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  if @student_form_data.present?
    @allocate_room_data=MgAllocateRoom.find_by(:id=>@student_form_data.mg_allocate_room_id)
  end
end

def complain_hostel_create
  @complain_hostel=MgComplainHostel.new(complain_hostel_params)

    current_school=MgSchool.find_by(:id=>session[:current_user_school_id])

    date =Date.strptime(params[:complain_hostel][:date],current_school.date_format)

    @complain_hostel.date=date


  student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
  @complain_hostel.mg_student_id=student_data.id
  @complain_hostel.save
  redirect_to :action=>"complain_hostel_index"
end

def complain_hostel_edit
  @action='edit'
  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
  @hostel_name= MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).try(:admission_number).to_i
  @room_no= MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).try(:mg_hostel_room_id).to_i
  @student_form_data= MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @allocate_room_data= MgAllocateRoom.find_by(:id=>@student_form_data.mg_allocate_room_id)
  
  @complain_hostel=MgComplainHostel.find(params[:id])
  
end

def complain_hostel_update
   @complain_hostel=MgComplainHostel.find(params[:id])
   puts params[:status_data].inspect
    @complain_hostel.update(:status=>params[:status_data])
    if @complain_hostel.update(complain_hostel_update_params)
    redirect_to :action=>"complain_hostel_index"
    else
      render 'complain_hostel_edit'
    end
end
def complain_hostel_show
   @complain_hostel=MgComplainHostel.find(params[:id])
   student_data=MgStudent.find_by(:mg_user_id=>session[:user_id])
  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  @student_form_data=MgAllocateRoomList.find_by(:mg_student_id=>student_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @allocate_room_data=MgAllocateRoom.find_by(:id=>@student_form_data.mg_allocate_room_id)

end
def complain_hostel_delete
   @complain_hostel=MgComplainHostel.find(params[:id])
   @complain_hostel.is_deleted=1
   @complain_hostel.save
       redirect_to :action=>"complain_hostel_index"

end
def hostel_complaint
    hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])        

   @hostel_complaint=MgComplainHostel.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id).paginate(page: params[:page], per_page: 10).where('status not in ("Resolved")')
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
end

def hostel_complaint_show
  @hostel_complaint=MgComplainHostel.find(params[:id])
    @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
  
end

def hostel_complaint_update
  @hostel_complaint=MgComplainHostel.find(params[:id])
  @hostel_complaint.status=params[:status]
  @hostel_complaint.save

  redirect_to :action=>"hostel_complaint"
end



def students_attendance
 end

  # def hostler_student_list
  #   puts "paramssssssssssssssssssssss"
  #   puts params
  #   puts "paramssssssssssssssssssssss"

  #   @programme_quota=MgHostelProgrammeQuota.find_by(:is_deleted=>0,:id=>params[:quota_id],:mg_school_id=>session[:current_user_school_id])
  #   @wing_data=MgWing.find_by(:id=>params[:wing_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  #   @hostel=MgHostelDetails.find_by(:is_deleted=>0,:id=>@programme_quota.mg_hostel_details_id,:mg_school_id=>session[:current_user_school_id])
  #   course_data=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:id)
  #   @hostel_list=MgStudentHostelApplicationForm.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_data,:status=>"Approved")
  #   render :layout=>false
  # end

  def hostler_student_list

    # @checkuser=MgUser.where(:id=>session[:user_id], :mg_school_id=>session[:current_user_school_id], :is_deleted=>0, :user_type=>'principal')

    mg_school_id=session[:current_user_school_id]
    weekday=[0,1,2,3,4,5,6]
    my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
    my_days=weekday-my_days

    data = Array.new
    # if @checkuser.present?
      # puts"insideeeeeeeeeeeeeeeeeeeeeeeeee iffffffffffffffffffff"
      # puts"insideeeeeeeeeeeeeeeeeeeeeeeeee iffffffffffffffffffff"
      # #princy
      # @sql = "Select * from mg_employees where mg_employee_department_id = #{params[:id]} and mg_school_id=#{session[:current_user_school_id] } and is_deleted=0 ORDER BY first_name "
      #   # @sql = "Select * from mg_employees where mg_employee_department_id = #{params[:id]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0 and mg_employee_category_id=(SELECT id FROM mg_employee_categories where category_name='Teaching Staff' and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0)"
        
      # @employees = MgEmployee.find_by_sql(@sql)
      # # logger.info(@students.inspect)
      # data.push(@employees)
      # @sql1 = "select DATE_FORMAT(absent_date, '%Y') year, DATE_FORMAT(absent_date, '%c') month, DATE_FORMAT(absent_date, '%e') day, mg_employee_id, created_at, updated_at from mg_employee_attendances where mg_employee_department_id=#{params[:id]} and is_deleted=0 and mg_school_id=#{session[:current_user_school_id] } and is_approved=1"
      # @absent_dates = MgStudent.find_by_sql(@sql1)
      # data.push(@absent_dates)
    # else
      puts"elseeeeeeeeeeeeeeeeeeeeeeeeee"
      puts"elseeeeeeeeeeeeeeeeeeeeeeeeee"

        # @sql = "Select * from mg_employees where mg_employee_department_id = #{params[:id]} and mg_school_id=#{session[:current_user_school_id]} and is_deleted=0 and mg_employee_category_id=(SELECT id FROM mg_employee_categories where category_name='Non Teaching Staff' and is_deleted=0) ORDER BY first_name"
        # @employees = MgEmployee.find_by_sql(@sql)
      # logger.info(@students.inspect)
        # data.push(@employees)

        #==========================================================================================
        @programme_quota=MgHostelProgrammeQuota.find_by(:is_deleted=>0,:id=>params[:quota_id],:mg_school_id=>session[:current_user_school_id])
        @wing_data=MgWing.find_by(:id=>params[:wing_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @hostel=MgHostelDetails.find_by(:is_deleted=>0,:id=>@programme_quota.mg_hostel_details_id,:mg_school_id=>session[:current_user_school_id])
        course_data=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:id)
        hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])        

        @hostel_list=MgStudentHostelApplicationForm.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_data,:status=>"Approved",:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id)
        
        hoster_ids=[]
        @hostel_list.each do |data|
          # student_data=MgStudent.find_by(:id=>data.mg_student_id)
          hoster_ids.push(data.mg_student_id)
        end
        
        if hoster_ids.present?
          @student_obj=MgStudent.where("is_deleted=? and mg_school_id=? and ID IN (?)",0,session[:current_user_school_id],hoster_ids)
        end

        

        data.push(@student_obj)
          
        # puts"insideeeeeeeeeeeeeeeeeeeeeeeeee elseeeeeeeeeeeeeeeeeeee"
        # puts data.inspect
        # puts"insideeeeeeeeeeeeeeeeeeeeeeeeee elseeeeeeeeeeeeeeeeeeee"



        #===========================================================================================
        @sql1="select DATE_FORMAT(a.absent_date, '%Y') year, DATE_FORMAT(a.absent_date, '%c') month, DATE_FORMAT(a.absent_date,
         '%e') day, a.mg_employee_id, a.created_at, a.updated_at from mg_employee_attendances a, mg_employees b where
          a.mg_employee_department_id=#{params[:id]} and a.is_deleted=0 and b.id=a.mg_employee_id and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id] } and b.mg_school_id=#{session[:current_user_school_id] } and a.is_approved=1 and b.mg_employee_category_id=(SELECT id FROM mg_employee_categories where category_name='Non Teaching Staff' and is_deleted=0)"
         # @sql1 = select DATE_FORMAT(a.absent_date, '%Y') year, DATE_FORMAT(a.absent_date, '%c') month, DATE_FORMAT(a.absent_date, '%e') day, a.mg_student_id, a.is_morning, a.is_evening, a.created_at, a.updated_at from mg_hostel_attendances a, mg_students b where a.is_deleted=0 and b.id=a.mg_student_id and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id] } and b.mg_school_id=#{session[:current_user_school_id] } "
        @absent_dates = MgStudent.find_by_sql("select DATE_FORMAT(a.absent_date, '%Y') year, DATE_FORMAT(a.absent_date, '%c') month, DATE_FORMAT(a.absent_date, '%e') day, a.mg_student_id, a.is_morning, a.is_evening, a.created_at, a.updated_at from mg_hostel_attendances a, mg_students b where a.is_deleted=0 and b.id=a.mg_student_id and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id] } and b.mg_school_id=#{session[:current_user_school_id] } ")
        data.push(@absent_dates)
          puts "i'm in else"
    # end

    puts "StudentsHash -- is comming"
    data.push(my_days)
    puts "========================================last==================================================="
    puts "insideeeeeeeeeeeeeeeeeeeeeeeeee555555555555555 elseeeeeeeeeeeeeeeeeeee"
        puts @absent_dates.inspect
        puts "insideeeeeeeeeeeeeeeeeeeeeeeeee elseeeeeeeeeeeeeeeeeeee"
    # debuggerasdsa


    respond_to do |format|
        format.json  { render :json => data }
    end
  end


  def edit_attendance

    @mg_hostel_id = params[:mg_hostel_id]
    # @deptId = params[:mg_employee_departments_id]
    date_student_id = params[:date_student_id]
    month = params[:month]
    year = params[:year]

    date_student_id=date_student_id.split(",")
    date=date_student_id[0]
    @day=date
    @student_id=date_student_id[1][0]
    
    # @student_id=date_student_id[1]
    @final_date=(date+"-"+month+"-"+year).to_datetime
    logger.info(@final_date)

     @update_attendance=params[:update_attendance]
     #    hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
     puts "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"      
     puts params  
     puts "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"        

    id=MgHostelAttendance.where(:absent_date=>@final_date, :mg_student_id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
    # id=MgEmployeeAttendance.where(:absent_date=>@final_date, :mg_employee_id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:id)
      puts "id ---- step --1"
      puts id[0]
    @student_attendances=MgHostelAttendance.find(id[0])
    # @employees_attendances=MgEmployeeAttendance.find(id[0])
      puts "step  ------2----"
      puts @student_attendances.inspect


      #=====================not use for hostel========================
      #  employee = MgEmployee.find_by(:id=>params[:id])
      #   emp_experience = employee.experience_year*12 + employee.experience_month
      #   emp_gender = Array.new
      #   emp_marital_status= Array.new
      #   emp_gender << "all"
      #   emp_gender << employee.gender
      #   emp_marital_status << "all"
      #   if employee.marital_status.present?
      #     emp_marital_status << employee.marital_status
      #   end
      #   emp_type_id = employee.mg_employee_type_id
        
      # @leave_types=MgEmployeeLeaveType.where("is_deleted  = 0 AND mg_school_id = #{session[:current_user_school_id]} AND minimum_month_experience <= ? AND gender IN (?) AND mg_employee_type_id =? AND marital_status IN (?)",emp_experience, emp_gender, emp_type_id,emp_marital_status)#.pluck(:id, :leave_name)
      #=====================not use for hostel========================
  
      render :layout => false
  end

  # def update_attendance
  #   puts "edit_attendanceeeeeeeeeeeeeeeeeeeeeeeee"
  #   puts params
  #     #{"mg_employee_id"=>"5", "mg_leave_type_id"=>"1", "absent_date"=>"2016-06-04", "mg_employee_department_id"=>"3", "reason"=>"dd", "is_afternoon"=>"false", "is_deleted"=>"0", "abcent_without_notice"=>"true", "leave_type"=>"1", "is_late_come"=>"false", "time"=>"", "is_lock"=>"false", "action"=>"update", "controller"=>"employees_attendances", "id"=>"28"}

  #   puts "edit_attendanceeeeeeeeeeeeeeeeeeeeeeeee"
  #   puts klj;l
  #   @employees_attendances = MgHostelAttendance.find_by(:id=>params[:id])
  #   # @employees_attendances = MgEmployeeAttendance.find(params[:id])
 
  #   @employees_attendances.update(student_ajax_params)
  #   @employees_attendances.updated_by=session[:user_id]
  #   @employees_attendances.save
  # end

  def update
    @student_attendances = MgHostelAttendance.find_by(:id=>params[:id])
    # @employees_attendances = MgEmployeeAttendance.find(params[:id])
     
    @student_attendances.update(student_ajax_params)
    @student_attendances.updated_by=session[:user_id]
    if params[:update_attendance]=="morning_attendance"

      if params[:is_late_come]=="true"
        @student_attendances.update(:morning_reason=>'',:absent_without_notice=>false,:is_late_come=>true)
      else
        @student_attendances.update(:morning_late_reason=>'',:time=>nil,:is_late_come=>false)
      end
    else
      if params[:is_evening_late]=="true"
        @student_attendances.update(:evening_reason=>'',:absent_without_notice=>false,:is_evening_late_come=>true)
      else
        @student_attendances.update(:evening_late_reason=>'',:evening_late_time=>nil,:is_evening_late_come=>false)
      end
    end
    @student_attendances.save
  end



  def delete_attendance
   
    @student_attendances=MgHostelAttendance.find_by(:id=>params[:id])

    if params[:delete_attendance_period]=="morning_attendance"
      if @student_attendances.is_evening==true
        @student_attendances.is_morning=false
        @student_attendances.morning_reason=''
        @student_attendances.time=nil
        @student_attendances.morning_late_reason=''
      else
        @student_attendances.is_deleted =1
      end
    else
      if @student_attendances.is_morning==true
        @student_attendances.is_evening=false
        @student_attendances.evening_reason=''
        @student_attendances.evening_late_time=nil
        @student_attendances.evening_late_reason=''
      else
        @student_attendances.is_deleted =1
      end
    end
    @student_attendances.save
    respond_to do |format|
      format.json  { render :json => @student_attendances }
    end
  end


 def hosteler_leave
  end
  def hosteler_leave_list
    puts "paramssssssssssssssssssssss"
    puts params
    puts "paramssssssssssssssssssssss"

    @all_data= params.permit(:startDate, :endDate, :mg_hostel_details_id, :wing_id, :quota_id)
    # @all_data= params.permit(:startDate, :endDate, :departmentId)
    @timeformat = MgSchool.find(session[:current_user_school_id])
    puts"---------step1--------------------"
    puts @all_data[:startDate]
    puts @all_data[:endDate]
    puts"---------step1--------------------"
    if @all_data[:startDate].present?
      @start_date = Date.strptime(@all_data[:startDate],@timeformat.date_format)
    end
    if @all_data[:endDate].present?
      @end_date = Date.strptime(@all_data[:endDate],@timeformat.date_format)
    end
    
    deptId =   @all_data[:mg_hostel_details_id]
    puts"---------step3--------------------"
    puts deptId
    puts"---------step3--------------------"

    # deptId =   @all_data[:departmentId]
   
    total_days=(@end_date.to_date - @start_date.to_date).to_i
    @total_days=total_days+1

    @data=MgHostelAttendance.where(:absent_date=>@start_date.to_date..@end_date.to_date, :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    # @data=MgEmployeeAttendance.where(:absent_date=>@start_date.to_date..@end_date.to_date, :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    
    sqlquery="SELECT distinct mg_student_id FROM mg_hostel_attendances WHERE absent_date BETWEEN '#{@start_date.to_date}' AND '#{@end_date.to_date}' and is_deleted=0"
    # sqlquery="SELECT distinct mg_employee_id FROM mg_employee_attendances WHERE absent_date BETWEEN '#{@start_date.to_date}' AND '#{@end_date.to_date}' and is_deleted=0"
    @employeeIDs=MgHostelAttendance.find_by_sql sqlquery
    # @employeeIDs=MgEmployeeAttendance.find_by_sql sqlquery
    puts"---------step2--------------------"
    puts  @employeeIDs.inspect
    puts"---------step2--------------------"

    
    @programme_quota=MgHostelProgrammeQuota.find_by(:is_deleted=>0,:id=>params[:quota_id],:mg_school_id=>session[:current_user_school_id])
    @wing_data=MgWing.find_by(:id=>params[:wing_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @hostel=MgHostelDetails.find_by(:is_deleted=>0,:id=>@programme_quota.mg_hostel_details_id,:mg_school_id=>session[:current_user_school_id])
    course_data=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:id)
            hostel_warden=MgHostelWarden.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])        

    @allEmloyees=MgStudentHostelApplicationForm.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_data,:status=>"Approved",:mg_hostel_details_id=>hostel_warden.mg_hostel_details_id)

    render :layout => false


  end 

  def leave_report
    if request.xhr?
      if params[:student]=="allday"
        @fullday=MgHostelAttendance.where(:mg_student_id=>params[:studentID], :absent_date=>params[:start_date].to_date..params[:end_date].to_date,:is_morning=>1,:is_evening=>1, :is_deleted=>0) 
        
        @morning_object="SELECT * FROM mg_hostel_attendances WHERE absent_date BETWEEN '#{params[:start_date].to_date}' AND '#{params[:end_date].to_date}' and is_deleted=0 AND mg_student_id='#{params[:studentID]}' AND is_morning=1 AND ( is_evening=false OR is_evening IS NULL)"
        @morningObject=MgHostelAttendance.find_by_sql(@morning_object)

        @evening_object="SELECT * FROM mg_hostel_attendances WHERE absent_date BETWEEN '#{params[:start_date].to_date}' AND '#{params[:end_date].to_date}' and is_deleted=0 AND mg_student_id='#{params[:studentID]}' AND is_evening=1 AND ( is_morning=false OR is_morning IS NULL)"
        @eveningObject=MgHostelAttendance.find_by_sql(@evening_object)

        render :json=> {:morningObject=>@morningObject, :eveningObject=>@eveningObject,:fullday=>@fullday}
      end
    end
  end


  #==========Pranav Work Ends===================================

private

def user_accounts_params
    params.require(:user).permit(:user_type,:password,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

def user_warden_accounts_params
    params.require(:user).permit(:user_type,:password,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def hostel_application_form_params
    params.require(:student_detail).permit(:is_deleted,:mg_school_id,:created_by,:updated_by,:mg_student_id,:mg_guardian_id,:mg_course_id,:mg_batch_id,:admission_number,:date_of_application,:mobile_no,:email_id,:status)
  end

private
def hostel_params
    params.require(:hostel_details).permit(:name,:description,:category,:mg_school_id,:created_by,:updated_by,:is_deleted)

  end

  def hostel_params_update
    params.require(:hostel_details).permit(:name,:description,:category,:mg_school_id,:updated_by,:is_deleted)

  end

  def room_type_params
    params.require(:room_type).permit(:name, :description,:capacity,:is_deleted,:created_by,:updated_by,:mg_school_id)
    
  end

  def room_type_update_params
    params.require(:room_type).permit(:name, :description,:capacity,:is_deleted,:updated_by,:mg_school_id)
    
  end

  def hostel_floor_params
    params.require(:hostel_floor).permit(:name, :description,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def hostel_floor_update_params
    params.require(:hostel_floor).permit(:name, :description,:is_deleted,:updated_by,:mg_school_id)
  end

  def hostel_rooms_params
    params.require(:hostel_rooms).permit(:mg_hostel_details_id, :mg_hostel_floor_id,:mg_hostel_room_type_id,:name,:is_occupiable,:reason,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def hostel_rooms_update_params
    params.require(:hostel_rooms).permit(:reason,:mg_hostel_details_id, :mg_hostel_floor_id,:name,:is_occupiable,:is_deleted,:updated_by,:mg_school_id)
  end

  def room_reallotment_params
    params.require(:reallotment).permit(:mg_hostel_details_id,:mg_student_id, :mg_hostel_floor_id,:mg_hostel_room_type_id,:mg_wing_id,:mg_hostel_room_id,:status,:is_deleted,:updated_by,:created_by,:mg_school_id)
  end

  def complain_hostel_params
    params.require(:complain_hostel).permit(:mg_hostel_details_id,:room_no,:reason,:programme,:status,:mg_student_id,:created_by,:is_deleted,:updated_by,:mg_school_id)
  end

  def complain_hostel_update_params
    params.require(:complain_hostel).permit(:mg_hostel_details_id,:room_no,:reason,:programme,:status,:mg_student_id,:is_deleted,:updated_by,:mg_school_id)
  end


  def provision_params
    params.require(:going_out_prov).permit(:reason, :start_time,:end_time,:status,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def provision_params_update
    params.require(:going_out_prov).permit(:reason, :start_time,:end_time,:is_deleted,:updated_by,:mg_school_id)
  end


  def subject_params
    params.require(:hostel_fees).permit(:name,:description,:is_deleted, :mg_school_id)
  end

  def particular_params
    params.require(:fesses2).permit(:mg_particular_type_id,:description,:fee_category,:is_deleted, :mg_school_id,:amount,
     :admission_no)
  end

  def update_particular_params
    params.require(:fesses2).permit(:name,:description,:fee_category,:is_deleted, :mg_school_id,:amount, :admission_no, :mg_student_category_id)
  end

  def health_mgmt_params
    params.require(:health_management).permit(:reason,:mg_hostel_details_id,:status,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def health_mgmt_params_update
    params.require(:health_management).permit(:reason,:mg_hostel_details_id,:is_deleted,:updated_by,:mg_school_id)
  end

  def employees_ajax_params
    # params.permit(:mg_employee_id, :mg_leave_type_id, :absent_date, :mg_employee_department_id, :reason, :is_halfday, :is_afternoon, :is_deleted, :is_late_come, :time, :abcent_without_notice, :is_lock, :mg_school_id, :created_by, :updated_by)
    params.permit(:mg_hostel_detail_id , :mg_wing_id,:absent_date, :reason, :is_deleted, :is_late_come, :time, :absent_without_notice, :is_lock, :mg_school_id, :created_by, :updated_by)
  end

  def student_ajax_params
    params.permit(:mg_student_id,:morning_reason,:evening_reason,:morning_late_reason,:evening_late_reason,:absent_date, :mg_hostel_detail_id, :reason, :is_deleted,
      :time,:evening_late_time, :absent_without_notice, :mg_school_id, :created_by, :updated_by)
  end
  

end
