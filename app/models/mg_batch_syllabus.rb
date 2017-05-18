class MgBatchSyllabus < ActiveRecord::Base

  belongs_to :mg_batch
  belongs_to :mg_syllabus

	belongs_to :mg_subject

end
