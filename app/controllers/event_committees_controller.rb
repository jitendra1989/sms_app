class EventCommitteesController < ApplicationController
		layout "mindcom"
		before_filter :login_required

        def new 
			@event_committees=MgEventCommittee.new()
			render :layout => false
		end
	
		def index
		  	@event_committees = MgEventCommittee.where(:is_deleted => 0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
		end

		def create
		  	@event_committees=MgEventCommittee.new(event_committees_params)
			  if @event_committees.save
			  	flash[:notice]="Event committee created successfully"
			    redirect_to :action => "index"
			  else
			  	flash[:error]="Error occured, please contact administrator"
			    render 'new'
			  end
		end

		def show
		  	@event_committees = MgEventCommittee.find(params[:id])
		  	render :layout => false
		end

	  	def edit
	 	@event_committees = MgEventCommittee.find(params[:id])
	 	render :layout => false
		end

		def update
		  @event_committees = MgEventCommittee.find(params[:id])
		  if @event_committees.update(event_committees_params)
		  	flash[:notice]="Event committee updated successfully"
		    redirect_to :back
		  else
		  	flash[:error]="Error occured, please contact administrator"
		    render 'edit'
		  end
		end

		

		def destroy

		end

		def delete
			@event_committees=MgEventCommittee.find_by_id(params[:id])
			@event_committees.is_deleted =1
			@event_committees.save
			flash[:notice]="Event committee successfully deleted"
		  	redirect_to :back
		end

		def add_committee_members
			mg_school_id=session[:current_user_school_id]
			@event_committees=MgEventCommittee.where(:is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:committee_name, :id )
			@departmets=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:department_name, :id)
			if params[:mg_event_committee_id].present?
				params[:mg_event_committee_id]=params[:mg_event_committee_id]
			end
		end
		def add_employee_to_commitee
			mg_school_id=session[:current_user_school_id]
			# @event_committees=MgCommitteeMember.all
			@departmets=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:department_name, :id)
			render :layout => false
		end
		def add_student_to_commitee
			mg_school_id=session[:current_user_school_id]
			@course_list=MgCourse.where(:is_deleted=>0,:mg_school_id=>mg_school_id).pluck(:course_name, :id)
			# @event_committees=MgCommitteeMember.all
			render :layout => false
		end

		def employee_list
			mg_school_id=session[:current_user_school_id]
			@mg_event_committee_id=params[:mg_event_committee_id]
			@mg_employee_department_id=params[:mg_employee_department_id]
			@employee_list=MgEmployee.where(:is_deleted=>0, :mg_employee_department_id=>params[:mg_employee_department_id], :mg_school_id=>mg_school_id)
			@event_committee_member_list=MgCommitteeMember.where(:mg_event_committee_id=>params[:mg_event_committee_id], :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_employee_id)
            render :layout => false
			
		end

		def save_employee_to_commitee
			begin
				# MgCommitteeMember.transaction do
				employee_list_department=MgEmployee.where(:is_deleted=>0, :mg_school_id=>params[:event_committees][:mg_school_id], :mg_employee_department_id=>params[:mg_employee_department_id]).pluck(:id)
				object=MgCommitteeMember.where( :mg_employee_id=>employee_list_department,:mg_student_id=>nil, :mg_school_id=>params[:event_committees][:mg_school_id],:mg_event_committee_id=> params[:mg_event_committee_id])
				object.each do |delete|
					delete.is_deleted=1
					delete.save
				end
				if params[:mg_employee_id].present?
					for i in 0...params[:mg_employee_id].size
						committe_save=MgCommitteeMember.find_by(:mg_student_id=>nil, :is_deleted=>1, :mg_school_id=>params[:event_committees][:mg_school_id], :mg_employee_id=>params[:mg_employee_id][i],:mg_event_committee_id=> params[:mg_event_committee_id])
						if committe_save.present?
							committe_save.is_deleted=0
							committe_save.save
						else
							@event_committees=MgCommitteeMember.new()
							@event_committees.mg_event_committee_id=params[:mg_event_committee_id]
							@event_committees.mg_school_id=params[:event_committees][:mg_school_id]
							@event_committees.is_deleted=0
							@event_committees.created_by=params[:event_committees][:created_by]
							@event_committees.updated_by=params[:event_committees][:updated_by]
							@event_committees.mg_employee_id=params[:mg_employee_id][i]
							@event_committees.save
						end
					end
				end
			# end
		
			flash[:notice]=="Members are successfully updated"
			rescue Exception => e
				# @object="Members are not saved, please try again"
					flash[:error]="Error occured, please contact administrator"
				# redirect_to :back
			end
		  	# flash[:error]=@object
			redirect_to :action=>'add_committee_members', :params=>{:mg_event_committee_id=>params[:mg_event_committee_id]}
		end

		def batch_list
			mg_school_id=session[:current_user_school_id]
			@batch=MgBatch.where(:mg_course_id=>params[:id],:mg_school_id=>mg_school_id, :is_deleted=>0).pluck(:name,:id)
			render :layout => false
		end

		def student_list
			mg_school_id=session[:current_user_school_id]
			@mg_event_committee_id=params[:mg_event_committee_id]
			@mg_batch_id=params[:id]
			@event_committee_member_list=MgCommitteeMember.where(:mg_event_committee_id=>params[:mg_event_committee_id], :is_deleted=>0, :mg_school_id=>mg_school_id).pluck(:mg_student_id)
			@student_list=MgStudent.where(:is_deleted=>0, :mg_batch_id=>params[:id], :mg_school_id=>mg_school_id)
			render :layout => false
		end

		def save_student_to_commitee
			begin
				 # MgCommitteeMember.transaction do
				student_list=MgStudent.where(:is_deleted=>0, :mg_school_id=>params[:event_committees][:mg_school_id], :mg_batch_id=>params[:mg_batch_id]).pluck(:id)
				object=MgCommitteeMember.where(:mg_student_id=>student_list, :mg_employee_id=>nil, :mg_school_id=>params[:event_committees][:mg_school_id],:mg_event_committee_id=> params[:mg_event_committee_id])
				object.each do |delete|
					delete.is_deleted=1
					delete.save
				end
				if params[:mg_student_id].present?
					for i in 0...params[:mg_student_id].size
						committe_save=MgCommitteeMember.find_by( :mg_employee_id=>nil,:is_deleted=>1, :mg_school_id=>params[:event_committees][:mg_school_id], :mg_student_id=>params[:mg_student_id][i],:mg_event_committee_id=> params[:mg_event_committee_id])
						if committe_save.present?
							committe_save.is_deleted=0
							committe_save.save
						else
							@event_committees=MgCommitteeMember.new()
							@event_committees.mg_event_committee_id=params[:mg_event_committee_id]
							@event_committees.mg_school_id=params[:event_committees][:mg_school_id]
							@event_committees.is_deleted=0
							@event_committees.created_by=params[:event_committees][:created_by]
							@event_committees.updated_by=params[:event_committees][:updated_by]
							@event_committees.mg_student_id=params[:mg_student_id][i]
							@event_committees.save
						end
					end
				end
			 # end
			flash[:notice]="Members are successfully updated"
			rescue Exception => e
				
				# @object="Members are not saved, please try again"
				flash[:error]="Error occured, please contact administrator"
				 # @object=e
				# redirect_to :back
			end
		  	# flash[:error]=@object
			redirect_to :action=>'add_committee_members', :params=>{:mg_event_committee_id=>params[:mg_event_committee_id]}
		end

  private
  def event_committees_params
    params.require(:event_committees).permit(:committee_name, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end
end
