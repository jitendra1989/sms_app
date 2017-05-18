# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
	# 	@mg_user__obj=MgUser.create(:user_name=>"cloudadmin",:first_name=>"cloudadmin",:middle_name=>"cloudadmin",:last_name=>"cloudadmin",:email=>"cloud@mindcom.com",:password=>"admin",
	# 		:user_type=>"cloudadmin",:is_deleted=>0,:mg_school_id=>1)
	# 	MgSchool.create(:is_deleted=>0,:school_name=>"mindcom",:school_code=>"sms",:subdomain=>"mindcom",:address_line1=>"100 feet", :city=>"Bangalore",
	# 	 :state=>"Karnataka",:pin_code=>560043, :country=>"India",:mobile_number=>"8745241478",:email_id=>"mindcom@group.com",:fax_number=>"547845",
	# 	 :date_format=>"%d/%m/%y",:timezone=>"kolkata",:currency_type=>"Rs",:affilicated_to=>"state board",:grading_system=>"3")
	# 	MgUserRole.create(:mg_user_id=>@mg_user__obj.id,:mg_role_id=>6)


 #  #========================model============================
	# 	MgModel.create([
	# 					{ modal_name: "MASTER_SETTINGS", index: 1,description: "MASTER_SETTINGS"},
	# 					{ modal_name: "EMPLOYEES", index: 2,description: "EMPLOYEES"},
	# 	        { modal_name: "CLASSES", index: 3,description: "CLASSES"},
	# 					{ modal_name: "FEES", index: 4,description: "FEES"},
	# 					{ modal_name: "ASSIGNMENTS", index: 5,description: "ASSIGNMENTS"},
	# 					{ modal_name: "TRANSPORTS", index: 6,description: "TRANSPORTS"},
	# 					{ modal_name: "TIMETABLE", index: 7,description: "TIMETABLE"},
	# 	        { modal_name: "ATTENDANCES", index: 8,description: "ATTENDANCES"},
	# 					{ modal_name: "PARENTS", index: 9,description: "PARENTS"},
	# 					{ modal_name: "SCHOOLS", index: 10,description: "SCHOOLS"},
	# 					{ modal_name: "NOTIFICATIONS", index: 11,description: "NOTIFICATIONS"},
	#           { modal_name: "STUDENTS", index: 12,description: "STUDENTS"},
	# 					{ modal_name: "PAYSLIPS", index: 13,description: "PAYSLIPS"},
	# 					{ modal_name: "LABORATORY", index: 14,description: "LABORATORY"},
	# 					{ modal_name: "LIBRARY", index: 15,description: "LIBRARY"},
	# 					{ modal_name: "CURRICULUM", index: 16,description: "CURRICULUM"},
	# 					{ modal_name: "EVENT_TYPES", index: 17,description: "EVENT_TYPES"},
	# 					{ modal_name: "CENTRAL_ACCOUNT_INCHARGE", index: 18,description: "CENTRAL_ACCOUNT_INCHARGE"},
	# 					{ modal_name: "CENTRAL_ACCOUNT_ASSISTANT_INCHARGE", index: 19,description: "CENTRAL_ACCOUNT_ASSISTANT_INCHARGE"},
	# 					{ modal_name: "EXAM_MANAGEMENT", index: 20,description: "EXAM_MANAGEMENT"},
	# 					{ modal_name: "EXAMINATION_CONTROLLER", index: 21,description: "EXAMINATION_CONTROLLER"}
	# 	])

	# 	MgRole.create([
	#           { role_name: 'admin', description: 'admin role'},
	#           { role_name: 'student', description: 'student role'},
	#           { role_name: 'employee', description: 'employee role'},
	#           { role_name: 'parent', description: 'parent role'},
	#           { role_name: 'principle', description: 'principle role'},
	#           { role_name: 'cloudadmin', description: 'cloudadmin role'},
	#           { role_name: 'superprincipal', description: 'superprincipal role'},
	#           { role_name: 'teacher', description: 'teacher role'}
	# 	])

	# 	MgAction.create([
	#           { action_name: 'view', description: 'view role'},
	#           { action_name: 'edit', description: 'student role'},
	#           { action_name: 'create', description: 'employee role'},
	#           { action_name: 'delete', description: 'parent role'},
	#           { action_name: 'update', description: 'principle role'}
	# 	])

	# MgPermission.create([
 #            { mg_model_id: 1, mg_action_id: 1},
	# 					{ mg_model_id: 1, mg_action_id: 2},
 #            { mg_model_id: 1, mg_action_id: 3},
	# 					{ mg_model_id: 1, mg_action_id: 4},
	# 					{mg_model_id: 1, mg_action_id: 5},

	# 					{ mg_model_id: 2, mg_action_id: 1},
	# 					{ mg_model_id: 2, mg_action_id: 2},
	# 					{ mg_model_id: 2, mg_action_id: 3},
	# 					{ mg_model_id: 2, mg_action_id: 4},
	# 					{ mg_model_id: 2, mg_action_id: 5},

	# 					{mg_model_id: 3, mg_action_id: 1},
	# 					{mg_model_id: 3, mg_action_id: 2},
	# 					{mg_model_id: 3, mg_action_id: 3},
	# 					{mg_model_id: 3, mg_action_id: 4},
	# 					{mg_model_id: 3, mg_action_id: 5},

	# 					{ mg_model_id: 4, mg_action_id: 1},
	# 					{ mg_model_id: 4, mg_action_id: 2},
	# 					{ mg_model_id: 4, mg_action_id: 3},
	# 					{ mg_model_id: 4, mg_action_id: 4},
	# 					{ mg_model_id: 4, mg_action_id: 5},

	# 					{ mg_model_id: 5, mg_action_id: 1},
	# 					{ mg_model_id: 5, mg_action_id: 2},
	# 					{ mg_model_id: 5, mg_action_id: 3},
	# 					{ mg_model_id: 5, mg_action_id: 4},
	# 					{ mg_model_id: 5, mg_action_id: 5},

	# 					{ mg_model_id: 6, mg_action_id: 1},
	# 					{mg_model_id: 6, mg_action_id: 2},
	# 					{ mg_model_id: 6, mg_action_id: 3},
	# 					{ mg_model_id: 6, mg_action_id: 4},
	# 					{ mg_model_id: 6, mg_action_id: 5},

	# 					{ mg_model_id: 7, mg_action_id: 1},
	# 					{ mg_model_id: 7, mg_action_id: 2},
	# 					{ mg_model_id: 7, mg_action_id: 3},
	# 					{mg_model_id: 7, mg_action_id: 4},
	# 					{mg_model_id: 7, mg_action_id: 5},

	# 					{mg_model_id: 9, mg_action_id: 1},
	# 					{mg_model_id: 9, mg_action_id: 2},
	# 					{mg_model_id: 9, mg_action_id: 3},
	# 					{ mg_model_id: 9, mg_action_id: 4},
	# 					{mg_model_id: 9, mg_action_id: 5},

	# 					{mg_model_id: 8, mg_action_id: 1},
	# 					{mg_model_id: 8, mg_action_id: 2},
	# 					{mg_model_id: 8, mg_action_id: 3},
	# 					{mg_model_id: 8, mg_action_id: 4},
	# 					{mg_model_id: 8, mg_action_id: 5},

	# 					{mg_model_id: 10, mg_action_id: 1},
	# 					{mg_model_id: 10, mg_action_id: 2},
	# 					{mg_model_id: 10, mg_action_id: 3},
	# 					{mg_model_id: 10, mg_action_id: 4},
	# 					{ mg_model_id: 10, mg_action_id: 5},

	# 					{mg_model_id: 11, mg_action_id: 1},
	# 					{mg_model_id: 11, mg_action_id: 2},
	# 					{mg_model_id: 11, mg_action_id: 3},
	# 					{mg_model_id: 11, mg_action_id: 4},
	# 					{mg_model_id: 11, mg_action_id: 5},

	# 					{mg_model_id: 12, mg_action_id: 1},
	# 					{mg_model_id: 12, mg_action_id: 2},
	# 					{mg_model_id: 12, mg_action_id: 3},
	# 					{mg_model_id: 12, mg_action_id: 4},
	# 					{mg_model_id: 12, mg_action_id: 5},

	# 					{mg_model_id: 13, mg_action_id: 1},
	# 					{mg_model_id: 13, mg_action_id: 2},
	# 					{mg_model_id: 13, mg_action_id: 3},
	# 					{mg_model_id: 13, mg_action_id: 4},
	# 					{mg_model_id: 13, mg_action_id: 5},

	# 					{mg_model_id: 14, mg_action_id: 1},
	# 					{mg_model_id: 14, mg_action_id: 2},
	# 					{mg_model_id: 14, mg_action_id: 3},
	# 					{mg_model_id: 14, mg_action_id: 4},
	# 					{mg_model_id: 14, mg_action_id: 5},

	# 					{mg_model_id: 15, mg_action_id: 1},
	# 					{mg_model_id: 15, mg_action_id: 2},
	# 					{mg_model_id: 15, mg_action_id: 3},
	# 					{mg_model_id: 15, mg_action_id: 4},
	# 					{mg_model_id: 15, mg_action_id: 5},

	# 					{mg_model_id: 16, mg_action_id: 1},
	# 					{mg_model_id: 16, mg_action_id: 2},
	# 					{mg_model_id: 16, mg_action_id: 3},
	# 					{mg_model_id: 16, mg_action_id: 4},
	# 					{mg_model_id: 16, mg_action_id: 5},

	# 					{mg_model_id: 17, mg_action_id: 1},
	# 					{mg_model_id: 17, mg_action_id: 2},
	# 					{mg_model_id: 17, mg_action_id: 3},
	# 					{mg_model_id: 17, mg_action_id: 4},
	# 					{mg_model_id: 17, mg_action_id: 5},

	# 					{mg_model_id: 18, mg_action_id: 1},
	# 					{mg_model_id: 18, mg_action_id: 2},
	# 					{mg_model_id: 18, mg_action_id: 3},
	# 					{mg_model_id: 18, mg_action_id: 4},
	# 					{mg_model_id: 18, mg_action_id: 5},

	# 					{mg_model_id: 19, mg_action_id: 1},
	# 					{mg_model_id: 19, mg_action_id: 2},
	# 					{mg_model_id: 19, mg_action_id: 3},
	# 					{mg_model_id: 19, mg_action_id: 4},
	# 					{mg_model_id: 19, mg_action_id: 5},

	# 					{mg_model_id: 20, mg_action_id: 1},
	# 					{mg_model_id: 20, mg_action_id: 2},
	# 					{mg_model_id: 20, mg_action_id: 3},
	# 					{mg_model_id: 20, mg_action_id: 4},
	# 					{mg_model_id: 20, mg_action_id: 5},

	# 					{mg_model_id: 21, mg_action_id: 1},
	# 					{mg_model_id: 21, mg_action_id: 2},
	# 					{mg_model_id: 21, mg_action_id: 3},
	# 					{mg_model_id: 21, mg_action_id: 4},
	# 					{mg_model_id: 21, mg_action_id: 5}
	# 			])

				

	# 			MgRolesPermission.create([
 #            { mg_role_id: 1, mg_permission_id: 1}
 #            { mg_role_id: 2, mg_permission_id: 6},
 #            { mg_role_id: 3, mg_permission_id: 11},
 #            { mg_role_id: 4, mg_permission_id: 16},
 #            { mg_role_id: 5, mg_permission_id: 21},
 #            { mg_role_id: 6, mg_permission_id: 26},
 #            { mg_role_id: 7, mg_permission_id: 31},
 #            { mg_role_id: 8, mg_permission_id: 36}
	# 	    ])
  #========================model============================

