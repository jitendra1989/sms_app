class SchoolsController < ApplicationController
    before_filter :login_required
  layout "mindcom"

  def index
    #com
     #@schools=MgSchool.all
     # #      render :layout => false
     redirect_to :action=>'show', :id=>session[:current_user_school_id]#Shr
     #@school_info = MgSchool.where(:id =>5)
  end

  def new
    @schools=MgSchool.new
    @dbdatas = MgCommonCustomField.where(model_name: "school")
   # render :layout => false
  end

  def show_image
    @school = MgSchool.find(params[:id])
    send_data @school.school_logo, :type => 'image/png',:disposition => 'inline'
  end



   def ajax_request_for_unique_subdomain_name

    schoolHash=Hash.new
    subdomain_name=params[:subdomainName]
    school_obj=MgSchool.find_by(:subdomain=>subdomain_name,:is_deleted=>0)
    puts "school_obj"
    puts school_obj.inspect
    if school_obj.present?
      schoolHash["is_subdomain_exist"]="true"
    else
      schoolHash["is_subdomain_exist"]="false"
    end
    render :json => { :schoolObj => schoolHash}

  end

  def create
    puts "inside create"
    puts school_params
    MgSchool.transaction do
   
    @schools=MgSchool.create(school_params)
    # @schools=MgSchool.new(school_params)
    
    
    is_school_save=@schools.save

    puts "is schooll   "
    puts is_school_save
    puts "is schooll   "
    

      for i in 1..6
          employee_weekdays=MgEmployeeWeekday.new( :mg_school_id=>@schools.id,:weekday=>i, :is_deleted=>0, :created_by=>session[:user_id], :updated_by=>session[:user_id])
         employee_weekdays.save
     end 


    # @school = MgSchool.new(school_params)
    #is_school_save = @school.save


      @fields = params[:custom_field]
      logger.info(@fields)
       @fieldsdata = params[:custom_data]

        if @fields.nil?
        else
           for j in 0...@fieldsdata.size
               
           
                @savedetails=MgCustomFieldsData.new(save_params) 
                
                  @savedetails.value=@fields[j]
                   @savedetails.mg_custom_field_id=@fieldsdata[j]
                  @savedetails.is_deleted=0

                 @savedetails.save
              
          
       end
       
      ############################end customdata
        end
    if is_school_save
    # if @school.save
      puts "On save method"
      #redirect_to :action=>'index'
       #redirect_to :action=>'index'
       redirect_to '/cloud_admins/school_index'
    else
      puts "On else method"


    end
  end

  end

  def show
    @schools=MgSchool.find(params[:id])
    @school_info = MgSchool.where(:id =>session[:current_user_school_id])
   
     puts "step -----1-----"
     puts  @school_info.inspect
     @dbdatas = MgCommonCustomField.where(model_name: "school",mg_school_id:session[:current_user_school_id],is_deleted:0)

     @customData = MgCustomFieldsData.where(mg_user_id:@schools.id,mg_school_id:session[:current_user_school_id],is_deleted:0)

    # render :layout => false
  end

  def edit
    @school = MgSchool.find(params[:id])
    puts @school
    @dbdatas = MgCommonCustomField.where(model_name: "school",is_deleted: 0,mg_school_id: session[:current_user_school_id])
    @customData = MgCustomFieldsData.where(mg_user_id:@school.id,is_deleted: 0,mg_school_id: session[:current_user_school_id])


  @data=MgExamSystem.where(:mg_school_id=>@school.id,:is_enabled=>0)
#       # logger.info(@data.inspect)
#        @examgrading=Array.new
#       @data.each do |data|
#       @examgrading.push(data.grading_system)
#     #@examssystem=MgExamSystem.find(:grading_system=>data[0],:is_enabled=>0)
# end
# @grade=Array.new
# @demodata=MgSchool.where(:mg_school_id=>@school.id,:is_enabled=>0)
# @demodata.each do |d|
#  @grade.push(@d.id)
# end


    render :layout => false
  end

  def update
    begin
  school_data_farmate = MgSchool.find(params[:id])
  MgSchool.transaction do  
    @schools=MgSchool.all
    @school = MgSchool.find(params[:id])

    @schools=MgSchool.new(school_params)
    @dataName=Array.new
               @dataName=["","CCE","CWE","GPA"]
       @examsystem=MgExamSystem.new()
        @examsystem.grading_system=@schools.grading_system
          @examsystem.description="grading sytem"
           @examsystem.mg_school_id=session[:current_user_school_id]
          @examsystem.is_enabled=0
          

          @examsystem.grading_name=@dataName[@schools.grading_system.to_i]        

          @demo=MgExamSystem.where(:grading_system=>@schools.grading_system)
        if  @demo.size<1
           @examsystem.save
           
         else
         end

 @custFieldNameIds = params[:custom_data]
 if  @custFieldNameIds.nil?
