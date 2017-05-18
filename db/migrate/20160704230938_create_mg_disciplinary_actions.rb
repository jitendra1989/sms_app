class CreateMgDisciplinaryActions < ActiveRecord::Migration
  def change
    create_table :mg_disciplinary_actions do |t|
      t.integer :mg_wing_id
      t.integer :mg_batches_id
      t.integer :mg_student_id
      t.text :remark
      t.text :action_taken
      t.string :status
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
