class AddColumnEndDateToMgPollQuestionAlumni < ActiveRecord::Migration
  def change
    add_column :mg_poll_question_alumnis, :start_date, :date
  end
end
