
Rails.application.routes.draw do

  # ===================================================================?
 get 'accounts/central_receivable_excel_report'=>'accounts#central_receivable_excel_report'
  get 'inventory/gate_pass_excel'=>'inventory#gate_pass_excel'
  get 'inventory/inventory_proposal_show_item'=>'inventory#inventory_proposal_show_item'
  get 'admission_managements/student_fee_particulars'
  # ===================================================================?

   get 'hostel_management/students_particular_hostel_details'
    get 'hostel_management/rejected_reason'
    get 'hostel_management/hostel_issues_list'=>'hostel_management#hostel_issues_list'
    get 'hostel_management/hostel_admin_complain_hostel_show'=>'hostel_management#hostel_admin_complain_hostel_show'
        get 'hostel_management/filter_hostel_data'=>'hostel_management#filter_hostel_data'


   get 'hostel_management/complain_hostel_new'=>'hostel_management#complain_hostel_new'
   get 'hostel_management/complain_hostel_index'=>'hostel_management#complain_hostel_index'
   post 'hostel_management/complain_hostel_create'=>'hostel_management#complain_hostel_create'
get 'hostel_management/complain_hostel_edit/:id'=>'hostel_management#complain_hostel_edit'
  get 'hostel_management/complain_hostel_show/:id'=>'hostel_management#complain_hostel_show'
  get 'hostel_management/complain_hostel_delete/:id'=>'hostel_management#complain_hostel_delete'
   patch 'hostel_management/:id/complain_hostel_update'=>'hostel_management#complain_hostel_update'

   get 'hostel_management/hostel_complaint'=>'hostel_management#hostel_complaint'
   get 'hostel_management/:id/hostel_complaint_show'=>'hostel_management#hostel_complaint_show'
      #===========Pranav End=======================
        get 'hostel_management/student_hostel_reject'


        get 'hostel_management/hostel_application_form_index'
        get 'hostel_management/hostel_application_form'
        get 'hostel_management/hostel_application_form_create'=>'hostel_management#hostel_application_form_create',as: :hostel_application_form_create
                get 'hostel_management/allocate_rooms_create'
              
                get 'hostel_management/hostel_application_list'
                get 'hostel_management/select_programme_data'
                get 'hostel_management/select_student_list_data'
                get 'hostel_management/allocate_rooms'
                get 'hostel_management/allocate_rooms_new'
                get 'hostel_management/allocate_rooms_student_lists'
                get 'hostel_management/manage_central_data'
                get 'hostel_management/room_reallotment_request'

                get 'hostel_management/room_reallotment_form'
                get 'hostel_management/room_reallotment_create'=>'hostel_management#room_reallotment_create',as: :room_reallotment_create

  get 'hostel_management/room_reallotment_update/:id'=>'hostel_management#room_reallotment_update',as: :room_reallotment_update
                get 'hostel_management/warden_re_allocate_rooms'

                get 'hostel_management/reallocation_show'
                get 'hostel_management/room_reallotment_request_update'
                get 'hostel_management/discipline_report'
                get 'hostel_management/discipline_report_new'
                
                get 'hostel_management/discipline_report_ajax'
  
                
                get 'hostel_management/discipline_report_create'
                get 'hostel_management/disciplanary_report_show/:id'=>'hostel_management#disciplanary_report_show',as: :disciplanary_report_show

                  get 'hostel_management/disciplanary_report_edit/:id'=>'hostel_management#disciplanary_report_edit',as: :disciplanary_report_edit
              
                       get 'hostel_management/discipline_report_update'
         

                  get 'hostel_management/discipline_report_destroy/:id'=>'hostel_management#discipline_report_destroy',as: :discipline_report_destroy

        get 'hostel_management/select_student_list_data_create'=>'hostel_management#select_student_list_data_create',as: :select_student_list_data_create
        get 'hostel_management/select_student_rejected_list_data_create'=>'hostel_management#select_student_rejected_list_data_create',as: :select_student_rejected_list_data_create
                

        get 'hostel_management/discipline_report_admin'
        get 'hostel_management/discipline_report_admin_show'
        get 'hostel_management/discipline_report_admin_update'
        


      get 'hostel_management/warden_edit_user/:id'=>'hostel_management#warden_edit_user',as: :warden_edit_user
     get 'hostel_management/warden_update_user/:id'=>'hostel_management#warden_update_user',as: :warden_update_user

    get 'hostel_management/hostel_warden_login_index'
    get 'hostel_management/new_hostel_warden_user'
    get 'hostel_management/select_employee'
    get 'hostel_management/hostel_warden_login_create'=>'hostel_management#hostel_warden_login_create',as: :hostel_warden_login_create
    

        get 'hostel_management/room_reallotment_request'
        get 'hostel_management/students_attendance'
        get 'hostel_management/hostler_student_list'
        get 'hostel_management/update_attendance'=>'hostel_management#update_attendance',as: :update_attendance
        patch 'hostel_management/delete_attendance'=>'hostel_management#delete_attendance',as: :delete_attendance
        
        get 'hostel_management/:id/edit_attendance'=>'hostel_management#edit_attendance'

        get 'hostel_management/hostler_student_list'
        get 'hostel_management/hosteler_leave' =>'hostel_management#hosteler_leave',as: :hosteler_leave
        get 'hostel_management/hosteler_leave_list' =>'hostel_management#hosteler_leave_list',as: :hosteler_leave_list
        get 'hostel_management/attendance_report'
        get 'hostel_management/leave_report'   

    # get 'hostel_management/hostel_warden_login_index'
    # get 'hostel_management/hostel_warden_login_index'
    

  get 'hostel_management/hostel_admin_login_index'
  get 'hostel_management/hostel_admin_login_edit'
  get 'hostel_management/hostel_admin_login_update'
  get 'hostel_management/hostel_admin_login_new'
  post 'hostel_management/hostel_admin_login_create'=>'hostel_management#hostel_admin_login_create',as: :hostel_admin_login_create
  get 'hostel_management/hostel_admin_login_show'
  get 'hostel_management/hostel_admin_login_destroy'
  get 'hostel_management/new_user'
  get 'hostel_management/user_change_password'=>'hostel_management#user_change_password',as: :user_change_password_data

  get 'hostel_management/change_password/:id'=>'hostel_management#change_password',as: :change_password_data
  get 'hostel_management/edit_user/:id'=>'hostel_management#edit_user',as: :edit_user_data

     get 'hostel_management/update_user_data/:id'=>'hostel_management#update_user_data',as: :update_user_data
     delete 'hostel_management/delete_user/:id'=>'hostel_management#delete_user',as: :delete_user_data


#hostel management added by balaji
    get 'hostel_management/hostel_details'=> 'hostel_management#hostel_details'
    get 'hostel_management/hostel_details_new'=> 'hostel_management#hostel_details_new'



    get 'hostel_management/:id/hostel_details_delete'=> 'hostel_management#hostel_details_delete'
    post 'hostel_management/:id/hostel_details_update'=> 'hostel_management#hostel_details_update'

    get 'hostel_management/room_type'=>'hostel_management#room_type'
    get 'hostel_management/room_type_new'=>'hostel_management#room_type_new'

    get 'hostel_management/:id/room_type_edit'=>'hostel_management#room_type_edit'
    post 'hostel_management/:id/room_type_update'=> 'hostel_management#room_type_update'
    get 'hostel_management/:id/room_type_delete'=> 'hostel_management#room_type_delete'
    get 'hostel_management/:id/room_type_show'=>'hostel_management#room_type_show'

    get 'hostel_management/hostel_floor'=>'hostel_management#hostel_floor'
    get 'hostel_management/hostel_floor_new'=>'hostel_management#hostel_floor_new'
    get 'hostel_management/:id/hostel_floor_edit'=>'hostel_management#hostel_floor_edit'
    post 'hostel_management/:id/hostel_floor_update'=> 'hostel_management#hostel_floor_update'
    get 'hostel_management/:id/hostel_floor_delete'=> 'hostel_management#hostel_floor_delete'
    get 'hostel_management/:id/hostel_floor_show'=>'hostel_management#hostel_floor_show'

    get 'hostel_management/hostel_rooms'=>'hostel_management#hostel_rooms'
    get 'hostel_management/hostel_rooms_new'=>'hostel_management#hostel_rooms_new'
    get 'hostel_management/hostel_rooms_admin'=>'hostel_management#hostel_rooms_admin'
    get 'hostel_management/:id/hostel_rooms_admin_show'=>'hostel_management#hostel_rooms_admin_show'
    


    get 'hostel_management/:id/room_type_capacity'=>"hostel_management#room_type_capacity"
    get 'hostel_management/:id/hostel_rooms_show'=>"hostel_management#hostel_rooms_show"
    post 'hostel_management/:id/hostel_rooms_update'=>"hostel_management#hostel_rooms_update"

    get 'hostel_management/health_management_admin'
    get 'hostel_management/health_management_admin_show'=>'hostel_management#health_management_admin_show'
    
  #fees

    get 'hostel_management/hostel_fee_category'
    get 'hostel_management/hostel_fee_category_new'
    get 'hostel_management/hostel_fee_category_create'
    get 'hostel_management/transport_fee_category_show'
    get 'hostel_management/hostel_fee_category_edit'
    get 'hostel_management/hostel_fee_category_update'
    get 'hostel_management/delete_transport_fee_category'

    get 'hostel_management/manage_hostel_particulars'
    get 'hostel_management/manage_hostel_particulars_new'
    get 'hostel_management/manage_hostel_particulars_create'
    get 'hostel_management/hostel_edit_fee_particular'
    get 'hostel_management/hostel_update_fee_particular'
    get 'hostel_management/hostel_destroy_fee_particular'

    get 'hostel_management/hostel_fee_schedule'
    get 'hostel_management/hostel_delete_fee_schedule'

    get 'hostel_management/going_out_provision'=>"hostel_management#going_out_provision"
    get 'hostel_management/going_out_provision_new'=>"hostel_management#going_out_provision_new"
    get 'hostel_management/:id/going_out_provision_edit'=>'hostel_management#going_out_provision_edit'
    post 'hostel_management/:id/going_out_provision_update'=> 'hostel_management#going_out_provision_update'
    get 'hostel_management/:id/going_out_provision_show'=>'hostel_management#going_out_provision_show'
    get 'hostel_management/:id/going_out_provision_delete'=>'hostel_management#going_out_provision_delete'

    get 'hostel_management/going_out_provision_warden'
    get 'hostel_management/going_out_provision_warden_show'=>'hostel_management#going_out_provision_warden_show'
    

    get 'hostel_management/health_management'=>"hostel_management#health_management"
    get 'hostel_management/health_management_new'=>"hostel_management#health_management_new"
    get 'hostel_management/:id/health_management_edit'=>'hostel_management#health_management_edit'
    post 'hostel_management/:id/health_management_update'=> 'hostel_management#health_management_update'
    get 'hostel_management/:id/health_management_show'=>'hostel_management#health_management_show'
    get 'hostel_management/:id/health_management_delete'=>'hostel_management#health_management_delete'
    get 'hostel_management/:id/room_number'=>"hostel_management#room_number"
    get 'hostel_management/:id/student_data'=>"hostel_management#student_data"
    get 'hostel_management/:id/wing_floor_data'=>"hostel_management#wing_floor_data"
    #fees

  get 'sports_management/participant_team_list'=>'sports_management#participant_team_list'



  # get 'hostel_management/placement_head_resetpassword'=> 'placements#placement_head_resetpassword'
  # get 'hostel_management/update_placement_head_resetpassword'=> 'placements#update_placement_head_resetpassword'
  # get 'hostel_management/:id/resetpassword'=>"placements#resetpassword"
  # get 'hostel_management/password_search_data' => 'placements#password_search_data'
  # get 'hostel_management/:id/resetpassword_recruit'=>"placements#resetpassword_recruit"
  # get 'hostel_management/:id/resetpassword_corporate'=>"placements#resetpassword_corporate"

  #=============placementlogin============
  get 'placements/edit_user/:id'=>'placements#edit_user',as: :edit_user
  delete 'placements/delete_user/:id'=>'placements#delete_user',as: :delete_user
  get 'placements/change_password/:id'=>'placements#change_password',as: :corporate_change_password
  get 'placements/user_change_password'=>'placements#user_change_password',as: :user_change_password
  #=============placementlogin============
  get 'hostel_management/index'

  get 'hostel_management/new'

  get 'hostel_management/create'

  get 'hostel_management/edit'

  get 'hostel_management/delete'

  get 'hostel_management/show'

  get 'hostel_management/update'


get 'sports_management/bed_availibility_details'=>'sports_management#bed_availibility_details',as: :bed_availibility_details
  get 'sports_management/result_show/:id'=>'sports_management#result_show'

  get 'sports_management/event_list/:id'=>'sports_management#event_list'

  get 'sports_management/event_list_dates/:id'=>'sports_management#event_list_dates'


  get 'sports_management/results'
  get 'sports_management/results_new'

  get 'sports_management/result_update'

  get 'sports_management/:id/result_delete'=>'sports_management#result_delete'

  get 'sports_management/results_edit/:id'=>'sports_management#results_edit'

  get 'sports_management/add_student_to_result'

  get 'sports_management/result_sem_data'

  get 'sports_management/result_section_students'

  get 'sports_management/add_employee_to_result'

  get 'sports_management/result_emp_data'

  get 'sports_management/result_create'

  get 'sports_management/show_fine_fee_particular'

  get 'sports_management/edit_fine_fee_particular'


  get 'sports_management/destroy_fee_fine_particular/:id'=>'sports_management#destroy_fee_fine_particular'
  get 'sports_management/update_fee_fine_particular/:id'=>'sports_management#update_fee_fine_particular'

  get 'sports_management/payroll_deduction_index'=>'sports_management#payroll_deduction_index'
get 'sports_management/payroll_deduction_new'=>'sports_management#payroll_deduction_new'
post 'sports_management/payroll_deduction_create'=>'sports_management#payroll_deduction_create'
get 'sports_management/:id/payroll_deduction_edit'=>'sports_management#payroll_deduction_edit'
post 'sports_management/:id/payroll_deduction_update'=>'sports_management#payroll_deduction_update'
get 'sports_management/payroll_deduction_show/:id'=>'sports_management#payroll_deduction_show'
get 'sports_management/:id/payroll_deduction_delete'=>'sports_management#payroll_deduction_delete'
get 'sports_management/payroll_deduction_ajax'

get 'sports_management/sports_item_consumption_index'=>'sports_management#sports_item_consumption_index'
get 'sports_management/sports_item_consumption_new'=>'sports_management#sports_item_consumption_new'
post 'sports_management/sports_item_consumption_create'=>'sports_management#sports_item_consumption_create'
get 'sports_management/:id/sports_item_consumption_edit'=>'sports_management#sports_item_consumption_edit'
patch 'sports_management/:id/sports_item_consumption_update'=>'sports_management#sports_item_consumption_update'
get 'sports_management/sports_item_consumption_show/:id'=>'sports_management#sports_item_consumption_show'
get 'sports_management/:id/sports_item_consumption_delete'=>'sports_management#sports_item_consumption_delete'
get 'sports_management/wing_wise_course_list/'=>'sports_management#wing_wise_course_list'
   
get 'sports_management/sports_stock'=>'sports_management#sports_stock'
get 'sports_management/sports_stock_new'=>'sports_management#sports_stock_new'
post 'sports_management/sports_stock_create'=>'sports_management#sports_stock_create'
get 'sports_management/:id/sports_stock_edit'=>'sports_management#sports_stock_edit'
patch 'sports_management/:id/sports_stock_update'=>'sports_management#sports_stock_update'
get 'sports_management/sports_stock_show/:id'=>'sports_management#sports_stock_show'
get 'sports_management/:id/sports_stock_delete'=>'sports_management#sports_stock_delete'
   
get 'sports_management/generate_fine_new'=>'sports_management#generate_fine_new'
post 'sports_management/generate_fine_create'=>'sports_management#generate_fine_create'
get 'sports_management/:id/generate_fine_edit'=>'sports_management#generate_fine_edit'
patch 'sports_management/:id/generate_fine_update'=>'sports_management#generate_fine_update'
get 'sports_management/:id/generate_fine_show'=>'sports_management#generate_fine_create'
get 'sports_management/generate_fine'=>'sports_management#generate_fine'


get 'sports_management/disciplinary_action_new'=>'sports_management#disciplinary_action_new'
post 'sports_management/disciplinary_action_create'=>'sports_management#disciplinary_action_create'
get 'sports_management/:id/disciplinary_action_edit'=>'sports_management#disciplinary_action_edit'
post 'sports_management/:id/disciplinary_action_update'=>'sports_management#disciplinary_action_update'
get 'sports_management/batch_wise_student_list'=>'sports_management#batch_wise_student_list'
  
