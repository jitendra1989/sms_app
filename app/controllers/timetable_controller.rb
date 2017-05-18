class TimetableController < ApplicationController
  layout "mindcom"
  before_filter :login_required
  def weekday_index
     @class_id=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>1).pluck(:id)
    #@batches = MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@class_id)
     @allvalue=["0","1","2","3","4","5","6"]
    @weekdaychecked=[]#MgWeekday.where(:mg_wing_id=>nil,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:weekday)
    @schoolWings=MgWing.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:wing_name,:id)
  end
  
  def index
   @academic_name=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    @batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @weekDays=MgClassTiming.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)

  end

  def create
    MgWeekday.transaction do
    @wing_id=params[:mg_wing_id]
    if @wing_id==""
      @wing_id=nil
    else
      @wing_id=params[:mg_wing_id]
    end

    # @wing_id=params[:mg_wing_id]
    @checked_week_day_id=params[:checked_weekday]
    @checked_weeks=@checked_week_day_id.split(",")

    #This for updating the is_deleted=0 and creating new record
    for i in 0...@checked_weeks.size
       @checked_weekday=MgWeekday.where(:mg_wing_id=>@wing_id,:weekday=>@checked_weeks[i],:mg_school_id=>session[:current_user_school_id])
       if @checked_weekday.size<1
          @checked=MgWeekday.new()
          # @checked.mg_batch_id=@wing_id
          @checked.weekday=@checked_weeks[i]
          @checked.is_deleted=0
          @checked.mg_school_id=session[:current_user_school_id]
          @checked.day_of_week=@checked_weeks[i]
          @checked.mg_wing_id=@wing_id
          @checked.save
     else
        @checked_weekday[0].update(:is_deleted=>0)
      end
      
    end

    #This for updating the is_deleted=1
    @unchecked_week_day_id=params[:unchecked_weekday]
    @unchecked_weeks=@unchecked_week_day_id.split(",")
    for i in 0... @unchecked_weeks.size
       @unchecked_weekday=MgWeekday.where(:mg_wing_id=>@wing_id,:weekday=>@unchecked_weeks[i])
        if @unchecked_weekday.size>0
          @unchecked_weekday[0].update(:is_deleted=>1)
        end
    end
  end
  end

  def show
    @wing_id=params[:mg_wing_id]
    if @wing_id==""
      @wing_id=nil
    else
      @wing_id=params[:mg_wing_id]
    end
    @allvalue=["0","1","2","3","4","5","6"]
    @weekdaychecked=MgWeekday.where(:mg_wing_id=>@wing_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:weekday)
   puts "checked_days in show for default"
   puts @weekdaychecked
    render :layout => false
  end



  def show_batch_timetables

    # timeTableEntries=MgTimeTableEntry.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    # @displayTimeTable="<table class='disply-all-timeTable-tbl-div' cellpadding='0' cellspacing='0'>"

    # finalArray=Array.new
    # weekDayHash=Hash.new
    # weekDayHash[0]='Sunday'
    # weekDayHash[1]="Monday"
    # weekDayHash[2]="Tuesday"
    # weekDayHash[3]="Wednesday"
    # weekDayHash[4]="Thursday"
    # weekDayHash[5]="Friday"
    # weekDayHash[6]="Saturday"

    # puts weekDayHash[0]
    # if timeTableEntries.present?
    #   timeTableEntries.each_with_index do|timeTableEntry, index|
    #       weekDayObj= timeTableEntry.mg_weekday 
    #       batchObj= timeTableEntry.mg_batch 
    #       subjectObj= timeTableEntry.mg_subject 
    #       employeeObj= timeTableEntry.mg_employee   
    #       classTimingObj=MgClassTiming.find(timeTableEntry.mg_class_timings_id)

    #       combinedHash=Hash.new

    #       if weekDayObj.present?
    #         combinedHash[:week_day_id]=weekDayObj.day_of_week
    #         combinedHash[:week_day_name]=weekDayHash[weekDayObj.day_of_week]
    #       else
    #         combinedHash[:week_day_id]=nil
    #         combinedHash[:week_day_name]=''
    #       end

    #       if classTimingObj.present?
    #         startTime = classTimingObj.start_time.strftime("%k:%M%p")
    #         endTime   = classTimingObj.end_time.strftime("%k:%M%p")
    #         combinedHash[:class_timing_id]=classTimingObj.id
    #         combinedHash[:start_time]=startTime
    #         combinedHash[:end_time]=endTime
            
    #       else
    #         combinedHash[:class_timing_id]=''
    #         combinedHash[:start_time]=''
    #         combinedHash[:end_time]=''
            
    #       end

    #       if batchObj.present?
    #         combinedHash[:batch_id]= batchObj.id
    #         combinedHash[:batch_name]=batchObj.course_batch_name
    #       else
    #         combinedHash[:batch_id]= ''
    #         combinedHash[:batch_name]=''
    #       end

    #       if subjectObj.present?
    #         combinedHash[:subject_id]= subjectObj.id
    #         combinedHash[:subject_name]=subjectObj.subject_name
    #       else
    #         combinedHash[:subject_id]= ''
    #         combinedHash[:subject_name]=''
    #       end

    #       if employeeObj.present?
    #         combinedHash[:employee_id]= employeeObj.id
    #         combinedHash[:employee_name]=employeeObj.first_name
    #       else
    #         combinedHash[:employee_id]= ''
    #         combinedHash[:employee_name]=''
    #       end
    #       finalArray<<combinedHash
    #   end
    # end
    # #weekDays.sort! { |a,b| a.day_of_week <=> b.day_of_week }
    # #finalArray.sort! {|a,b| a[:day_of_week] <=> b[:day_of_week]}
    # finalArray.sort! { |a, b| [a[:batch_id], a[:week_day_id], a[:start_time]] <=> [b[:batch_id], b[:week_day_id], b[:start_time]] }
    # #finalArray.sort! { |a, b| [a[:week_day_id], a[:batch_id], a[:start_time]] <=> [b[:week_day_id], b[:batch_id], b[:start_time]] }
    
    # # return_keys = [ :batch_id]
    # # batch_id_array = finalArray.collect do |event|
    # #   Hash[
    # #     return_keys.collect do |key|
    # #       [ key, event[key] ]
    # #     end
    # #   ]
    # # end

    # #hsh=finalArray.select { |a| a[ :batch_id]== a[ :batch_id] }
    # #puts "hsh"
    # #puts hsh

    # periodTimingHash=Hash.new
    # for i in 0...8
    #   if finalArray.size>=8
    #     sTime=finalArray[i][:start_time]
    #     eTime=finalArray[i][:end_time]
    #     periodTimingHash[i]="#{sTime}-#{eTime}"
    #   end
    # end

    # testBatch=0
    # testWeek="abc"
    # closeTR="No"
    # currentDay=""
    # displayTimeTableRow=""
    # @displayTimeTableWeekName=""
    # @displayTimeTableTiming=""
    # count=0
    # s_time=""
    # e_time=""
    # for i in 0...finalArray.size
    #   # if i==0
    #   #   @displayTimeTable +="<tr class='tbl-tr'>"
    #   #   finalArray[i].each do |key, value|
    #   #     @displayTimeTable +="<td class='tbl-td' >#{key} </td>"
    #   #   end
    #   #   @displayTimeTable +="</tr>"
    #   # end

    #   # @displayTimeTable +="<tr class='tbl-tr'>"
    #   # finalArray[i].each do |key, value|
    #   #   @displayTimeTable +="<td class='tbl-td' >#{value} </td>"
    #   # end
    #   # @displayTimeTable +="</tr>"

    #   checkBatch=finalArray[i][:batch_id]
    #   weekDayName=finalArray[i][:week_day_name]
    #   startTime=finalArray[i][:start_time]
    #   endTime=finalArray[i][:end_time]
    #   batchName=finalArray[i][:batch_name]
    #   subjectName=finalArray[i][:subject_name]
    #   employeeName=finalArray[i][:employee_name] 

    #   if i==0
    #     testBatch=checkBatch
    #     testWeek=weekDayName
    #     #first tr of the table

    #     # @displayTimeTable +="<tr class='tbl-tr'> 
    #     #           <td class='tbl-td' ></td>
    #     #           <td class='tbl-td' colspan='8' align='center'>Monday</td>
    #     #           <td class='tbl-td' colspan='8' align='center'>Tuesday</td>
    #     #           <td class='tbl-td' colspan='8' align='center'>Wednesday</td>
    #     #           <td class='tbl-td' colspan='8' align='center'>Thursday</td>
    #     #           <td class='tbl-td' colspan='8' align='center'>Friday</td>
    #     #           <td class='tbl-td' colspan='8' align='center'>Saturday</td>
    #     #           </tr>"

    #     @displayTimeTable +="<tr class='tbl-tr'> <th class='tbl-td'></th>"
    #     for i in 1...7
    #       @displayTimeTable +="<th class='tbl-td mg-align-center mg-tbl-padding-mod' colspan='8'>#{weekDayHash[i]}</th>"
    #     end
    #     @displayTimeTable +="</tr> "

    #     @displayTimeTable +="<tr class='tbl-tr'><td class='tbl-td' ></td> "
    #     for i in 0...6
    #       for j in 0...8
    #         @displayTimeTable +="<td class='tbl-td mg-table-heading mg-tbl-padding-mod' >#{periodTimingHash[j]}</td>"
    #       end
    #     end
    #     @displayTimeTable +="</tr> "

    #     displayTimeTableRow +="<tr class='tbl-tr'>"
    #     displayTimeTableRow +="<td class='tbl-td mg-tbl-cell-size mg-tbl-padding-mod' >#{batchName}</td>"

    #     @displayTimeTableWeekName +="<tr class='tbl-tr'><td class='tbl-td' ></td>"
    #     @displayTimeTableTiming   +="<tr class='tbl-tr'><td class='tbl-td' ></td>"
    #   end
      
    #   if checkBatch==testBatch
    #     # add the td in the tr 
    #     #displayTimeTableRow +="<td class='tbl-td' >#{weekDayName}-#{startTime}-#{endTime}-#{subjectName}
    #     #      -#{employeeName} </td>"
    #     displayTimeTableRow +="<td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size mg-tbl-bg-color-#{subjectName}' ><span class='mg-tbl-font-weight'>#{subjectName}</span><br/>#{employeeName}</td>"
    #     if count==1
    #       currentDay=testWeek
    #       #s_time=startTime
    #       #e_time=endTime
    #     end

    #     if weekDayName==testWeek
    #       count +=1
    #       currentDay=weekDayName
    #       @displayTimeTableTiming +="<td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size' >#{startTime}&nbsp;-#{endTime}</td>"
    #     else
    #       #currentDay=weekDayName
    #       @displayTimeTableWeekName +="<td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size' colspan='#{count}' >#{currentDay}</td>"

    #       @displayTimeTableTiming +="<td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size' >#{startTime}&nbsp;-#{endTime}</td>"
    #       count=0
    #       count +=1
    #       #s_time=startTime
    #       #e_time=endTime
    #     end

    #   else
    #     #close the tr if batch is change and add new tr for the
    #     #new batch
    #     displayTimeTableRow +="</tr>"

    #     @displayTimeTableWeekName +="<td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size' colspan='#{count}' >#{testWeek}</td>"
    #     @displayTimeTableWeekName +="</tr>"

    #     @displayTimeTableTiming +="</tr>"

    #     #@displayTimeTable +="<tr class='tbl-tr'><td class='tbl-td' colspan='#{count+1}' >#{weekDayName}</td></tr>"
    #     #@displayTimeTable += @displayTimeTableWeekName

    #     #@displayTimeTable +=@displayTimeTableWeekName
        
    #     #@displayTimeTable +=@displayTimeTableTiming
    #     @displayTimeTable += displayTimeTableRow

    #     displayTimeTableRow=""
    #     @displayTimeTableWeekName =""
    #     @displayTimeTableTiming=""

    #     displayTimeTableRow +="<tr class='tbl-tr'>"
    #     # displayTimeTableRow +="<td class='tbl-td' >#{batchName}</td><td class='tbl-td' >#{weekDayName}-#{startTime}-#{endTime}-#{subjectName}
    #     #     -#{employeeName} </td>"

    #      displayTimeTableRow +="<td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size' >#{batchName}</td><td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size mg-tbl-bg-color-#{subjectName}' ><span class='mg-tbl-font-weight'>#{subjectName}</span><br>#{employeeName} </td>"

    #     @displayTimeTableWeekName +="<tr class='tbl-tr'><td class='tbl-td' ></td>"
    #     @displayTimeTableTiming +="<tr class='tbl-tr'><td class='tbl-td' ></td>"
    #     @displayTimeTableTiming +="<td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size'>#{startTime}&nbsp;-#{endTime}</td>"
    #     count=0
    #     count +=1
    #   end

    #   testBatch=checkBatch
    #   testWeek=weekDayName
    #   #s_time=startTime
    #   #e_time=endTime

    # end

    # @displayTimeTableWeekName +="<td class='tbl-td mg-tbl-padding-mod mg-tbl-cell-size' colspan='#{count}' >#{testWeek}</td>"
    # @displayTimeTableWeekName +="</tr>"
    # @displayTimeTableTiming +="</tr>"
    # displayTimeTableRow +="</tr>"

    # #@displayTimeTable +=@displayTimeTableWeekName
    # #@displayTimeTable +=@displayTimeTableTiming
    # @displayTimeTable +=displayTimeTableRow
    # @displayTimeTable +="</table>"


  end




  def batches_for_selected_wing_in_classtimings
     @classId_for_selected_wing=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:mg_wing_id]).pluck(:id)
    @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@classId_for_selected_wing)
    
    render :layout => false
  end

 def class_timing_index
  #@class_id=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>1).pluck(:id)
  #@batches = MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@class_id)
  @commonClassTimings=[]#MgClassTiming.where(:is_deleted=>0,:mg_wing_id=>nil,:mg_school_id=>session[:current_user_school_id])
  @schoolWings=MgWing.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:wing_name,:id)
  # puts "inside class_timings index"
  # puts @commonClassTimings.length.inspect
  # puts @commonClassTimings.inspect
 end

 def create_class_timing
  @allvalue=["0","1","2","3","4","5","6"]
  @wing_id=params[:mg_wing_id]
  if @wing_id==""
    @wing_id=nil
  else
    @wing_id=params[:mg_wing_id]
  end
  @weekdays=MgWeekday.where(:mg_wing_id=>@wing_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  render :layout => false
 end

 def save_class_timing
  MgClassTiming.transaction do
  @wing_id=params[:mg_wing_id]
  @checkedvalue=params[:checkedvalue]
  @checked_day=@checkedvalue.split(",")

  @checked_day.each do|checked|
    class_timings=MgClassTiming.new(ajax_create_params)
    class_timings.mg_weekday_id=checked
    @responcet = class_timings.save
    puts "from model"
    puts  @responcet
  end  

    if (!@responcet)
      respond_to do |format|
        format.json  { render :json => @responcet }
      end
    else
      respond_to do |format|
        format.json  { render :json => @responcet }
      end
    end
  end
 end

 def edit_class_timing
  @classtimings=MgClassTiming.find(params[:id])
  puts "class Timings"
  puts @classtimings.mg_batch_id.inspect
  puts @classtimings.mg_wing_id.inspect

  @weekDays=MgWeekday.where(:mg_wing_id=>@classtimings.mg_wing_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  puts "week days"
  puts @weekDays[0].id.inspect
  @weekdayIds = MgClassTiming.where(:mg_wing_id=>@classtimings.mg_wing_id ,:name=> @classtimings.name,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_weekday_id)
  puts "weekdayIds=="
  puts @weekdayIds
  #@weekdayIds = @weekdays.id

 
  #@weekdaycheckedforClass=MgWeekday.where(:id=> @weekdays.id, :is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:weekday)

  #puts "@weekdaycheckedforClass"
  #puts @weekdaycheckedforClass
  render :layout => false
 end

 def update_class_timing

  MgClassTiming.transaction do
  @wing_id=params[:mg_wing_id]
  @checked_week_day_value=params[:checkedWeekdayValue]
  @checked_week_day_edit=@checked_week_day_value.split(",")

  for i in 0...@checked_week_day_edit.size
      @classtimings=MgClassTiming.find(params[:id])
      #@dayTest=MgWeekday.where(:mg_batch_id=>@classtimings.mg_batch_id,:weekday=>@checked_week_day_edit[i])
       @checked_weekday_class_edit=MgClassTiming.where(:name=> @classtimings.name,:mg_weekday_id=> @checked_week_day_edit[i],:mg_wing_id=>@wing_id)
       
       if  @checked_weekday_class_edit.size < 1
       
          @checked_days=MgClassTiming.new
          @checked_days.mg_batch_id=@classtimings.mg_batch_id
          @checked_days.name=@classtimings.name
          @checked_days.start_time=params[:start_time]
          @checked_days.end_time=params[:end_time]
          @checked_days.is_break=params[:is_break]
          @checked_days.is_deleted=@classtimings.is_deleted
          @checked_days.mg_school_id=@classtimings.mg_school_id
          @checked_days.mg_weekday_id=@checked_week_day_edit[i]
          @checked_days.mg_wing_id=@wing_id
          @checked_days.save
     else
      @checked_weekday_class_edit[0].update(ajax_edit_params)
      end
  end
    

  @unchecked_week_day_value=params[:uncheckedWeekdayValue]
  @unchecked_week_day_edit=@unchecked_week_day_value.split(",")
  
  for i in 0...@unchecked_week_day_edit.size
       @uncheckedclasstimings=MgClassTiming.find(params[:id])
       @unchecked_weekday_for_edit_class=MgClassTiming.where(:name=> @uncheckedclasstimings.name,:mg_weekday_id=>@unchecked_week_day_edit[i],:mg_wing_id=>@wing_id)
        if @unchecked_weekday_for_edit_class.size>0
          @uncheckIsUpdated=@unchecked_weekday_for_edit_class[0].update(:is_deleted=>1)
        end
  end

  # puts "from model"
  # puts @checkIsSaved

  # puts "from model"
  # puts @checkIsUpdated

  # puts "from model"
  # puts @uncheckIsUpdated

    # if (!@checkIsSaved &&!@checkIsUpdated &&!@uncheckIsUpdated)
    #   puts "inside if"
    #     respond_to do |format|
    #       format.json  { render :json => @checkIsSaved }
    #     end
    # else
    #     puts "inside else"
    #     respond_to do |format|
    #       format.json  { render :json => @checkIsSaved }
    #     end
    # end
    end
 end

 def delete_class_timings
    @classtimings=MgClassTiming.find(params[:id])
    @classtimings.update(:is_deleted=>1)
 end

 def show_class_timings
  @wing_id=params[:mg_wing_id]
  if @wing_id==""
     @wing_id=nil
    else
      @wing_id=params[:mg_wing_id]
    end
     # @weekdaychecked=MgBatch.find(@wing_id).mg_weekdays.where(:is_deleted=>0).pluck(:weekday)
     #@commonClassTimings #= MgBatch.find(@wing_id).mg_weekdays.mg_class_timings.where(:is_deleted=>0)
     puts "inside show_class_timings"

   @commonClassTimings=MgClassTiming.where(:mg_wing_id=>@wing_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  
   render :layout => false
 end

 def time_table_index
  @academicdetails=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order("start_date ASC").paginate(page: params[:page], per_page: 10)
 end

 def create_time_table
  MgTimeTable.transaction do
   @time_table=MgTimeTable.new(create_time_table_params)
     @current_school = MgSchool.find(session[:current_user_school_id])
     @startDate = Date.strptime(params[:createTimeTable][:start_date],@current_school.date_format)
     @endDate   = Date.strptime(params[:createTimeTable][:end_date],@current_school.date_format)
    @time_table.update(:start_date => @startDate,:end_date => @endDate)
    @isSaved=@time_table.save
    puts "from model"
   puts @isSaved

   if(!@isSaved)
    puts "inside if"
     @object="Given date range overlaps with existing academic year."
  end
    redirect_to :action=>'time_table_index',:notice=>@object
  end
 
 end

 def new_time_table
    render :layout => false
 end

 def edit_time_table
  @acdameic_detail=MgTimeTable.find(params[:id])
  puts "inside edit time table"
  puts @acdameic_detail.inspect
  render :layout => false

 end

 def update_time_table
  MgTimeTable.transaction do
   @academic_detail_for_update=MgTimeTable.find(params[:id])
   @current_school = MgSchool.find(session[:current_user_school_id])
   @startDate = Date.strptime(params[:editTimeTable][:start_date],@current_school.date_format)
   @endDate   = Date.strptime(params[:editTimeTable][:end_date],@current_school.date_format)
  @isUpdated=@academic_detail_for_update.update(:name=>params[:editTimeTable][:name],:start_date => @startDate,:end_date => @endDate)
  #@academic_detail_for_update.update(edit_time_table_params)
   if(!@isUpdated)
      puts "inside if"
     @object="Given date range overlaps with existing academic year."
  end
   redirect_to :action=>'time_table_index',:notice=>@object
  end
 end

 def delete_time_table
   @academic_detail_for_delete=MgTimeTable.find(params[:id])
   @academic_detail_for_delete.update(:is_deleted=>1)
   #redirect_to :action=>'time_table_index'
   @academicdetails=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  render :layout => false
 end

def time_table_associate_index
   #@academic_name=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    #@batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    #@weekDays=MgClassTiming.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    
  end

  def batch_wise_select_class_timings_name
    @batch_id=params[:batch_id]
    wing_idArray=Array.new
    if @batch_id==""
     @batch_id=nil
    else
      @batch_id=params[:mg_batch_id]
    end
      @batch_id = MgBatch.find(params[:batch_id])
      @wing_id=MgBatch.find(params[:batch_id]).mg_course.mg_wing_id
      # puts "Batch_id=="
      # puts @batch_id.inspect
      puts "wing id===="
      puts @wing_id
   
    wing_idArray.push(@wing_id)
     @classTimingName=MgClassTiming.where(:mg_wing_id=>@wing_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_break=>0).pluck(:name, :id)
    @classTimingNameTable=MgClassTiming.where(:mg_wing_id=>@wing_id,:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:is_break=>0).order(:mg_weekday_id, :start_time)#, MgWeekday.find(:mg_weekday_id).weekday
     
     @SubjectIds = MgBatchSubject.where(:mg_batch_id=>@batch_id,:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:mg_subject_id)
    @subject=MgSubject.where(:is_deleted=>0,:id=>@SubjectIds,:mg_school_id=>session[:current_user_school_id]).pluck(:subject_name,:id)
    @employee=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:first_name,:id)
    
    @mg_time_table_id=params[:mg_time_table_id]
   
     render :layout => false
  end

  def batch_wise_week_day_time_table
    @name=params[:name]
    @weekDays=MgClassTiming.where(:id=>@name,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    
    @subject=MgSubject.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:subject_name,:id)
    @employee=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:first_name,:id)

    # @timetable=MgTimeTableEntry.where(:mg_class_timings_id=>@weekDays.id)


    render :layout => false
  end

  def teacher_for_subject
    if params[:sub]=='Subject'
      sql="select b.first_name, b.id from mg_employee_subjects a, mg_employees b where a.mg_subject_id=#{params[:subject]} and a.mg_employee_id=b.id"
      @employee=MgEmployeeSubject.find_by_sql sql
      # puts "SubjectId"
      # puts params[:subject]
      # @employeeId=MgEmployeeSubject.where(:mg_subject_id=>params[:subject]).pluck(:mg_employee_id)
      # puts "EmployeeId"
      # puts @employeeId
      # @employee=MgEmployee.where(:id=>@employeeId).pluck(:first_name,:id)
      # puts "@employee"
      # puts @employee

      #validation for teachers start
      #@time_table_entry=MgTimeTableEntry.where(:mg_class_timings_id=>@mg_class_timings_id[i], :mg_weekday_id=>@weekdays[i], :is_deleted=>0, :mg_batch_id=>params[:batch], :mg_timetable_id=>params[:mg_time_table_id],:mg_school_id=>session[:current_user_school_id])
    
    end
    render :layout => false
  end

  def teacher_for_subject_save
      @subject=params[:subject]
      @employee=params[:employees]
      @weekdays=params[:weekday_id]
      @mg_class_timings_id=params[:mg_class_timings_id]
      
      for i in 0...@employee.size
        if @employee[i].present?
          @time_table_entry=MgTimeTableEntry.where(:mg_class_timings_id=>@mg_class_timings_id[i], :mg_weekday_id=>@weekdays[i], :is_deleted=>0, :mg_batch_id=>params[:batch], :mg_timetable_id=>params[:mg_time_table_id],:mg_school_id=>session[:current_user_school_id])
          if @time_table_entry.present?
            @update=MgTimeTableEntry.find(@time_table_entry[0].id)
            @update.mg_employee_id=@employee[i]
            @update.mg_subject_id=@subject[i]
            @update.save
          else
          @timetableentrie=MgTimeTableEntry.new(:mg_batch_id=>params[:batch],:mg_class_timings_id=> @mg_class_timings_id[i],:mg_subject_id=>@subject[i], :mg_employee_id=>@employee[i],:mg_weekday_id=>@weekdays[i], :mg_timetable_id=>params[:mg_time_table_id], :is_deleted=>params[:is_deleted], :mg_school_id=>params[:mg_school_id])
          @timetableentrie.save
          end
        end
      end
     redirect_to :action=>'index'
  end

  def view_time_table_index
    @course=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
    @batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  end

  def batch_for_selected_course
    if params[:course_id]!=""
    @courseID=params[:course_id]
    @batches=MgBatch.where(:mg_course_id=>@courseID,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
     @courses=MgCourse.where(:id=>@courseID,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
     @batch=Array.new
     @courses.each do |batches|
        batches.mg_batches.each do |batch|
           @batchName=Array.new
          @batchName.push(batch.name)
          @batch.push(@batchName)
        end
     end
     render :layout => false
   else
    render :layout => false
  end
end
  def batch_wise_view_time_table
    @wing_id=params[:batch_id]
    @courseId=params[:course_id]
    @courseName=MgCourse.where(:id=> @courseId,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name).join("")
    @batchname=MgBatch.where(:id=>@wing_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name).join("")
    @weekDayForSelectedBatch=MgTimeTableEntry.where(:mg_batch_id=>@wing_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    puts "weekday for selected batch"
    puts @weekDayForSelectedBatch.inspect
    render :layout => false
  end

  def day_wise_view_time_table
    @wing_id=params[:batch_id]
    @courseId=params[:course_id]
    @weekdayId=params[:day_id]
    @courseName=MgCourse.where(:id=> @courseId,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name).join("")
    @batchname=MgBatch.where(:id=>@wing_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name).join("")
    @weekDayForSelectedBatch=MgTimeTableEntry.where(:mg_batch_id=>@wing_id,:is_deleted=>0,:mg_weekday_id=>@weekdayId,:mg_school_id=>session[:current_user_school_id])
    render :layout => false
  end

  def change_teacher_index
    mg_school_id=session[:current_user_school_id]
    @school=MgSchool.find(mg_school_id)
    @acadamic_year= MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    # @batch_name=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    @subject=MgSubject.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:subject_name,:id)
    # @employee=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:first_name,:id)
    # @period=MgClassTiming.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    @course=MgCourse.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:course_name, :id)
    date=Date.today
    if params[:changed_date].present?
      date=Date.strptime(params[:changed_date],@school.date_format)
    else
      params[:changed_date]=date.strftime(@school.date_format)
    end
    @change_teacher_list=MgTimeTableChangeEntry.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :date=>date, :is_permanent=>0)
  end

  def class_timings_for_selected_batch
    mg_school_id=session[:current_user_school_id]
    @school=MgSchool.find(mg_school_id)
    weekday_hash=Hash.new
    weekday_hash[0]= "Sunday"
    weekday_hash[1]= "Monday"
    weekday_hash[2]= "Tuesday" 
    weekday_hash[3]= "Wednesday" 
    weekday_hash[4]= "Thursday"
    weekday_hash[5]= "Friday"
    weekday_hash[6]= "Saturday"
    if params[:key_select]=='batch'
      date=Date.strptime(params[:date],@school.date_format)
      puts date.strftime("%w")
      weekdays=MgWeekday.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :weekday=>date.strftime("%w"))

       batch=MgBatch.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id)
       @period=MgClassTiming.where(:mg_wing_id=>batch.mg_wing_id_for_batch,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_weekday_id=>weekdays).includes(:mg_weekday).order("mg_weekdays.weekday asc")#.pluck(:id, :name)
   
      period_hash=Array.new

      @period.order(:start_time).each do |p|
        period_hash.push({
          "id"=>p.id,
          "weekday_name"=>p.weekday_name,
          "name"=>p.start_time.strftime("%k:%M%p").to_s+"-"+p.end_time.strftime("%k:%M%p").to_s
        })
      end
      @object=period_hash
    elsif params[:key_select]=='course'
      @object =MgBatch.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_course_id=>params[:mg_course_id])
    # elsif params[:key_select]=='batch'
    elsif params[:key_select]=="class_timing"
    elsif params[:key_select]=="delete"
      oblect=MgTimeTableChangeEntry.find(params[:id])
      oblect.is_deleted=1
      @object = oblect.save
    elsif params[:key_select]=='restore'
      oblect=MgTimeTableChangeEntry.find(params[:id])
      oblect.is_deleted=1
      @object = oblect.save
      if oblect.present?
        restore=MgTimeTableEntry.find_by(:id=>oblect.mg_time_table_entry_id)
        restore.mg_employee_id=oblect.old_mg_employee_id
        restore.mg_subject_id=oblect.old_mg_subject_id
        restore.mg_batch_id=oblect.old_mg_batch_id
        restore.save
      end
    elsif params[:key_select]=='subject'

        employees_ids=MgEmployeeSubject.where(:mg_subject_id=>params[:mg_subject_id],:mg_school_id=>mg_school_id).pluck(:mg_employee_id)
        time_table_entry=MgTimeTableEntry.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_class_timings_id=>params[:mg_class_timing_id], :mg_timetable_id=>params[:mg_timetable_id], :mg_batch_id=>params[:mg_batch_id]).pluck(:mg_employee_id)
        puts "----1"
        puts employees_ids.inspect
        puts "----2"
        puts ""
        puts time_table_entry.inspect
        puts "----3"

        employees_ids -=time_table_entry
        puts employees_ids.inspect
        puts "----4"

        # attendance_teach= MgEmployee.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>'Teaching Staff').id), :id=>@employee_list)
        employee_list=MgEmployeeAttendance.where(:is_deleted=>0,:absent_date=>Date.today(), :mg_school_id=>mg_school_id).pluck(:mg_employee_id)
        employees_ids -=employee_list
        employee=MgEmployee.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>employees_ids)
        employee_arr=Array.new
       
        puts employee_list.inspect

        puts "----5"
        puts employees_ids.inspect
        employee.each do |emp|
          employee_arr.push({
            "id"=>emp.id,
            "name"=>emp.first_name.to_s+" "+emp.last_name.to_s+" ( #{emp.employee_number} )"
            })
        end
      @object=employee_arr
    end
    render :json =>  @object 

  end

  def teacher_for_selected_subject
    @employeesId=MgEmployeeSubject.where(:mg_subject_id=>params[:subjectId],:mg_school_id=>session[:current_user_school_id])
    @keyAndValue=Array.new
    @employeesId.each do |emp|
        @employee=Array.new
        @employee.push(emp.mg_employee.first_name) 
        @employee.push(emp.mg_employee.id) 
        @keyAndValue.push(@employee)
     end
     render :layout => false
  end

  def select_batch_for_show_time_table

   mg_school_id=session[:current_user_school_id]
    
    #@wing_id = MgBatch.find(params[:batch_id]).mg_course.mg_wing_id
    if params[:batch_id]!=""

    @academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    puts @academic_years.inspect
    @timetables

    @timetables=MgTimeTableEntry.where(:mg_batch_id=>params[:batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

    # unless( @academic_years.nil?)
    #   if( @academic_years.length>0)
    #     @timetables=MgTimeTableEntry.where(:mg_timetable_id=>@academic_years[0].id,:mg_batch_id=>params[:batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    #       puts @timetables.inspect
          
    #   end
    # end
    puts "---------------------------------------------"
      timetables=ShowTimetable.new
      time_table_arr=timetables.student_show_time_table(params[:batch_id], mg_school_id, @academic_years[0].try(:id))


    puts "---------------------------------------------"

    # time_table_arr=student_time_table_show(params[:batch_id], mg_school_id)

  if time_table_arr.present?
    @timetable=time_table_arr[0]
    @big_weekday=time_table_arr[1]
  end
    
    render :layout => false
  else
@data="data is empty"
render :layout => false
  end
    
  end
  def view_employee_time_table_index
    @department=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck( :department_name, :id)

  end

  def all_employee_for_time_table
    @employee=MgEmployee.where(:mg_employee_department_id=>params[:mg_employee_department_id], :is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:first_name, :id)
    render :layout => false
    
  end
  def employee_time_table
    mg_school_id=session[:current_user_school_id]
     @academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
     puts "academicdetails for employee"
     puts @academic_years.inspect
     #logger.infoazxckh
     @timetables=MgTimeTableEntry.where(:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

    #  if @academic_years.size>0
    #     @timetables=MgTimeTableEntry.where(:mg_timetable_id=>@academic_years[0].id,:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    # else
    #   @timetables=MgTimeTableEntry.new
    # end

     timetables=ShowTimetable.new
      time_table_arr=timetables.employee_time_table_show(params[:mg_employee_id], mg_school_id, @academic_years[0].try(:id))
      if time_table_arr.present?
        @timetable=time_table_arr[0]
        @big_weekday=time_table_arr[1]
      end
    render :layout => false
    
  end
  def view_subject_time_table
    @subject=MgSubject.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:subject_code,:id)

  end

  def view_subject_time_table_index
    mg_school_id=session[:current_user_school_id]
     @academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
     puts "academicdetails for employee"
     puts @academic_years.length

     @timetables=MgTimeTableEntry.where(:mg_subject_id=>params[:mg_subject_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    #  if @academic_years.length>0
    #   @timetables=MgTimeTableEntry.where(:mg_timetable_id=>@academic_years[0].id,:mg_subject_id=>params[:mg_subject_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    # else
    #   @timetables=MgTimeTableEntry.new
    # end

    timetables=ShowTimetable.new
      time_table_arr=timetables.subject_time_table_show(params[:mg_subject_id], mg_school_id, @academic_years[0].try(:id))
      if time_table_arr.present?
        @timetable=time_table_arr[0]
        @big_weekday=time_table_arr[1]
      end

    # subject_time_table_show(mg_subject_id,mg_school_id, mg_timetable_id)
      render :layout => false

    
  end
def view_free_teachers_time_table
  sql="select distinct a.id from mg_employees a, mg_time_table_entries b, mg_employee_categories c where not(a.id=b.mg_employee_id) and a.is_deleted=0 and b.is_deleted=0 and a.mg_employee_category_id=(SELECT id FROM mg_employee_categories where category_name='Teaching Staff');"
  @freeEmployee=MgEmployee.find_by_sql sql

  #@period=MgClassTiming.where(:is_deleted=>0).pluck(:name, :id)
#shr
  @period=MgClassTiming.where(:is_deleted=>0,:is_break=>0,:mg_school_id=>session[:current_user_school_id]).group(:name).pluck(:name)
end

def absent_teachers

  @absent_teachers=MgEmployeeAttendance.where(:mg_school_id=>session[:current_user_school_id],:absent_date=>DateTime.now.strftime('%Y-%m-%d'))
  
end
def show_free_teacher
  #@timetables=MgTimeTableEntry.where(:mg_class_timings_id=>params[:class_time_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  #@freeTeacher=MgTimeTableEntry.where(:mg_class_timings_id=>params[:class_time_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_id)
 @academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
     puts "academicdetails for employee"
     puts @academic_years.length

  @mg_class_timings = MgClassTiming.where(:name=>params[:class_time_name],:mg_school_id=>session[:current_user_school_id]).pluck(:id)
  
 #  if(@academic_years.length>0)
 #    @timetables=MgTimeTableEntry.where(:mg_timetable_id=>@academic_years[0].id,:mg_class_timings_id=>@mg_class_timings,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
 #    @occupiedTeacher=MgTimeTableEntry.where(:mg_timetable_id=>@academic_years[0].id,:mg_class_timings_id=>@mg_class_timings,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_id)
 #    @free_teacher = MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>1,:mg_school_id=>session[:current_user_school_id])
 #    @free_teacher = MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>1,:mg_school_id=>session[:current_user_school_id]).where('id not in (?)',@occupiedTeacher) unless @occupiedTeacher.empty?
 # else
 #  @timetables=MgTimeTableEntry.new
 # end
emp_category=MgEmployeeCategory.find_by(:category_name=>"Teaching Staff")
@timetables=MgTimeTableEntry.where(:mg_class_timings_id=>@mg_class_timings,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@occupiedTeacher=MgTimeTableEntry.where(:mg_class_timings_id=>@mg_class_timings,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_id)
@free_teacher = MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>emp_category.id,:mg_school_id=>session[:current_user_school_id])
#@free_teacher = MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>1,:mg_school_id=>session[:current_user_school_id]).where('id not in (?)',@occupiedTeacher) unless @occupiedTeacher.empty?

  #@employee=MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>1,:mg_school_id=>session[:current_user_school_id]).pluck(:id)
   # @all_employee=MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>1,:mg_school_id=>session[:current_user_school_id] ).pluck(:id)
  
 #for i in 0...@freeTeacher.size
  
  #@employee.delete(@freeTeacher[i]) 
 #end


 puts @timetables.inspect

  render :layout => false
  
end
def batches_for_selected_wing
  @classId_for_selected_wing=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:mg_wing_id]).pluck(:id)
  @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@classId_for_selected_wing)
  render :layout => false
end

def generate_timetable
school_id = session[:current_user_school_id]
  @notice = ""
 begin
   gtt = TimeTableGenerator.new

   @notice = gtt.create_time_table(school_id)
  rescue Exception => ex
    @notice ="Error occured, please contact administrator"
 end

   puts "After resue"
     render :json=>{:notice=>@notice}
end  

def generate_timetable_2

  school_id = session[:current_user_school_id]

gtt = TimeTableGenerator.new

gtt.create_time_table(school_id)


redirect_to :action=>'time_table_creation' and return
end


def generate_timetable_1



@timetable_generate=MgTimeTableEntry.all

@timetable_generate.each do |timetable|

timetable.update(:is_deleted => 0)


  end
  puts"generate_timetable"
  @timetable_generate

  redirect_to :back
end

def delete_timetable


@timetabledelete=MgTimeTableEntry.all

@timetabledelete.each do |timetable|

timetable.update(:is_deleted => 1)


  end


#   puts "8888888888888888888"
#   # @timetable=MgTimeTableEntry.all
#   # @timetable.destroy
# MgTimeTableEntry.where("id > 0").delete_all
#   #MgTimeTableEntry.delete_all("id > 0")
#   puts "88888888888888888888"
  redirect_to :back
end

def change_teacher_save
  mg_school_id=session[:current_user_school_id]
  user_id=session[:user_id]
  school=MgSchool.find(mg_school_id)
  time_table=MgTimeTableEntry.where(:is_deleted=>0, :mg_school_id=>mg_school_id , :mg_batch_id=>params[:mg_batch_id], :mg_class_timings_id=>params[:mg_class_timing_id], :mg_timetable_id=>params[:acadamic_year])
  puts ""
  puts time_table.inspect
  puts ""
  
  notice=false
  if time_table.present?
    check_time_table=MgTimeTableChangeEntry.where(:mg_time_table_entry_id=>time_table[0].id, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=> mg_school_id, :mg_class_timing_id=>params[:mg_class_timing_id], :mg_timetable_id=>params[:acadamic_year], :is_deleted=>0, :date=>Date.strptime(params[:date],school.date_format), :is_permanent=>0)
      # , :mg_employee_id=>params[:mg_employee_id], :mg_subject_id=>params[:mg_subject_id],
      if check_time_table.present?
        @notice="Time table entry present for selected selection"
      else
        timetable_save=MgTimeTableChangeEntry.new
        timetable_save.mg_time_table_entry_id=time_table[0].id
        timetable_save.mg_batch_id=params[:mg_batch_id]
        timetable_save.mg_school_id=mg_school_id
        timetable_save.mg_class_timing_id=params[:mg_class_timing_id]
        timetable_save.mg_timetable_id=params[:acadamic_year]
        timetable_save.is_deleted=0
        timetable_save.mg_employee_id=params[:mg_employee_id]
        timetable_save.mg_subject_id=params[:mg_subject_id]
        timetable_save.date=Date.strptime(params[:date],school.date_format)
        timetable_save.created_by=user_id
        timetable_save.is_permanent=0
        notice=timetable_save.save
      end
  else
    @notice="Time table entry not present for selected selection"
  end

  if notice
    flash[:notice]="Techer changed successfully"#+", "+@notice.to_s
  else
     flash[:error]=@notice.to_s+", "+" please try again "
  end


  redirect_to :back
  
end

def change_teacher_time_table
   mg_school_id=session[:current_user_school_id]
    @school=MgSchool.find(mg_school_id)
    @permanent_check="permanent"
    @acadamic_year= MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    # @batch_name=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    @subject=MgSubject.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:subject_name,:id)
    # @employee=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:first_name,:id)
    # @period=MgClassTiming.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    @course=MgCourse.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:course_name, :id)
    date=Date.today
    if params[:changed_date].present?
      date=Date.strptime(params[:changed_date],@school.date_format)
    else
      params[:changed_date]=date.strftime(@school.date_format)
    end
    @change_teacher_list=MgTimeTableChangeEntry.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :date=>date, :is_permanent=>1)