#if it is nil come to here
 else

    for j in 0...@custFieldNameIds.size

      
       @custFieldValObj = params[:"custom_field_#{@custFieldNameIds[j]}"]
    if !@custFieldValObj.nil? && @custFieldValObj.size>0
       @custFieldVal =@custFieldValObj[0];
        for index in 1...@custFieldValObj.size 
        @custFieldVal << ','+@custFieldValObj[index]
                
        end 
    end
    


          
          @id=@custFieldNameIds[j]

          

          puts "@details.inspect"
          puts @details.inspect
@details = MgCustomFieldsData.where(:mg_custom_field_id=>@id,:mg_user_id=>session[:current_user_school_id])
      
           if @details.size<1

           @savedetails=MgCustomFieldsData.new(save_params) 
            @savedetails.value=@custFieldVal
             @savedetails.mg_custom_field_id=@id
             @savedetails.mg_user_id = session[:current_user_school_id]
             @savedetails.mg_school_id=session[:current_user_school_id]
              @savedetails.is_deleted=0
           @savedetails.save



        else
          @details = MgCustomFieldsData.where(:mg_custom_field_id=>@id,:mg_user_id=>session[:current_user_school_id])

          
          @data = @custFieldVal
          @details[0].update(value: @data,is_deleted:0)
 
    end
end
    end
    puts "======error=============="
    puts @school.errors.messages
    puts "====================="
    puts @school.inspect
    puts "======================"
    puts ":is_deleted, :school_name,:school_code,:address_line1, :address_line2, :street, :city, :state,:pin_code, :landmark,:country,:mobile_number,:email_id,:fax_number,:date_format,:timezone,:currency_type,:affilicated_to,:grading_system,:image_file,:reg_num,:logo,:language,:start_time,:end_time"
    puts "============================"


     parent_url = request.env['HTTP_REFERER']
    @school.update(school_params)
    if params[:school][:mg_leave_calendar_start_date]!=""
      timeformat = MgSchool.find(session[:current_user_school_id])
    
      leave_start_date = Date.strptime(params[:school][:mg_leave_calendar_start_date],school_data_farmate.date_format)
      # leave_start_date = params[:school][:mg_leave_calendar_start_date]
      @school.update(:mg_leave_calendar_start_date=>leave_start_date)
    end

    user = MgUser.find(session[:user_id])
    user_type = user[:user_type]
    if user_type=="cloudadmin"
      redirect_to '/cloud_admins/school_index/'
    else
      if parent_url!=nil  && (parent_url.include? "master")
              redirect_to  '/master_settings'
          else
        
          redirect_to :action=>'show', :id=>session[:current_user_school_id]

          end    
    end
    # if @school.update(school_params)
    #   puts "if cccccccc"
    #   redirect_to :action=>'show', :id=>1
    # else
    #   puts "else cccccccc"
    #   render 'edit'
    # end
  end
  rescue
  flash[:error]="Error occured, please contact administrator"
  redirect_to :action=>'show', :id=>session[:current_user_school_id]

end
end

  def destroy
  @school = MgSchool.find(params[:id])
  @school.update(:is_deleted=>1)
 
   redirect_to '/cloud_admins/school_index/'
end


 def custom_new
  @dbdatas = MgCommonCustomField.where(model_name: "school")
  #render :layout => false
end
    def custom_index
  #render :layout => false

end



def custom_create

  @customfields = MgCommonCustomField.new(post_params)
  
  @customfields.save
 # schools/custom_index
  redirect_to :action=>'custom_fields'

end

def custom_fields
  @customfields = MgCommonCustomField.where(is_deleted:0,mg_school_id:session[:current_user_school_id],model_name: "school")

  
end

def custom_fields_edit
  @demo = MgCommonCustomField.find(params[:id])
  render :layout => false

  
end

def custom_fields_update
  @customfields = MgCommonCustomField.find(params[:id])
 
  @customfields.update(post_params)
  
  redirect_to :action=>'custom_fields'
end


def custum_fields_delete
   @customfields=MgCommonCustomField.find_by_id(params[:id])

      @customfields.is_deleted =1
      @customfields.save
     # schools/custom_index
     #   redirect_to '/schools/custom_index'

redirect_to :action=>'custom_fields'
  
end

  private 

  def school_params
    params.require(:school).permit(:subdomain,:logo,:is_deleted, :school_name,:school_code,:address_line1, :address_line2, :street, :city, :state,:pin_code, :landmark,:country,:mobile_number,:email_id,:fax_number,:date_format,:timezone,:currency_type,:affilicated_to,:grading_system,:image_file,:reg_num,:language,:start_time,:end_time,:mg_leave_calendar_start_date)
  end

    def post_params
        params.require(:demo).permit(:mg_school_id,:model_name,:name,:text_data,:data_type, :is_deleted)
      end

    def edit_params
        params.require(:customfields).permit(:mg_school_id,:model_name,:name,:text_data,:data_type, :is_deleted)
      end


    def save_params
   #params.require(:save).permit(:School_id,:custom_field_id,:one['value'],:two['value'],:three['value'],:four['value'])
      params.require(:school).permit(:mg_school_id,:is_deleted)

    end

end

