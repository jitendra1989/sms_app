class MasterSettingsController < ApplicationController
	layout "mindcom"
	before_filter :login_required
	def index
		@schools=MgSchool.find(session[:current_user_school_id])
     @dbdatas = MgCommonCustomField.where(model_name: "school",mg_school_id:session[:current_user_school_id],is_deleted:0)

     @customData = MgCustomFieldsData.where(mg_user_id:@schools.id,mg_school_id:session[:current_user_school_id],is_deleted:0)

	end
end