end

def change_teacher_permanent_save
  mg_school_id=session[:current_user_school_id]
  user_id=session[:user_id]
  school=MgSchool.find(mg_school_id)
      MgTimeTableEntry.transaction do
        time_table=MgTimeTableEntry.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id , :mg_batch_id=>params[:mg_batch_id], :mg_class_timings_id=>params[:mg_class_timing_id], :mg_timetable_id=>params[:acadamic_year])
        puts ""
        puts time_table.inspect
        puts ""
        
        @notice_result=false
        if time_table.present?
          check_time_table=MgTimeTableChangeEntry.where(:mg_time_table_entry_id=>time_table.id, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=> mg_school_id, :mg_class_timing_id=>params[:mg_class_timing_id], :mg_timetable_id=>params[:acadamic_year], :is_deleted=>0, :date=>Date.strptime(params[:date],school.date_format), :is_permanent=>1)
            # , :mg_employee_id=>params[:mg_employee_id], :mg_subject_id=>params[:mg_subject_id],
            if check_time_table.present?
              @notice="Time table entry present for selected selection"
            else
              timetable_save=MgTimeTableChangeEntry.new
              timetable_save.mg_time_table_entry_id=time_table.id
              timetable_save.mg_batch_id=params[:mg_batch_id]
              timetable_save.mg_school_id=mg_school_id
              timetable_save.mg_class_timing_id=params[:mg_class_timing_id]
              timetable_save.mg_timetable_id=params[:acadamic_year]
              timetable_save.is_deleted=0
              timetable_save.mg_employee_id=params[:mg_employee_id]
              timetable_save.mg_subject_id=params[:mg_subject_id]
              timetable_save.date=Date.strptime(params[:date],school.date_format)
              timetable_save.created_by=user_id
              timetable_save.old_mg_employee_id=time_table.try(:mg_employee_id)
              timetable_save.old_mg_subject_id=time_table.try(:mg_subject_id)
              timetable_save.old_mg_batch_id=time_table.try(:mg_batch_id)
              timetable_save.is_permanent=1
              @notice_result=timetable_save.save

              time_table.mg_employee_id=params[:mg_employee_id]
              time_table.mg_batch_id=params[:mg_batch_id]
              time_table.mg_subject_id=params[:mg_subject_id]
              time_table.updated_by=user_id
              @notice_result=time_table.save

            end
        else
          @notice="Time table entry not present for selected selection"
        end

      end

        if  @notice_result 
          flash[:notice]="Techer changed successful"#+", "+@notice.to_s
        else
           flash[:error]=@notice.to_s+", "+" please try again "
        end

  redirect_to :back
