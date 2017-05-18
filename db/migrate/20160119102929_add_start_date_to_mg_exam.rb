class AddStartDateToMgExam < ActiveRecord::Migration
  def change
    add_column :mg_exams, :start_date_data, :date
    add_column :mg_exams, :start_time_data, :time
    add_column :mg_exams, :end_time_data, :time

  end
end
