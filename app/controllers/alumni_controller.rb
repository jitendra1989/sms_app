class AlumniController < ApplicationController
	#layout "mindcom"
  layout 'mindcom', :except => :alumni_registration_form_new
  before_filter :login_required , :except => [:alumni_registration_form_new ,:alumni_registration_form_create,:alumni_user_id]

  def index
  	@get_together_data=MgAlumniGetTogether.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 20)
  end

  def new
  	@action='new'
  end

  def edit
  	@action='edit'
  	@get_together_data=MgAlumniGetTogether.find(params[:id])
    #MgInviteGetTogether
    #MgGetTogether
  	render :layout=>false
  end

  def show
  	@get_together_data=MgAlumniGetTogether.find(params[:id])
    @mg_get_together_data=MgGetTogether.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_alumni_get_together_id=>params[:id]).pluck(:mg_alumni_id)
  	@alumni_data=MgAlumni.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>@mg_get_together_data)
    render :layout=>false
  end

  def create
  	@timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    event_date = Date.strptime(params[:get_togethers_type][:event_date],@timeformat.date_format)
    get_together_params=MgAlumniGetTogether.new(get_together_params_data)
    get_together_params.event_date=event_date
    puts"0000000000000000000000000000"
   

    if get_together_params.save
      params[:time_table_year].each do |data2|
        params[:mg_wing_id].each do |data1|
          invitition=MgInviteGetTogether.new
          invitition.mg_wing_id=data1
          invitition.passout_year=data2
          invitition.mg_alumni_get_together_id=get_together_params.id
          invitition.is_deleted=0
          invitition.mg_school_id=session[:current_user_school_id]
          invitition.created_by=session[:user_id]
          invitition.updated_by=session[:user_id]
          invitition.save
        end
      end

      params[:select_data].each do |student|
        together=MgGetTogether.new
        together.mg_alumni_id=student
        together.mg_alumni_get_together_id=get_together_params.id
        together.is_deleted=0
        together.mg_school_id=session[:current_user_school_id]
        together.created_by=session[:user_id]
        together.updated_by=session[:user_id]
        together.save
      end
      if params[:select_data].present?
        send_email_to_alumni(params[:select_data],params[:get_togethers_type])
      end
      flash[:notice] = "Get Together created Successfully..."
    else
      flash[:error] = "Error Occurred..."
    end
    redirect_to :action=>"index"	
  end

  def send_email_to_alumni(alumni_id,params)
    begin
      event_message ="#{params[:event_name]} Event will be organized on Date #{params[:event_date]} and Event time is scheduled to be from #{params[:start_time]} to #{params[:end_time]}. Venue is #{params[:venue]}."
      alumni_id.each do |id|

        @email_from = MgAlumni.where(:mg_user_id => session[:user_id]).pluck(:email_id)
        @message = Message.new
        @message.subject =  "Get Together Event"
        @message.description=event_message
        @email_to = MgAlumni.where(:id=>id).pluck(:email_id)
        
        if @email_to[0].present?
          @message.to_user_id = @email_to[0]
          if @email_from[0].present?
            @message.from_user_id = @email_from[0]
          else
            @message.from_user_id = "abc@mindcomgroup.com"
          end
          server_response = NotificationMailer.send_mail(@message).deliver!
          
          # db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
          #           :to_user_id => user.to_i,
          #           :subject => @message.subject,
          #           :description => @message.description,
          #           :is_deleted => 0,
          #           :from_user_id =>session[:user_id],
          #           :status => 0)
          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                      :email_addrs_to => @message.to_user_id,
                                :mg_school_id => session[:current_user_school_id] ,
                                      :email_addrs_by => @message.from_user_id,
                                      :email_subject => 'test',
                                     :email_server_description => server_description(server_response.status) )
        else
          puts "Email id is not present"
        end
      end #each loop
      return @notice="Mail Sent Successfully."
    rescue Net::SMTPFatalError => e
      puts "inside Exception in principal"
      puts e
      return @notice="Email Id is not valid."
    rescue ArgumentError => e
      puts "inside Exception in principal"
      puts e
      return @notice="Email to address is not present."
    rescue Exception => e
      puts e
      puts "inside Exception in principal"
      return @notice="Error while sending email,Please contact admin."
    end
  end


  def update
    update_data=MgAlumniGetTogether.find(params[:id])
  	@timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    event_date = Date.strptime(params[:get_togethers_type][:event_date],@timeformat.date_format)
    update_data.event_date=event_date
    # ====================================================================================
    get_together=MgGetTogether.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_alumni_get_together_id=>params[:id])
    invite_get_together=MgInviteGetTogether.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_alumni_get_together_id=>params[:id])
    get_together.each do |data|
      data.update(:is_deleted=>1)
    end
    
    if update_data.update(update_get_together_params_data)
      if params[:time_table_year].present?
        invite_get_together.each do |data|
          data.update(:is_deleted=>1)
        end

        params[:time_table_year].each do |data2|
          params[:mg_wing_id].each do |data1|
            invitition=MgInviteGetTogether.new
            invitition.mg_wing_id=data1
            invitition.passout_year=data2
            invitition.mg_alumni_get_together_id=params[:id]
            invitition.is_deleted=0
            invitition.mg_school_id=session[:current_user_school_id]
            invitition.created_by=session[:user_id]
            invitition.updated_by=session[:user_id]
            invitition.save
         end
        end
      end

      params[:select_data].each do |student|
        together=MgGetTogether.new
        together.mg_alumni_id=student
        together.mg_alumni_get_together_id=params[:id]
        together.is_deleted=0
        together.mg_school_id=session[:current_user_school_id]
        together.created_by=session[:user_id]
        together.updated_by=session[:user_id]
        together.save
      end
      if params[:select_data].present?
        send_email_to_alumni(params[:select_data],params[:get_togethers_type])
      end
      flash[:notice] = "Successfully Updated..."
    else
      flash[:error] = "Not Updated..."
    end
    redirect_to :action=>"index"
  end

  def delete
  	delete_get_together_data=MgAlumniGetTogether.find(params[:id])
  	delete_get_together_data.is_deleted=1
  	if delete_get_together_data.save
  	flash[:notice] = "Successfully Deleted..."
  	else
    flash[:error]="Error Occurred..."
  	end
  	redirect_to :action=>"index"
  end



# ===================================================================================================
  def search_photo_gallery
    array_data=params[:search_gallery]
    str=""
    if params[:search_gallery].present?
        str =" name LIKE '%#{array_data}%'"
      if session[:user_type]=="Alumni"
        @photo_gallery = MgAlumniPhotoGallery.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where(str)#.paginate(page: params[:page], per_page: 10)
      else
        @photo_gallery = MgAlumniPhotoGallery.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where(str)#.paginate(page: params[:page], per_page: 10)
      end
    else
      if session[:user_type]=="Alumni"
        @photo_gallery = MgAlumniPhotoGallery.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#.paginate(page: params[:page], per_page: 10)
      else
        @photo_gallery = MgAlumniPhotoGallery.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#.paginate(page: params[:page], per_page: 10)
      end
    end
    @total_gallery = MgAlumniPhotoGallery.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).count
    render :layout=>false
  end
