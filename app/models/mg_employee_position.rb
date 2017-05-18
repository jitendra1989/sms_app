class MgEmployeePosition < ActiveRecord::Base
	belongs_to :mg_employee_category

	has_many :mg_employees,:dependent => :destroy
    accepts_nested_attributes_for :mg_employees
	
end