get 'sports_management/index'

  get 'sports_management/index_corporate_login'=>'sports_management#index_corporate_login'
  get 'sports_management/index_placement_cell_head'=>'sports_management#index_placement_cell_head'
  get 'sports_management/index_recruitment_assistant'=>'sports_management#index_recruitment_assistant'
  get 'sports_management/new_user'=>'sports_management#new_user'
  post 'sports_management/create_user'=>'sports_management#create_user'
  get 'sports_management/edit_user/:id'=>'sports_management#edit_user'
  patch 'sports_management/:id/update_user'=>'sports_management#update_user'
  delete 'sports_management/delete_user/:id'=>'sports_management#delete_user'
  get 'sports_management/change_password/:id'=>'sports_management#change_password'
  get 'sports_management/user_change_password'=>'sports_management#user_change_password'

    get 'sports_management/game'=>'sports_management#game'
    get 'sports_management/game_new'=>'sports_management#game_new'
    get 'sports_management/:id/game_edit'=>'sports_management#game_edit'
    post 'sports_management/:id/game_update'=> 'sports_management#game_update'
    get 'sports_management/:id/game_delete'=> 'sports_management#game_delete'
    get 'sports_management/:id/game_show'=>'sports_management#game_show'
    get 'sports_management/emp_name_data'=>'sports_management#emp_name_data'

    get 'sports_management/bed_availibility'=>'sports_management#bed_availibility'
    get 'sports_management/bed_assigned_record'=>'sports_management#bed_assigned_record'
    get 'sports_management/assign_bed'=>'sports_management#assign_bed'
    get 'sports_management/new_assign_bed'=>'sports_management#new_assign_bed'
    post 'sports_management/create_assign_bed'=>'sports_management#create_assign_bed'
    get 'sports_management/show_assign_bed'=>'sports_management#show_assign_bed'
    get 'sports_management/edit_assign_bed'=>'sports_management#edit_assign_bed'
    patch 'sports_management/update_assign_bed'=>'sports_management#update_assign_bed'
    get 'sports_management/delete_assign_bed'=>'sports_management#delete_assign_bed'
    
    get 'sports_management/bed_details'=>'sports_management#bed_details'
    get 'sports_management/bed_details_new'=>'sports_management#bed_details_new'
    post 'sports_management/bed_details_create'=>'sports_management#bed_details_create'
    get 'sports_management/bed_details_show'=>'sports_management#bed_details_show'
    get 'sports_management/bed_details_edit'=>'sports_management#bed_details_edit'
    patch 'sports_management/bed_details_update'=>'sports_management#bed_details_update'
    get 'sports_management/bed_details_delete/:id'=>'sports_management#bed_details_delete'


    get 'sports_management/game_data'=>'sports_management#game_data'
    get 'sports_management/add_student_to_commitee'=>'sports_management#add_student_to_commitee'
    get 'sports_management/sem_data'=>'sports_management#sem_data'
    get 'sports_management/sect_data'=>'sports_management#sect_data'
    get 'sports_management/section_students'=>'sports_management#section_students'
    get 'sports_management/add_employee_to_team'=>'sports_management#add_employee_to_team'
    get 'sports_management/dept_data'=>'sports_management#dept_data'

    get 'sports_management/team'=>'sports_management#team'
    get 'sports_management/team_new'=>'sports_management#team_new'
    get 'sports_management/:id/team_edit'=>'sports_management#team_edit'
    post 'sports_management/:id/team_update'=> 'sports_management#team_update'
    get 'sports_management/:id/team_delete'=> 'sports_management#team_delete'
    get 'sports_management/:id/team_show'=>'sports_management#team_show'
    get 'sports_management/emp_data/:id'=>'sports_management#emp_data'
    get 'sports_management/schedule'=>'sports_management#schedule'
    get 'sports_management/schedule_new'=>'sports_management#schedule_new'
    get 'sports_management/:id/schedule_edit'=>'sports_management#schedule_edit'
    post 'sports_management/:id/schedule_update'=> 'sports_management#schedule_update'
    get 'sports_management/:id/schedule_delete'=> 'sports_management#schedule_delete'
    get 'sports_management/:id/schedule_show'=>'sports_management#schedule_show'


  get 'canteen_managements/balance_paid_history'=>'canteen_managements#balance_paid_history',as: :balance_paid_history
  get 'canteen_managements/search_student_employee_details'=>'canteen_managements#search_student_employee_details',as: :search_student_employee_details
  get 'canteen_managements/bill_detail_pdf'=>'canteen_managements#bill_detail_pdf',as: :bill_detail_pdf
  get 'canteen_managements/show_balance_details'=>'canteen_managements#show_balance_details',as: :show_balance_details
  get 'canteen_managements/show_particular_balance_details'=>'canteen_managements#show_particular_balance_details',as: :show_particular_balance_details
  get 'canteen_managements/show_particular_search_balance_details'=>'canteen_managements#show_particular_search_balance_details',as: :show_particular_search_balance_details



  get 'canteen_managements/balance_details'=>'canteen_managements#balance_details',as: :balance_details
  get 'canteen_managements/balance_amount'=>'canteen_managements#balance_amount',as: :balance_amount
  get 'canteen_managements/pay_balance_amount'=>'canteen_managements#pay_balance_amount',as: :pay_balance_amount
  patch 'canteen_managements/update_balance_amount'=>'canteen_managements#update_balance_amount',as: :update_balance_amount
  get 'canteen_managements/show_bill_history'=>'canteen_managements#show_bill_history',as: :show_bill_history
  get 'canteen_managements/show_all_bill_history'=>'canteen_managements#show_all_bill_history',as: :show_all_bill_history
  get 'canteen_managements/total_price'=>'canteen_managements#total_price',as: :total_price
  get 'canteen_managements/employee_details'=>'canteen_managements#employee_details'
  get 'canteen_managements/student_details'=>'canteen_managements#student_details'
  get 'canteen_managements/student_amount_details'=>'canteen_managements#student_amount_details'
  get 'canteen_managements/regular_menu'=>'canteen_managements#regular_menu',as: :regular_menu
  get 'canteen_managements/new_regular_menu'=>'canteen_managements#new_regular_menu',as: :new_regular_menu
  post 'canteen_managements/create_regular_menu'=>'canteen_managements#create_regular_menu',as: :create_regular_menu
  get 'canteen_managements/show_regular_menu'=>'canteen_managements#show_regular_menu',as: :show_regular_menu
  get 'canteen_managements/edit_regular_menu'=>'canteen_managements#edit_regular_menu',as: :edit_regular_menu
  patch 'canteen_managements/update_regular_menu'=>'canteen_managements#update_regular_menu',as: :update_regular_menu
  get 'canteen_managements/delete_regular_menu'=>'canteen_managements#delete_regular_menu',as: :delete_regular_menu

  get 'canteen_managements/bill_detail'=>'canteen_managements#bill_detail',as: :bill_detail
  get 'canteen_managements/new_bill_genereate'=>'canteen_managements#new_bill_genereate',as: :new_bill_genereate
  post 'canteen_managements/create_bill_detail'=>'canteen_managements#create_bill_detail',as: :create_bill_detail
  get 'canteen_managements/show_bill_detail'=>'canteen_managements#show_bill_detail',as: :show_bill_detail
  get 'canteen_managements/:id/edit_bill_detail'=>'canteen_managements#edit_bill_detail',as: :edit_bill_detail
  patch 'canteen_managements/update_bill_detail'=>'canteen_managements#update_bill_detail',as: :update_bill_detail
  get 'canteen_managements/delete_bill_detail'=>'canteen_managements#delete_bill_detail',as: :delete_bill_detail
  get 'canteen_managements/menu' => 'canteen_managements#menu' 
  get 'canteen_managements/new_menu' => 'canteen_managements#new_menu' 
  get 'canteen_managements/edit_menu/:id' => 'canteen_managements#edit_menu'
  get 'canteen_managements/show_menu/:id' => 'canteen_managements#show_menu'
  patch 'canteen_managements/update_menu/:id'=>'canteen_managements#update_menu',as: :canteen_managements_update
  get 'canteen_managements/canteen_manager'=>'canteen_managements#canteen_manager',as: :canteen_manager
  get 'canteen_managements/new_canteen_manager'=>'canteen_managements#new_canteen_manager',as: :new_canteen_manager
  patch 'canteen_managements/:id/update_canteen_manager'=>'canteen_managements#update_canteen_manager',as: :update_canteen_manager
  get 'canteen_managements/change_canteen_manager_password'=>'canteen_managements#change_canteen_manager_password',as: :change_canteen_manager_password

  get 'canteen_managements/account'
       # canteen_managements/account
  get 'canteen_managements/account_new'                                                            
  post 'canteen_managements/account_create' , as: :canteen_managements_account_create
  get 'canteen_managements/account_show'
  post 'canteen_managements/account_edit'
  post 'canteen_managements/account_delete'
  patch 'canteen_managements/account_update/:id'=>'canteen_managements#account_update' , as: :canteen_managements_account_update

  get 'canteen_managements/meal_category'=>'canteen_managements#meal_category',as: :meal_category
  get 'canteen_managements/new_meal_category'=>'canteen_managements#new_meal_category',as: :new_meal_category
  post 'canteen_managements/create_meal_category'=>'canteen_managements#create_meal_category',as: :create_meal_category
  get 'canteen_managements/:id/edit_meal_category'=>'canteen_managements#edit_meal_category',as: :edit_meal_category
  patch 'canteen_managements/update_meal_category'=>'canteen_managements#update_meal_category',as: :update_meal_category
  get 'canteen_managements/show_meal_category'=>'canteen_managements#show_meal_category',as: :show_meal_category
  get 'canteen_managements/delete_meal_category'=>'canteen_managements#delete_meal_category',as: :delete_meal_category
  
  get 'canteen_managements/canteen_fee_category'
  get 'canteen_managements/canteen_fee_category_new'
  get 'canteen_managements/canteen_fee_category_create'
  get 'canteen_managements/transport_fee_category_show'
  get 'canteen_managements/canteen_fee_category_edit'
  get 'canteen_managements/canteen_fee_category_update'
  get 'canteen_managements/delete_transport_fee_category'

  get 'canteen_managements/manage_hostel_particulars'
  get 'canteen_managements/manage_hostel_particulars_new'
  get 'canteen_managements/manage_hostel_particulars_create'
  
  get 'canteen_managements/canteen_edit_fee_particular'
  get 'canteen_managements/canteen_update_fee_particular'
  get 'canteen_managements/canteen_destroy_fee_particular'

  get 'canteen_managements/canteen_fee_schedule'
  get 'canteen_managements/canteen_delete_fee_schedule'
  get 'canteen_managements/manage_canteen_particulars_new'

  # get 'canteen_managements/manage_canteen_particulars/:idcurl 'http://st.cms.vcap.me:4000/canteen_managements/manage_canteen_particulars_new/?id=18&_=1469098800378' -H 'Host: st.cms.vcap.me:4000' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:45.0) Gecko/20100101 Firefox/45.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'X-CSRF-Token: iUKhFYWieiTZmeWngBqTjHH9oArwuP0ctxGcXqgG7v8=' -H 'X-Requested-With: XMLHttpRequest' -H 'Referer: http://st.cms.vcap.me:4000/canteen_managements/manage_canteen_particulars/18' -H 'Cookie: _cms_application_session=9ea4d1f9d3660ca3ee14c8d28d67d1e8''







  resources :canteen_managements
  
  get 'alumni/video_gallery_list'=>'alumni#video_gallery_list',as: :video_gallery_list
  get 'alumni/photo_gallery_list'=>'alumni#photo_gallery_list',as: :photo_gallery_list
  get 'alumni/gallery_list'=>'alumni#gallery_list',as: :gallery_list
  get 'alumni/online_store' => 'alumni#online_store'
  get 'alumni/online_store_item_list'=>"alumni#online_store_item_list"
  get 'alumni/online_store_item_show'=>"alumni#online_store_item_show"
  post 'alumni/cart_update'=>'alumni#cart_update',as: :cart_update
  get 'alumni/online_store_cart_show'=>'alumni#online_store_cart_show'
  get 'alumni/online_store_item_buy_from_cart'=>'alumni#online_store_item_buy_from_cart'
  get 'alumni/online_store_history'=>'alumni#online_store_history'
  get 'alumni/alumni_search'
  get 'alumni/payment_new'
  get 'alumni/payment_create'
  get 'alumni/payment_show'
  get 'alumni/payment_edit'
  get 'alumni/payment_delete'
  get 'alumni/payment_updates'
  get 'alumni/payment_index'
  get 'alumni/search_data'
  get 'alumni/ordered_list'=>'alumni#ordered_list'
  get 'alumni/edit_ordered_list'=>'alumni#edit_ordered_list'
  get 'alumni/update_ordered_list'=>'alumni#update_ordered_list',as: :update_ordered_list
  get 'alumni/show_ordered_list'=>'alumni#show_ordered_list'
  get "alumni/polling_result"

    get 'alumni/search_photo_gallery'
  get 'alumni/search_all_photo_gallery'
  
  # get "alumni"=>"alumni#alumni_registration_form_new"
  get "alumni/alumni_polls"=> "alumni#alumni_polls"
  post "alumni/:id/polling_options_update"=> "alumni#polling_options_update"
  get 'alumni/upload_video_gallery'=>'alumni#upload_video_gallery', as: :upload_video_gallery
  get 'alumni/show_photo_gallery'=>'alumni#show_photo_gallery', as: :show_photo_gallery
  get 'alumni/delete_gallery_photos'=>'alumni#delete_gallery_photos', as: :delete_gallery_photos
  post 'alumni/photo_gallery_save'=>'alumni#photo_gallery_save', as: :photo_gallery_save
  get 'alumni/upload_photo_gallery'=>'alumni#upload_photo_gallery', as: :upload_photo_gallery
  get 'alumni/delete_gallery_album'=>'alumni#delete_gallery_album', as: :delete_gallery_album
  get 'alumni/update_photo_gallery'=>'alumni#update_photo_gallery', as: :update_photo_gallery
  get 'alumni/edit_photo_gallery'=>'alumni#edit_photo_gallery', as: :edit_photo_gallery
  post 'alumni/create_photo_gallery'=>'alumni#create_photo_gallery', as: :create_photo_gallery
  get 'alumni/new_photo_gallery'=>'alumni#new_photo_gallery', as: :new_photo_gallery
  get 'alumni/photo_gallery'=>'alumni#photo_gallery', as: :photo_gallery
  # Bindhu Added routes for alumni starts
  get 'alumni/alumni_event_index'=>'alumni#alumni_event_index',as: :alumni_event_index
  get 'alumni/alumni_event_new'=>'alumni#alumni_event_new',as: :alumni_event_new
  post 'alumni/alumni_event_create'=>'alumni#alumni_event_create',as: :alumni_event_create
  get 'alumni/:id/alumni_event_edit'=>'alumni#alumni_event_edit',as: :alumni_event_edit
  patch 'alumni/:id/alumni_event_update'=>'alumni#alumni_event_update',as: :alumni_event_update
  get 'alumni/alumni_event_show/:id'=>'alumni#alumni_event_show',as: :alumni_event_show
  delete 'alumni/alumni_event_delete/:id'=>'alumni#alumni_event_delete',as: :alumni_event_delete
  get 'alumni/alumni_job_posting_index'=>'alumni#alumni_job_posting_index',as: :alumni_job_posting_index
  get 'alumni/alumni_job_posting_new'=>'alumni#alumni_job_posting_new',as: :alumni_job_posting_new
  post 'alumni/alumni_job_posting_create'=>'alumni#alumni_job_posting_create',as: :alumni_job_posting_create
  get 'alumni/:id/alumni_job_posting_edit'=>'alumni#alumni_job_posting_edit',as: :alumni_job_posting_edit
  patch 'alumni/:id/alumni_job_posting_update'=>'alumni#alumni_job_posting_update',as: :alumni_job_posting_update
  get 'alumni/alumni_job_posting_show/:id'=>'alumni#alumni_job_posting_show',as: :alumni_job_posting_show
  delete 'alumni/alumni_job_posting_delete/:id'=>'alumni#alumni_job_posting_delete',as: :alumni_job_posting_delete
 # Bindhu Added routes for alumni ends
  get 'alumni/fee_payment' => 'alumni#fee_payment'
  get 'alumni/fee_payment_new' => 'alumni#fee_payment_new'
  get 'alumni/alumni_data' => 'alumni#alumni_data'
  get 'alumni/create_payment' => 'alumni#create_payment'
  get 'alumni/alumni_fee_pdf' => 'alumni#alumni_fee_pdf'
  patch '/alumni/:id/update' => 'alumni#update'
  get 'alumni/polling' => 'alumni#polling'
  get 'alumni/prepopulate_alumni_data' => 'alumni#prepopulate_alumni_data'
  get 'alumni/polling_new' => 'alumni#polling_new'
  get 'alumni/polling_edit' => 'alumni#polling_edit'
  get 'alumni/polling_delete' => 'alumni#polling_delete'
  get 'alumni/polling_options' => 'alumni#polling_options'
  get 'alumni/polling_options_new' => 'alumni#polling_options_new'
  get 'alumni/polling_options_create' => 'alumni#polling_options_create'
  get 'alumni/polling_options_edit' => 'alumni#polling_options_edit'
  get 'alumni/polling_options_graph' => 'alumni#polling_options_graph'
  get 'alumni/polling_options_update' => 'alumni#polling_options_update'
  get 'alumni/polling_options_delete' => 'alumni#polling_options_delete'
  get 'alumni/polling_options_show' => 'alumni#polling_options_show'
  get 'alumni/alumni_registration_show' => 'alumni#alumni_registration_show'
  get 'alumni/alumni_registration_form' => 'alumni#alumni_registration_form'
  get 'alumni/alumni_registration_form_edit' => 'alumni#alumni_registration_form_edit'
  get 'alumni/alumni_registration_form_new' => 'alumni#alumni_registration_form_new'
  get 'alumni/alumni_registration_form_create' => 'alumni#alumni_registration_form_create'
  get 'alumni/alumni_registration_form_show' => 'alumni#alumni_registration_form_show'
  get 'alumni/alumni_registration_form_accept' => 'alumni#alumni_registration_form_accept'
  get 'alumni/alumni_registration_form_reject' => 'alumni#alumni_registration_form_reject'
  get 'alumni/alumni_confirm_email_id' => 'alumni#alumni_confirm_email_id'
  get 'alumni/alumni_user_id' => 'alumni#alumni_user_id'
  get 'alumni/alumni_login' => 'alumni#alumni_login'
  get 'alumni/password_search_data' => 'alumni#password_search_data'
  get 'alumni/change_alumni_login_password' => 'alumni#change_alumni_login_password'
  get 'alumni/alumni_update_profile' => 'alumni#alumni_update_profile'
  get 'alumni/alumni_registration_form_update' => 'alumni#alumni_registration_form_update'
  get 'alumni/searchable_information' => 'alumni#searchable_information'
  post 'alumni/searchable_information' => 'alumni#searchable_information'
  get 'alumni/search_alumni_data' => 'alumni#search_alumni_data'
  get 'alumni/search_alumni_data_forshow' => 'alumni#search_alumni_data_forshow'
  get 'alumni/events' => 'alumni#events'
  get 'alumni/email_search_data' => 'alumni#email_search_data'
  resources :alumni

  post 'healthcare/create'=>'healthcare#create',as: :healthcare_create
  get 'healthcare/specialization'=>'healthcare#specialization',as: :specialization
  get 'healthcare/new_specialization'=>'healthcare#new_specialization',as: :new_specialization
  post 'healthcare/create_specialization'=>'healthcare#create_specialization',as: :create_specialization
  get 'healthcare/show_specialization'=>'healthcare#show_specialization',as: :show_specialization
  get 'healthcare/edit_specialization'=>'healthcare#edit_specialization',as: :edit_specialization
  patch 'healthcare/update_specialization/:id'=>'healthcare#update_specialization',as: :update_specialization
  get 'healthcare/delete_specialization'=>'healthcare#delete_specialization',as: :delete_specialization

  get 'healthcare/allergy_record'=>'healthcare#allergy_record',as: :allergy_record
  get 'healthcare/healthcare_admin'=>'healthcare#healthcare_admin',as: :healthcare_admin
  get 'healthcare/new_healthcare_admin'=>'healthcare#new_healthcare_admin',as: :new_healthcare_admin
  post 'healthcare/create_healthcare_admin'=>'healthcare#create_healthcare_admin',as: :create_healthcare_admin
  get 'healthcare/edit_healthcare_admin'=>'healthcare#edit_healthcare_admin',as: :edit_healthcare_admin
  patch 'healthcare/:id/update_healthcare_admin'=>'healthcare#update_healthcare_admin',as: :update_healthcare_admin
  get 'healthcare/delete_healthcare_admin'=>'healthcare#delete_healthcare_admin',as: :delete_healthcare_admin
  get 'healthcare/change_healthcare_admin_password'=>'healthcare#change_healthcare_admin_password',as: :change_healthcare_admin_password
  get 'healthcare/healthcare_admin_change_password'=>'healthcare#healthcare_admin_change_password',as: :healthcare_admin_change_password
  get 'healthcare/change_password_by_healthcare_admin'=>'healthcare#change_password_by_healthcare_admin',as: :change_password_by_healthcare_admin
  get 'healthcare/healthcare_admin_detail'=>'healthcare#healthcare_admin_detail',as: :healthcare_admin_detail
  
  
  get 'healthcare/health_test_history'=>'healthcare#health_test_history',as: :health_test_history
  get 'healthcare/immunization_particular'=>'healthcare#immunization_particular',as: :immunization_particular
  post 'healthcare/create_vaccinations'=>'healthcare#create_vaccinations',as: :create_vaccinations
  patch 'healthcare/:id/update_vaccinations'=>'healthcare#update_vaccinations',as: :update_vaccinations
  get 'healthcare/:id/edit_vaccinations'=>'healthcare#edit_vaccinations',as: :edit_vaccinations
  get 'healthcare/new_vaccinations'=>'healthcare#new_vaccinations',as: :new_vaccinations
  get 'healthcare/show_vaccinations/:id'=>'healthcare#show_vaccinations',as: :show_vaccinations
  get 'healthcare/delete_vaccinations/:id'=>'healthcare#delete_vaccinations',as: :delete_vaccinations
  get 'healthcare/vaccinations'=>'healthcare#vaccinations',as: :vaccinations

  post 'healthcare/create_booster_doses'=>'healthcare#create_booster_doses',as: :create_booster_doses
  patch 'healthcare/:id/update_booster_doses'=>'healthcare#update_booster_doses',as: :update_booster_doses
  get 'healthcare/:id/edit_booster_doses'=>'healthcare#edit_booster_doses',as: :edit_booster_doses
  get 'healthcare/new_booster_doses'=>'healthcare#new_booster_doses',as: :new_booster_doses
  get 'healthcare/show_booster_doses/:id'=>'healthcare#show_booster_doses',as: :show_booster_doses
  get 'healthcare/delete_booster_doses/:id'=>'healthcare#delete_booster_doses',as: :delete_booster_doses
  get 'healthcare/booster_doses'=>'healthcare#booster_doses',as: :booster_doses
  
  get 'healthcare/immunization_vaccinations'=>'healthcare#immunization_vaccinations',as: :immunization_vaccinations
  get 'healthcare/immunization_booster_doses'=>'healthcare#immunization_booster_doses',as: :immunization_booster_doses
  get 'healthcare/new_immunization_vaccinations'=>'healthcare#new_immunization_vaccinations',as: :new_immunization_vaccinations
  get 'healthcare/multi_task_worker'
  get 'healthcare/vaccinations_list'
  post 'healthcare/create_immunization_vaccinations'=>'healthcare#create_immunization_vaccinations',as: :create_immunization_vaccinations
  patch 'healthcare/:id/update_immunization_vaccinations'=>'healthcare#update_immunization_vaccinations',as: :update_immunization_vaccinations
  get 'healthcare/:id/edit_immunization_vaccinations'=>'healthcare#edit_immunization_vaccinations',as: :edit_immunization_vaccinations
  get 'healthcare/:id/show_immunization_vaccinations'=>'healthcare#show_immunization_vaccinations',as: :show_immunization_vaccinations
  get 'healthcare/:id/delete_immunization_vaccinations'=>'healthcare#delete_immunization_vaccinations',as: :delete_immunization_vaccinations
  get 'healthcare/new_immunization_booster_doses'=>'healthcare#new_immunization_booster_doses',as: :new_immunization_booster_doses
  post 'healthcare/create_immunization_booster_doses'=>'healthcare#create_immunization_booster_doses',as: :create_immunization_booster_doses
  get 'healthcare/booster_doses_list'
  get 'healthcare/:id/show_immunization_booster_doses'=>'healthcare#show_immunization_booster_doses',as: :show_immunization_booster_doses
  get 'healthcare/:id/edit_immunization_booster_doses'=>'healthcare#edit_immunization_booster_doses',as: :edit_immunization_booster_doses
  get 'healthcare/:id/delete_immunization_booster_doses'=>'healthcare#delete_immunization_booster_doses',as: :delete_immunization_booster_doses
  # patch 'healthcare/:id'=>'healthcare',as: :update
  # get 'healthcare/:id/edit'=>'healthcare/edit',as: :edit

  # Bindhu Added routs Starts for Healthcare
  get 'healthcare/index_doctor_login'=>'healthcare#index_doctor_login',as: :index_doctor_login
  get 'healthcare/doctor_detail'=>'healthcare#doctor_detail',as: :doctor_detail
  get 'healthcare/new_doctor'=>'healthcare#new_doctor',as: :new_doctor
  post 'healthcare/create_doctor_login'=>'healthcare#create_doctor_login',as: :create_doctor_login
  get 'healthcare/edit_doctor/:id'=>'healthcare#edit_doctor',as: :edit_doctor
  patch 'healthcare/:id/update_doctor_login'=>'healthcare#update_doctor_login',as: :update_doctor_login
  get 'healthcare/change_doctor_password/:id'=>'healthcare#change_doctor_password',as: :change_doctor_password
  get 'healthcare/change_password'=>'healthcare#change_password',as: :doctor_change_password
  get 'healthcare/change_password_by_doctor'=>'healthcare#change_password_by_doctor',as: :change_password_by_doctor
  get 'healthcare/delete_doctor/:id'=>'healthcare#delete_doctor',as: :delete_doctor
  get 'healthcare/doctor_index'=>'healthcare#doctor_index',as: :doctor_index
  get 'healthcare/allergy_index'=>'healthcare#allergy_index',as: :allergy_index
  get 'healthcare/allergy_new'=>'healthcare#allergy_new',as: :allergy_new
  get 'healthcare/student_list'=>'healthcare#student_list'
  get 'healthcare/student_list_table'=>'healthcare#student_list_table'
  get 'healthcare/employee_list_table'=>'healthcare#employee_list_table'
  get 'healthcare/employee_list'=>'healthcare#employee_list'
  post 'healthcare/allergy_create'=>'healthcare#allergy_create',as: :allergy_create
  # get 'healthcare/allergy_new'=>'healthcare#allergy_new',as: :allergy_new
  get 'healthcare/allergy_edit/:id'=>'healthcare#allergy_edit',as: :allergy_edit
  delete 'healthcare/allergy_delete/:id'=>'healthcare#allergy_delete',as: :allergy_delete
  get 'healthcare/allergy_show/:id'=>'healthcare#allergy_show',as: :allergy_show
  patch 'healthcare/:id/allergy_update'=>'healthcare#allergy_update',as: :allergy_update
  # Bindhu Added routs Ends for Healthcare
  # Jitendra  Added routs for Healthcare frome here
  
  
  get 'healthcare/healh_card_pdf'=>'healthcare#healh_card_pdf',as: :healh_card_pdf
  get 'healthcare/health_card_record'=>'healthcare#health_card_record',as: :health_card_record
  get 'healthcare/generate_report'=>'healthcare#generate_report',as: :generate_healthcare_report
  get 'healthcare/update_health_test'=>'healthcare#update_health_test',as: :update_health_test
  get 'healthcare/edit_health_test'=>'healthcare#edit_health_test',as: :edit_health_test
  get 'healthcare/health_test_from_section'=>'healthcare#health_test_from_section',as: :health_test_from_section
  get 'healthcare/section_form'=>'healthcare#section_form',as: :section_form
  get 'healthcare/student_employe_list'=>'healthcare#student_employe_list',as: :student_employe_list
  get 'healthcare/delete_health_test'=>'healthcare#delete_health_test',as: :delete_health_test
  get 'healthcare/show_health_test'=>'healthcare#show_health_test',as: :show_health_test
  get 'healthcare/create_health_test'=>'healthcare#create_health_test',as: :create_health_test
  get 'healthcare/manage_health_test'=>'healthcare#new_health_test',as: :new_health_test
  get 'healthcare/health_test'=>'healthcare#health_test',as: :health_test
 

  get 'healthcare/check_up_schedule'=>'healthcare#check_up_schedule',as: :check_up_schedule
  get 'healthcare/new_check_up_schedule'=>'healthcare#new_check_up_schedule',as: :new_check_up_schedule
  post 'healthcare/create_check_up_schedule'=>'healthcare#create_check_up_schedule',as: :create_check_up_schedule
  get 'healthcare/edit_check_up_schedule'=>'healthcare#edit_check_up_schedule',as: :edit_check_up_schedule
  patch 'healthcare/update_check_up_schedule'=>'healthcare#update_check_up_schedule',as: :update_check_up_schedule
  get 'healthcare/delete_check_up_schedule'=>'healthcare#delete_check_up_schedule',as: :delete_check_up_schedule
  get 'healthcare/show_check_up_schedule'=>'healthcare#show_check_up_schedule',as: :show_check_up_schedule
  
  get 'healthcare/bed_availibility'=>'healthcare#bed_availibility',as: :bed_availibility
  get 'healthcare/bed_assigned_record'=>'healthcare#bed_assigned_record',as: :bed_assigned_record
  get 'healthcare/assign_bed'=>'healthcare#assign_bed',as: :assign_bed
  get 'healthcare/new_assign_bed'=>'healthcare#new_assign_bed',as: :new_assign_bed
  post 'healthcare/create_assign_bed'=>'healthcare#create_assign_bed',as: :create_assign_bed
  get 'healthcare/show_assign_bed'=>'healthcare#show_assign_bed',as: :show_assign_bed
  get 'healthcare/edit_assign_bed'=>'healthcare#edit_assign_bed',as: :edit_assign_bed
  patch 'healthcare/update_assign_bed'=>'healthcare#update_assign_bed',as: :update_assign_bed
  get 'healthcare/delete_assign_bed'=>'healthcare#delete_assign_bed',as: :delete_assign_bed
  get 'healthcare/bed_detail'=>'healthcare#bed_detail',as: :bed_detail
  get 'healthcare/new_bed_detail'=>'healthcare#new_bed_detail',as: :new_bed_detail
  post 'healthcare/create_bed_detail'=>'healthcare#create_bed_detail',as: :create_bed_detail
  get 'healthcare/show_bed_detail'=>'healthcare#show_bed_detail',as: :show_bed_detail
  get 'healthcare/edit_bed_detail'=>'healthcare#edit_bed_detail',as: :edit_bed_detail
  patch 'healthcare/update_bed_detail'=>'healthcare#update_bed_detail',as: :update_bed_detail
  get 'healthcare/delete_bed_detail'=>'healthcare#delete_bed_detail',as: :delete_bed_detail
  # Jitendra  end Added routs for Healthcare



  get 'front_office_management/action_required_index'
  get 'front_office_management/action_required_create'
  get 'front_office_management/action_required_update'
  get 'front_office_management/action_required_delete'
  get 'front_office_management/action_required_show'
  get 'front_office_management/action_required_new'
  get 'front_office_management/action_required_edit'



  get 'front_office_management/meeting_planner_data'
  get 'front_office_management/attendance'
  get 'front_office_management/delete_caller_category'=>'front_office_management#delete_caller_category', as: :delete_caller_category
  get 'front_office_management/show_caller_category'=>'front_office_management#show_caller_category', as: :show_caller_category
  get 'front_office_management/update_caller_category'=>'front_office_management#update_caller_category', as: :update_caller_category
  get 'front_office_management/edit_caller_category'=>'front_office_management#edit_caller_category', as: :edit_caller_category
  get 'front_office_management/create_caller_category'=>'front_office_management#create_caller_category', as: :create_caller_category
  get 'front_office_management/new_caller_category'=>'front_office_management#new_caller_category', as: :new_caller_category
  get 'front_office_management/caller_category'=>'front_office_management#caller_category', as: :caller_category
  
  get 'front_office_management/user_detail', as: :user_detail
  get 'front_office_management/edit_user_detail'
  get 'front_office_management/update_user_detail', as: :update_user_detail
  
  get 'front_office_management/room_availibility'=>'front_office_management#room_availibility', as: :room_availibility
  get 'front_office_management/room_overlapping_details'=>'front_office_management#room_overlapping_details', as: :room_overlapping_details

  get 'front_office_management/room_list'
  get 'front_office_management/employee_list'
  get 'front_office_management/employee_position_list/:id'=> 'front_office_management#employee_position_list'
  get 'front_office_management/type_of_query_index'
  get 'front_office_management/type_of_query_create'
  get 'front_office_management/type_of_query_update'
  get 'front_office_management/type_of_query_delete'
  get 'front_office_management/type_of_query_show'
  get 'front_office_management/type_of_query_new'
  get 'front_office_management/type_of_query_edit'
  get 'front_office_management/caller_category_new'
  get 'front_office_management/caller_category_index'
  get 'front_office_management/caller_category_show'
  get 'front_office_management/caller_category_edit'
  get 'front_office_management/caller_category_create'
  get 'front_office_management/guest_room_booking_index'
  get 'front_office_management/guest_room_booking_new'
  get 'front_office_management/guest_room_booking_show'
  get 'front_office_management/guest_room_booking_edit'
  get 'front_office_management/guest_room_booking_create'
  get 'front_office_management/query_record_index', as: :query_record_index
  get 'front_office_management/query_record_new'
  get 'front_office_management/query_record_show'
  get 'front_office_management/query_record_edit'
  get 'front_office_management/query_record_create'
  get 'front_office_management/transport_booking_index'
  get 'front_office_management/transport_booking_new'
  get 'front_office_management/transport_booking_show'
  get 'front_office_management/transport_booking_edit'
  get 'front_office_management/transport_booking_create'
  get 'front_office_management/show_meeting_detail'=>'front_office_management#show_meeting_detail', as: :show_meeting_detail
  get 'front_office_management/delete_booking'=>'front_office_management#delete_booking', as: :delete_booking
  get 'front_office_management/update_booking'=>'front_office_management#update_booking', as: :update_booking
  get 'front_office_management/edit_booking'=>'front_office_management#edit_booking', as: :edit_booking
  get 'front_office_management/create_booking'=>'front_office_management#create_booking', as: :create_booking
  get 'front_office_management/room_book'=>'front_office_management#room_book', as: :room_book
  get 'front_office_management/meeting_detail'=>'front_office_management#meeting_detail', as: :meeting_detail
  get 'front_office_management/room_creation_edit'=>'front_office_management#room_creation_edit', as: :room_creation_edit
  get 'front_office_management/room_creation_update'=>'front_office_management#room_creation_update', as: :room_creation_update
  get 'front_office_management/room_creation_delete'=>'front_office_management#room_creation_delete', as: :room_creation_delete
  get 'front_office_management/room_creation_create'=>'front_office_management#room_creation_create', as: :room_creation_create
  get 'front_office_management/room_creation_new'=>'front_office_management#room_creation_new', as: :room_creation_new
  get 'front_office_management/room_creation_index'=>'front_office_management#room_creation_index', as: :room_creation_index
  get 'front_office_management/record_excel'=>'front_office_management#record_excel', as: :record_excel
  get 'front_office_management/delete_postal_record'=>'front_office_management#delete_postal_record', as: :delete_postal_record
  get 'front_office_management/update_postal_record'=>'front_office_management#update_postal_record', as: :update_postal_record
  get 'front_office_management/edit_postal_record'=>'front_office_management#edit_postal_record', as: :edit_postal_record
  get 'front_office_management/show_postal_record'=>'front_office_management#show_postal_record', as: :show_postal_record
  get 'front_office_management/create_postal_record'=>'front_office_management#create_postal_record', as: :create_postal_record
  get 'front_office_management/new_postal_record'=>'front_office_management#new_postal_record', as: :new_postal_record
  get 'front_office_management/postal_records'=>'front_office_management#postal_records', as: :postal_records
  get 'front_office_management/address_book'=>'front_office_management#address_book', as: :address_book
  get 'front_office_management/address_book_new'
  #get 'front_office_management/address_book_edit'
  get 'front_office_management/address_book_show'
  get 'front_office_management/address_book_update'
  get 'front_office_management/address_book_create'
  get 'front_office_management/address_book_destroy'
  get 'front_office_management/:id/address_book_edit'=>'front_office_management#address_book_edit', as: :address_book_edit
  #get 'front_office_management/:id/address_book_destroy'=>'front_office_management#address_book_destroy', as: :address_book_destroy
  get 'front_office_management/directory_search'
  get 'front_office_management/fom_all_search_data'
  get 'front_office_management/meeting_planner'
  get 'front_office_management/meeting_planner_create'
  get 'front_office_management/meeting_planner_new'
  #kumar======starts=================================
  get 'front_office_management/:id/meeting_planner_edit' =>'front_office_management#meeting_planner_edit'
  get 'front_office_management/:id/meeting_planner_show' =>'front_office_management#meeting_planner_show'
  get 'front_office_management/meeting_plan'
  get 'front_office_management/meeting_plan_create'
  get 'front_office_management/meeting_plan_new'
  get 'front_office_management/:id/meeting_plan_edit' =>'front_office_management#meeting_plan_edit'
  get 'front_office_management/:id/meeting_plan_show' =>'front_office_management#meeting_plan_show'
  get 'front_office_management/change_front_office_manager_password'=>"inventory#change_front_office_manager_password",as: :change_front_office_manager_password
  get 'front_office_management/query_record_excel'

  get "front_office_management/category" => "front_office_management#category"
  get "front_office_management/category_new" => "front_office_management#category_new"
  get "front_office_management/category_create" => "front_office_management#category_create"
  get "front_office_management/category_edit" => "front_office_management#category_edit"
  get "front_office_management/category_update" => "front_office_management#category_update"
  get "front_office_management/sub_category" => "front_office_management#sub_category"
  get "front_office_management/sub_category_new" => "front_office_management#sub_category_new"
  get "front_office_management/sub_category_create" => "front_office_management#sub_category_create"
  get "front_office_management/sub_category_edit" => "front_office_management#sub_category_edit"
  get "front_office_management/sub_category_update" => "front_office_management#sub_category_update"

  get "front_office_management/faq" => "front_office_management#faq"
  get "front_office_management/faq_new" => "front_office_management#faq_new"
  get "front_office_management/faq_create" => "front_office_management#faq_create"
  get "front_office_management/faq_edit" => "front_office_management#faq_edit"
  get "front_office_management/faq_update" => "front_office_management#faq_update"
  get "front_office_management/faq_show" => "front_office_management#faq_show"
  get "front_office_management/faq_view" => "front_office_management#faq_view"

  get 'front_office_management/sub_category_list/:id' => 'front_office_management#sub_category_list'
  get 'front_office_management/faq_status'

  get 'front_office_management/meeting'
  get 'front_office_management/meeting_create'
  get 'front_office_management/meeting_new'
  get 'front_office_management/:id/meeting_edit' =>'front_office_management#meeting_edit'
  get 'front_office_management/:id/meeting_show' =>'front_office_management#meeting_show'

  #kumar======ends=================================

  get 'front_office_management/index'
  get 'front_office_management/create'
  get 'front_office_management/update'
  get 'front_office_management/delete'
  get 'front_office_management/show'
  get 'front_office_management/new'
  get 'front_office_management/edit'

  
  get 'accounts/index'
  get 'accounts/new'
  get 'accounts/edit'
  get 'accounts/update'
  get 'accounts/show'
  get 'accounts/delete'
  get 'accounts/create'
  get 'accounts/incharge'
  get 'accounts/incharge_new'
  get 'accounts/incharge_edit'
  get 'accounts/incharge_update'
  get 'accounts/incharge_show'
  get 'accounts/incharge_delete'
  get 'accounts/incharge_create'
  get 'accounts/transfer'
  get 'accounts/transfer_new'
  get 'accounts/transfer_edit'
  get 'accounts/transfer_update'
  get 'accounts/transfer_show'
  get 'accounts/transfer_delete'
  get 'accounts/transfer_create'
  get 'accounts/review'
  get 'accounts/review_edit'
  get 'accounts/review_update'
  get 'accounts/review_show'
  get 'accounts/revert'
  get 'accounts/central_receivable'
  get 'accounts/central_receivable_generation'

  #Bindhu Work starts for accounts
  get 'accounts/account_index'=>"accounts#account_index",as: :account_index
  get 'accounts/account_new'
  get 'accounts/account_create'=>"accounts#account_create",as: :account_create
  get 'accounts/account_edit'=>"accounts#account_edit",as: :account_edit
  patch 'accounts/account_update/:id'=>'accounts#account_update' , as: :account_update
  get 'accounts/account_show'=>"accounts#account_show",as: :account_show
  get 'accounts/account_delete/:id'=>'accounts#account_delete',as: :account_delete
  get 'accounts/central_incharge_change_password/:id'=>'accounts#central_incharge_change_password',as: :central_incharge_change_password
  get 'accounts/change_password'=>'accounts#change_password',as: :change_password
  #Bindhu Work ends for accounts
  #======================================Routes for inventory module Starts================================

  
  get 'inventory/search_vendor_by_code'=>"inventory#search_vendor_by_code",as: :search_vendor_by_code
  get 'inventory/change_credential'=>"inventory#change_credential",as: :change_credential
  get 'inventory/about_store'=>"inventory#about_store",as: :about_store
  get 'inventory/delete_financial_manager'=>"inventory#delete_financial_manager",as: :delete_financial_manager
  get 'inventory/update_financial_manager'=>"inventory#update_financial_manager",as: :update_financial_manager
  get 'inventory/edit_financial_manager'=>"inventory#edit_financial_manager",as: :edit_financial_manager
  get 'inventory/change_financial_password'=>"inventory#change_financial_password",as: :change_financial_password
  get 'inventory/show_financial_manager'=>"inventory#show_financial_manager",as: :show_financial_manager
  get 'inventory/new_financial_manager'=>"inventory#new_financial_manager",as: :new_financial_manager
  get 'inventory/create_financial_officer'=>"inventory#create_financial_officer",as: :create_financial_officer
  get 'inventory/index_financial_officer'=>"inventory#index_financial_officer",as: :index_financial_officer

  get 'inventory/edit_store_manager/:id'=>'inventory#edit_store_manager',as: :edit_store_manager
  patch 'inventory/update_store_manager'=>'inventory#update_store_manager',as: :update_store_manager
  get 'inventory/store_information'=>"inventory#store_information",as: :store_information
  get 'inventory/delete_store_manager'=>"inventory#delete_store_manager",as: :delete_store_manager
  get 'inventory/store_manager_change_password'=>"inventory#store_manager_change_password",as: :store_manager_change_password
  get 'inventory/show_store_manager'=>"inventory#show_store_manager",as: :show_store_manager
  get 'inventory/create_store_manager'=>"inventory#create_store_manager",as: :create_store_manager
  get 'inventory/new_store_manager'=>"inventory#new_store_manager",as: :new_store_manager
  get 'inventory/index_store_manager'=>"inventory#index_store_manager",as: :index_store_manager
  
 
  get 'inventory/select_inventory_category'=>"inventory#select_inventory_category",as: :select_inventory_category
  get 'inventory/gate_pass'=>"inventory#gate_pass",as: :gate_pass
  get 'inventory/gate_pass_show/id'=>"inventory#gate_pass_show",as: :gate_pass_show
  get 'inventory/cash_transaction_details/id'=>"inventory#cash_transaction_details",as: :cash_transaction_details
  get 'inventory/cash_transaction'=>"inventory#cash_transaction",as: :cash_transaction
  get 'inventory/cash_transaction_report'=>"inventory#cash_transaction_report",as: :cash_transaction_report
  


 get 'inventory/show_fine_fee_particular'
  

  get 'inventory/auto_number'
  
  get 'inventory/auto_item_code'

  get 'inventory/auto_proposal_code'

  get 'inventory/new'

  get 'inventory/create'

  get 'inventory/show'

  get 'inventory/edit'

  get 'inventory/delete'

  get 'inventory/updates'

  get 'inventory/index'


   get 'inventory/item_new'

  get 'inventory/item_create'

  get 'inventory/item_show'

  get 'inventory/item_edit'

  get 'inventory/item_delete'

  get 'inventory/item_update'

  get 'inventory/item'



  get 'inventory/vendor'
  get 'inventory/vendor_new'                                                            
  post 'inventory/vendor_create'
  get 'inventory/vendor_show'
  post 'inventory/vendor_edit'
  post 'inventory/vendor_delete'
  patch 'inventory/vendor_update/:id'=>'inventory#vendor_update' , as: :vendor_update


  get 'inventory/proposal'
  get 'inventory/proposal_new'                                                            
  post 'inventory/proposal_create'
  get 'inventory/proposal_show'
  post 'inventory/proposal_edit'
  post 'inventory/proposal_delete'
  patch 'inventory/proposal_update/:id'=>'inventory#proposal_update' , as: :proposal_update


  get 'inventory/proposal_review'
  post 'inventory/review_edit'
  patch 'inventory/review_update/:id'=>'inventory#review_update' , as: :review_update



  get 'inventory/projection'
  get 'inventory/projection_new'                                                            
  post 'inventory/projection_create'
  get 'inventory/projection_show'
  post 'inventory/projection_edit'
  post 'inventory/projection_delete'
  patch 'inventory/projection_update/:id'=>'inventory#projection_update' , as: :projection_update


  get 'inventory/projection_review'
  post 'inventory/projection_review_edit'
  patch 'inventory/projection_review_update/:id'=>'inventory#projection_review_update' , as: :projection_review_update

  get 'inventory/proposal_report_show'
  get 'inventory/projection_report_show'



  get 'inventory/multiple_item_search'=>'inventory#multiple_item_search',as: :multiple_item_search

  



  #Bindhu works for Inventory starts
  get 'inventory/item_management_index'=>'inventory#item_management_index',as: :item_management_index
  get 'inventory/item_management_new'=>'inventory#item_management_new',as: :item_management_new
  get 'inventory/item_name_based_on_item_category'=>'inventory#item_name_based_on_item_category',as: :item_name_based_on_item_category
  get 'inventory/item_management_create'=>'inventory#item_management_create',as: :item_management_create
  get 'inventory/rack_based_on_room'=>'inventory#rack_based_on_room',as: :rack_based_on_room
  get 'inventory/auto_generating_id_from_prefix'=>'inventory#auto_generating_id_from_prefix',as: :auto_generating_id_from_prefix
  get 'inventory/item_management_edit/:id'=>'inventory#item_management_edit',as: :item_management_edit
  get 'inventory/item_management_show/:id'=>'inventory#item_management_show',as: :item_management_show
  get 'inventory/item_management_delete/:id'=>'inventory#item_management_delete',as: :item_management_delete
  patch 'inventory/item_management_update'=>'inventory#item_management_update',as: :item_management_update
  
  get 'inventory/inventory_item_consumption_index'=>'inventory#inventory_item_consumption_index',as: :inventory_item_consumption_index
  get 'inventory/inventory_item_consumption_new'=>'inventory#inventory_item_consumption_new',as: :inventory_item_consumption_new
  get 'inventory/inventory_item_consumption_create'=>'inventory#inventory_item_consumption_create',as: :inventory_item_consumption_create
  get 'inventory/auto_generating_id_from_prefix_consumption'=>'inventory#auto_generating_id_from_prefix_consumption',as: :auto_generating_id_from_prefix_consumption
  get 'inventory/item_available_quantity'=>'inventory#item_available_quantity',as: :item_available_quantity
  get 'inventory/inventory_item_consumption_edit/:id'=>'inventory#inventory_item_consumption_edit',as: :inventory_item_consumption_edit
  patch 'inventory/inventory_item_consumption_update'=>'inventory#inventory_item_consumption_update',as: :inventory_item_consumption_update
  get 'inventory/inventory_item_consumption_delete/:id'=>'inventory#inventory_item_consumption_delete',as: :inventory_item_consumption_delete
  get 'inventory/item_search'=>'inventory#item_search',as: :item_search
  get 'inventory/inventory_item_report '=>'inventory#inventory_item_report ',as: :inventory_item_report 
  get 'inventory/item_search_data'=>'inventory#item_search_data',as: :item_search_data
  get 'inventory/inventory_consumption_type_changes'=>'inventory#inventory_consumption_type_changes',as: :inventory_consumption_type_changes
  get 'inventory/inventory_consumption_for_student'=>'inventory#inventory_consumption_for_student',as: :inventory_consumption_for_student
  get 'inventory/inventory_consumption_for_employee'=>'inventory#inventory_consumption_for_employee',as: :inventory_consumption_for_employee
  get 'inventory/department_wise_employee_list'=>'inventory#department_wise_employee_list'
  get 'inventory/batch_wise_student_list'=>'inventory#batch_wise_student_list'
  get 'inventory/item_consumption_onshelf'=>'inventory#item_consumption_onshelf'
  get 'inventory/inventory_item_consumption_show'=>'inventory#inventory_item_consumption_show'
  get 'inventory/inventory_item_report_by_category'=>'inventory#inventory_item_report_by_category'
  get 'inventory/inventory_generate_fine'=>'inventory#inventory_generate_fine',as: :inventory_generate_fine
  get 'inventory/inventory_fine_particular_new'=>'inventory#inventory_fine_particular_new',as: :inventory_fine_particular_new
  get 'inventory/inventory_fine_particular_create'=>'inventory#inventory_fine_particular_create',as: :inventory_fine_particular_create
  get 'inventory/inventory_fine_particular_edit'=>'inventory#inventory_fine_particular_edit',as: :inventory_fine_particular_edit
  patch 'inventory/inventory_fine_particular_update'=>'inventory#inventory_fine_particular_update',as: :inventory_fine_particular_update
  #get 'inventory/edit_store_manager/:id'=>'inventory#edit_store_manager',as: :edit_store_manager
  #patch 'inventory/update_store_manager'=>'inventory#update_store_manager',as: :update_store_manager
  
  #Bindhu works for Inventory ends
  