# ===================================================================================================

  # Jitendra Work start
  def photo_gallery
    array_data=params[:search_gallery]
    str=""
    if params[:search_gallery].present?
        str =" name LIKE '%#{array_data}%'"
      if session[:user_type]=="Alumni"
        @photo_gallery = MgAlumniPhotoGallery.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where(str).paginate(page: params[:page], per_page: 10)
      else
        @photo_gallery = MgAlumniPhotoGallery.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where(str).paginate(page: params[:page], per_page: 10)
      end
    else
      if session[:user_type]=="Alumni"
        @photo_gallery = MgAlumniPhotoGallery.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
      else
        @photo_gallery = MgAlumniPhotoGallery.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
      end
    end
    @total_gallery = MgAlumniPhotoGallery.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).count
  end

  def new_photo_gallery
    @photo_gallery = MgAlumniPhotoGallery.new
  end

  def create_photo_gallery
    
    alumni_id = MgAlumni.find_by(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    photo_gallery = MgAlumniPhotoGallery.new(photo_gallery_params)
    photo_gallery.save

    if photo_gallery.update(:mg_alumni_id=>alumni_id.id,:mg_user_id=>session[:user_id])
      flash[:notice]='Photo Gallery created successfully'
      
      if params[:uploads]=='photo'
        redirect_to :action => "upload_photo_gallery", :id=>photo_gallery.id
      elsif params[:uploads]=='video'
        redirect_to :action => "upload_video_gallery", :id=>photo_gallery.id
      else
        redirect_to :action =>'photo_gallery'
      end
    else
      flash[:error]="There is some problem"
    end
  end

  def upload_photo_gallery
    mg_school_id=session[:current_user_school_id]
    @photos=MgImage.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_alumni_photo_gallery_id=>params[:id],:status=>'accepted').where.not('image'=>nil)#.paginate(page: params[:page], per_page: 12)
    @pending_photos=MgImage.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_alumni_photo_gallery_id=>params[:id],:status=>'pending').where.not('image'=>nil)#.paginate(page: params[:page], per_page: 12)
    @rejected_photos=MgImage.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_alumni_photo_gallery_id=>params[:id],:status=>'rejected').where.not('image'=>nil)#.paginate(page: params[:page], per_page: 12)
    @created_obj = MgAlumniPhotoGallery.find_by(:id=>params[:id])
    
    @total_photos=MgImage.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_alumni_photo_gallery_id=>params[:id]).where.not('image'=>nil).count
  end

  def upload_video_gallery
    mg_school_id=session[:current_user_school_id]
    @videos=MgImage.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_alumni_photo_gallery_id=>params[:id],:status=>'accepted').where.not('video'=>nil)#.paginate(page: params[:page], per_page: 12)
    @pending_videos=MgImage.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_alumni_photo_gallery_id=>params[:id],:status=>'pending').where.not('video'=>nil)#.paginate(page: params[:page], per_page: 12)
    @rejected_videos=MgImage.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_alumni_photo_gallery_id=>params[:id],:status=>'rejected').where.not('video'=>nil)#.paginate(page: params[:page], per_page: 12)
    @created_obj = MgAlumniPhotoGallery.find_by(:id=>params[:id])
    @total_videos=MgImage.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_alumni_photo_gallery_id=>params[:id]).where.not('video'=>nil).count#.paginate(page: params[:page], per_page: 12)
  end

  def photo_gallery_save
    @mg_alumni_obj = MgAlumniPhotoGallery.find_by(:id=>params[:mg_alumni_photo_gallery_id])

    if params[:mg_video].present?

      for i in 0...params["video"].size 
        save_data = @mg_alumni_obj.mg_images.new(:video=>params["video"][i],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id],:status=>"pending")   
        save_data.save
      end
    else
      for i in 0...params["file"].size 
        save_data = @mg_alumni_obj.mg_images.new(:image=>params["file"][i],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id],:status=>"pending")   
        save_data.save
      end
    end

    if save_data.save
      flash[:notice]="Successfully Uploaded"
    else
      flash[:error]="There is some problem"
    end

    if params[:mg_video].present?
      redirect_to :action =>'upload_video_gallery',:id=>params[:mg_alumni_photo_gallery_id]
    else
      redirect_to :action =>'upload_photo_gallery',:id=>params[:mg_alumni_photo_gallery_id]
    end
  end

  def delete_gallery_photos
    
    if params[:mg_album_photos_id].present?
      @gallery = MgAlumniPhotoGallery.find_by(:id=>params[:id]);
      if params[:submitted_form_for]=="accept_photos"
        @gallery.update(:status=>'accepted',:updated_by=>session[:user_id]);
        params[:mg_album_photos_id].each do |f|
          MgImage.where(:id=>f).update_all(:status=>"accepted",:updated_by=>session[:user_id])
        end
        flash[:notice]= "Photos/Video accepted successfully"
      elsif params[:submitted_form_for]=="reject_photos"
        params[:mg_album_photos_id].each do |f|
          MgImage.where(:id=>f).update_all(:status=>"rejected",:updated_by=>session[:user_id])
        end
        flash[:notice]= "Photos/Video rejected successfully"
      else
        params[:mg_album_photos_id].each do |f|
          MgImage.where(:id=>f).delete_all#update_all(:is_deleted=>1,:updated_by=>session[:user_id])
        end
        flash[:notice]= "Photos/Video deleted successfully"
      end
    else
      flash[:error]= "There is no photo/video Selected"
    end
      
    redirect_to :back 
  end

  def edit_photo_gallery
    @photo_gallery = MgAlumniPhotoGallery.find_by(:id=>params[:id])
  end

  def update_photo_gallery

    photo_gallery = MgAlumniPhotoGallery.find_by(:id=>params[:photo_gallery][:id])
    photo_gallery.update(photo_gallery_update_params)
    flash[:notice]='Updated Successfully'
    if params[:uploads]=='photo'
      redirect_to :action => "upload_photo_gallery", :id=>params[:photo_gallery][:id]
    elsif params[:uploads]=='video'
      redirect_to :action => "upload_video_gallery", :id=>params[:photo_gallery][:id]
    else
      redirect_to :action =>'photo_gallery'
    end
  end

  def show_photo_gallery
    @photo_gallery = MgAlumniPhotoGallery.find_by(:id=>params[:id])
    render :layout=>false
  end

  def delete_gallery_album
    @photo_gallery = MgAlumniPhotoGallery.find_by(:id=>params[:id])
    @photo_gallery.destroy
    flash[:notice]='Deleted Successfully'
    redirect_to :action =>'photo_gallery'
  end
  # Jitendra Work ends


  def alumni_job_posting_index
    @job_lists=MgAlumniJobPostingDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page],per_page: 5)
  end

  def alumni_job_posting_new
    @action='new'
    @alumni_job_posting=MgAlumniJobPostingDetail.new()
  end

  def alumni_job_posting_create
      alumni_job_posting=MgAlumniJobPostingDetail.new(alumni_job_posting_params)
      school=MgSchool.find(session[:current_user_school_id])
      interview_date=Date.strptime(params[:alumni_job_posting][:interview_date],school.date_format)
      last_date_of_interview=Date.strptime(params[:alumni_job_posting][:last_date_of_application],school.date_format)
    alumni_job_posting.interview_date=interview_date
    alumni_job_posting.last_date_of_application=last_date_of_interview

    if alumni_job_posting.save
      flash[:notice]="Created Successfully"
      redirect_to :action=>"alumni_job_posting_index"
    else
      flash[:error]="Error occured,Please try later"
      redirect_to :action=>"alumni_job_posting_index"
    end
  end

  def alumni_job_posting_edit
    @action='edit'
    @alumni_job_posting=MgAlumniJobPostingDetail.find(params[:id])
  end

  def alumni_job_posting_update
    #puts ajsdhjhgja
    alumni_job_posting=MgAlumniJobPostingDetail.find(params[:id])
      school=MgSchool.find(session[:current_user_school_id])
      interview_date=Date.strptime(params[:alumni_job_posting][:interview_date],school.date_format)
      last_date_of_interview=Date.strptime(params[:alumni_job_posting][:last_date_of_application],school.date_format)
    if alumni_job_posting.update(alumni_job_posting_params)
      alumni_job_posting.update(:last_date_of_application=>last_date_of_interview,:interview_date=>interview_date)
      flash[:notice]="Updated Successfully"
      redirect_to :action=>"alumni_job_posting_index"
    else
      flash[:error]="Error occured,Please try later"
      redirect_to :action=>"alumni_job_posting_index"
    end
  end

  def alumni_job_posting_show
    @alumni_job_posting=MgAlumniJobPostingDetail.find(params[:id])
    #render :layout=>false
  end

  def alumni_job_posting_delete
    alumni_job_posting=MgAlumniJobPostingDetail.find(params[:id])
    if alumni_job_posting.update(:is_deleted=>1)
      flash[:notice]="Deleted Successfully"
      redirect_to :action=>"alumni_job_posting_index"
    else
      flash[:error]="Error occured,Please try later"
      redirect_to :action=>"alumni_job_posting_index"
    end
  end
 




