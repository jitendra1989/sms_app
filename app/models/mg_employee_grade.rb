class MgEmployeeGrade < ActiveRecord::Base
	has_many :mg_employees
	has_many :mg_grade_components,:dependent => :destroy
  	accepts_nested_attributes_for :mg_grade_components

end
