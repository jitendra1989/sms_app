
class MgCceExamCategory < ActiveRecord::Base
	belongs_to :mg_school

	has_many :mg_cce_weightages
    has_many :mg_exam_groups
    has_many :mg_fa_groups


end