get 'inventory/inventory_stack_management'
  get 'inventory/inventory_stack_management_new'
  get 'inventory/inventory_stack_management_create'
  get 'inventory/inventory_stack_management_show'
  get 'inventory/inventory_stack_management_edit'
  get 'inventory/inventory_stack_management_update'
  get 'inventory/inventory_stack_management_delete'

 get 'inventory/inventory_store_management'
  get 'inventory/inventory_store_management_new'
  get 'inventory/inventory_store_management_create'
  get 'inventory/inventory_store_management_show'
  get 'inventory/inventory_store_management_edit'
  get 'inventory/inventory_store_management_update'
  get 'inventory/inventory_store_management_delete'
  
  
get 'inventory/inventory_room_management'
  get 'inventory/inventory_room_management_new'
  get 'inventory/inventory_room_management_create'
  get 'inventory/inventory_room_management_show'
  get 'inventory/inventory_room_management_edit'
  get 'inventory/inventory_room_management_update'
  get 'inventory/inventory_store_management_delete'
  get 'inventory/inventory_room_data'

  get 'inventory/assaign_store_manager'
  get 'inventory/assaign_store_manager_new'
  get 'inventory/assaign_store_manager_create'
  get 'inventory/assaign_store_manager_edit'
  get 'inventory/assaign_store_manager_show'
  get 'inventory/assaign_store_manager_update'
  get 'inventory/assaign_store_manager_delete'
  
  get 'inventory/select_employee_for_manager'

  get 'inventory/assaign_financial_officer'
  get 'inventory/assaign_financial_officer_new'
  get 'inventory/assaign_financial_officer_edit'
  get 'inventory/assaign_financial_officer_update'
  get 'inventory/assaign_financial_officer_show'
  get 'inventory/assaign_financial_officer_create'

  
  get 'inventory/inventory_sales_category_data'
  get 'inventory/inventory_sales'
  get 'inventory/inventory_auto_generated_data'
  get 'inventory/inventory_sales_create'
  get 'inventory/inventory_sales_index'

  get 'inventory/inventory_sales_show'
  get 'inventory/inventory_sales_edit'
  get 'inventory/inventory_sales_update'
  get 'inventory/inventory_sales_delete'



 get 'inventory/inventory_goods_purchased'
  get 'inventory/inventory_goods_report_generation'

  get 'inventory/inventory_goods_ordered'

  get 'inventory/inventory_goods_ordered_generation'

  get 'inventory/inventory_damaged_goods'


   get 'inventory/inventory_fee_category'
  get 'inventory/inventory_fee_category_new'
  get 'inventory/inventory_fee_category_item_data'

  get 'inventory/inventory_fee_edit'
  get 'inventory/inventory_delete_fee_category'
  
  


  get 'inventory/inventory_finance_fee'
  get 'inventory/inventory_update_fee_particular'
  get 'inventory/inventory_destroy_fee_particular'


  get 'inventory/inventory_edit_fee_particular/:id' => 'inventory#inventory_edit_fee_particular'

  get 'inventory/inventory_fee_schedule'

  get 'inventory/fee_module_communication'
  
  
  #======================================Routes for inventory module Ends================================


  post 'timetable/change_teacher_save'=>'timetable#change_teacher_save',as: :change_teacher_save
  get 'timetable/change_teacher_time_table'=>'timetable#change_teacher_time_table',as: :change_teacher_time_table
  post 'timetable/change_teacher_permanent_save'=>'timetable#change_teacher_permanent_save',as: :change_teacher_permanent_save
  get 'timetable/edit_change_teacher'=>'timetable#edit_change_teacher',as: :edit_change_teacher
  post  'timetable/change_teacher_edit_save'=>'timetable#change_teacher_edit_save',as: :change_teacher_edit_save
  # get 'mg_elective_student_associations/index'




   get 'vehicles/search_vehicle_data'