end


def edit_change_teacher
    # puts bhsfkfgsdgdghh
    mg_school_id=session[:current_user_school_id]
    @school=MgSchool.find(mg_school_id)
    puts params[:id]
    @timetable=MgTimeTableChangeEntry.find_by(:id=>params[:id])
    @acadamic_year=MgTimeTable.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:name,:id)
    @course=MgCourse.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:course_name, :id)
    @batches=MgBatch.find_by(:is_deleted=>0, :id=>@timetable.mg_batch_id)
    @batche=MgBatch.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_course_id=>@batches.mg_course_id).pluck(:name,:id)
    
    date=@timetable.date
      puts date.strftime("%w")
      weekdays=MgWeekday.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :weekday=>date.strftime("%w"))

       batch=MgBatch.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id)
       @period=MgClassTiming.where(:mg_wing_id=>batch.mg_wing_id_for_batch,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_weekday_id=>weekdays).includes(:mg_weekday).order("mg_weekdays.weekday asc")#.pluck(:id, :name)
   
      @period_hash=Array.new

      @period.order(:start_time).each do |p|
        @period_hash.push([p.start_time.strftime("%k:%M%p").to_s+"-"+p.end_time.strftime("%k:%M%p").to_s, p.id ])
      end
      @subject=MgSubject.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:subject_name,:id)
      employee=MgEmployee.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>MgEmployeeSubject.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_subject_id=>@timetable.mg_subject_id).pluck(:mg_employee_id))#.pluck("employee_full_name_with_number", :id)
      @employee=[]
      employee.each do |emp|
        @employee.push(["#{emp.try(:first_name)} #{emp.try(:last_name).to_s} ( #{emp.try(:employee_number)} )", emp.id])
      end
      puts ""
      puts @employee.inspect
    render :layout=>false
