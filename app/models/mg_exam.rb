class MgExam < ActiveRecord::Base

	belongs_to :mg_exam_group
	belongs_to :mg_subject
	belongs_to :mg_grading_level
	belongs_to :mg_event
	belongs_to :mg_school

	has_many :mg_assessment_scores

  has_many :mg_exam_scores,:dependent => :destroy
  accepts_nested_attributes_for :mg_exam_scores


end
