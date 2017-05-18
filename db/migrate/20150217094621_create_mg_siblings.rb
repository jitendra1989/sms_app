class CreateMgSiblings < ActiveRecord::Migration
  def change
    create_table :mg_siblings do |t|
      t.integer :mg_user_id
      t.string :name
      t.string :relation
      t.integer :mg_course_id
      t.integer :mg_batch_id
      t.integer :roll_no
      t.date :admission_date
      t.string :admission_no
      t.boolean :is_sibling

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
