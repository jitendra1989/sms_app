class WingsController < ApplicationController

	before_filter :login_required
    layout "mindcom"

  def index
  	@wings = MgWing.where(:is_deleted => '0', :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def create
    @wings=MgWing.new(wing_params)
    @wings.save
  puts "ccccccccllllllllllllaaaaaass showwwwwwwwwwww"
    redirect_to :action => "index"
    
  end 

  def wing_edit
      @wings = MgWing.find(params[:id])
  end

  def wing_delete
    @wings = MgWing.find(params[:id])
      puts params[:id]
       @wings.update(:is_deleted => 1)
       redirect_to :action => "index"
      

  end

  def new
    
    
  end

  def wing_update
    @wings = MgWing.find(params[:id])
     
      if @wings.update(wing_params)
        redirect_to :controller => "wings" , :action => "index"
      end
  end

  def show

  end


  private
   def wing_params
     params.require(:wings).permit(:wing_name, :status, :created_by, :updated_by, :is_deleted, :mg_school_id)
   end


end