get 'dashboards/search_vehicle_status'
  get 'dashboards/vehicle_information'
   #get 'dashboards/search_vehicle_status'
  get 'dashboards/employee_library_search'


resources :hostel_management
  
get 'employees/validate_accout_no'=>'employees#validate_accout_no',as: :validate_accout_no 
get 'payslips/reports'=>'payslips#reports',as: :payslips_reports
get 'payslips/overtime_report'=>'payslips#overtime_report',as: :overtime_report
get 'payslips/unpaid_leaves_report'=>'payslips#unpaid_leaves_report',as: :unpaid_leaves_report
get 'payslips/over_time'=>'payslips#over_time',as: :over_time
get 'mg_employee_grades/edit_employee_salary'=>'mg_employee_grades#edit_employee_salary',as: :edit_employee_salary
get 'mg_employee_grades/edit_employee_salary_by_grade/:id'=>'mg_employee_grades#edit_employee_salary_by_grade',as: :edit_employee_salary_by_grade
post 'mg_employee_grades/save_employee_salary'=>'mg_employee_grades#save_employee_salary',as: :save_employee_salary

get 'payslips/generate_payslip'=>'payslips#generate_payslip',as: :generate_payslip
get 'payslips/payslips_for_approve'=>'payslips#payslips_for_approve',as: :payslips_for_approve
get 'payslips/show_payslip_for_employee'=>'payslips#show_payslip_for_employee',as: :show_payslip_for_employee
get 'payslips/unpaid_leaves_report_count'=>'payslips#unpaid_leaves_report_count',as: :unpaid_leaves_report_count
get 'payslips/delete/:id'=>'payslips#delete'

  # get 'employee_weekdays/edit'
