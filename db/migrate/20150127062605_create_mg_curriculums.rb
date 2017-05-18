class CreateMgCurriculums < ActiveRecord::Migration
  def change
    create_table :mg_curriculums do |t|
      t.integer :mg_user_id
      t.integer :mg_subject_id
      t.integer :mg_topic_id

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
