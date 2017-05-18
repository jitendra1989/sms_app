class AddDueDateToMgPollQuestionAlumnis < ActiveRecord::Migration
  def change
    add_column :mg_poll_question_alumnis, :due_date, :date
  end
end