get 'payslips/payslip_approval'=>'payslips#payslip_approval',as: :payslip_approval
get 'payslips/payslip_release'=>'payslips#payslip_release',as: :payslip_release
get 'payslips/salary_deduction'=>'payslips#salary_deduction',as: :salary_deduction




get 'employees/salary_components_new'=>'employees#salary_components_new',as: :salary_components_new
post 'employees/salary_components_create'=>'employees#salary_components_create',as: :salary_components_create

get 'employees/salary_components_edit/:id'=>'employees#salary_components_edit',as: :salary_components_edit
patch 'employees/salary_components_update/:id'=>'employees#salary_components_update',as: :salary_components_update
get 'employees/salary_components_delete/:id'=>'employees#salary_components_delete',as: :salary_components_delete
get 'employees/salary_components'=>'employees#salary_components',as: :salary_components
get 'guests/event_list/:id'=>'guests#event_list', as: :guests_event_list
get 'guests/guests_for_event/:id'=>'guests#guests_for_event',as: :guests_for_event
get 'employee_biometric_attendances/select_employees'

get 'employee_biometric_attendances/import_data'
  get 'library/search_reserve_books_index'
get 'library/stack_management'=>'library#stack_management',as: :stack_management

  get 'library/check_uniq_username'=>'library#check_uniq_username',as: :check_uniq_username
  get 'library/stack_management_new'

  get 'library/stack_management_edit'

  get 'library/stack_management_show'

  get 'library/stack_management_update'

  
  get 'library/print_book_details'
  

  get 'library/stack_management_delete'



  get 'library/stack_management_create'=>'library#stack_management_create',as: :stack_management_create


get 'library/class_by_class_report'
get 'library/library_report_generation'

get 'dashboards/library_book_issue_index'

get 'library/asst_library_incharge_data_update'

get 'library/asst_library_incharge_edit'
get 'library/damaged_book_list'


get 'library/library_asst_incharge_create'

get 'library/library_card_issue_new'
  get 'library/library_card_issue_create'
  get 'library/section_for_selected_class'
  get 'library/students_for_selected_section'
  get 'library/employee_student_information'
  get 'library/save_issue_data_status_for_library'
  get 'library/save_return_data'
  get 'library/update_renew_data'
  get 'library/library_book_issue_index'
  
  get 'library/library_incharge_index'

  get 'library/select_incharge_for_library'
  get 'library/library_incharge_create'
  get 'library/library_select_employees'
  get 'library/library_incharge_data_update'
  #get 'library/library_incharge_create'
 get 'albums/upload_photos/:id'=>'albums#upload_photos',as: :upload_photos
  patch 'albums/upload_photos_save'=>'albums#upload_photos_save',as: :upload_photos_save
  get 'albums/employee_albums'=>'albums#employee_albums',as: :employee_albums
  get 'albums/albums_photos/:id'=>'albums#albums_photos',as: :albums_photos
  get 'albums/student_albums/'=>'albums#student_albums',as: :student_albums
  # get 'albums/student_albums_photos/:id'=>'albums#student_albums_photos',as: :student_albums_photos
  get 'albums/guardian_albums/'=>'albums#guardian_albums',as: :guardian_albums
  get 'albums/delete_photos/'=>'albums#delete_photos',as: :delete_photos
  get 'library/borrowed_book_list'

  



  get 'dashboards/search_reserve_books_index'
  get 'dashboards/select_category_type'
  
  get 'dashboards/library_search_results'
  
  
  
  
  get 'library/index'
  get 'library/edit'
  get 'library/new'
  get 'library/update'
  get 'library/show'
  get 'library/delete'
  get 'library/create'
  get 'library/resource'
  get 'library/resource_edit'
  get 'library/resource_new'
  get 'library/resource_update'
  get 'library/resource_show'
  get 'library/resource_delete'
  get 'library/resource_create'
  get 'library/subject'
  get 'library/subject_edit'
  get 'library/subject_new'
  get 'library/subject_update'
  get 'library/subject_show'
  get 'library/subject_delete'
  get 'library/subject_create'
  get 'library/purchase'
  get 'library/purchase_edit'
  get 'library/purchase_new'
  get 'library/purchase_update'
  get 'library/purchase_show'
  get 'library/purchase_delete'
  get 'library/purchase_create'
  get 'library/inventory'
  get 'library/inventory_edit'
  get 'library/inventory_new'
  get 'library/inventory_update'
  get 'library/inventory_show'
  get 'library/inventory_delete'
  get 'library/inventory_create'
   get 'library/auto_resource_number'
  
    get 'library/kiosk'
  get 'library/kiosk_edit'
  get 'library/kiosk_new'
  get 'library/kiosk_update'
  get 'library/kiosk_show'
  get 'library/kiosk_delete'
  get 'library/kiosk_create'
  get 'library/change_password'
  get 'library/prefix_validation'
  get 'library/prefix_edit_validation'
 get 'event_committees/delete/:id'=>'event_committees#delete',as: :delete
  get 'event_committees/index'=>'event_committees#index'
  get 'event_committees/add_committee_members'=>"event_committees#add_committee_members",as: :add_committee_members
  get 'event_committees/add_employee_to_commitee/:id'=>'event_committees#add_employee_to_commitee',as: :add_employee_to_commitee
  get 'event_committees/add_student_to_commitee'=>'event_committees#add_student_to_commitee',as: :add_student_to_commitee
  get 'event_committees/employee_list/'=>'event_committees#employee_list',as: :employee_list
  patch 'event_committees/save_employee_to_commitee'=>'event_committees#save_employee_to_commitee',as: :save_employee_to_commitee
  get 'event_committees/student_list/'=>'event_committees#student_list',as: :student_list
  get 'event_committees/save_student_to_commitee/'=>'event_committees#save_student_to_commitee',as: :save_student_to_commitee
  get 'guests/guest_participation/'=>'guests#guest_participation',as: :guest_participation
  patch 'guests/save_attended_guests/'=>'guests#save_attended_guests',as: :save_attended_guests
  get 'guests/guests_list/:id'=>'guests#guests_list',as: :guests_list
  get 'document_managements/add_photos'=>'document_managements#add_photos',as: :add_photos
  patch 'document_managements/save_photos'=>'document_managements#save_photos',as: :save_photos











   

  get 'transports/transport_fees_schedule_index'
  get 'transports/transport_fees_schedule'
  get 'transports/transport_edit_fee_schedule'
  get 'transports/update_transport_fee_schedule'
  get 'transports/transport_delete_fee_schedule'
  get 'transports/transport_show_fee_schedule'
  get 'transports/validation_params_transport'
  
  
  

   get 'transports/confirmation_request'
   get 'transports/confirmation_request_new'
   get 'transports/confirmation_request_create'

  get 'dashboards/transport_facility'
  
  get 'dashboards/transport_facility_new'

   get 'dashboards/select_stop_name'
  post 'dashboards/select_stop_name'
  post 'dashboards/transport_facility_create'
   get 'dashboards/transport_facility_edit'
   get 'dashboards/transport_facility_update'
   get 'dashboards/transport_facility_destroy'
   get 'dashboards/query_record_index_data'=>'dashboards#query_record_index_data', as: :query_record_index_data
   
  get 'transports/vehicle_transport_show'
  get 'transports/vehicle_transport_edit'
  get 'transports/vehicle_transport_update'
  get 'transports/vehicle_transport_destroy'
  get 'transports/confirmation_vehicle_request_new'
  
  get 'transports/student_status_data'
  get 'transports/transport_student_information'
  get 'transports/transport_fee_category'
  get 'transports/transport_fee_category_new'
  get 'transports/transport_fee_category_create'
  get 'transports/transport_fee_category_update'

  get 'transports/transport_fee_category_show'
  

  


 get 'transports/transport_fee_category_edit'

  get 'transports/delete_transport_fee_category'

  get 'transports/manage_transport_particulars/:id'=>'transports#manage_transport_particulars',as: :manage_transport_particulars
  get 'transports/manage_transport_particulars_new/:id'=>'transports#manage_transport_particulars_new',as: :manage_transport_particulars_new
  get 'transports/manage_transport_particulars_create'

  get 'transports/manage_transport_particulars_edit'
  get 'transports/manage_transport_particulars_show'

  get 'transports/manage_transport_particulars_update'
  get 'transports/manage_transport_particulars_destroy'
  get 'transports/select_students'




  get 'transports/list_vehicles/:id'=>'transports#list_vehicles',as: :list_vehicles

  get 'transports/index'
  get 'transports/route_vehicle_selection/:id'=>'transports#route_vehicle_selection',as: :route_vehicle_selection
  get 'transports/route_vehicle_create/:id'=>'transports#route_vehicle_create'
  

  get 'transports/create'

  get 'transports/new'

  get 'transports/edit'

  get 'transports/show'

  get 'transports/update_data'


  get 'transports/destroy'

  get '/transports/employee_list'

  get '/transports/transport_time_management_index'


  get '/transports/transport_time_management_index'


  get '/transports/transport_time_management_new'

  get '/transports/transport_time_management_create'
  get '/transports/transport_time_management_show'

  get '/transports/transport_time_management_edit'

  get '/transports/transport_time_management_update'
  get '/transports/transport_time_management_destroy'


 get 'vehicles/index'

  get 'vehicles/edit'

  get 'vehicles/new'

  get 'vehicles/destroy'

  get 'vehicles/update'

  get 'vehicles/show'
  get 'vehicles/new_report_type'
  get 'vehicles/report_type_index'
  get 'vehicles/report_type_create'
  get 'vehicles/report_type_show'
  get 'vehicles/report_type_edit'

  get 'vehicles/report_type_update'
  get 'vehicles/report_type_destroy'

  get 'vehicles/payment_type_index'
  get 'vehicles/new_payment_type'
  get 'vehicles/payment_type_create'

  get 'vehicles/payment_type_show'

  get 'vehicles/payment_type_edit'

  get 'vehicles/payment_type_update'

  get 'vehicles/payment_type_destroy'

  get 'vehicles/vehicle_report_index'

  get 'vehicles/vehicle_report_new'

  get 'vehicles/vehicle_report_create'

  get 'vehicles/vehicle_report_show'


  get 'vehicles/vehicle_report_edit'
  
  get '/vehicles/delete_record'



  get 'vehicles/vehicle_report_destroy'

  get 'vehicles/payment_type_report'

  get 'vehicles/payment_type_report_new'
  get 'vehicles/payment_type_report_edit'
  get 'vehicles/payment_type_report_update'
  get 'vehicles/payment_type_report_show'
  get 'vehicles/payment_type_report_destroy'


get 'libraries/index'
  get 'libraries/new'
  get 'libraries/show'
  get 'libraries/edit/:id'=>'libraries#edit',as: :libraries_edit
  get 'libraries/update/:id'=>'libraries#update'
  get 'libraries/destroy'
  get 'libraries/create'
  get 'libraries/library_report_generation'
  get 'libraries/damaged_book_list'
  get 'libraries/borrowed_book_list'
  

  get 'libraries/library_settings_index'
  get 'libraries/library_settings_new'
  get 'libraries/select_employees'
  get 'libraries/library_settings_create'
  get 'libraries/library_settings_show'=>'libraries#library_settings_show',as: :library_settings_show


  get 'libraries/library_settings_edit'
  get 'libraries/library_settings_update'
  get 'libraries/library_settings_destroy'

  get 'libraries/books_category_index'=>'libraries#books_category_index',as: :books_category_index
  get 'libraries/books_category_new'
  get 'libraries/books_category_create'
  get 'libraries/books_category_edit'
  get 'libraries/books_category_show'
  get 'libraries/books_category_update'
  get 'libraries/books_category_destroy'


  get 'libraries/books_inventory_index'=>'libraries#books_inventory_index',as: :books_inventory_index
  get 'libraries/books_inventory_new'=>'libraries#books_inventory_new',as: :books_inventory_new
  get 'libraries/books_inventory_create'
  get 'libraries/books_inventory_show'
  get 'libraries/books_inventory_edit'=>'libraries#books_inventory_edit',as: :books_inventory_edit
  get 'libraries/books_inventory_update'
  get 'libraries/books_inventory_destroy'

  get 'libraries/library_card_issue_index'=>'libraries#library_card_issue_index',as: :library_card_issue_index
  get 'libraries/library_card_issue_new'=>'libraries#library_card_issue_new',as: :library_card_issue_new
  get 'libraries/library_card_issue_create'
  get 'libraries/sestion_for_selected_class'
  get 'libraries/students_for_selected_section'
  #get 'libraries/sestion_for_selected_class'
  
  get 'libraries/book_issue_index'=>'libraries#book_issue_index',as: :book_issue_index
  get 'libraries/search_books'
  get 'libraries/search'
  get 'libraries/books_information_data'
  get 'libraries/update_status'
  get 'libraries/fine_status'
  get 'libraries/save_fee_fine_particulars'
  get 'libraries/renew_fine_status'
  get 'libraries/save_renew_fee_fine_particulars'
  get 'libraries/reserved_fine_status'
  get 'libraries/save_reservation_data'
  get 'libraries/issue_data_status'
  get 'libraries/save_issue_data_status'
  get 'libraries/issue_data_status_validation'
  get 'libraries/save_issued_validate_data'
  get 'libraries/cancel_reservation_data'
  get 'libraries/cancel_reservation_data_for_second_condition'
  get 'libraries/particular_student_library_records'


  get 'libraries/class_by_class_report'


  get 'dashboards/books_information_data_for_student'


  
  get 'dashboards/reserve_books_index'
  get 'dashboards/search_books_for_student'
get 'employee_biometric_attendances/select_employees'
get 'employee_biometric_attendances/import'=>'employee_biometric_attendances#import',as: :employee_biometric_attendances_import
get 'employee_biometric_attendances/import_data'

  get 'payslips/index'

  get 'payslips/show'

  get 'payslips/new'

  get 'payslips/edit'
  get 'payslips/employee_list/:id'=>'payslips#employee_list',as: :payslips_employee_list
  get 'payslips/payslips_for_employee'=>'payslips#payslips_for_employee',as: :payslips_for_employee
  get 'payslips/generate_payslip_pdf/:id'=>'payslips#generate_payslip_pdf',as: :generate_payslip_pdf
  get 'payslips/payslip_for_employee'=>'payslips#payslip_for_employee',as: :payslip_for_employee
   get 'payslips/date_wise_employee_leave_update'
  patch 'attendances/attendance_import'=>'attendances#attendance_import',as: :attendance_import
  get 'employees/verify_employee_record'
  
  get 'examination/section_subjects'
  get 'examination/generated_report6'



  get 'cce_reports/section_wise_report'
  #get 'cce_reports/make_scholastic_report/:id'=>'cce_reports#make_scholastic_report'


  get 'schools/ajax_request_for_unique_subdomain_name'

