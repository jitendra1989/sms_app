class CreateMgBatchSubjects < ActiveRecord::Migration
  def change
    create_table :mg_batch_subjects do |t|
 	  t.integer :mg_batch_id
      t.integer :mg_subject_id

      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
