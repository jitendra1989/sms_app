class MgCceGradesSet < ActiveRecord::Base
	has_many :mg_cce_grades
    has_many :mg_fa_groups
    has_many :mg_observation_groups


end
