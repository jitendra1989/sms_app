class AddExpectedClassToMgSyllabusTracker < ActiveRecord::Migration
  def change
    add_column :mg_syllabus_trackers, :expected_class, :integer
  end
end
