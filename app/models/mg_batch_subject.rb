class MgBatchSubject < ActiveRecord::Base
	belongs_to :mg_batch
	belongs_to :mg_subject
	belongs_to :mg_school
end
