class AddMgCorseIdMgBatchIdMgStudentIdReturnedDateToMgItemConsumption < ActiveRecord::Migration
  def change
    add_column :mg_item_consumptions, :mg_course_id, :integer
    add_column :mg_item_consumptions, :mg_batch_id, :integer
    add_column :mg_item_consumptions, :mg_student_id, :integer
    add_column :mg_item_consumptions, :return_date, :date
  end
end
