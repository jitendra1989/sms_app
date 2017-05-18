class ChangeTypeOfExamVenueForMgEntranceExamDetails < ActiveRecord::Migration
  def change
    change_column :mg_entrance_exam_details, :exam_venue, :text
  end
end
