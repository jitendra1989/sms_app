class MgExamScore < ActiveRecord::Base
	belongs_to :mg_student
	belongs_to :mg_exam
	belongs_to :mg_grading_level
	belongs_to :mg_school
end
