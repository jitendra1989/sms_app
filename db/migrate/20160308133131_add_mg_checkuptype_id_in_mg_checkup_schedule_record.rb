class AddMgCheckuptypeIdInMgCheckupScheduleRecord < ActiveRecord::Migration
  def change
  	add_column :mg_check_up_schedule_records ,:mg_check_up_type_id ,:integer
  end
end