#==========================================================
  get 'cloud_admins/cloud_class'=>'cloud_admins#cloud_class',as: :cloud_class
  get 'cloud_admins/class_cloud_admin_upload'=>'cloud_admins#class_cloud_admin_upload',as: :class_cloud_admin_upload
  get 'cloud_admins/section'=>'cloud_admins#section',as: :section
  get 'cloud_admins/section_cloud_admin_upload'=>'cloud_admins#section_cloud_admin_upload',as: :section_cloud_admin_upload
  get 'cloud_admins/cloud_acount'=>'cloud_admins#cloud_acount',as: :cloud_acount
  get 'cloud_admins/cloud_acount_admin_upload'=>'cloud_admins#cloud_acount_admin_upload',as: :cloud_acount_admin_upload
  
  get 'cloud_admins/help_document_new'
  post 'cloud_admins/help_document_create' ,as: :help_document_create
  get 'cloud_admins/help_document_show'
  post 'cloud_admins/help_document_edit'
  post 'cloud_admins/help_document_delete'
  patch 'cloud_admins/help_document_update/:id'=>'cloud_admins#help_document_update' , as: :help_document_update
#========================================HOMEWORK==================================================

  get 'homework/index', as: :homework
  get 'homework/new'
  get 'homework/edit'
  get 'homework/delete'
  get 'homework/show'
  get 'homework/create'
  get 'homework/homework_new'
  patch 'homework/update/:id'=>'homework#update' , as: :homework_update
  get 'homework/student', as: :homework_student
  get 'homework/assignment'
  patch 'homework/student_update/:id'=>'homework#student_update' , as: :homework_student_update
  get 'homework/guardian'
  get 'homework/student_homework'
  get 'homework/student_list'
  get 'homework/student_show'
  patch 'homework/review_update/:id'=>'homework#review_update' , as: :homework_review_update
  get 'homework/notify_guardian'
  get 'homework/submission'
  post 'homework/employee_attachment_delete'
  get 'homework/status'
  get 'homework/section_list'
  get 'homework/homework_status'
  get 'homework/homework_status_date_wise'
  # =============after changes=====================================
  get 'homework/category'
  get 'homework/category_edit'
  get 'homework/category_new'
  get 'homework/category_update'
  get 'homework/category_show'
  get 'homework/category_delete'
  get 'homework/category_create' , as: :homework_category_create
   
#========================================laboratory===============================================
get 'laboratory/edit'
  get 'laboratory/delete'
  get 'laboratory/show'
  get 'laboratory/index'
  get 'laboratory/create'
  patch 'laboratory/update/:id'=>'laboratory#update' , as: :update
  get 'laboratory/inventory'
  get 'laboratory/inventory_new'                                                            
  post 'laboratory/inventory_create'
  get 'laboratory/inventory_show'
  post 'laboratory/inventory_edit'
  post 'laboratory/inventory_delete'
  patch 'laboratory/inventory_update/:id'=>'laboratory#inventory_update' , as: :inventory_update

  get 'laboratory/unit'
  get 'laboratory/unit_new'                                                            
  post 'laboratory/unit_create'
  get 'laboratory/unit_show'
  post 'laboratory/unit_edit'
  post 'laboratory/unit_delete'
  patch 'laboratory/unit_update/:id'=>'laboratory#unit_update' , as: :unit_update

  get 'laboratory/management'
  get 'laboratory/management_new'                                                            
  post 'laboratory/management_create'
  get 'laboratory/management_show'
  post 'laboratory/management_edit'
  post 'laboratory/management_delete'
  patch 'laboratory/management_update/:id'=>'laboratory#management_update' , as: :management_update
  get 'laboratory/category_list/:id' => 'laboratory#category_list'
  get 'laboratory/category_list_for_purchase/:id' => 'laboratory#category_list_for_purchase'
  get 'laboratory/section_list/:id' => 'laboratory#section_list'
  get 'laboratory/students_list/:id' => 'laboratory#students_list'
get 'laboratory/students_list_for_issued/:id' => 'laboratory#students_list_for_issued'



  get 'laboratory/consumption'
  get 'laboratory/consumption_new'                                                            
  post 'laboratory/consumption_create'
  get 'laboratory/consumption_show'
  post 'laboratory/consumption_edit'
  post 'laboratory/consumption_delete'
  patch 'laboratory/consumption_update/:id'=>'laboratory#consumption_update' , as: :consumption_update
  
                                                          

 get 'laboratory/purchase'
  get 'laboratory/purchase_new'                                                            
  post 'laboratory/purchase_create'
  get 'laboratory/purchase_show'
  get 'laboratory/purchase_edit'
  post 'laboratory/purchase_delete'
  #patch 'laboratory/purchase_update/:id'=>'laboratory#purchase_update' , as: :purchase_update
  get 'laboratory/purchase_update/:id'=>'laboratory#purchase_update'
  # =============================After changes ================================
  get 'laboratory/item'
  get 'laboratory/item_edit'
  get 'laboratory/item_new'
  get 'laboratory/item_update'
  get 'laboratory/item_show'
  get 'laboratory/item_delete'
  get 'laboratory/item_create' , as: :laboratory_item_create
  get 'laboratory/auto_resource_number'
  get 'laboratory/subject'
  get 'laboratory/subject_edit'
  get 'laboratory/subject_new'
  get 'laboratory/subject_update'
  get 'laboratory/subject_show'
  get 'laboratory/subject_delete'
  get 'laboratory/subject_create'
  get 'laboratory/room_list'
  get 'laboratory/incharge_create' , as: :incharge_create
  get 'laboratory/assistant_incharge_create' , as: :assistant_incharge_create
  get 'laboratory/incharge_update' , as: :incharge_update
  get 'laboratory/assistant_incharge_update' , as: :assistant_incharge_update
  get 'laboratory/edit_laboratory_assistant_incharge'
  post 'laboratory/edit_laboratory_incharge'
  post 'laboratory/laboratory_settings_show'
  post 'laboratory/show_laboratory_incharge'




#==========================================================batch_syllabus_update


  get 'cloud_admins/edit_super_principal'
  get 'cloud_admins/show_super_principal_profile/:id'=>'cloud_admins#show_super_principal_profile'   
  get 'cloud_admins/delete_super_principal/:id'=>'cloud_admins#delete_super_principal' 

  get 'cloud_admins/admin_index'
  get 'cloud_admins/new_admin'
  post 'cloud_admins/create_new_admin' 
  patch 'cloud_admins/edit_admin/:id'=>'cloud_admins#edit_admin' 
  get 'cloud_admins/delete_admin/:id'=>'cloud_admins#delete_admin' 
  get 'cloud_admins/show_admin/:id'=>'cloud_admins#show_admin' 

  get 'cloud_admins/principal_index'
  get 'cloud_admins/add_principal'
  post 'cloud_admins/save_principal' 
  patch 'cloud_admins/edit_principal/:id'=>'cloud_admins#edit_principal' 
  get 'cloud_admins/delete_principal/:id'=>'cloud_admins#delete_principal' 
  get 'cloud_admins/show_principal/:id'=>'cloud_admins#show_principal' 



  
  patch 'employees_attendances/import_attendance_save'=>'employees_attendances#import_attendance_save',as: :import_attendance_save
  
  get 'employees_attendances/import_attendance'=>'employees_attendances#import_attendance',as: :import_attendance
  #  match '/', to: 'dashboards#principle', constraints: { subdomain: 'www' }, via: [:get, :post, :put, :patch, :delete]
  # match '/', to: 'sessions#select_school', constraints: { subdomain: /.+/ }, via: [:get, :post, :put, :patch, :delete]
  get 'cloud_admins/school_principal_association_save'=>'cloud_admins#school_principal_association_save', as: :school_principal_association_save
  
  get 'cloud_admins/super_principal'

  #post 'employees/employee_principal_create'

  get 'cloud_admins/school_principal_association/:id'=>'cloud_admins#school_principal_association', as: :school_principal_association
  get 'cloud_admins/school_association'=>'cloud_admins#school_association',as: :school_association 
  get 'sessions/change_school'=>'sessions#change_school',as: :change_school
  get 'dashboards/sublect_and_class_for_employee/:id'=>'dashboards#sublect_and_class_for_employee',as: :sublect_and_class_for_employee
  get 'employees_attendances/attendance_validation'=>'employees_attendances#attendance_validation',as: :attendance_validation
get 'employees_attendances/leave_details_for_employee/:id'=>'employees_attendances#leave_details_for_employee',as: :leave_details_for_employee

   

  get 'timetable/time_table_creation'
  get 'timetable/generate_timetable'
  get 'timetable/delete_timetable'
  
  get 'timetable/show_batch_timetables'
   get 'fees/fine_fee_reports'
  get 'fees/fee_submission_status'
  get 'fees/fee_recept'=>'fees#fee_recept', as: :fee_recept
  get 'fees/fee_report_for_student'=>'fees#fee_report_for_student',as: :fee_report_for_student
  get 'fees/generate_fee_pdf/:id'=>'fees#generate_fee_pdf', as: :generate_fee_pdf
  get 'fees/account_detail'=>'fees#account_detail', as: :account_detail




  get 'mg_employee_leave_types/leave_action_save'=>'mg_employee_leave_types#leave_action_save',as: :leave_action_save
  get 'mg_employee_leave_types/leave_action'=>'mg_employee_leave_types#leave_action',as: :leave_action
  get 'mg_employee_leave_types/leave_for_approve'=>'mg_employee_leave_types#leave_for_approve',as: :leave_for_approve
  patch 'document_managements/share_file_for_batch_save'=>'document_managements#share_file_for_batch_save', as: :share_file_for_batch_save
  
  get 'my_questions/select_batch'=>'my_questions#select_batch', as: :select_batch
  get 'document_managements/download_html'=>'document_managements#download_html',as: :download_html
  get 'document_managements/content_show_for_student/:id'=>'document_managements#content_show_for_student', as: :content_show_for_student
  patch 'my_questions/share_to_bach_save'=>'my_questions#share_to_bach_save',as: :share_to_bach_save
  get 'my_questions/share_to_bach/:id'=>'my_questions#share_to_bach',as: :share_to_bach

  get 'document_managements/folder_table_show'=>'document_managements#folder_table_show', as: :folder_table_show
  get 'document_managements/files_for_student'=>'document_managements#files_for_student', as: :files_for_student
  
  get 'document_managements/share_file_for_batch/:id'=>'document_managements#share_file_for_batch', as: :share_file_for_batch
  get 'attendances/period_wise_attendance_for_student_guardian'=>'attendances#period_wise_attendance_for_student_guardian', as: :period_wise_attendance_for_student_guardian
  get 'attendances/period_wise_attendance_for_student'=>'attendances#period_wise_attendance_for_student', as: :period_wise_attendance_for_student
  get 'mg_employee_leave_types/validate_employee_leave'=>'mg_employee_leave_types#validate_employee_leave', os: :validate_employee_leave
  post 'principals/attendance_permission_craete/;id'=>'principals#attendance_permission_craete',  as: :attendance_permission_craete
  get 'principals/attendance_permission'=>'principals#attendance_permission', as: :attendance_permission
  get 'attendances/period_attendence_edit/:id'=>'attendances#period_attendence_edit', as: :period_attendence_edit
  get 'attendances/attendance_new_period'=>'attendances#attendance_new_period', as: :attendance_new_period
  # get 'attendances/folder_edit/:id'=>'attendances#folder_edit',  as: :folder_edits
  post 'attendances/attendance_create/;id'=>'attendances#attendance_create',  as: :attendance_create
  get 'attendances/period_attendence_save/:id'=>'attendances#period_attendence_save', as: :period_attendence_save
  get 'attendances/time_table_for_attendance'=>'attendances#time_table_for_attendance', as: :time_table_for_attendance
  get 'attendances/employee_student_attendance'=>'attendances#employee_student_attendance', as: :employee_student_attendance

 get 'events/edit_event/:id'=>'events#edit_event',  as: :edit_event
  patch 'events/update_event/:id'=>'events#update_event',  as: :update_event 



  post 'event_types/create'=>'event_types#create', as: :event_types_create
  get 'mg_employee_types/index'

  get 'mg_employee_types/create'

  get 'mg_employee_types/edit'

  get 'mg_employee_types/type_update'
  post 'mg_employee_types/destroy'

  get 'mg_employee_types/show'

  get 'mg_employee_types/new'


  get 'wings/edit'

  get 'wings/wing_update/:id'=>'wings#wing_update'

  get 'wings/show'

  get 'wings/index'
  resources :front_office_management
  
  resources :wings
  
  resources :master_settings

  resources :libraries
  resources :invitations


  get 'dashboards/student_timetable'
  get 'examination/exam_wise_reports'

  get 'dashboards/cloud_admin'
  get 'cloud_admins/add_school_data/:id'=>'cloud_admins#add_school_data', as: :add_school_data
  
  get 'examination/list_exam_types'
  get 'examination/generated_report'
  get 'examination/consolidated_exam_report'
   
    get 'examination/subject_wise_report'
       get 'examination/list_subjects'
         get 'examination/generated_report2'
          get 'examination/grouped_exam_report'
          get 'examination/generated_report3'
           get 'examination/final_report_type'

           get 'examination/subject_rank'
           get 'examination/list_batch_subjects'
            get 'examination/student_subject_rank'

             get 'examination/batchWise_rank'

             get 'examination/generate_reports'
             get 'examination/list_batch_groups'




  get '/students/delete_record'
  get '/students/search_student_data' => 'students#search_student_data', as: :search_student_data
  get '/students/batches_for_selected_course'
  get '/guardians/search_guardian_data' => 'guardians#search_guardian_data', as: :search_guardian_data 
  get '/employees/search_employee_data' 
  get 'employees/employee_records_delete' 





  mount Ckeditor::Engine => '/ckeditor'


  get 'my_questions/delete/:id'=>'my_questions#delete'
  get 'document_managements/folder_index_try'=>'document_managements#folder_index_try'
  get 'document_managements/view_file_in_sub_folder_list'=>'document_managements#view_file_in_sub_folder_list'
  get 'document_managements/delete_file/:id'=>'document_managements#delete_file'
  
  get 'document_managements/delete_folder/:id'=>'document_managements#delete_folder'

  get 'reports/department_details'
  get 'reports/teaching_staff_details'
  get 'reports/subject_employee_details'
  get 'reports/non_teaching_staff_details'
  get 'reports/student_details'
  get 'reports/batch_details'
  get 'reports/course_details'
  get 'reports/index'
  resources :reports
  get 'timetable/show_free_teacher'=>'timetable#show_free_teacher'
  get 'timetable/absent_teachers'=>'timetable#absent_teachers'
  get 'timetable/view_free_teachers_time_table'=>'timetable#view_free_teachers_time_table'
  get 'timetable/view_subject_time_table'=>'timetable#view_subject_time_table'
  get 'timetable/view_subject_time_table_index'=>'timetable#view_subject_time_table_index'

  get 'dashboards/employee_time_table'=>'dashboards#employee_time_table', as: :employee_time_table


  get 'dashboards/admission_report_for_principle'=>'dashboards#admission_report_for_principle', as: :admission_report_for_principle

  get 'timetable/weekday_index'
  get 'timetable/batches_for_selected_wing_in_classtimings'
  get 'timetable/batches_for_selected_wing'
  get 'timetable/employee_time_table'=>'timetable#employee_time_table'
  get 'timetable/all_employee_for_time_table'=>'timetable#all_employee_for_time_table'
  get 'timetable/view_employee_time_table_index'=>'timetable#view_employee_time_table_index'
  get 'timetable/select_batch_for_show_time_table'=>'timetable#select_batch_for_show_time_table'
  get 'timetable/teacher_for_subject_save'=>'timetable#teacher_for_subject_save'  , as: :teacher_for_subject_save
  get 'timetable/teacher_for_subject'

get 'curriculum/syllabus_index' , as: :curriculum_syllabus_index
  get 'curriculum/index'
  get 'document_managements/view_file_in_list/:id'=>'document_managements#view_file_in_list'
  get 'document_managements/folder_new'=>'document_managements#folder_new', as: :folder_new
  get 'document_managements/folder_edit/:id'=>'document_managements#folder_edit',  as: :folder_edit
  post 'document_managements/folder_new_create'=>'document_managements#folder_new_create',  as: :folder_new_create
  patch 'document_managements/folder_update/:id'=>'document_managements#file_upload_update',  as: :folder_update 
  get 'document_managements/folder_index'=>'document_managements#folder_index',  as: :folder_index     

  get 'curriculum/batch_syllabus_show'
  get 'curriculum/unit_index'
  get 'curriculum/index', as: :curr_index
  get 'curriculum/class_show'
  get 'curriculum/batchsubject_index'
  get 'curriculum/batchsubject_syllabus'
  get 'curriculum/batchsubject_new'
  get 'curriculum/student_syllabus'
  get 'curriculum/employee_subject_index'
  get 'curriculum/employee_subject'
  get 'curriculum/employee_topic'

  get 'dashboards/file_upload_delete/:id'=>'dashboards#file_upload_delete'
  get 'dashboards/new_folder'=>'dashboards#new_folder', as: :new_folder
  post 'dashboards/create_folder'=>'dashboards#create_folder', as: :create_folder
  get 'dashboards/file_upload'=>'dashboards#file_upload'
  get 'dashboards/file_upload_new'=>'dashboards#file_upload_new', as: :file_upload_new
  get 'dashboards/file_upload_edit/:id'=>'dashboards#file_upload_edit',  as: :file_upload_edit
  post 'dashboards/file_upload_create'=>'dashboards#file_upload_create',  as: :file_upload_create
  patch 'dashboards/file_upload_update/:id'=>'dashboards#file_upload_update',  as: :file_upload_update                                                             




  get 'events/testing'=>'events#testing'

  