# def polling
#   @polling=MgAlumniPolling.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
# end

# def polling_edit
#   @polling=MgAlumniPolling.find_by(:id=>params[:id])
#   render :layout=>false
# end

# def polling_show
#   @category=MgAlumniPolling.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:id=>params[:id])
#   render :layout=>false
# end

# def polling_new
#   render :layout=>false
# end

# def polling_create
#   polling=MgAlumniPolling.new(polling_data)
#   if polling.save
#   flash[:notice]="Data has saved successfully."
#     else
#   flash[:notice]="Data not saved."
#   end
#   redirect_to :action=>"polling"
# end

# def polling_update
#   polling=MgAlumniPolling.find_by(:id=>params[:id])
#   if polling.update(polling_data)
#   flash[:notice]="Data updated successfully."
#   else
#     flash[:notice]="Data not saved."
#   end
#   redirect_to :action=>"polling"
# end

# def polling_delete
#   polling=MgAlumniPolling.find_by(:id=>params[:id])
#   polling.update(:is_deleted=>1, :updated_by=>session[:user_id])
#   redirect_to :action=>"polling"
# end

  # redirect_to :action=>"polling"

def polling_options
  @polling=MgPollQuestionAlumni.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def polling_options_new
  @action='new'
  render :layout=>false
end

def polling_options_create
  array=[]
  MgPollQuestionAlumni.transaction do
    puts params.inspect
    polling=MgPollQuestionAlumni.new(polling_option_data)
    @timeformat = MgSchool.find(session[:current_user_school_id])
    start_date = Date.strptime(params[:polling_option][:start_date],@timeformat.date_format)
    due_date = Date.strptime(params[:polling_option][:due_date],@timeformat.date_format)
    polling.start_date=start_date
    polling.due_date=due_date

    array.push(polling.save)
    alumni_particulars=params[:alumni_particulars]
    alumni_particulars.each do  |data|
      polling_data=MgPollOptionAlumniParticulars.new
      polling_data.is_deleted=0
      polling_data.mg_school_id=session[:current_user_school_id]
      polling_data.created_by=session[:user_id]
      polling_data.updated_by=session[:user_id]
      polling_data.mg_poll_option_alumni_id=polling.id
      polling_data.paticular=data
      array.push(polling_data.save)
    end
  end
  if array.include?(false)
    flash[:error]="Error Occured"
  else
    flash[:notice]="Created Successfully"
  end
  redirect_to :action=>"polling_options"
end

def polling_options_edit
  @action='edit'
  @polling_option=MgPollQuestionAlumni.find_by(:id=>params[:id])
  @start_date=@polling_option.start_date
  @today_date=Date.today
  render :layout=>false
end


