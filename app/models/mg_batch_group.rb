class MgBatchGroup < ActiveRecord::Base
	belongs_to :mg_course
	has_many :mg_grouped_batches
	has_many :mg_batches, :through=>:mg_grouped_batches
	def has_active_batches
    self.mg_batches.each do|b|
      return true if (b.is_deleted=0)
    end
    return false
  end



end
