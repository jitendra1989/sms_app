class EventTypesController < ApplicationController

		layout "mindcom"
		before_filter :login_required

        def new 
			@event_types=MgEventType.new()
			render :layout => false


		end
	
		def index
	
		  	@event_types = MgEventType.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
	 		# render :layout => false


		end

		def create
			puts "test ---1"
			puts event_types_params.inspect
			puts "test ---1"
			
		  	@event_types=MgEventType.new(event_types_params)
			  	if @event_types.save
			    redirect_to :action => "index"
			  	else
			    render 'new'
			  	end
		end

		def show
		  	@event_types = MgEventType.find(params[:id])
		  	render :layout => false

		  	
		end

	  	def edit
	 	@event_types = MgEventType.find(params[:id])
	 	render :layout => false

		end

		def update
		  @event_types = MgEventType.find(params[:id])
		 
		  if @event_types.update(event_types_params)
		    redirect_to :back
		  else
		    render 'edit'
		  end
		end

		def destroy

		end

		def delete
			@event_types=MgEventType.find_by_id(params[:id])
			@event_types.is_deleted =1
			@event_types.save
		  	redirect_to event_types_path
		end

  private
  def event_types_params
    params.require(:event_types).permit(:name, :event_color, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end
end
