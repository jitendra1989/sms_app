class CreateMgPollQuestionAlumnis < ActiveRecord::Migration
  def change
    create_table :mg_poll_question_alumnis do |t|
      t.text :question
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
