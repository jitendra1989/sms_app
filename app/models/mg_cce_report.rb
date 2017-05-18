class MgCceReport < ActiveRecord::Base
	belongs_to    :mg_batch
  belongs_to    :mg_student
  belongs_to    :mg_exam
scope :scholastic,{:conditions=>{:observable_type=>"FaCriteria"}}
end
