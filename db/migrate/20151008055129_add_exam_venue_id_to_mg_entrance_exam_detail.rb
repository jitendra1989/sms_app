class AddExamVenueIdToMgEntranceExamDetail < ActiveRecord::Migration
  def change
    add_column :mg_entrance_exam_details, :mg_entrance_exam_venue_id, :integer
  end
end
