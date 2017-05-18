class AlbumsController < ApplicationController

		layout "mindcom"
		before_filter :login_required

        def new 
        	mg_school_id=session[:current_user_school_id]
        	@department_list=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
			@course_list=MgCourse.where(:is_deleted=>0, :mg_school_id=>mg_school_id)

			@albums=MgAlbum.new()
			# render :layout => false


		end
	
		def index
	
		  	@albums = MgAlbum.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
	 		# render :layout => false

	 		# @image_list=MgDocumentManagement.where(:is_deleted=>0)


		end

		
# 
		def create
		  begin
		    MgAlbum.transaction do
				created_by=params[:albums][:created_by]
				mg_school_id=params[:albums][:mg_school_id]
				@albums=MgAlbum.new(albums_params)
				  	if params[:albums][:accessable_to­_employees]=='1'
				  		if params[:mg_employee_department_id].present?
			  				puts params[:mg_employee_department_id].inspect
			  				for i in 0...params[:mg_employee_department_id].size
			  					@albums.mg_user_albums.build(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>params[:mg_employee_department_id][i], "accessable_to_employees"=>"1", :created_by=>created_by, :updated_by=>created_by)
			  				end
				  		end
				  	end

				  	if params[:albums][:accessable_teacher]=='1'
				  		if params[:tech_mg_employee_department_id].present?
			  				puts params[:tech_mg_employee_department_id].inspect
			  				for i in 0...params[:tech_mg_employee_department_id].size
			  					@albums.mg_user_albums.build(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>params[:tech_mg_employee_department_id][i], "accessable_teacher"=>"1", :created_by=>created_by, :updated_by=>created_by)
			  				end
				  		end
				  	end

				  	if params[:albums][:accessable_to­_students]=='1'
				  		if params[:student_mg_batch_id].present?
				  				puts params[:student_mg_batch_id].inspect
				  				for i in 0...params[:student_mg_batch_id].size
			  					@albums.mg_user_albums.build(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>params[:student_mg_batch_id][i], "accessable_to_students"=>"1", :created_by=>created_by, :updated_by=>created_by)
			  				end
				  		end
				  	end

				  	if params[:albums][:accessable_to­_guardians]=='1'
				  		if params[:guardian_mg_batch_id].present?
				  				puts params[:guardian_mg_batch_id].inspect
				  				for i in 0...params[:guardian_mg_batch_id].size
			  						@albums.mg_user_albums.build(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>params[:guardian_mg_batch_id][i], "accessable_to_guardians"=>"1", :created_by=>created_by, :updated_by=>created_by)
			  					end
				  		end
				  	end

			  	@albums.save
			  	flash[:notice]='Album created successfully'
			  	if params[:url_direction].present?
			  		redirect_to :action => "upload_photos", :id=>@albums.id
			  	else
			  		redirect_to :action =>'index'
			  	end
			    
			end
		  rescue Exception => e
			puts e
			consolo.logo(e)
			 flash[:error]="Error occured, please contact administrator"
			redirect_to :action =>'index'
			# redirect_to :action => "index"
		  end
		end

		def show
			@mg_school_id=session[:current_user_school_id]
		  	@albums = MgAlbum.find(params[:id])
		  	render :layout => false
		end

	  	def edit
	  	@albums = MgAlbum.find(params[:id])
	  	mg_school_id=@albums.mg_school_id
	  	@department_list=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
	  	@department_list_checked=MgUserAlbum.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_album_id=>@albums.id,:accessable_to_employees=>1).pluck(:mg_employee_department_id)
	  	@batch_std_checked=MgUserAlbum.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_album_id=>@albums.id,:accessable_to_students=>1).pluck(:mg_batch_id)
	  	@batch_gnd_list_checked=MgUserAlbum.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_album_id=>@albums.id,:accessable_to_guardians=>1).pluck(:mg_batch_id)
	  	@course_list=MgCourse.where(:is_deleted=>0, :mg_school_id=>mg_school_id)
	 	# render :layout => false

	 	@department_list_tech_checked=MgUserAlbum.where(:is_deleted=>0,:mg_school_id=>mg_school_id, :mg_album_id=>@albums.id,:accessable_teacher=>1).pluck(:mg_employee_department_id)

		end


		def update
			begin
				MgAlbum.transaction do
					  @albums = MgAlbum.find(params[:id])
					  mg_school_id=@albums.mg_school_id
					  updated_by=session[:user_id]
					  var=@albums.mg_user_albums.where(:mg_school_id=>mg_school_id)
					  var.each do |delete|
						delete.update(:is_deleted=>1, :updated_by=>updated_by)
					  end
					  	if params[:albums][:accessable_to­_employees]=='1'
					  		if params[:mg_employee_department_id].present?
				  				for i in 0...params[:mg_employee_department_id].size
				  					present_date=MgUserAlbum.find_by(:mg_school_id=>mg_school_id, :mg_album_id=>@albums.id, :mg_employee_department_id=>params[:mg_employee_department_id][i])
				  					if present_date.present?
				  						present_date.update(:is_deleted=>0, :accessable_to_employees=>1)
				  					else
				  						@albums.mg_user_albums.build(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>params[:mg_employee_department_id][i], "accessable_to_employees"=>"1",  :updated_by=>updated_by)
				  					end

				  				end
					  		end
					  	end

					  	if params[:albums][:accessable_teacher]=='1'
					  		if params[:tech_mg_employee_department_id].present?
				  				for i in 0...params[:tech_mg_employee_department_id].size
				  					present_date=MgUserAlbum.find_by(:mg_school_id=>mg_school_id, :mg_album_id=>@albums.id, :mg_employee_department_id=>params[:tech_mg_employee_department_id][i])
				  					if present_date.present?
				  						present_date.update(:is_deleted=>0, :accessable_teacher=>1)
				  					else
				  						@albums.mg_user_albums.build(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_department_id=>params[:tech_mg_employee_department_id][i], :accessable_teacher=>1,  :updated_by=>updated_by)
				  					end

				  				end
					  		end
					  	end

					  	if params[:albums][:accessable_to­_students]=='1'
					  		if params[:student_mg_batch_id].present?
					  				puts params[:student_mg_batch_id].inspect
					  				for i in 0...params[:student_mg_batch_id].size
					  					present_date=MgUserAlbum.find_by(:mg_school_id=>mg_school_id, :mg_album_id=>@albums.id, :mg_batch_id=>params[:student_mg_batch_id][i],"accessable_to_students"=>"1")
				  						if present_date.present?
				  							present_date.update(:is_deleted=>0, :accessable_to_students=>1)
				  						else
				  							@albums.mg_user_albums.build(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>params[:student_mg_batch_id][i], "accessable_to_students"=>"1", :updated_by=>updated_by)
				  						end
				  				end
					  		end
					    end
					    if params[:albums][:accessable_to­_guardians]=='1'
					  		if params[:guardian_mg_batch_id].present?

					  				puts params[:guardian_mg_batch_id].inspect
					  				for i in 0...params[:guardian_mg_batch_id].size
					  					present_date=MgUserAlbum.find_by(:mg_school_id=>mg_school_id, :mg_album_id=>@albums.id, :mg_batch_id=>params[:guardian_mg_batch_id][i],"accessable_to_guardians"=>"1")
					  					if present_date.present?
					  						present_date.update(:is_deleted=>0, :accessable_to_guardians=>1)
					  					else
				  							@albums.mg_user_albums.build(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>params[:guardian_mg_batch_id][i], "accessable_to_guardians"=>"1", :updated_by=>updated_by)
					  					end
				  					end
					  		end
						end
					@albums.update(albums_params)
					flash[:notice]='Album updated successfully'
					# redirect_to :action => "upload_photos", :id=>@albums.id
					if params[:url_direction].present?
			  			redirect_to :action => "upload_photos", :id=>@albums.id
			  		else
			  			redirect_to :action =>'index'
			  		end
			    end
			rescue Exception => e
				flash[:error]="Error occured, please contact administrator"
				redirect_to :action =>'index'
			end

		end

		def destroy

		end

		def delete
			@albums=MgAlbum.find_by_id(params[:id])
			@albums.is_deleted =1
			@albums.save
		  	redirect_to albums_path
		end

		def department_list
			@department_list=MgEmployeeDepartment.where(:is_deleted, :mg_school_id=>mg_school_id)
			
		end

		def upload_photos
			mg_school_id=session[:current_user_school_id]
			@photos=MgAlbumPhoto.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_album_id=>params[:id])#.paginate(page: params[:page], per_page: 12)

		end

		def upload_photos_save
			 require 'mime/types'
		mg_school_id=session[:current_user_school_id]
            
            @file=params[:file]
           # @fileupload.file=params[:file]
            if @file.nil?
            	flash[:notice]="Photos are not selected"
            else
              @file.each do |a|
                 @fileupload=MgAlbumPhoto.new()
            
                 @fileupload.photo=a
                 @fileupload.mg_album_id=params[:mg_album_id]
                 @fileupload.is_deleted=0
                 @fileupload.mg_school_id=mg_school_id
                 @fileupload.created_by=session[:user_id]
                 @fileupload.updated_by=session[:user_id]
                  
                 @fileupload.save
                flash[:notice]= "Photos upload successfully"
            end
          
          end
		
			redirect_to :action=>'upload_photos',:id=>params[:mg_album_id]
		end
   #  def delete_photo
   #  	@albums=MgAlbumPhoto.find(params[:id])
			# @albums.is_deleted =1
			# @albums.save
		 #  	redirect_to :back
    	
   #  end

    def employee_albums
    	user_id=session[:user_id]
    	mg_school_id=session[:current_user_school_id]
    	albums_list=[]
    	# user=MgEmployee.find_by(:mg_user_id=>user_id,:is_deleted=>0, :mg_school_id=>mg_school_id)
    	user=MgEmployee.find_by(:mg_user_id=>user_id,:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_employee_category_id=>(MgEmployeeCategory.find_by(:category_name=>"Non Teaching Staff").id))
        if user.present?

	       	albums=MgUserAlbum.where(:mg_employee_department_id=>user.mg_employee_department_id, :is_deleted=>0, :mg_school_id=>mg_school_id, "accessable_to_employees"=>"1").pluck(:mg_album_id)
			albums_list +=albums

			committitee=MgCommitteeMember.where(:mg_employee_id=>user.id, :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_event_committee_id)
			committitee_events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>committitee).pluck(:id)

			committitee_album=MgAlbum.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_id=>committitee_events).pluck(:id)
			albums_list +=committitee_album

        else
        	user=MgEmployee.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id])	
      		
	       	albums=MgUserAlbum.where(:mg_employee_department_id=>user.mg_employee_department_id, :is_deleted=>0, :mg_school_id=>mg_school_id, :accessable_teacher=>1).pluck(:mg_album_id)
			albums_list +=albums

			committitee=MgCommitteeMember.where(:mg_employee_id=>user.id, :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_event_committee_id)
			committitee_events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>committitee).pluck(:id)

			committitee_album=MgAlbum.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_id=>committitee_events).pluck(:id)
			albums_list +=committitee_album
      	end  

    	
		@albums_list=MgAlbum.where(:id=>albums_list.uniq, :is_deleted=>0, :mg_school_id=>mg_school_id).paginate(page: params[:page], per_page: 10)
    end

    def albums_photos
    	user_id=session[:user_id]
    	mg_school_id=session[:current_user_school_id]
    	@user=MgUser.find(user_id).user_type
    	@albums=MgAlbumPhoto.where(:mg_album_id=>params[:id], :is_deleted=>0, :mg_school_id=>mg_school_id)
    end

    def student_albums
    	user_id=session[:user_id]
    	mg_school_id=session[:current_user_school_id]
    	albums_list=[]
    	student=MgStudent.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_user_id=>user_id)
    	albums=MgUserAlbum.where(:mg_batch_id=>student.mg_batch_id, "accessable_to_students"=>1, :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_album_id)
    	albums_list +=albums
		committitee=MgCommitteeMember.where(:mg_student_id=>student.id, :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_event_committee_id)
		committitee_events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>committitee).pluck(:id)
		committitee_album=MgAlbum.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_id=>committitee_events).pluck(:id)
		albums_list +=committitee_album
		@albums_list=MgAlbum.where(:id=>albums_list.uniq, :is_deleted=>0, :mg_school_id=>mg_school_id).paginate(page: params[:page], per_page: 10)
    	
    end

    def guardian_albums
    	user_id=session[:user_id]
    	mg_school_id=session[:current_user_school_id]
    	albums_list=[]
    	user=MgGuardian.find_by(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_user_id=>user_id)
    	student_list=MgStudentGuardian.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_guardians_id=>user.id).pluck(:mg_student_id)
    	batchs=MgStudent.where(:id=>student_list, :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_batch_id)

    	mg_albums_id=MgUserAlbum.where(:mg_batch_id=>batchs,"accessable_to_guardians"=>1, :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_album_id)
		@albums_list=MgAlbum.where(:id=>mg_albums_id, :is_deleted=>0, :mg_school_id=>mg_school_id).paginate(page: params[:page], per_page: 10)

    end

    def delete_photos
    	@photos=MgAlbumPhoto.where(:id=>params[:mg_album_photos_id])
    	@photos.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
    
    	 flash[:notice]= "photos deleted successfully"
    	redirect_to :back 
    end



  private
  def albums_params
    params.require(:albums).permit(:accessable_teacher,:accessable_to­_employees, :accessable_to­_students, :accessable_to­_guardians, :name,:mg_event_id, :description ,:is_deleted, :mg_school_id, :created_by, :updated_by)
  end
end


# mg_event_id:integer  description:string mg_employee_department_id:integer mg_batch_id:integer 
#  accessable_to­_employees:boolean  accessable_to­_students:boolean  accessable_to­_guardians:boolean