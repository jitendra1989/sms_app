class MgFeeCategoryBatches < ActiveRecord::Base

	belongs_to :mg_batch
	belongs_to :mg_school
	belongs_to :mg_fee_category

end
