class AddColumnToMgCheckUpSchedule < ActiveRecord::Migration
  def change
  	add_column :mg_check_up_schedules ,:mg_doctor_id ,:integer
  end
end
