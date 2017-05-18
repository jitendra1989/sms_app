class MgGroupedBatch < ActiveRecord::Base
	belongs_to :mg_batch_group
    belongs_to :mg_batch

end