post 'curriculum/create' , as: :curriculum_indexes

  post 'curriculum/batch_syllabus_edit'
  post 'curriculum/batch_syllabus_delete'
  patch 'curriculum/batch_syllabus_update/:id'=>'curriculum#batch_syllabus_update' , as: :batch_syllabus_update
  get 'curriculum/curriculum_index'
  post 'curriculum/subject_edit'
  post 'curriculum/subject_delete'
  post 'curriculum/unit_create'
  get 'curriculum/unit_show'
  post 'curriculum/unit_edit'
  post 'curriculum/unit_delete'
  get 'curriculum/topic_index'
  post 'curriculum/topic_create'
  get 'curriculum/topic_show'
  post 'curriculum/topic_edit'
  post 'curriculum/topic_delete'
  post 'curriculum/batch_syllabus_create'
  post 'curriculum/student_curriculum_create'
  post 'curriculum/employee_subject_create'
  post 'curriculum/saveBatch' , as: :curriculum_save_batch

  #post 'curriculum_managements/subject_update'
  patch 'curriculum/subject_update/:id'=>'curriculum#subject_update' , as: :curriculum_subject_update
  patch 'curriculum/unit_update/:id'=>'curriculum#unit_update' , as: :curriculum_unit_update
  patch 'curriculum/topic_update/:id'=>'curriculum#topic_update' , as: :curriculum_topic_update
  resources :curriculum



  get 'principals/principle_new'
  get 'principals/principle_data'
  get 'principals/syllabus_track'
  get 'principals/syllabus_tracker'
  post 'principals/principle_tracker_create', :as => "principle_tracker_create"
  post 'principals/principle_syllabus_tracker_create', :as => "principle_syllabus_tracker_create"
 # post 'principals/principals#principle_syllabus_tracker_create', :as: :principle_syllabus_tracker_create
  post 'principals/tracker_edit'
  post 'principals/tracker_delete'
  patch 'principals/tracker_update/:id'=>'principals#tracker_update' , as: :principle_tracker_update





  get 'principals/syllabus_tracker_show'
  get 'employees_attendances/report'

  get 'principals/event_new'=>'principals#event_new',  as: :event_new
  get 'principals/event_edit/:id'=>'principals#event_edit',  as: :event_edit                                                                 
  post 'principals/event_create'=>'principals#event_create',  as: :event_create
  patch 'principals/event_update/:id'=>'principals#event_update',  as: :event_update                                                             
  get 'principals/event_delete/:id'=>'principals#event_delete',  as: :event_delete   

  get 'dashboards/guardian_student_results'

  post 'dashboards/student_changed_password'=>'dashboards#student_changed_password',  as: :student_changed_password
  #patch 'dashboards/guardian_changed_password/:id'=>'dashboards#guardian_changed_password',  as: :guardian_changed_password                                                           

  get 'dashboards/student_change_password'=>'dashboards#student_change_password' 

 post 'dashboards/guardian_changed_password'=>'dashboards#guardian_changed_password',  as: :guardian_changed_password
  #patch 'dashboards/guardian_changed_password/:id'=>'dashboards#guardian_changed_password',  as: :guardian_changed_password                                                           

get 'dashboards/employee_change_password'=>'dashboards#employee_change_password' 

 post 'dashboards/employee_changed_password'=>'dashboards#employee_changed_password',  as: :employee_changed_password
 
get 'dashboards/principle_change_password'=>'dashboards#principle_change_password' 

 post 'dashboards/principle_changed_password'=>'dashboards#principle_changed_password',  as: :principle_changed_password
 

  get 'dashboards/guardian_change_password'=>'dashboards#guardian_change_password'
  get 'dashboards/principal_guardian_calender'=>'dashboards#principal_guardian_calender'
  get 'dashboards/principal_student_calender'=>'dashboards#principal_student_calender'
  get 'dashboards/principal_employee_calender'=>'dashboards#principal_employee_calender'
  get 'events/delete/:id'=>'events#delete'

  get 'examination/add_new_grade' => 'examination#add_new_grade'
  get 'examination/exammanagement_newLink/:id'=>'examination#exammanagement_newLink'



  get 'dashboards/student_calender'=>'dashboards#student_calender'
  get 'dashboards/allevents'=>'dashboards#allevents'
  
  
  get 'event_types/index' => 'event_types#index', as: :event_types

  get 'events/index'


  get 'cce_reports/cce_report'
   get 'cce_reports/generate_report'
  get 'cce_reports/student_wise_report'
  get 'cce_reports/student_report'
  get 'cce_reports/getStudentRecordFromBatchId'


  get 'timetable/index' 

  get 'file_uploads/index'


  get 'examination/setGradeFromMarks'


  get 'examination/new'
  get 'examination/index' => 'examination#index' ,as: :examinations
  


  get 'examination/update/:id'=> 'examination#update'

  post 'examination/exam_result_entry_create'

  get 'examination/scholastic_formativeIndicatorIndex/:id'=> 'examination#scholastic_formativeIndicatorIndex'
  get 'examination/scholastic_formativeIndicatorNewData'
  get 'examination/scholastic_formativeIndicatorCreate'
  get 'examination/scholastic_formativeIndicatorEdit'

  get 'examination/scholastic_formativeIndicatorUpdate'
  get 'examination/scholastic_formativeIndicatorDestroy'

  get 'examination/Co_Scholastic_newIndicatorData/:id'=>'examination#Co_Scholastic_newIndicatorData', as: :Co_Scholastic_newIndicatorData
  get 'examination/Co_Scholastic_newIndicatorNew'
  get 'examination/Co_Scholastic_newIndicatorCreate'
  get 'examination/Co_Scholastic_newIndicatorEdit'
  get 'examination/Co_Scholastic_newIndicatorUpdate'
  get 'examination/Co_Scholastic_newIndicatorDestroy'

  get 'examination/exammanagement_examGroups/:id'=>'examination#exammanagement_examGroups'
  get 'examination/exammanagement_examGroupsNew'
  get 'examination/exammanagement_examGroupsCreate'
  get 'examination/exammanagement_examGroupsEdit'
  get 'examination/exammanagement_examGroupsUpdate'
  get 'examination/exammanagement_examGroupsDestroy'

 

  get 'examination/exammanagement_resultEntryIndex/:id'=>'examination#exammanagement_resultEntryIndex'

  get 'examination/exammanagement_resultEntryDataIndex/:id'=>'examination#exammanagement_resultEntryDataIndex'

  get 'examination/exammanagement_resultEntryShow'
  get 'examination/exammanagement_resultEntryCreate'

  get 'examination/cce_new'
   get 'examination/cceBasic_Settings'
   get 'examination/cceBasic_gradeSets'
   get 'examination/cceBasic_gradeSetsData'
   get 'examination/cceBasic_gradeSetscreate'
   get 'examination/cceBasic_gradeSetsEditData'
   get 'examination/cceBasic_gradeSetsUpdateData'
   get 'examination/cceBasic_gradeSetsDestroyData'
   get 'examination/addGradeSet_new/:id'=> 'examination#addGradeSet_new'
   get 'examination/addGradeSet_newData'
   get 'examination/addGradeSet_newDataCreate'
   get 'examination/addGradeSet_newDataEdit'
   get 'examination/addGradeSet_newDataUpdate'
   get 'examination/addGradeSet_newDataDestroy'
  get 'examination/cceExamCategory_index'
  get 'examination/cceExamCategory_new'
  get 'examination/cceExamCategory_create'
  get 'examination/cceExamCategory_edit'
  get 'examination/cceExamCategory_update'
  get 'examination/cceExamCategory_destroy'
  
  get 'examination/cceWeightages_index'
  get 'examination/cceWeightages_new'
  get 'examination/cceWeightages_create'
  get 'examination/cceWeightages_edit'
  get 'examination/cceWeightages_update'
  get 'examination/cceWeightages_destroy'

  get 'examination/cceAssaignWeightages_index'
  get 'examination/cceAssaignWeightages_new'
  get 'examination/cceAssaignWeightages_create'


  get 'examination/Co_ScholasticCourseObservation_index'
  get 'examination/Co_ScholasticCourseObservation_new'
  get 'examination/Co_ScholasticCourseObservation_create'


 get 'examination/ScholasticFaGroups_index'
 get 'examination/ScholasticFaGroups_new'
 get 'examination/ScholasticFaGroups_newData'
 get 'examination/ScholasticFaGroups_create'







  get 'examination/Co_Scholastic_index'
  get 'examination/Co_Scholastic_new'
  get 'examination/Co_Scholastic_newData'
  get 'examination/Co_Scholastic_newDataCreate'
  get 'examination/Co_Scholastic_newDataEdit'
  get 'examination/Co_Scholastic_newDataUpdate'
   get 'examination/Co_Scholastic_newDataDestroy'
  get 'examination/Co_Scholastic_newDataShow/:id'=> 'examination#Co_Scholastic_newDataShow',as: :Co_Scholastic_newDataShow
  get 'examination/Co_Scholastic_criteriaNew'
  get 'examination/Co_Scholastic_criteriaCreate'
  get 'examination/Co_Scholastic_criteriaEdit'
  get 'examination/Co_Scholastic_criteriaUpdate'
  get 'examination/Co_Scholastic_criteriaDestroy'
 
  get 'examination/scholastic_index'
  get 'examination/scholastic_formativeAssessmentnew'
   get 'examination/scholastic_formativeAssessmentnewData'
   get 'examination/scholastic_formativeAssessmentnewCreate'
   get 'examination/scholastic_formativeAssessmentEdit'
   get 'examination/scholastic_formativeAssessmentUpdate'
get 'examination/scholastic_formativeAssessmentDestroy'



get 'examination/scholastic_formativeCriteriaIndex/:id'=> 'examination#scholastic_formativeCriteriaIndex', as: :scholastic_formativeCriteriaIndex
get 'examination/scholastic_formativeCriteriaNew'
get 'examination/scholastic_formativeCriteriaCreate'
get 'examination/scholastic_formativeCriteriaEdit'
get 'examination/scholastic_formativeCriteriaUpdate'
get 'examination/scholastic_formativeCriteriaDestroy'






  get 'examination/edit'
get 'examination/ranking_new'
get 'examination/ranking_destroy'
get 'examination/ranking_newdata'
get 'examination/ranking_edit'
get 'examination/ranking_update'
get 'examination/designation_new'
get 'examination/designation_newData'
get 'examination/designation_create'
get 'examination/designation_update'
get 'examination/designation_destroy'
get 'examination/designation_edit'
get 'examination/exammanagement_index'
get 'examination/exammanagement_new'
get 'examination/exammanagement_addnewdata/:id'=>'examination#exammanagement_addnewdata', as: :exammanagement_addnewdata
get 'examination/exammanagement_newcreate'
get 'examination/exammanagement_newExamData'
get 'examination/exammanagement_destroy/:id'=> 'examination#exammanagement_destroy'
get 'examination/exammanagement_connectExamData/:id'=> 'examination#exammanagement_connectExamData', as: :exammanagement_connectExamData
 get 'examination/connect_Exam_create'

get 'examination/exammanagement_coScholasticResultEntry/:id'=> 'examination#exammanagement_coScholasticResultEntry', as: :exammanagement_coScholasticResultEntry
get 'examination/exammanagement_coScholasticGradeEntry'
get 'examination/exammanagement_saveCoScholasticGradeEntry'




  get 'examination/destroy'
  get 'examination/show'
  post 'examination/show'

 
  get 'employees_attendances/attendance_report'

  get 'timetable/create'

  get 'timetable/edit'
  get 'timetable/update'


  get 'examination/add_grades'
  
  get 'examination/report_center'
  get 'examination/generate_reports'



  get 'timetable/destroy'

  get 'timetable/class_timing_index'
  
  get 'timetable/create_class_timing'

  get 'timetable/save_class_timing'

  get 'timetable/edit_class_timing'
  
 get 'timetable/update_class_timing'

 get 'timetable/delete_class_timings'

 get 'timetable/show_class_timings'

 get 'timetable/time_table_index'

 get 'timetable/create_time_table'

 get 'timetable/batch_wise_create_time_table'

 get 'timetable/time_table_associate_index' => 'timetable#time_table_associate_index', as: :time_table_associate_index

 get 'timetable/employee_list'

 get 'timetable/new_time_table'

 get 'timetable/edit_time_table'

 get 'timetable/update_time_table'

 get 'timetable/delete_time_table'
 
 get 'timetable/batch_wise_week_day_time_table'

 get 'timetable/batch_wise_select_class_timings_name'
 
 get 'timetable/view_time_table_index'

 get 'timetable/batch_for_selected_course'
 
 get 'timetable/batch_wise_view_time_table'

 get 'timetable/day_wise_view_time_table'

 get 'timetable/change_teacher_index'

 get 'timetable/teacher_for_selected_subject'

  get 'timetable/class_timings_for_selected_batch'
 
resources :vehicles
resources :transports




  patch 'guardians/address_update_by_guardian/:id'=>'guardians#address_update_by_guardian' , as: :address_update_by_guardian
  patch 'guardians/guardian_profile_contact_edit/:id'=>'guardians#guardian_profile_contact_edit' , as: :guardian_profile_contact_edit
  

get 'dashboards/guardian_leave'=>'dashboards#guardian_leave', as: :guardian_leave
get 'attendances/apply_leave_for_student'=>'attendances#apply_leave_for_student'

patch 'attendances/delete/:id'=>'attendances#delete'
  patch 'employees_attendances/delete/:id' => 'employees_attendances#delete'
  get 'employees_attendances/attendance_new'
  get 'employees_attendances/delete_attendance'
get 'employees_attendances/subjects_for_employee'=>'employees_attendances#subjects_for_employee', as: :subjects_for_employee
get 'employees_attendances/employee_list' 

get 'employees_attendances/employee_index'=>'employees_attendances#employee_index', as: :employee_index

get 'employees_attendances/employee_attendence'
get 'employees_attendances/pie_chart'

post 'attendances/apply_leave/:id'=> 'attendances#createstudent'
get 'attendances/student_index'
get 'attendances/student'
get 'attendances/view_attendance'=>'attendances#view_attendance', as: :attendance_guardian
get 'attendances/gardian_index'

resources :my_questions
resources :timetable
resources :employee_biometric_attendances

 










get 'previous_educations/new_pre_education'


resources :previous_educations
resources :principals
  get 'schools/custom_fields'
  get 'schools/custom_fields_edit/:id' =>'schools#custom_fields_edit'
  get 'previous_educations/newdetail/:id' => 'previous_educations#newdetail'
  get '/previous_educations/newdetail/:id', to: 'previous_educations#newdetail'
  # get 'schools/custom_fields_update'
  # post 'schools/custom_fields_update'
 patch "schools/custom_fields_update/:id" => "schools#custom_fields_update"
 get 'schools/custum_fields_delete/:id' => 'schools#custum_fields_delete'


 get 'students/custom_fields_edit/:id' =>'students#custom_fields_edit'
 patch "students/custom_fields_update/:id" => "students#custom_fields_update"
 get 'students/custum_fields_delete/:id' => 'students#custum_fields_delete'


 get 'employees/assign_class_teacher_to_batch' =>'employees#assign_class_teacher_to_batch', as: :assign_class_teacher_to_batch
 post 'employees/assign_class_teacher_to_batch_create' =>'employees#assign_class_teacher_to_batch_create', as: :assign_class_teacher_to_batch_create
 

 get 'employees/custom_fields_edit/:id' =>'employees#custom_fields_edit'
 patch "employees/custom_fields_update/:id" => "employees#custom_fields_update"
 get 'employees/custum_fields_delete/:id' => 'employees#custum_fields_delete'




 get 'guardians/custom_fields_edit/:id' =>'guardians#custom_fields_edit'
 patch "guardians/custom_fields_update/:id" => "guardians#custom_fields_update"
 get 'guardians/custum_fields_delete/:id' => 'guardians#custum_fields_delete'


  get 'guardians/guardian_list_searched'
  get 'guardians/student_guardian_create'

  get 'guardians/custom_index'
  get 'guardians/custom_create'
  post 'guardians/custom_create'
  get 'guardians/custom_new'
  post 'guardians/custom_new'
  #employees customs
  get 'employees/custom_index'
  get 'employees/custom_create'
  post 'employees/custom_create'
  get 'employees/custom_new' => 'employees#custom_new', as: :employee_custom_new
  post 'employees/custom_new'
  #schools customs
  get 'schools/custom_index'
  get 'schools/custom_create'
  post 'schools/custom_create'
  get 'schools/custom_new' => 'schools#custom_new', as: :school_custom_new
  post 'schools/custom_new'
  #student customs
  get 'students/custom_index'
  get 'students/custom_create'
  post 'students/custom_create'
  get 'students/custom_new'
  post 'students/custom_new'


  get 'mg_employee_leave_types/delete/:id' => 'mg_employee_leave_types#delete'
  get 'mg_employee_leave_types/from_emp'=>'mg_employee_leave_types#from_emp', as: :from_emp
  get 'mg_employee_leave_types/search'
  get '/mg_employee_leave_types/emp_attendances' => 'mg_employee_leave_types#emp_attendances', as: :emp_attendances
  get '/mg_employee_leave_types/employee_leave'
  get '/mg_employee_leave_types/for_manager_attendence'
  get '/mg_employee_leave_types/approve_leave_by_manager/:id' => 'mg_employee_leave_types#approve_leave_by_manager'
  get '/mg_employee_leave_types/is_not_approve/:id' => 'mg_employee_leave_types#is_not_approve'
  get '/mg_employee_leave_types/is_approve/:id' => 'mg_employee_leave_types#is_approve'
  get '/mg_employee_leave_types/department_reset/:id' => 'mg_employee_leave_types#department_reset'
  get '/mg_employee_leave_types/individual_employee_leave_reset' #=> 'mg_employee_leave_types#individual_employee_leave_reset'



  resources :mg_employee_leave_types



  get 'dashboards/principal'
  get 'dashboards/principle_events'
  get 'dashboards/principle_messages'
  get 'dashboards/principle_news'
  get 'dashboards/principal_profile'
  get 'dashboards/principle_attendance'
  get 'dashboards/guardian'
  get 'dashboards/guardian_profile_address_edit'
  get 'dashboards/guardian_profile_contact_edit'

  get 'dashboards/admin_mail'
  get 'dashboards/admin_events'
  get 'dashboards/admin_messages'
  get 'dashboards/admin_news'
  get 'dashboards/admin_calendar'

  post 'dashboards/employee_profiles' ,as: :emp_pro
  get 'dashboards/employee'
  get 'dashboards/employee_profile'=>'dashboards#employee_profile', as: :employee_profile
  get 'dashboards/employee_events'=>'dashboards#employee_events', as: :employee_events
  get 'dashboards/employee_messages'
  get 'dashboards/employee_news'

  get 'dashboards/emploee_attendance_pie_chart'

  get 'dashboards/student'
  get 'dashboards/student_news'=>'dashboards#student_news', as: :student_news
  get 'dashboards/student_messages'
  get 'dashboards/student_event'=>'dashboards#student_event', as: :student_event

  get 'dashboards/guardian_profile'=>'dashboards#guardian_profile', as: :guardian_profile
  get 'dashboards/guardian_events'=>'dashboards#guardian_events', as: :guardian_events
  get 'dashboards/guardian'
  get 'dashboards/guardian_students'
  get 'dashboards/guardian_news'=>'dashboards#guardian_news', as: :guardian_news
  get 'dashboards/guardian_show'
  get 'dashboards/guardians_student_fee'=>'dashboards#guardians_student_fee', as:  :guardians_student_fee


