class MgGroupedExam < ActiveRecord::Base
	belongs_to :mg_exam_group
	belongs_to :mg_batch
	belongs_to :mg_school
end
