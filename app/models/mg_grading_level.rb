class MgGradingLevel < ActiveRecord::Base

	belongs_to :mg_batch
	belongs_to :mg_school

	has_many :mg_exams
	has_many :mg_exam_scores

end
