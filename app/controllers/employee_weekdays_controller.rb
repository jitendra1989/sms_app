class EmployeeWeekdaysController < ApplicationController
 layout "mindcom"
		before_filter :login_required

        def new 
			@employee_weekdays=MgEmployeeWeekday.new
			render :layout => false


		end
	
		def index
	
		  	@employee_weekdays = MgEmployeeWeekday.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
	 		# render :layout => false
	 		@weekdaychecked= MgEmployeeWeekday.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).pluck(:weekday)

		end

		def create
			mg_school_id=session[:current_user_school_id]
			user_id=session[:user_id]

			puts params[:weekdays].inspect
			obj=MgEmployeeWeekday.where(:is_deleted=>0,:mg_school_id=>mg_school_id)
			if obj.present?
				obj.update_all(:is_deleted=>1)
			end
			if params[:weekdays].present?
				for i in 0...params[:weekdays].size
					employee_weekdays=MgEmployeeWeekday.where( :mg_school_id=>mg_school_id,:weekday=>params[:weekdays][i])
					if employee_weekdays[0].present?
						employee_weekdays[0].is_deleted=0
						employee_weekdays[0].updated_by=user_id
						employee_weekdays[0].save
					else
						new_obj=MgEmployeeWeekday.new
						new_obj.is_deleted=0
						new_obj.mg_school_id=mg_school_id
						new_obj.weekday=params[:weekdays][i]
						new_obj.created_by=user_id
						new_obj.updated_by=user_id
						new_obj.save
					end
				end 

			end
			flash[:notice]= "weekdays updated successfully"
		redirect_to :action => "index"
		

			# @employee_weekdays=MgEmployeeWeekday.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id])
		 #  	@employee_weekdays=MgEmployeeWeekday.new(employee_weekdays_params)
			#   	if @employee_weekdays.save
			#     redirect_to :action => "index"
			#   	else
			#     render 'new'
			#   	end
		end

		def show
		  	@employee_weekdays = MgEmployeeWeekday.find(params[:id])
		  	render :layout => false

		  	
		end

	  	def edit
	 	@employee_weekdays = MgEmployeeWeekday.find(params[:id])
	 	render :layout => false

		end

		def update
		  @employee_weekdays = MgEmployeeWeekday.find(params[:id])
		 
		  if @employee_weekdays.update(event_types_params)
		    redirect_to :back
		  else
		    render 'edit'
		  end
		end

		def destroy

		end

		def delete
			@notice=''
			begin
				MgEmployeeWeekday.transaction do
					@employee_weekdays=MgEmployeeWeekday.find_by_id(params[:id])
					@employee_weekdays.is_deleted =1
					@employee_weekdays.save
					@employee_weekdays.mg_events.update_all(:is_deleted=>1)
					events_id=@employee_weekdays.mg_events.pluck(:id)
					events=MgEvent.where(:id=>events_id)
					events.each do |delete|
						delete.mg_guests.update_all(:is_deleted=>1)
						delete.mg_albums.update_all(:is_deleted=>1)
					end

				end
				@notice="Event type deleted Successfully"
			rescue Exception => e
				puts e
				@notice="Event type deleted unsuccessful, pleace contact admin"
			end
			
		  	redirect_to event_types_path , :notice=>@notice
		end

  private
  def employee_weekdays_params
    params.require(:employee_weekdays).permit(:name, :event_color, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end
end
