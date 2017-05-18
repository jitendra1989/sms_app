class CreateMgFaGroupsSubjects < ActiveRecord::Migration
  def change
    create_table :mg_fa_groups_subjects do |t|
      t.integer :mg_subject_id
      t.integer :mg_fa_group_id

      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :updated_by
      t.integer :created_by

      t.timestamps
    end
  end
end
