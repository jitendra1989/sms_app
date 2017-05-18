class ChangeMgClassTimingsIdToMgClassTimingId < ActiveRecord::Migration
  def change
     rename_column :mg_time_table_change_entries, :mg_class_timings_id, :mg_class_timing_id
  end

end
