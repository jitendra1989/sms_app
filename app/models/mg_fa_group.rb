class MgFaGroup < ActiveRecord::Base
	belongs_to :mg_cce_exam_category
	belongs_to :mg_cce_grade_set
	belongs_to :mg_school

	has_many :mg_fa_criterias
	has_many :mg_fa_groups_subjects



end