def polling_options_graph
  @polling_option=MgPollQuestionAlumni.find_by(:id=>params[:id])
  options= MgPollOptionAlumniParticulars.where(:mg_poll_option_alumni_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @particular_array=Array.new
  @value_array=Array.new
  # ==========================================================================================
  @sum=0
  options.each_with_index do |option,i|
      if option.try(:count).present? 
          @sum=@sum+option.try(:count).to_i
      end
  end
  # ==========================================================================================
  options.each_with_index do |option,i|
      @particular_array.push(option.try(:paticular))
      if option.try(:count).present?
          temp= ((option.try(:count).to_i/@sum.to_f)*100)
          temp=temp.round(2)
          # @value_array.push(option.try(:count))
          @value_array.push(temp)
      else 
        @value_array.push(0)
      end
  end
end

def polling_options_update
  array=[]
  MgPollQuestionAlumni.transaction do
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @polling_option=MgPollQuestionAlumni.find(params[:id])

    if params[:is_disabled]=="not_disabled"
      @polling_option.update(update_polling_option_data)
      start_date = Date.strptime(params[:polling_option][:start_date],@timeformat.date_format)
      due_date = Date.strptime(params[:polling_option][:due_date],@timeformat.date_format)
      @polling_option.update(:due_date=>due_date)
      @polling_option.update(:start_date=>start_date)
      array.push(@polling_option.save)

      @params=params[:ids]
      
      examination_evaluation_data=MgPollOptionAlumniParticulars.where('is_deleted=? and mg_school_id=? and mg_poll_option_alumni_id=? and id  NOT IN (?)', 0,session[:current_user_school_id],params[:id],params[:ids])
      if examination_evaluation_data.length>0
        for j in 0...examination_evaluation_data.length 
          data=MgPollOptionAlumniParticulars.find_by(:id=>examination_evaluation_data[j].id)
          if data.present?
            data.update(:is_deleted=>1)
          end
        end
      end

      @params=params[:ids]
      alumni_particulars=params[:alumni_particulars]
      for j in 0...@params.size
        inventory_data=MgPollOptionAlumniParticulars.where('mg_school_id=? and mg_poll_option_alumni_id=? and id=?', session[:current_user_school_id],params[:id],@params[j])
        if inventory_data.size<1
          if alumni_particulars[j].present?
            purchase_details=MgPollOptionAlumniParticulars.new()
            purchase_details.mg_poll_option_alumni_id=params[:id]
            purchase_details.paticular=alumni_particulars[j]
            purchase_details.is_deleted=0
            purchase_details.mg_school_id=session[:current_user_school_id]
            purchase_details.created_by=session[:user_id]
            purchase_details.updated_by=session[:user_id]
            array.push(purchase_details.save)
          else
          end
        else
          inventory_data[0].update(:paticular=>alumni_particulars[j])
        end
      end
    else
      due_date = Date.strptime(params[:polling_option][:due_date],@timeformat.date_format)
      @polling_option.update(:due_date=>due_date)
      array.push(@polling_option.save)
    end
  end #transaction end
  if array.include?(false)
    flash[:error]="Error Occured"
  else
    flash[:notice]="Updated Successfully"
  end
  redirect_to :action=>"polling_options"
end

def polling_options_show
  @polling=MgPollQuestionAlumni.find_by(:id=>params[:id])
  @timeformat = MgSchool.find(session[:current_user_school_id])

  render :layout=>false

end


def polling_options_delete

polling=MgPollQuestionAlumni.find_by(:id=>params[:id])
  polling.update(:is_deleted=>1, :updated_by=>session[:user_id])
    particular_details=MgPollOptionAlumniParticulars.where(:mg_poll_option_alumni_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    particular_details.each do |data|
      data.is_deleted=1
      data.updated_by=session[:user_id]
      data.save
    end
  redirect_to :action=>"polling_options"

end

def create_poll_data
  alumni=MgAlumni.find_by(:mg_user_id=>session[:user_id])
    params[:mg_question_id].each do |question|
       
          if params[:options_id].present? 

            @poll_answers=MgPollData.new(polling_answer_data)

            @poll_answers.mg_alumni_user_id=alumni.id
            
            @poll_answers.mg_question_id= question

            @poll_answers.answer=params[:options_id][question]
              if params[:options_id][question].present?
                  answer_data=MgPollOptionAlumniParticulars.find(params[:options_id][question])
                  total_count=answer_data.count
                  answer_data.count=total_count.to_i+1
                  answer_data.save
                  @poll_answers.save
              end
          end
    end

redirect_to :action=>"alumni_polls"

end




def alumni_registration_form
@alumni_data=MgAlumni.all.paginate(page: params[:page], per_page: 10)


end

def alumni_registration_form_new
  @school=MgSchool.find_by(:is_deleted=>0,:subdomain=>request.subdomain.split(".")[0])
  session[:current_user_school_id]=@school.id
  @timeformat=MgSchool.find(session[:current_user_school_id])
  puts session[:current_user_school_id]
end

  def alumni_registration_form_accept
     puts params[:inspect]
     #puts ajsgd

if params[:alumni_demo_data]=="Accept"
   #puts ajsgd
params[:select_data].each do |data|
alumni_data=MgAlumni.find_by(:id=>data)
user_data=MgUser.find_by(:id=>alumni_data.mg_user_id)
user_data.is_deleted=0
if user_data.save
alumni_data.is_deleted=0
alumni_data.status="Accepted"
if alumni_data.save
programme_data=MgAlumniProgrammeAttended.where(:mg_alumni_id=>alumni_data.id)
programme_data.each do |data|
data.is_deleted=0
data.save
end
end
end
end


elsif  params[:alumni_demo_data]=="Reject"
 # puts ajsgd
params[:select_data].each do |data|
alumni_data=MgAlumni.find_by(:id=>data)
user_data=MgUser.find_by(:id=>alumni_data.mg_user_id)
user_data.is_deleted=1
if user_data.save
alumni_data.is_deleted=1
alumni_data.status="Rejected"
if alumni_data.save
programme_data=MgAlumniProgrammeAttended.where(:mg_alumni_id=>alumni_data.id)
programme_data.each do |data|
data.is_deleted=1
data.save
end
end
end
end
end

   # puts ajsdhgasd
redirect_to :back

  end
def alumni_registration_form_reject

  redirect_to :action=>"alumni_registration_form"

  end

  def alumni_confirm_email_id

render :layout=>false

  end

   def alumni_user_id
 #  split_data=params[:user_name]
 #    array_data=split_data.to_s.split(" ")
 #    str=""
   
 #      for s in 0..array_data.size-1
 #        str +=" user_name LIKE '%#{array_data[s]}%'"
 #        if s<array_data.size-1
 #          str+=" or "
 #        end
 # end

#user_name=MgUser.where(:mg_school_id=>session[:current_user_school_id]).where(str).pluck(:user_name)

  user_data=MgUser.where(:mg_school_id=>session[:current_user_school_id],:user_name=>params[:user_name])
  data=user_data.size
  alumni_data=MgAlumni.where(:mg_school_id=>session[:current_user_school_id],:admission_number=>params[:user_name])
  alumni_data=alumni_data.size
  render :json => {:name =>data,:alumni_data=>alumni_data}

  end
  

	def alumni_registration_form_create
    array=[]
    begin
      MgUser.transaction do
        timeformat = MgSchool.find(session[:current_user_school_id])
        date_of_births = Date.strptime(params[:student][:date_of_birth],timeformat.date_format)

        @user = MgUser.new(user_params)
        @user.email=params[:confirm_email_id]
        array.push(@user.save)
        if @user.save
          role=MgRole.find_by(:role_name=>"Alumni")
          if role.id.present?
            @user_role = @user.mg_user_roles.build(:mg_role_id => role.id)
            @user_role.save 
            
          end
          alumni_data=MgAlumni.new(alumni_params)
          alumni_data.email_id=params[:confirm_email_id]
          alumni_data.mg_user_id=@user.id
          alumni_data.status="Pending"
          alumni_data.date_of_birth=date_of_births

          array.push(alumni_data.save)
          if alumni_data.save
            params[:mg_wing_id].each do |key,i|
              receipt_data=MgAlumniProgrammeAttended.new()
              @fileupload=MgDocumentManagement.new()

              receipt_data.mg_alumni_id=alumni_data.id
              receipt_data.mg_wing_id=params[:mg_wing_id][key]
              receipt_data.time_table_year=params[:time_table_year][key]
              #receipt_data.mg_employee_specialization_id=params[:mg_specialization_id][key]
              receipt_data.is_deleted=1
              receipt_data.mg_school_id=session[:current_user_school_id]
              receipt_data.created_by=session[:user_id]
              receipt_data.updated_by=session[:user_id]
              receipt_data.save
              if params[:files].present?

                if params[:files][key].present?
                  
                  @fileupload.file=params[:files][key]
                  @fileupload.mg_alumni_programme_attended_id=receipt_data.id
                  @fileupload.is_deleted=1
                  @fileupload.mg_school_id=session[:current_user_school_id]
                  @fileupload.created_by=session[:user_id]
                  @fileupload.updated_by=session[:user_id]
                  @fileupload.save
                end
              end
            end

            # alumni_data.is_name_sharable=params[:student][:is_name_sharable]
            alumni_data.is_email_id_sharable=params[:student][:is_email_id_sharable]
            alumni_data.is_mobile_no_sharable=params[:student][:is_mobile_no_sharable]
            # alumni_data.is_programme_searchable=params[:student][:is_programme_searchable]
            # alumni_data.is_passing_out_searchable=params[:student][:is_passing_out_searchable]
            # alumni_data.is_specialization_searchable=params[:student][:is_specialization_searchable]
            alumni_data.is_current_location_searchable=params[:student][:is_current_location_searchable]
            alumni_data.is_current_profession_searchable=params[:student][:is_current_profession_searchable]
            alumni_data.is_current_designation_searchable=params[:student][:is_current_designation_searchable]
            alumni_data.is_current_organization_searchabler=params[:student][:is_current_organization_searchabler]
            alumni_data.is_date_of_birth_searchable=params[:student][:is_date_of_birth_searchable]
            alumni_data.save
          end
        end
      end #transaction end
      if array.include?(false)
        flash[:error]="Error Occured Please contact admin"
      else
        flash[:notice]="Successfully Registered please wait for approval"
      end
    rescue Exception => e
      flash[:error]="Error Occured Please contact admin"
    end
    redirect_to :controller=>'Sessions',:action=>"index"
  end




def alumni_registration_form_show
  @alumni_data=MgAlumni.find_by(:id=>params[:id])
end

def alumni_registration_show
  @alumni_data=MgAlumni.find_by(:id=>params[:id])
end




def  alumni_login

@alumni_login=MgUser.find_by(:id=>params[:user_id])
end

def  change_alumni_login_password

    user_data=MgUser.find_by(:id=>session[:user_id])
    
    if user_data.update(:password=>params[:alumni_hashed_password])
    
      flash[:notice] = "Password Changed Successfully..."
    end
redirect_to :action=>"alumni_login"


end

def password_search_data
user = MgUser.authenticatePasswordData(session[:user_id],params[:password]) 
# user_data=MgUser.where(:mg_school_id=>session[:current_user_school_id],:user_name=>params[:user_name])
#   data=user_data.size
puts session[:user_id]
if user.present?
data=1
else
data=0

end
puts data

  render :json => {:name =>data}
  end
  def alumni_update_profile
    @student=MgAlumni.find_by(:mg_user_id=>session[:user_id])
  end



  def alumni_registration_form_update
    puts"alumninnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
    puts params
    puts"alumninnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
    timeformat = MgSchool.find(session[:current_user_school_id])
    date_of_births = Date.strptime(params[:date_of_birth],timeformat.date_format)
    alumni_data=MgAlumni.find_by(:id=>params[:id])
    @user = MgUser.find_by(:id=>alumni_data.mg_user_id)
    @user.update(user_params_update)
    @user.update(:email=>params[:student][:email_id]);
    alumni_data.update(alumni_params_update)
    alumni_data.update(:email_id=>params[:student][:email_id],:date_of_birth=>date_of_births)

    # alumni_data.is_name_sharable=params[:student][:is_name_sharable]
    alumni_data.is_email_id_sharable=params[:student][:is_email_id_sharable]
    alumni_data.is_mobile_no_sharable=params[:student][:is_mobile_no_sharable]
    # alumni_data.is_programme_searchable=params[:student][:is_programme_searchable]
    # alumni_data.is_passing_out_searchable=params[:student][:is_passing_out_searchable]
    # alumni_data.is_specialization_searchable=params[:student][:is_specialization_searchable]
    alumni_data.is_current_location_searchable=params[:student][:is_current_location_searchable]
    alumni_data.is_current_profession_searchable=params[:student][:is_current_profession_searchable]
    alumni_data.is_current_designation_searchable=params[:student][:is_current_designation_searchable]
    alumni_data.is_current_organization_searchabler=params[:student][:is_current_organization_searchabler]
    alumni_data.is_date_of_birth_searchable=params[:student][:is_date_of_birth_searchable]
    alumni_data.save

    #===========================================
    if params[:program_attended_id].present?
      params[:program_attended_id].each do |programme_id|
        @program_obj = MgAlumniProgrammeAttended.find_by(:id=>programme_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        if @program_obj.present?
          @program_obj.update(:is_deleted=>1,:updated_by=>session[:user_id])
        end
        # @document = MgDocumentManagement.find_by(:mg_alumni_programme_attended_id=>programme_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        # if @document.present?
        #   @document.update(:is_deleted=>1,:updated_by=>session[:user_id])
        # end
      end

      if params[:mg_wing_id].present?
        params[:mg_wing_id].each do |key,value|
          if params[:program_attended_id].include? key
            @programs_value = MgAlumniProgrammeAttended.find_by(:id=>key,:mg_school_id=>session[:current_user_school_id])
            @programs_value.update(:mg_wing_id=>value,:time_table_year=>params[:time_table_year][key],:is_deleted=>0,:updated_by=>session[:user_id],:mg_school_id=>session[:current_user_school_id])
            @document = MgDocumentManagement.where(:mg_alumni_programme_attended_id=>key,:mg_school_id=>session[:current_user_school_id])
            if params[:files].present? && params[:files][key].present?
              if @document.present?

                #======================doc===========================
                @document_present = MgDocumentManagement.find_by(:mg_alumni_programme_attended_id=>key,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
                if @document_present.present?
                  @document_present.update(:is_deleted=>1,:updated_by=>session[:user_id])
                end
                #======================doc===========================

                #@document.update_all(:file=>params[:files][key],:is_deleted=>0,:updated_by=>session[:user_id])
                fileupload=MgDocumentManagement.new()
                fileupload.file=params[:files][key]
                fileupload.mg_alumni_programme_attended_id=key
                fileupload.is_deleted=0
                fileupload.mg_school_id=session[:current_user_school_id]
                fileupload.created_by=session[:user_id]
                fileupload.updated_by=session[:user_id]
                fileupload.save
              else
                fileupload=MgDocumentManagement.new()
                fileupload.file=params[:files][key]
                fileupload.mg_alumni_programme_attended_id=key
                fileupload.is_deleted=0
                fileupload.mg_school_id=session[:current_user_school_id]
                fileupload.created_by=session[:user_id]
                fileupload.updated_by=session[:user_id]
                fileupload.save
              end
            end
          else
            new_programme=MgAlumniProgrammeAttended.new()
            fileupload=MgDocumentManagement.new()
            new_programme.mg_wing_id=value
            new_programme.time_table_year=params[:time_table_year][key]
            # new_programme.mg_employee_specialization_id=params[:mg_specialization_id][key]
            new_programme.mg_alumni_id=params[:id]
            new_programme.is_deleted=0
            new_programme.created_by=session[:user_id]
            new_programme.updated_by=session[:user_id]
            new_programme.mg_school_id=session[:current_user_school_id]
            new_programme.save

            if params[:files].present?
              if params[:files][key].present?
                fileupload.file=params[:files][key]
                fileupload.mg_alumni_programme_attended_id=new_programme.id
                fileupload.is_deleted=0
                fileupload.mg_school_id=session[:current_user_school_id]
                fileupload.created_by=session[:user_id]
                fileupload.updated_by=session[:user_id]
                fileupload.save
              end
            end
          end #end include if
        end #end do
      end
    end


    flash[:notice]="Updated Successfully"
    redirect_to :action=>"alumni_update_profile"
  end

def searchable_information
  
 @alumni_data=MgAlumni.find_by(:mg_user_id=>session[:user_id])
 if request.get?

 elsif request.post?

  # @alumni_data.is_name_sharable=params[:alumni_data][:is_name_sharable]
  @alumni_data.is_email_id_sharable=params[:alumni_data][:is_email_id_sharable]
  @alumni_data.is_mobile_no_sharable=params[:alumni_data][:is_mobile_no_sharable]
  # @alumni_data.is_programme_searchable=params[:alumni_data][:is_programme_searchable]
  # @alumni_data.is_passing_out_searchable=params[:alumni_data][:is_passing_out_searchable]
  # @alumni_data.is_specialization_searchable=params[:alumni_data][:is_specialization_searchable]
  @alumni_data.is_current_location_searchable=params[:alumni_data][:is_current_location_searchable]
  @alumni_data.is_current_profession_searchable=params[:alumni_data][:is_current_profession_searchable]
  @alumni_data.is_current_designation_searchable=params[:alumni_data][:is_current_designation_searchable]
  @alumni_data.is_current_organization_searchabler=params[:alumni_data][:is_current_organization_searchabler]


  @alumni_data.save
#puts ajsgdj;
redirect_to :action=>"searchable_information"
end
end

def search_alumni_data


end
def search_alumni_data_forshow
  if params[:temp_val].present?
    @data_selected=params[:search_by]
    @data_text=params[:temp_val]
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
      if  params[:demo]=="passing out year"
@alumni_data=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:time_table_year=>params[:passout]).pluck(:mg_alumni_id).uniq
#information=MgAlumni.where(:id=>alumni_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@information=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>@alumni_data).where(str)

elsif params[:demo]=="programme"
@alumni_data=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:mg_alumni_id).uniq
#information=MgAlumni.where(:id=>alumni_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@information=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>@alumni_data).where(str)


#puts ajgsdj
end
 elsif(params[:search_by]=="mobile number")

   
      for s in 0..array_data.size-1
        str +=" mobile_number LIKE '%#{array_data[s]}%'"
        if s<array_data.size-1
          str+=" or "
        end
      end
  
if  params[:demo]=="passing out year"
@alumni_data=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:time_table_year=>params[:passout]).pluck(:mg_alumni_id).uniq
#information=MgAlumni.where(:id=>alumni_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@information=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>@alumni_data).where(str)

elsif params[:demo]=="programme"
@alumni_data=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:mg_alumni_id).uniq
#information=MgAlumni.where(:id=>alumni_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@information=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>@alumni_data).where(str)