#custom roots for fees controller




get 'fees/fine_from_index'
get 'fees/update_fee_fine_particular/:id'=>'fees#update_fee_fine_particular'
get 'fees/destroy_fee_fine_particular/:id'=>'fees#destroy_fee_fine_particular'
get 'fees/newfineparticular'


get 'fees/savefineParticularFee'
 get 'fees/show_fine_fee_particular'
   get 'fees/edit_fine_fee_particular'
 get '/fees/section_students'
  get '/fees/multiple_students'
  get 'fees/financeFee/:id' => 'fees#financeFee' , as: :financeFee
  get 'fees/financeFee'
  get 'fees/edit'
  post'fees/edit'
  post'fees/update_category'
  get 'fees/newparticular'
  post'fees/newparticular'
  
get 'fees/saveParticularFee'
  post'fees/saveParticularFee'
  get 'fees/student_number'
  post'fees/student_number'
  get 'fees/student_category'
  post'fees/student_category'
  get 'fees/destroy_fee_particular'
  post'fees/destroy_fee_particular'
  delete'fees/delete_fee_particular/:id'=>'fees#delete_fee_particular'
  get 'fees/fee_discounts'
  post 'fees/fee_discounts'
  get 'fees/generate_fine'
  post 'fees/generate_fine'
  get 'fees/show_fee_particular/:id' => 'fees#show_fee_particular'
  get 'fees/edit_fee_particular/:id' => 'fees#edit_fee_particular'
  patch "fees/:id" => "fees#update_fee_particular"
  get 'fees/fee_collection'
  get 'fees/fee_schedule'
  post 'fees/fee_schedule'


    get 'fees/student_fee_submission'

    get 'fees/guardian__student_fee_view'
  get 'fees/fees_submission_batch/:id/:fee_collection_id' => 'fees#fees_submission_batch' 

  post 'fees/fees_submission_batch'
  get 'fees/fee_discount_index' => 'fees#fee_discount_index', as: :fee_discount_index 
  get 'fees/show_fee_discount/:id' => 'fees#show_fee_discount'
  get 'fees/show_fee_fine/:id' => 'fees#show_fee_fine'
  get 'fees/edit_fee_discount/:id' => 'fees#edit_fee_discount'
  patch "fees/update_fee_discount/:id" => "fees#update_fee_discount"
  delete'fees/delete_fee_discount/:id' => "fees#delete_fee_discount"
  get'fees/fee_fine_index' => 'fees#fee_fine_index', as: :fee_fine_index
  get 'fees/show_fee_fine/:id' => 'fees#show_fee_fine'
  get 'fees/edit_fee_fine/:id' => 'fees#edit_fee_fine'
  patch "fees/update_fee_fine/:id" => "fees#update_fee_fine"
  delete'fees/delete_fee_fine/:id' => "fees#delete_fee_fine"
  get 'fees/fee_schedule_index'
  get 'fees/edit_fee_schedule/:id' => 'fees#edit_fee_schedule' 
  patch "fees/update_fee_schedule/:id" => "fees#update_fee_schedule"
  delete'fees/delete_fee_schedule/:id' => "fees#delete_fee_schedule"
  get'fees/show_fee_schedule/:id' => "fees#show_fee_schedule"
  delete'fees/delete_fee_category/:id' => "fees#delete_fee_category"
  get 'fees/fee_defaulter'
  get 'fees/defaulter_fees_submission/:id/:fee_collection_id' => 'fees#defaulter_fees_submission' 
  post 'fees/defaulter_fees_submission'


  


resources :fees








  get 'employees/syllabus_track'
  get 'employees/syllabus_tracker'
  post 'employees/syllabus_tracker_create', :as => "syllabus_tracker_create"
  get 'employees/syllabus_tracker_show'
  post 'employees/tracker_edit'
  post 'employees/tracker_delete'
  patch 'employees/tracker_update/:id'=>'employees#tracker_update' , as: :tracker_update












  get 'employees/employee_position_list/:id' => 'employees#employee_position_list'
  get 'employees/employee_list_according_to_category/:id' => 'employees#employee_list_according_to_category'

  get 'employees_attendances/index'
  get 'employees_attendances/studentsHash'
  get 'attendances/studentsHash'
  get 'employees_attendances/emp_attendances'
  get 'employees_attendances/reset_all'



  get 'mg_employee_hierarchies' => 'mg_employee_hierarchies#index', as: :mg_employee_hierarchy
  get 'mg_employee_hierarchies/new'
  post 'mg_employee_hierarchies/create'
  get 'mg_employee_hierarchies/create'
  get 'mg_employee_hierarchies/employee_under_manager'
  
  get 'mg_employee_hierarchies/mg_employee_list'

  get 'mg_employee_hierarchies/list_of_employee'

  get 'mg_employee_hierarchies/remove_employee'

  get 'subjects/batch_subject_asso' => 'subjects#batch_subject_asso', as: :batch_subject_asso
  
  get 'subjects/select_subject/:id' => 'subjects#select_subject'
  get 'subjects/batch_subject'
   get 'subjects/emp_subject_asso' => 'subjects#emp_subject_asso', as: :emp_subject_asso
  get 'subjects/emp_subject'
  get 'subjects/select_subject_emp/:id' => 'subjects#select_subject_emp' , as: :select_subject_emp



  resources :subjects

  get 'settings/role_dashboard'
  get 'batches/batcheList'
  get 'attendances/index'

  resources :payslips
  resources :mg_actions
  resources :mg_roles
  resources :mg_models
  resources :mg_permissions
  resources :mg_roles_permissions
  resources :mg_user_roles
  resources :attendances
  resources :users
  resources :batches
  resources :schools
  resources :employees
  resources :mg_employee_categories
  resources :mg_employee_positions
  resources :mg_employee_departments
  resources :mg_employee_grades
  resources :employees_attendances do
    collection { post :import }
  end
  resources :examination

  get 'students/manage_student_categories' 
  get 'students/get_batches_path' 
  get 'student_categories/manage_student_categories'
  
  get 'students/student_category'
  post 'students/student_category'
  # get 'students/edit_student_category/:id' => 'students#edit_student_category'
  # patch "students/:id" => "students#edit_student_category"

  get 'students/manage_students' 
  get 'employees/manage_employees' 

  get 'guardians/new_guardian/:id' => 'guardians#new_guardian'
  get 'guardians/student_guardian_show/:id' => 'guardians#student_guardian_show'
  get 'guardians/login_access'
  get 'attendances/apply_leave' => 'attendances#apply_leave'
  
  resources :students
  resources :guardians
  
  resources :student_categories

  # => get 'settings/index'

  # => get 'dynamic_loaders/index'

  # => get 'dynamic_loaders/new'

  # => get 'dynamic_loaders/edit'

#editted........................lower one for testing.....................
get 'classes/check'
get 'classes/modeltest'
get 'classes/new'
get 'classes/index'
#-----------------------------upper one for testing-------------------------
get 'classes/grouped_batches/:id'=>'classes#grouped_batches'
get 'classes/create_batch_group'

  get 'classes/addBatch'
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#index", :as => "log_in"
  
  resources :sessions
  post 'sessions/forgot_password'
  post 'sessions/update_password'

  resources :dashboards
  resources :settings
  get 'events/admin_calender' => 'events#admin_calender', as: :admin_calender
  get 'events/allevents'  =>'events#allevents'
  
  resources :events# do
    resources :event_types
  # end


  resources :classes do
    resources :batches
  end



get 'cce_reports/student_wise_report'


get 'cce_reports/exam_wise_report'


resources :cce_reports





  get 'mg_student_admissions/batches_for_selected_course'
  resources :mg_student_admissions

  get 'entrance_exam_details/edit_students'=>'entrance_exam_details#edit_students', as: :edit_students
  get 'entrance_exam_details/show_students'=>'entrance_exam_details#show_students', as: :show_students
  get 'entrance_exam_details/print_list'=>'entrance_exam_details#print_list', as: :print_list
  get 'entrance_exam_details/update_student_index'=>'entrance_exam_details#update_student_index', as: :update_student_index
  get 'entrance_exam_details/students_index_list'=>'entrance_exam_details#students_index_list', as: :students_index_list
  get 'entrance_exam_details/students_index'=>'entrance_exam_details#students_index', as: :students_index
  get 'entrance_exam_details/update_center'=>'entrance_exam_details#update_center', as: :update_center
  get 'entrance_exam_details/show_center'=>'entrance_exam_details#show_center', as: :show_center
  get 'entrance_exam_details/exam_test_center'=>'entrance_exam_details#exam_test_center', as: :exam_test_center
  get 'entrance_exam_details/update_for_admission'=>'entrance_exam_details#update_for_admission', as: :update_for_admission
  get 'entrance_exam_details/selection_for_admission_exam'=>'entrance_exam_details#selection_for_admission_exam', as: :selection_for_admission_exam
  get 'entrance_exam_details/selection_for_exam'=>'entrance_exam_details#selection_for_exam', as: :selection_for_exam
  get 'entrance_exam_details/update_student_marks'=>'entrance_exam_details#update_student_marks', as: :update_student_marks
  get 'entrance_exam_details/student_marks_obtain'=>'entrance_exam_details#student_marks_obtain', as: :student_marks_obtain
  get 'entrance_exam_details/exam_marks'=>'entrance_exam_details#exam_marks', as: :exam_marks
  get 'entrance_exam_details/update_mg_student'=>'entrance_exam_details#update_mg_student', as: :update_mg_student
  get 'entrance_exam_details/select_student_list'=>'entrance_exam_details#select_student_list', as: :select_student_list
  get 'entrance_exam_details/cut_off_index'=>'entrance_exam_details#cut_off_index', as: :cut_off_index
  get 'entrance_exam_details/center_name'=>'entrance_exam_details#center_name', as: :center_name
  delete 'entrance_exam_details/destroy_exam_venue'=>'entrance_exam_details#destroy_exam_venue', as: :destroy_exam_venue
  get 'entrance_exam_details/edit_exam_venue'=>'entrance_exam_details#edit_exam_venue', as: :edit_exam_venue
  patch 'entrance_exam_details/update_exam_venue'=>'entrance_exam_details#update_exam_venue', as: :update_exam_venue
  get 'entrance_exam_details/show_exam_venue'=>'entrance_exam_details#show_exam_venue', as: :show_exam_venue
  post 'entrance_exam_details/create_exam_venue'=>'entrance_exam_details#create_exam_venue', as: :create_exam_venue
  get 'entrance_exam_details/new_exam_venue'=>'entrance_exam_details#new_exam_venue', as: :new_exam_venue
  get 'entrance_exam_details/exam_venue'=>'entrance_exam_details#exam_venue', as: :exam_venue
  resources :entrance_exam_details

  get 'student_hall_tickets/send_hall_ticket'=>'student_hall_tickets#send_hall_ticket', as: :send_hall_ticket
  get 'student_hall_tickets/student_list'
  get 'student_hall_tickets/generate_pdf'=>'student_hall_tickets#generate_pdf'
  resources :student_hall_tickets

  get 'admission_managements/fee_detail_pdf'=>'admission_managements#fee_detail_pdf', as: :fee_detail_pdf
  get 'admission_managements/pay_fees'=>'admission_managements#pay_fees',as: :pay_fees
  get 'admission_managements/class_student'=>'admission_managements#class_student', as: :class_student
  get 'admission_managements/students_category'=>'admission_managements#students_category', as: :students_category
  get 'admission_managements/fee_details'=>'admission_managements#fee_details', as: :fee_details
  resources :admission_managements  



# patch 'students/student_contact_edit_by_guardian'
patch 'students/student_contact_edit_by_guardian/:id'=>'students#student_contact_edit_by_guardian',  as: :student_contact_edit_by_guardian
get 'dashboards/guardian_student_profile_addres_edit'

patch 'students/student_address_update_by_guardian/:id'=>'students#student_address_update_by_guardian',  as: :student_address_update_by_guardian
get 'dashboards/guardian_student_profile_correspondanceaddress_address_edit'
patch 'students/student_Caddress_update_by_guardian/:id'=>'students#student_Caddress_update_by_guardian',  as: :student_Caddress_update_by_guardian
get 'dashboards/edit_employee_contact/:id'=>'dashboards#edit_employee_contact'
patch 'employees/edit_contact_by_employee/:id'=>'employees#edit_contact_by_employee',  as: :edit_contact_by_employee
get 'dashboards/edit_employee_permanent_address/:id'=>'dashboards#edit_employee_permanent_address'
patch 'employees/edit_address_by_employee/:id'=>'employees#edit_address_by_employee',  as: :edit_address_by_employee
get 'dashboards/edit_employee_correspondnce_address/:id'=>'dashboards#edit_employee_correspondnce_address'
patch 'employees/edit_crrespondance_address_by_employee/:id'=>'employees#edit_crrespondance_address_by_employee',  as: :edit_crrespondance_address_by_employee
get 'dashboards/edit_principal_contact/:id'=>'dashboards#edit_principal_contact'
patch 'principals/edit_contact_by_principle/:id'=>'principals#edit_contact_by_principle',  as: :edit_contact_by_principle
get 'dashboards/edit_principal_correspondnce_address/:id'=>'dashboards#edit_principal_correspondnce_address'
get 'dashboards/edit_principal_permanent_address/:id'=>'dashboards#edit_principal_permanent_address'
patch 'principals/edit_permanent_address_by_principle/:id'=>'principals#edit_permanent_address_by_principle',  as: :edit_permanent_address_by_principle
patch 'principals/edit_correspondnce_address_by_principal/:id'=>'principals#edit_correspondnce_address_by_principal',  as: :edit_correspondnce_address_by_principal








#strat here

resources :employee_weekdays
#end here



resources :document_managements
#strat here
resources :event_committees
resources :event_planners
resources :guests
resources :albums
resources :employee_weekdays
resources :healthcare
#end here

 # root :to => "classes#index"
  
 # root :to => "sessions#index"

 # principal_notifications
  get 'notifications/principal_notifications' => 'notifications#principal_notifications' , :as => "principal_notifications"
  get 'notifications/show_notification' => 'notifications#show_notification' , :as => "show_notification"
  get 'notifications/show_by_box' => 'notifications#show_by_box' , :as => "show_by_box"
  get 'notifications/view_notification/:id' => 'notifications#view_notification' , :as => "view_notification"
 
  get 'notifications/notification_seen/:id' => 'notifications#notification_seen' , :as => "notification_seen"
  get 'notifications/notification_unseen/:id' => 'notifications#notification_unseen' , :as => "notification_unseen"
  get 'notifications/principal_notification_unseen/:id' => 'notifications#principal_notification_unseen' , :as => "principal_notification_unseen"

  get 'notifications/get_data_list/:id' => 'notifications#get_data_list' , :as => "get_data_list"

  resources :notifications

   root 'sessions#index'
  match ':controller(/:action(/:id))', :via => [:get, :post]
get 'employees_attendances/generatepdf'

end
