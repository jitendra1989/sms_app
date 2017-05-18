class ReportsController < ApplicationController
	layout "mindcom"
	before_filter :login_required
	def index
		@course_count=MgCourse.where(:is_deleted=>0)
		@batches_count=MgBatch.where(:is_deleted=>0)
		@student_count=MgStudent.where(:is_deleted=>0)
		@department_count=MgEmployeeDepartment.where(:is_deleted=>0)
		@teaching_staff_count=MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>140)
		@non_Teaching_staff_count=MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>107)
		 render :layout => false
	end
	
	def course_details
		@courses=MgCourse.where(:is_deleted=>0)
		 render :layout => false
	end

	def batch_details
		@batches=MgBatch.where(:is_deleted=>0)
		render :layout => false
	end

	def student_details
		@students=MgStudent.where(:is_deleted=>0)
		render :layout => false
	end

	def teaching_staff_details
		@teaching_staffs=MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>140)
		render :layout => false
	end

	def non_teaching_staff_details
		@non_teaching_staffs=MgEmployee.where(:is_deleted=>0,:mg_employee_category_id=>107)
		render :layout => false
	end

	def subject_employee_details
		@subjects=MgSubject.where(:is_deleted=>0)
		render :layout => false
	end

	def department_details
		@departments=MgEmployeeDepartment.where(:is_deleted=>0)	
		render :layout => false
	end

end
