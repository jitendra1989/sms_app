class MgFaCriteria < ActiveRecord::Base
	belongs_to :mg_fa_group
	belongs_to :mg_school

	has_many :mg_descriptive_indicators

end