#puts ajgsdj
end
  elsif(params[:search_by]=="email_id")

   
      for s in 0..array_data.size-1
        str +=" email_id LIKE '%#{array_data[s]}%'"
        if s<array_data.size-1
          str+=" or "
        end
      end

if  params[:demo]=="passing out year"
@alumni_data=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:time_table_year=>params[:passout]).pluck(:mg_alumni_id).uniq
#information=MgAlumni.where(:id=>alumni_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@information=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>@alumni_data).where(str)

elsif params[:demo]=="programme"
@alumni_data=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id]).pluck(:mg_alumni_id).uniq
#information=MgAlumni.where(:id=>alumni_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@information=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>@alumni_data).where(str)


#puts ajgsdj
end

end

else
   

@data_selected=0
@data_text=""
 end
render :layout=>false

end
def fom_all_search_data
   

    #   @student_data=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
    #   puts @student_data.inspect
    #   @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
    #   puts @employee_data.inspect


    #   @guardian_data=MgGuardian.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
    #   puts @guardian_data.inspect


    #   @address_book_data=MgAddressBookFom.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(" name LIKE ?","%#{params[:temp_val]}%")
    #   puts @address_book_data.inspect

    #     #puts agsjdgasdjg
    # elsif(params[:search_by]=="phone number")

   
    #   for s in 0..array_data.size-1
    #     str +=" phone_number LIKE '%#{array_data[s]}%'"
    #     if s<array_data.size-1
    #       str+=" or "
    #     end
    #   end


    #   phone_data=MgPhone.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str).pluck(:mg_user_id)

    #   @student_data=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
    #   puts @student_data.inspect
    #   @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
    #   puts @employee_data.inspect


    #   @guardian_data=MgGuardian.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
    #   puts @guardian_data.inspect


    #   @address_book_data=MgAddressBookFom.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where("contact_number LIKE ?","%#{params[:temp_val]}%")
    #   puts @address_book_data.inspect
    # elsif(params[:search_by]=="email_id")

   
    #   for s in 0..array_data.size-1
    #     str +=" mg_email_id LIKE '%#{array_data[s]}%'"
    #     if s<array_data.size-1
    #       str+=" or "
    #     end
    #   end


    #   phone_data=MgEmail.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str).pluck(:mg_user_id)

    #   @student_data=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
    #   puts @student_data.inspect
    #   @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
    #   puts @employee_data.inspect


    #   @guardian_data=MgGuardian.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>phone_data)
    #   puts @guardian_data.inspect


    #   @address_book_data=MgAddressBookFom.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where("email_id LIKE ?","%#{params[:temp_val]}%")
    #   puts @address_book_data.inspect
    # elsif(params[:search_by]=="Designation")
    #   for s in 0..array_data.size-1
    #     str +=" user_type LIKE '%#{array_data[s]}%'"
    #     if s<array_data.size-1
    #       str+=" or "
    #     end
    #   end


    #   user_data=MgUser.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str).pluck(:id)
      
      
    #   hod_data=MgExaminationHodLogin.where(:mg_user_id=>user_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_id).uniq
    #   library_employee=MgLibraryEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where( "designation LIKE '%#{array_data[s]}%'").pluck(:mg_employee_id)

    #   @student_data=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>user_data)
    #   puts @student_data.inspect
    #   if hod_data.present?
    #     @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>hod_data)
    #     puts @employee_data.inspect
    #   elsif library_employee.present?
    #     @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:id=>library_employee)
    #   else
    #     @employee_data=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>user_data)
    #   end
    #   @guardian_data=MgGuardian.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(:mg_user_id=>user_data)
    #   puts @guardian_data.inspect
    #   @address_book_data=MgAddressBookFom.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where("designation LIKE ?","%#{params[:temp_val]}%")
    #   puts @address_book_data.inspect
    # end
    # render :layout=>false
  end

