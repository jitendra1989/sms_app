class SettingsController < ApplicationController
    before_filter :login_required
#com

  layout 'mindcom'

  def index
    @school = MgSchool.find(session[:current_user_school_id])
    #.pluck(:currency_type,:language ,:grading_system, :date_format,:timezone )
    
  end

  def new
  	@user = User.new
  end

  def show

  end

  def edit
    @school = MgSchool.find(session[:current_user_school_id])
   render :layout => false
    
  end
  def update
    @school = MgSchool.find(params[:id])
    @school.update(school_params)

  puts "step one"
  puts school_params.inspect

  redirect_to :action =>'index'
    
  end
  
  def role_dashboard
  end

  private 
  def school_params
    params.require(:school).permit(:date_format,:timezone,:currency_type,:grading_system,:language)
    
  end




end
