class CreateMgBatchGroups < ActiveRecord::Migration
  def change
    create_table :mg_batch_groups do |t|
      t.integer :mg_course_id
      t.string :name
      t.integer :mg_school_id
      t.string :is_deleted
      t.integer :created_by
      t.integer :updated_by
 
      t.timestamps
    end
  end
end
