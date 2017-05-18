class AddIsPermanentToMgTimeTableChangeEntries < ActiveRecord::Migration
  def change
    add_column :mg_time_table_change_entries, :is_permanent, :boolean
    add_column :mg_time_table_change_entries, :old_mg_employee_id, :integer
    add_column :mg_time_table_change_entries, :old_mg_batch_id, :integer
    add_column :mg_time_table_change_entries, :old_mg_subject_id, :integer


  end
end
