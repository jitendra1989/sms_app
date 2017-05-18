class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # com
  protect_from_forgery with: :exception
  
  # Work for locale lang
  before_filter :set_locale
  # before_filter :check_subdomain

	def set_locale
	  I18n.locale = params[:locale] if params[:locale].present?
	end



  def login_required

    if session[:user_id].present? && MgUser.find_by(:id=>session[:user_id], :is_deleted=>0).try(:mg_school_id).to_s==session[:current_user_school_id].to_s# || MgSchool.find_by(:is_deleted=>0,:subdomain=>request.subdomain).try(:id).to_s==MgUser.find_by(:is_deleted=>0, :id=>session[:user_id]).try(:mg_school_id).to_s
       #session[:back_url] = request.url
      
      set_mailer_settings
    else
	   redirect_to root_url
    end
  end

  def check_subdomain
    school_name=request.subdomain
    if school_name.present?
      if school_name.present? && school_name.split(".").size>=2
        school_name=school_name[0...school_name.index(".")]
        school=MgSchool.find_by(:is_deleted=>0,:subdomain=>school_name)#,:id=>session[:current_user_school_id])
        # user=MgUser.find_by(:is_deleted=>0,:id=>session[:user_id].present? session[:user_id] : nil )
        if school.present? 
            #if MgUser.find_by(:id=>session[:user_id], :is_deleted=>0).try(:mg_school_id)==school.try(:id)
              session[:current_user_school_id]=school.id
            #else
              #render_404
            #end
          #logger.ood
        else
          render_error_page1
        end
      else
        render_error_page1
      end
    else
      render_error_page1
    end

  end


  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => '404' }
      #format.xml  { head :not_found }
      #format.any  { head :not_found }
    end
  end

  def render_error_page
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/error_page", :layout => false, :status => '404' }
      #format.xml  { head :not_found }
      #format.any  { head :not_found }
    end
  end

  def render_error_page1
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/error_page1", :layout => false, :status => '404' }
      #format.xml  { head :not_found }
      #format.any  { head :not_found }
    end
  end

  # def default_url_options
  #   if Rails.env.development?

  #     {:host => "local.in"}
  #   else
  #     {}
  #   end
  # end

   def set_mailer_settings
    puts "----------------------------------------------------------------------------  start -----"
 #    ActionMailer::Base.smtp_settings = {
            # :address  =>"smtp.gmail.com",
           #:port  => 587,
          #   :domain =>  'localhost',
         #    :authentication => :plain,
        #     :user_name => xxxxxxxx@gmail.com',
       #      :password => 'xxxxxxxxxxx',
      #     :return_response => true
     #  }
    # ActionMailer::Base.delivery_method = :smtp

# require 'openssl'
 #  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
       ActionMailer::Base.smtp_settings = {
            :address  =>'103.21.59.24',
          :port  => 25,
            :domain => '180.92.169.25',
            #:authentication => :plain,
            :user_name => 'dharaniks@mindcomgroup.com',
            :password => 'Da070#90',
          :return_response => true,
                :openssl_verify_mode  => 'none'
            }
          ActionMailer::Base.delivery_method = :smtp
    puts "----------------------------------------------------------------------------  end -------"

  end



end
  
