class SessionsController < ApplicationController
 #   before_filter :login_required

 #com
  def index

    session[:user_type]=""
    # school_name=request.subdomain
    # school_name=school_name[0...school_name.index(".")]
    # @school=MgSchool.find_by(:is_deleted=>0,:subdomain=>school_name)
    @school=MgSchool.find_by(:is_deleted=>0)
    # puts "subdoman===="
    # puts request.subdomain
    session[:current_user_school_id]=@school.id

    
    # session[:user_type]=""
    # school_name=request.subdomain
    # school_name=school_name[0...school_name.index(".")]
    # @school=MgSchool.find_by(:is_deleted=>0,:subdomain=>school_name)
    # @school=MgSchool.find_by(:is_deleted=>0,:id=>1)
    # puts "subdoman===="
    # puts request.subdomain
    # session[:current_user_school_id]=@school.try(:id)

    # puts 'session[:current_user_school_id]'
    # puts session[:current_user_school_id]
    # puts request.subdomain.inspect
    #logger.ijjd
  end

  def dashboard
    logger.info "--dashboard--"
    logger.info @ModelData.model_name
  end

  def create
    puts "I am herre............."

    puts params[:user_name]

    puts "I am till herre............."
    deleted= MgUser.where(:user_name=>params[:user_name]).pluck(:is_deleted)
    puts "deleted"
    puts deleted
    #user = MgUser.authenticateUsers(params[:user_name], params[:password], session[:current_user_school_id],deleted[0])  
    #Added By Bindhu
    user = MgUser.authenticateUsersWithSchool(params[:user_name], params[:password],deleted[0], session[:current_user_school_id])  
    if user
       puts "inside if   for cloud admin"
       # @school=MgSchool.find(1)
       @school=MgSchool.find(session[:current_user_school_id])

      ###########   start   for cloud admin ############
        if (user.user_type.to_s.eql? "cloudadmin")
       session[:current_user_school_id] = user.mg_school_id
      puts "step >----------------->> 1 inside if condition"

             @user_type = user.user_type #MgUser.find(user.id)
     
       session[:user_type] = @user_type

             @sql = "SELECT P.id, P.mg_model_id, P.mg_action_id,  M.model_name
                FROM mg_permissions P, 
                     mg_users U,
                     mg_user_roles UR, 
                     mg_roles R,
                     mg_roles_permissions RP,
                     mg_models M
                WHERE U.id = UR.mg_user_id 
                  AND U.mg_school_id=#{session[:current_user_school_id]}
                  AND R.id = RP.mg_role_id 
                  AND RP.mg_permission_id = P.id
                  AND P.mg_model_id = M.id 
                  AND U.id = #{user.id}
                  AND RP.mg_school_id = #{user.mg_school_id}
                 ORDER BY  M.index" 
  # AND UR.mg_role_id = R.id 
                  @Pquery=MgPermission.find_by_sql(@sql)

                 arrData = Array.new
                 arr = @Pquery

                 puts "Step -- 1 in login"
                 puts arr.inspect
                 # Iterating array
                  arr.each { |a| 
                    # Generating hash
                    roleData = Hash.new 
                    roleData["model_id"] = a.mg_model_id 
                    roleData["action_id"] = a.mg_action_id 
                    roleData["model_name"] = a.model_name
                    #Pushing in array
                    arrData.push(roleData)

                  }

                   if arrData.length > 0 
                  # pushing in session our data array
                    session[:roles_permissions_data] = arrData
                    puts "-------------------------------------------------------------------"
                    puts session[:roles_permissions_data].inspect
                    puts "-------------------------------------------------------------------"



                   $roles_permissions_data_global_var = arrData



                   session[:user_id] = user.id

                   #redirect_to :controller => 'dashboards/cloud_admin'
                   #host=@school.subdomain<<"."<<"vcap.me"
                   #redirect_to :host => host, :controller => 'dashboards', :action => 'cloud_admin'
                   redirect_to :controller => 'dashboards', :action => 'cloud_admin'
                   #redirect_to  url_for(:controller => "dashboards", :action => "cloud_admin",:subdomain => @school.subdomain)

                 end

        else
          puts "inside else for cloud admin"
          if (user.mg_school_id != nil)
            session[:current_user_school_id] = user.mg_school_id
                 $current_user_school_id = user.mg_school_id

         
      ###########   end  for cloud admin ############





       @user_type = user.user_type #MgUser.find(user.id)
     
       session[:user_type] = @user_type
        #//pluck(:name)
      #@sql = "select A.id, A.mg_model_id, A.mg_action_id from mg_permissions A,mg_users B,mg_user_roles C, mg_roles D,mg_roles_permissions E Where B.id = C.mg_user_id AND C.mg_role_id = D.id AND D.id = E.mg_role_id AND E.mg_permission_id = A.id AND B.id = #{user.id} "

      @sql = "SELECT P.id, P.mg_model_id, P.mg_action_id ,M.model_name
                FROM mg_permissions P, 
                     mg_users U,
                     mg_user_roles UR, 
                     mg_roles R,
                     mg_roles_permissions RP,
                     mg_models M
                WHERE U.id = UR.mg_user_id 
                  AND U.mg_school_id=#{session[:current_user_school_id]}
                  AND UR.mg_role_id = R.id 
                  AND R.id = RP.mg_role_id 
                  AND RP.mg_permission_id = P.id
                  AND P.mg_model_id = M.id 
                  AND U.id = #{user.id}
                  AND RP.mg_school_id = #{user.mg_school_id}
                 ORDER BY  M.index"
  
     # @sql = "select G.model_name, F.action_name,  A.id, A.model_id, A.action_id from permissions A,users B,user_roles C, roles D,roles_permissions E, actions F , models G Where B.id = C.user_id AND C.role_id = D.id AND D.id = E.role_id AND E.permission_id = A.id  AND A.action_id = F.id AND A.model_id = G.id AND B.id =#{@user.id}"
    

     @Pquery=MgPermission.find_by_sql(@sql)

     arrData = Array.new
     arr = @Pquery

     puts "Step -- 1 in login"
     puts arr.inspect
     # Iterating array
      arr.each { |a| 
        # Generating hash
        roleData = Hash.new 
        roleData["model_id"] = a.mg_model_id 
        roleData["action_id"] = a.mg_action_id
         roleData["model_name"] = a.model_name
        #Pushing in array
        arrData.push(roleData)

      }
      puts arrData.length
      puts "Step -- 2 "
          # if User have Access to our model
          if arrData.length > 0 
          # pushing in session our data array
            session[:roles_permissions_data] = arrData
           $roles_permissions_data_global_var = arrData



           session[:user_id] = user.id
          #render "dashboard"
           puts "Step -- 1"
           puts @user_type
           puts "Step -- 1"
           if @user_type == "guardian" 
            #Added By Bindhu Start
            login_guardian=MgGuardian.where(:mg_user_id=>session[:user_id])
            login_access=MgStudentGuardian.where(:mg_guardians_id=>login_guardian[0].id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            puts "Login Guardian"
            puts login_guardian.inspect


            puts "Login Access"
            puts login_access.inspect
            @tmp=0
            login_access.each do |guardian|
              if(guardian.has_login_access)
                @tmp=1
              end
            end
            puts "temp"
            puts @tmp

            if(@tmp==1)
              redirect_to :controller => 'dashboards/guardian'
            else
              # flash.now.alert = "You doesn't have the login access please contact your admin"
              flash[:notice] = "You doesn't have the login access please contact your admin"
              redirect_to root_url
            end
            #Added By Bindhu End
           elsif  @user_type == "principal"
              redirect_to :controller => 'dashboards/principal'
           elsif @user_type == 'student'
              redirect_to :controller => 'dashboards/student'
             # redirect_to :controller => '/attendances/student/'
             

           elsif @user_type == 'employee'
             redirect_to :controller => 'dashboards/employee'


             elsif @user_type == 'kiosk'
             redirect_to :controller => 'library/search_reserve_books_index'

             elsif @user_type == 'front_office_manager'
             redirect_to :controller => 'front_office_management/user_detail'

           #Bindhu Added for store_manager login starts  
          elsif @user_type == 'store_manager'
             redirect_to :controller => 'inventory/store_information'
           #Bindhu Added for store_manager login ends 

          #Bindhu Added for Accounts login starts  
           elsif @user_type == 'central_account_incharge'
             redirect_to :controller => 'accounts/account_index'
           
           elsif @user_type == 'central_account_assistant_incharge'
             redirect_to :controller => '/accounts/transfer'

          elsif @user_type == 'Alumni'
            #puts ajgsdfga
            redirect_to :controller => '/alumni/alumni_login'


           elsif @user_type == 'account_incharge'
             redirect_to :controller => '/accounts/accounts_review'
          #Bindhu Added for Accounts login starts  

           #Added By Jitendra for finance manager login start
           elsif @user_type == 'financial_manager'
             redirect_to :controller => 'inventory/proposal_review'
             #Added By Jitendra for finance manager login end

           elsif @user_type == 'cloudadmin'
              redirect_to :controller => 'dashboards/cloud_admin'

           elsif  @user_type == "superprincipal"
              redirect_to :controller => 'dashboards/principal'
           elsif  @user_type == "healthcare_admin"
              redirect_to :controller => 'healthcare'
              
          # Added By Bindhu for doctor login starts
           elsif  @user_type == "doctor"
              redirect_to :controller => 'healthcare/health_test'
           # Added By Bindhu for doctor login ends
           elsif  @user_type == "sports_incharge"
             # puts ahsdjkad
              redirect_to :controller => 'sports_management/game'
			elsif  @user_type == "hostel_admin"
             # puts ahsdjkad
              redirect_to :controller => 'hostel_management/hostel_application_list'
			elsif @user_type=="hostel_warden"
              redirect_to :controller => 'hostel_management/room_type'
      	   elsif  @user_type == "canteen_manager"
              redirect_to :controller => '/canteen_managements/meal_category'
           else
              #redirect_to :controller => 'dashboards'
              #redirect_to :controller => 'schools'#Shravan
              redirect_to :controller => 'master_settings'#Bindhu

           end  
        # else user don't have any permission
         else
          flash.now.alert = "Please contact your admin for give you access to use website!"
          redirect_to root_url
        end

      # If school id not assigned redirect here
       else
            flash.now.alert = "School is not assign to you. Please contact admin!"
            flash[:notice] = "School is not assign to you. Please contact admin!"
            redirect_to root_url
          end
        end

    else
      flash.now.alert = "Invalid username or password"
       flash[:notice] = "Invalid User Name or Password"
      redirect_to root_url
    end
    
  end
  # Log out work in destroy action it would be delete session
  def destroy
     session[:user_id] = nil
     session[:roles_permissions_data] = nil
     session[:current_user_school_id] = nil
     #render 'index'
     redirect_to root_url, :notice => "Logged out!"
  end

  def forgot_password
      logger.info "sessions_forgot_password step -- 11"

     user = MgUser.find_by(email: email_params[:email] )


     if user
         session[:update_password_for_user_id] = user.id
        respond_to do |format|
            format.js {}
        end
    else
      render plain: params[:sessions].inspect
      # your email address is not valid
      render plain: email_params
      
    end
  end

  def update_password
    @user = MgUser.find(session[:update_password_for_user_id])

    if @user
       @user.update(password_params)
       respond_to do |format|
            format.js {}
        end
    end  
    
  end
  def change_school
   
   puts params[:principal][:mg_school_id]
    school=MgSchool.find( params[:principal][:mg_school_id])
   
    session[:current_user_school_id]=school.id

    #host=school.subdomain<<"."<<"vcap.me"
    #redirect_to :host => host, :controller => 'dashboards', :action => 'principal'
    redirect_to :controller => 'dashboards', :action => 'principal'
    # redirect_to :controller=>'dashboards', :action=>'principle'#, :subdomain=>'ksd'

    #redirect_to  url_for(:controller => "dashboards", :action => "principal",:subdomain => school.subdomain)

# url_for(:controller => "da_controller", 
#   :action => "cool_feature", 
#   :subdomain => "admin") 
# redirect_to root_url(:host => "subdomain" + '.' + request.domain + request.port_string, :controller=>"principle")

  end

  def write_action
    controller_list = Array.new
    Dir["app/controllers/*.rb"].each do |file|
        #controller_list.push({"#{file.split('/').last.sub!('_controller.rb','')}"=>"dd"})
        if file.split('/').last.sub!('_controller.rb','').present?
          
          #controller_list.push({"#{file.split('/').last.sub!('_controller.rb','')}"=> file.split('/').last.sub!('.rb','').split('_').map(&:strip).map(&:capitalize).join('').constantize.action_methods.collect{|a| a.to_s}.join(', ')  })
          controller_list+= file.split('/').last.sub!('.rb','').split('_').map(&:strip).map(&:capitalize).join('').constantize.action_methods.collect{|a| a.to_s}.join(',').split(',')  
          
        end

    end

    # str = "[80, 75, 3, 4, 10, 0, 0, 0, 0, 0, -74, 121, 57, 64, 0, 0, 0, 0]"
    #   int_array = str.gsub('[', '').gsub(']', '').split(', ').collect{|i| i.to_i}
    File.open(File.join(Rails.root, "public", "file.txt"), "wb") do |file|
      file.write(controller_list.uniq.to_json.to_s)
    end
    puts "controller_list---------->   #{controller_list.size}"
    # controller_list.uniq.each do |s|
    #   MgAction.create(:action_name=>s)
    # end
    
  end

  private

  def email_params
    params.require(:sessions).permit( :email)
  end

  def password_params
    params.require(:sessions).permit( :password)
    
  end

end