#   def registration_sign_up

#   end

#   def registration_create

#     userdata=User.new(user_forum_params)
#     userdata.save
#     session[:user_form_id]=userdata.id

# redirect_to :controller=>"posts",:action=>"index"
#   end

#    def registration_sign_in

#   end

#   def registration_sign_in_create

#   user = User.authenticateUsersWithSchool(params[:resource_name][:email], params[:resource_name][:encrypted_password]) 
#   if user.present?
#     session[:user_form_id]=user.id


# redirect_to :controller=>"posts",:action=>"index"
# else
#     session[:user_form_id]=""

#   end
#   end

#   def email_search_data
#     email_id=MgEmail.find_by(:mg_email_id=>params[:email])
#     if email_id.present?
#       data=1
# else
# data=0

# end
#   render :json => {:name =>data}

#   end


def prepopulate_alumni_data
  data=params[:year]
  puts data.inspect
 # puts sadhasd
  alumni_data=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:wing_id],:time_table_year=>params[:year]).pluck(:mg_alumni_id).uniq
  @alumni=MgAlumni.where(:id=>alumni_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

if params[:get_together_id].present?
  wing_data=MgInviteGetTogether.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_alumni_get_together_id=>params[:get_together_id]).pluck(:mg_wing_id)
  year_data=MgInviteGetTogether.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_alumni_get_together_id=>params[:get_together_id]).pluck(:passout_year)

  alumni_data=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>wing_data,:time_table_year=>year_data).pluck(:mg_alumni_id).uniq
  @alumni=MgAlumni.where(:id=>alumni_data,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @selected_alumni=MgGetTogether.where(:mg_alumni_get_together_id=>params[:get_together_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_alumni_id)
end
render :layout=>false
  end


def fee_payment
    @gateway_data=MgPaymentGateway.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 5)
end

def fee_payment_new
    @action="new"
end

def create_payment
  mgtransaction = MgFinanceTransaction.new(:fees_from=>'Alumni',:title=>"Receipt No:",:amount=>params[:alumni_pay][:amount],:transaction_date=>Date.today,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])              
  mgtransaction.save
  @mg_finance_transaction = MgFinanceTransactionDetail.new(:is_partial_payment=>0,:mg_transaction_id=>mgtransaction.id,:paid_amount=>params[:alumni_pay][:amount],:detail_type=>"Alumni",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
  @mg_finance_transaction.save

  gateway=MgPaymentGateway.new(:mg_master_payment_type_id=>params[:mg_master_payment_type],:mg_wing_id=>params[:mg_wing_id],:time_table_year=>params[:time_table_year],:mg_alumni_id=>params[:mg_alumni_id],:amount=>params[:alumni_pay][:amount],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:mg_finance_fee_id=>mgtransaction.id)
  gateway.save
  
  #Added By Bindhu For Accounts Starts
  if params[:alumni_pay][:mg_account_id].present?
    if params[:alumni_pay][:mg_account_id]=="central"
      gateway.update(:is_to_central=>1)
    else
      gateway.update(:mg_account_id=>params[:alumni_pay][:mg_account_id])
    end
  end              
  #Added By Bindhu For Accounts Ends

 redirect_to :action=>"fee_payment"
end

def alumni_data
    alumni_data_attended=MgAlumniProgrammeAttended.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>params[:mg_wing_id],:time_table_year=>params[:year]).pluck(:mg_alumni_id).uniq
    alumni_data=MgAlumni.where(:id=>alumni_data_attended,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])   
    @array1=Array.new

    alumni_data.each do |data|
      array2=Array.new
      array2.push("#{data.first_name} #{data.last_name}",data.id)
      @array1.push(array2)
    end
  render :layout=>false
end

def alumni_fee_pdf   
  receipt_no=MgPaymentGateway.find(params[:id])
  # Added By Bindhu for account starts
  account_name=""
  if (receipt_no.mg_account_id).present?
    account=MgAccount.find_by(:id=>receipt_no.try(:mg_account_id))
    account_name=account.mg_account_name
  elsif receipt_no.is_to_central
    account_name="Central"
  end
  # Added By Bindhu for account ends

   alumni_data=MgAlumni.find(receipt_no.mg_alumni_id)
   #specialization=MgEmployeeSpecialization.find(receipt_no.mg_employee_specialization_id)
    wing=MgWing.find(receipt_no.mg_wing_id)
    type=MgMasterPaymentType.find(receipt_no.mg_master_payment_type_id)

    @school_id=session[:current_user_school_id]
    @dateFormat = MgSchool.find(@school_id).date_format
    school=MgSchool.find(session[:current_user_school_id])
