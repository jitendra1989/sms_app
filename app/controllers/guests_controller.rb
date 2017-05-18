class GuestsController < ApplicationController

		layout "mindcom"
		before_filter :login_required

        def new 
        	@mg_event_id=params[:mg_event_id]
			@guests=MgGuest.new()
			render :layout => false


		end
	
		def index
			@events=[]
		  	@guests = MgGuest.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
	 		# render :layout => false
	 		mg_school_id=session[:current_user_school_id]
			@event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name, :id )
			
			params[:mg_event_id]=params[:mg_event_id]
			if params[:mg_event_id].present?
				events=MgEvent.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :id=>params[:mg_event_id])
				params[:mg_event_committee_id]=events.mg_event_committee_id
				@events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>events.mg_event_committee_id).pluck(:title, :id)
			end


		end

		def create
			
		  	@guests=MgGuest.new(guests_params)
			  	if @guests.save
			  	flash[:notice]="Guests details created successfully"
			    redirect_to :action => "index", :params=>{:mg_event_id=>params[:guests][:mg_event_id]}
			  	else
			    
				flash[:error]="Error occured, please contact administrator"
		    	redirect_to :action=>'index',:params=>{:mg_event_id=>params[:guests][:mg_event_id]}
			  	end
		end

		def show
		  	@guests = MgGuest.find(params[:id])
		  	render :layout => false

		  	
		end

	  	def edit
	 	@guests = MgGuest.find(params[:id])
	 	render :layout => false

		end

		def update
		  @guests = MgGuest.find(params[:id])
		 
		  if @guests.update(guests_params)
		  	flash[:notice]="Guests details updated successfully"
		    redirect_to :action=>'index',:params=>{:mg_event_id=>params[:guests][:mg_event_id]}
		  else
		    # render 'edit'
		    flash[:error]="Error occured, please contact administrator"
		    redirect_to :action=>'index',:params=>{:mg_event_id=>params[:guests][:mg_event_id]}
			

		  end
		end

		def destroy

		end

		def delete
			@guests=MgGuest.find_by_id(params[:id])
			@guests.is_deleted =1
			@guests.save
		  	redirect_to guests_path
		end
		def guest_participation
			@events=[]
			mg_school_id=session[:current_user_school_id]
			@event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name, :id )

			# @events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck( :title, :id)
		  	#.paginate(page: params[:page], per_page: 10)

		  	params[:mg_event_id]=params[:mg_event_id]
			if params[:mg_event_id].present?
				events=MgEvent.find_by(:is_deleted=>0,:mg_school_id=>mg_school_id, :id=>params[:mg_event_id])
				params[:mg_event_committee_id]=events.mg_event_committee_id
				@events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>events.mg_event_committee_id).pluck(:title, :id)
			end
			
		end

		
		def guests_list
			@mg_event_id=params[:id]
			mg_school_id=session[:current_user_school_id]
			@guests = MgGuest.where(:is_deleted => 0, :mg_school_id=>mg_school_id, :mg_event_id=>params[:id])
			@all_guest=MgGuest.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_id=>params[:id]).pluck(:id)

			render :layout => false
		end
		def save_attended_guests

			# "mg_event_id"=>"2", "mg_guest_id"=>["1"]
			mg_school_id=session[:current_user_school_id]
			all_guest=MgGuest.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_id=>params[:mg_event_id])
			all_guest.each do |g|
				g.update(:status=>'not_attend')
			end
			
			if params[:mg_guest_id].present?
				for i in 0...params[:mg_guest_id].size
					present_guest=MgGuest.find_by(:id=> params[:mg_guest_id][i],:mg_school_id=>mg_school_id, :mg_event_id=>params[:mg_event_id])
					if present_guest.present?
						present_guest.is_deleted=0
						present_guest.status='will_attend'
						present_guest.save
					# else
					# 	present_guest.is_deleted=0
					# 	present_guest.status='will_attend'
					# 	present_guest.save
						# MgGuest.create(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_id=>params[:mg_event_id], :status=>'will_attend')
					end
				end
			end
			flash[:notice]="Guests participation updated successfully"
			redirect_to :action=>'guest_participation', :params=>{:mg_event_id=>params[:mg_event_id]}
		end

	def event_list
		
		mg_school_id=session[:current_user_school_id]
		@events=MgEvent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_event_committee_id=>params[:id])#.pluck( :title, :id)
		# render :layout => false
		respond_to do |format|
	        format.json  { render :json => @events }
	    end
	end

	def guests_for_event
		@mg_event_id=params[:id]
			@guests = MgGuest.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id], :mg_event_id=>params[:id])#.paginate(page: params[:page], per_page: 10)
		 render :layout => false
		
	end

  private
  def guests_params
    params.require(:guests).permit(:mg_event_id, :guest_name, :guest_details,:mobile_no, :email_id, :status, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end
end



 # MgGuest  guest_name:string  guest_details:string 
 # mobile_no:integer  email_id:string  status:string