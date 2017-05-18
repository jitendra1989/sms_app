class MgDescriptiveIndicator < ActiveRecord::Base
	  belongs_to :mg_fa_criteria	
	  belongs_to :mg_school	

	  has_many :mg_assessment_scores

end