@@school_logo=school.logo.url(:medium,:timestamp=>false)
    fee_transaction = MgFinanceTransaction.find(receipt_no.mg_finance_fee_id)
 if fee_transaction.transaction_date.present?
        date=fee_transaction.transaction_date.strftime(@dateFormat)
      end
   pdf = Prawn::Document.new(:size=>1) do
    
      repeat [1] do
       

        bounding_box [bounds.left, bounds.top],:align => :right, :width  => bounds.width do
            font "Helvetica"
            if File.exists?("#{Rails.root}/public/#{@@school_logo}") 

      image ("#{Rails.root}/public/#{@@school_logo}"),:width=>45
        end
       
            text school.school_name, :align => :center, :size => 18
            stroke_horizontal_rule
        end
        move_down 10
        
        text "Receipt No : #{receipt_no.mg_finance_fee_id} Payment Date : #{date}"
       
        move_down 15

        #cell size
        widths = [125,125,125,125]
        cell_height = 10
        font_size=8
         widths_for=[135,140]

  table([
["Name","#{alumni_data.first_name} #{alumni_data.last_name}"]],:column_widths => widths_for, :cell_style => { size: font_size }) 
      
         # foo
  table([
["Passout Year","#{receipt_no.time_table_year}"]],:column_widths => widths_for,:cell_style => { size: font_size }) 
  table([
["Programme","#{wing.wing_name}"]],:column_widths => widths_for, :cell_style => { size: font_size }) 
#   table([
# ["Specialization","#{specialization.name}"]],:column_widths => widths_for, :cell_style => { size: font_size }) 
  table([
["Payment Type","#{type.name}"]],:column_widths => widths_for, :cell_style => { size: font_size }) 
  # Added By Bindhu for account starts
   table([
["Account","#{account_name}"]],:column_widths => widths_for, :cell_style => { size: font_size }) 
   # Added By Bindhu for account ends
    table([
["Amount","#{receipt_no.amount}"]],:column_widths => widths_for, :cell_style => { size: font_size }) 
   
        bounding_box [bounds.left, bounds.bottom + 45], :width  => bounds.width do
              font "Helvetica"
              stroke_horizontal_rule
              move_down(5)
              # image "#{Rails.root}/app/assets/images/mindcom-logo.png", :width => 45, :align => :left
              # text " Powered By - ©", :size => 12
              move_down 12
              #draw_text "Terms & Conditions| Privacy Policy| About Us| Contact Us",:at => [70,3]
              draw_text "Powered By - ©", :at => [400,3]
              image "#{Rails.root}/app/assets/images/mindcom-logo.png", :at=>[495,15], :width => 45, :align => :right
          end
       
      end

       


    # start_new_page
    end
    
    send_data pdf.render, :filename => "x.pdf", :type => "application/pdf", :disposition => 'inline'
  end
def online_store
  mg_school_id=session[:current_user_school_id]
  @category=MgInventoryItemCategory.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:name, :id)
  @items=MgInventoryItem.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :item_type=>"Sale").order(:mg_category_id)
  @cart_detail=MgAlumniItemSaleDetail.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_user_id=>session[:user_id], :cart_status=>0).group(:mg_inventory_item_id)
  # mg_inventory_item_id

end

def online_store_item_list
  mg_school_id=session[:current_user_school_id]

  online_store_item_list=MgInventoryItem.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_category_id=>params[:id])#.pluck(:name, :id)
  str="<option value=''>All</option>"
  online_store_item_list.each do |i|
    str +="<option value='#{i.id}'>#{i.name}</option>"
  end

  render :json=>{:data=>str} 
end

def online_store_item_show
  mg_school_id=session[:current_user_school_id]
  @items=MgInventoryItem.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>params[:id])
  @category=MgInventoryItemCategory.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=> @items.mg_category_id)
  @current_count=MgInventoryItemManagement.where(:is_deleted=>0, :mg_school_id=>mg_school_id)

  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    today_date = DateTime.parse(Date.today.to_s)
    new_date_format = today_date.strftime(@timeformat.date_format)
    current_date = Date.strptime(new_date_format,@timeformat.date_format)
    @inventory_item_management = MgInventoryItemManagement.where("mg_inventory_item_id=? and is_deleted=? and mg_school_id=? and date_of_expiry>?",
      @items.id,0,mg_school_id,current_date)
    @total_quantity=0
    @inventory_item_management.each do |quantity|
      @total_quantity+=quantity.quantity_available
    end

    puts"000000000000000000000000000"
    puts @total_quantity
    puts"000000000000000000000000000"


  render :layout=>false
end

def order_number
  mg_school_id=session[:current_user_school_id]
  order_number_count=1
  order_number=MgAlumniItemSaleDetail.where(:mg_school_id=>mg_school_id).where("order_number  IS NOT NULL").pluck(:order_number)#.order("desc")
  puts "order_number last --1"
  # puts order_number.first.order_number
  # puts order_number.last.order_number
  # puts order_number.inspect
  puts "order_number last --2"

  if order_number.present?
    # order_number.each do |o|
    #   if o.order_number.present?
    #     order_number_count=(o.order_number.to_i+1)
    #   end
    # end
    order_number_count=(order_number.map(&:to_i).max+1)
  end
  return order_number_count
end

def cart_update
  user_id=session[:user_id]
  mg_school_id=session[:current_user_school_id]
  item=MgInventoryItem.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>params[:store][:mg_inventory_item_id])
  cort_obj=MgAlumniItemSaleDetail.new(cart_update_params)
  cort_obj.price=item.try(:online_price)
  if params[:store][:cart_status] != "false"
    cort_obj.order_number=order_number
  end
  # puts order_number
  # puts gjhfdjks
  if cort_obj.save
    flash[:notice]="Request Processed successfully"
  else
    flash[:error]="Request Processed unsuccessful , Please try later."
  end

  redirect_to :action=>'online_store'

end
def online_store_cart_show
  mg_school_id=session[:current_user_school_id]
  @cart_detail=MgAlumniItemSaleDetail.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_user_id=>session[:user_id], :cart_status=>0)
  @school=MgSchool.find(mg_school_id)
  render :layout=>false
end

def online_store_item_delete_from_cart

  obj=MgAlumniItemSaleDetail.find_by(:id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
  full_sale_detail_obj=MgAlumniItemSaleDetail.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_inventory_item_id=>obj.mg_inventory_item_id)
  result=full_sale_detail_obj.update_all(:is_deleted=>1  , :updated_by=>session[:user_id])
  render :json=>{result: result}
end

def online_store_item_buy_from_cart
  puts params.inspect

  obj=MgAlumniItemSaleDetail.where(:mg_user_id=>session[:user_id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :cart_status=>false)
  result=obj.update_all(:cart_status=>1  , :updated_by=>session[:user_id], :order_number=>order_number)
  
  render :json=>{result: result}

end
def online_store_history
  @school=MgSchool.find(session[:current_user_school_id])
  @online_store_history=MgAlumniItemSaleDetail.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_user_id=>session[:user_id], :cart_status=>1).order(:order_number)
end


def ordered_list
  @obj=MgAlumniItemSaleDetail.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def edit_ordered_list
  @obj=MgAlumniItemSaleDetail.find_by(:id=>params[:id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
  mg_school_id=session[:current_user_school_id]
  puts "=========================================================================="
  puts @obj.inspect
  puts "=========================================================================="
  # ====================================================================================================
  @items=MgInventoryItem.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>@obj.mg_inventory_item_id)
  @category=MgInventoryItemCategory.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=> @items.mg_category_id)
  @current_count=MgInventoryItemManagement.where(:is_deleted=>0, :mg_school_id=>mg_school_id)

  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    today_date = DateTime.parse(Date.today.to_s)
    new_date_format = today_date.strftime(@timeformat.date_format)
    current_date = Date.strptime(new_date_format,@timeformat.date_format)
    @inventory_item_management = MgInventoryItemManagement.where("mg_inventory_item_id=? and is_deleted=? and mg_school_id=? and date_of_expiry>?",
      @items.id,0,mg_school_id,current_date)
    @total_quantity=0
    @inventory_item_management.each do |quantity|
      @total_quantity+=quantity.quantity_available
    end
  render :layout=>false
end



def show_ordered_list
  @obj=MgAlumniItemSaleDetail.find_by(:id=>params[:id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
  mg_school_id=session[:current_user_school_id]
  puts "=========================================================================="
  puts @obj.inspect
  puts "=========================================================================="
  # ====================================================================================================
  @items=MgInventoryItem.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=>@obj.mg_inventory_item_id)
  @category=MgInventoryItemCategory.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :id=> @items.mg_category_id)
  @current_count=MgInventoryItemManagement.where(:is_deleted=>0, :mg_school_id=>mg_school_id)

  @timeformat=MgSchool.find_by(:id=>session[:current_user_school_id])
    today_date = DateTime.parse(Date.today.to_s)
    new_date_format = today_date.strftime(@timeformat.date_format)
    current_date = Date.strptime(new_date_format,@timeformat.date_format)
    @inventory_item_management = MgInventoryItemManagement.where("mg_inventory_item_id=? and is_deleted=? and mg_school_id=? and date_of_expiry>?",
      @items.id,0,mg_school_id,current_date)
    @total_quantity=0
    @inventory_item_management.each do |quantity|
      @total_quantity+=quantity.quantity_available
    end
  render :layout=>false
