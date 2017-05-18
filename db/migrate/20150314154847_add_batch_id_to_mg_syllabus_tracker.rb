class AddBatchIdToMgSyllabusTracker < ActiveRecord::Migration
  def change
    add_column :mg_syllabus_trackers, :mg_batch_id, :integer
  end
end
