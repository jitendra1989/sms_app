class CreateMgDisciplinaryActionStudents < ActiveRecord::Migration
  def change
    create_table :mg_disciplinary_action_students do |t|
      t.integer :mg_disciplinary_action_id
      t.integer :mg_student_id
      t.integer :mg_batch_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