end



def update_ordered_list
  # puts sdf
    demanded_quantity=params[:obj][:required_quantity].to_i
    @object=MgAlumniItemSaleDetail.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:obj][:mg_alumni_item_sale_detail_id])
    pre_status=@object.try(:status)
    @object.update(:status=>params[:obj][:status],:updated_by=>session[:user_id])
    reduced_quantity=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>params[:obj][:mg_inventory_item_id]).order(:created_at)
    if pre_status.to_s=="pending" && params[:obj][:status].to_s!="rejected"
        reduced_quantity.each do |red|
          if demanded_quantity>0
              if demanded_quantity>red.try(:quantity_available)
                  red.update(:quantity_available=>0,:updated_by=>session[:user_id])
                  demanded_quantity=demanded_quantity-red.try(:quantity_available)
              else
                temp=red.try(:quantity_available)-demanded_quantity
                red.update(:quantity_available=>temp,:updated_by=>session[:user_id])
                demanded_quantity=0
              end
          end
        end
    end
    redirect_to :action=>'ordered_list'
end


# ============================================================================================

  def payment_new
    render :layout=>false
  end

  def payment_create
    itemCategory=MgMasterPaymentType.new(params_category)
     if itemCategory.save
     else
        # flash[:notice]="category already exist"
    end
    redirect_to :action=> "payment_index"
  end

  def payment_show
    @itemCategory=MgMasterPaymentType.find_by(:id=>params[:id])
    render :layout=>false
  end

  def payment_edit
    @alumni=MgMasterPaymentType.find_by(:id=>params[:id])
    render :layout=>false
  end

  def payment_delete
    puts "==========================================================="
    puts params[:id]
    puts "==========================================================="
    @itemCategory=MgMasterPaymentType.find_by(:id=>params[:id])
    @itemCategory.update(:is_deleted=>1,:updated_by=>session[:user_id])
    redirect_to :back
  end

  def payment_updates
  @itemCategory=MgMasterPaymentType.find_by(:id=>params[:id])
  @itemCategory.update(params_update_category)
  redirect_to :action=> "payment_index"
  end

  def payment_index
    @itemCategory=MgMasterPaymentType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end


  # ===================================================================================================
  def search_all_photo_gallery
    array_data=params[:search_gallery]
    str=""
    if params[:search_gallery].present?
      str =" name LIKE '%#{array_data}%'"
      @gallery_list = MgAlumniPhotoGallery.where(:status=>"accepted",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where(str)#.paginate(page: params[:page], per_page: 10)
    else
      @gallery_list = MgAlumniPhotoGallery.where(:status=>"accepted",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#.paginate(page: params[:page], per_page: 10)
    end
    render :layout => false
  end
  # ===================================================================================================

  def gallery_list
    array_data=params[:search_gallery]
    str=""
    if params[:search_gallery].present?
      str =" name LIKE '%#{array_data}%'"
      @gallery_list = MgAlumniPhotoGallery.where(:status=>"accepted",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where(str).paginate(page: params[:page], per_page: 10)
    else
      @gallery_list = MgAlumniPhotoGallery.where(:status=>"accepted",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    end
  end

 def photo_gallery_list
    @photos=MgImage.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_alumni_photo_gallery_id=>params[:id],:status=>'accepted').where.not('image'=>nil)#.paginate(page: params[:page], per_page: 12)
    @created_obj = MgAlumniPhotoGallery.find_by(:id=>params[:id])
  end

  def alumni_search
  end

  def video_gallery_list
    @photos=MgImage.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_alumni_photo_gallery_id=>params[:id],:status=>'accepted').where.not('video'=>nil)#.paginate(page: params[:page], per_page: 12)
    @created_obj = MgAlumniPhotoGallery.find_by(:id=>params[:id])
  end

  def search_data
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
        
      @alumni_data=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
    elsif(params[:search_by]=="phone number")
      for s in 0..array_data.size-1
        str +=" phone_number LIKE '%#{array_data[s]}%'"
        if s<array_data.size-1
          str+=" or "
        end
      end
      @alumni_data=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str).where(:is_mobile_no_sharable=>1)

    elsif(params[:search_by]=="email_id")
      for s in 0..array_data.size-1
        str +=" email_id LIKE '%#{array_data[s]}%'"
        if s<array_data.size-1
          str+=" or "
        end
      end
      @alumni_data=MgAlumni.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str).where(:is_email_id_sharable=>1)

    end
    render :layout=>false
  end



private

def params_category
  params.require(:alumni).permit(:name,:description,:is_deleted,:created_by,:updated_by,:mg_school_id)
end

def params_update_category
  params.require(:alumni).permit(:name,:description,:is_deleted,:updated_by,:mg_school_id)
end

def get_together_params_data
	params.require(:get_togethers_type).permit(:event_name,:event_date,:start_time,:end_time,:venue,:status,:mg_user_id,:mg_school_id,:created_by,:updated_by,:is_deleted)
end

def update_get_together_params_data
	params.require(:get_togethers_type).permit(:event_name,:start_time,:end_time,:venue,:status,:mg_school_id,:updated_by,:is_deleted)

end
# def polling_data
#   params.require(:polling).permit(:question,:description,:mg_school_id,:created_by,:updated_by,:is_deleted)
# end

def polling_option_data
  params.require(:polling_option).permit(:question,:mg_school_id,:created_by,:updated_by,:is_deleted)
end

def update_polling_option_data
params.require(:polling_option).permit(:question,:mg_school_id,:updated_by,:is_deleted)
end



 def alumni_params
   params.require(:student).permit(:first_name,:middle_name,:last_name,:gender,:phone_number,:country_code,:mobile_number,:current_location,:current_address,:current_profession,:designation,:current_organization,:hobbies,:user_name,:mg_school_id,:is_deleted,:created_by,:updated_by,:admission_number)
 end
 def user_params
      params.require(:student).permit(:user_name,:first_name,:middle_name,:last_name, :password, :mg_school_id, :is_deleted,:user_type,:created_by,:updated_by)
    end
    def alumni_params_update
      params.require(:student).permit(:first_name,:middle_name,:last_name,:gender,:phone_number,:country_code,:mobile_number,:current_location,:current_address,:current_profession,:designation,:current_organization,:hobbies)
    end
 def user_params_update
      params.require(:student).permit(:first_name,:middle_name,:last_name)
    end
    # def user_forum_params
    #   params.require(:resource_name).permit(:email,:encrypted_password)
    # end

  def polling_answer_data
    params.require(:alumni_poll_data).permit(:mg_school_id,:created_by,:updated_by,:is_deleted)
  end


   def photo_gallery_params
    params.require(:photo_gallery).permit(:name, :description,:status,:mg_school_id,:created_by,:updated_by,:is_deleted)
  end

  def photo_gallery_update_params
    params.require(:photo_gallery).permit(:name, :description,:mg_school_id,:updated_by,:is_deleted)
  end

  def alumni_job_posting_params
    params.require(:alumni_job_posting).permit(:position,:job_description,:minimum_qualification,:minimum_experience_required,:company,:company_website,:relevant_experience,:alumni_id,:referral_code,:is_amount_applicable,:amount_as,:amount,:is_deleted,:created_by,:updated_by,:mg_school_id,:functional_area,:technical_skills,:soft_skills,:salary,:referral_code,:status)
  end
def cart_update_params
      params.require(:store).permit(:mg_inventory_item_id,:price,:required_quantity,:mg_user_id, :cart_status,:status,:mg_school_id,:created_by,:updated_by,:is_deleted)
    
  end


end