end

def change_teacher_edit_save
  puts ""
  puts params.inspect
  mg_school_id=session[:current_user_school_id]
  time_table=MgTimeTableChangeEntry.find_by(:id=>params[:id])
  if time_table.is_permanent
    puts "if is_permanent-------------------------------------********************************************************"
    entry=MgTimeTableEntry.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>time_table.try(:mg_time_table_entry_id))
    if entry.present?
      entry.mg_subject_id=params[:mg_subject_id]
      entry.mg_employee_id=params[:mg_employee_id]
      entry.updated_by=session[:user_id]
      result=entry.save
    end
  else
    puts "else not_permanent-------------------------------------********************************************************"

  end
  time_table.mg_subject_id=params[:mg_subject_id]
  time_table.mg_employee_id=params[:mg_employee_id]
  time_table.updated_by=session[:user_id]
  result=time_table.save
  if result
    flash[:notice]="teacher & subject updated successfully"
  else
    flash[:error]="Error occured, please contact administrator"
  end
  redirect_to :back
end


 private 
 def teacher_for_subject_params
    params.require(:createtimetableasso).permit(:mg_batch_id, :mg_weekday_id, :mg_class_timings_id, :mg_subject_id, :mg_employee_id, :is_deleted)
 end
 def create_time_table_params
  params.require(:createTimeTable).permit(:start_date,:end_date,:is_deleted,:name,:mg_school_id)
 end

 def edit_time_table_params
  params.require(:editTimeTable).permit(:start_date,:end_date,:is_deleted,:name,:mg_school_id)
 end

 def ajax_create_params
    params.permit(:name,:start_time,:end_time,:is_break,:is_deleted,:mg_batch_id,:mg_school_id,:mg_wing_id)
 end

 def ajax_edit_params
    params.permit(:name,:start_time,:end_time,:is_break,:is_deleted,:mg_batch_id,:mg_school_id,:mg_wing_id)
 end

end
