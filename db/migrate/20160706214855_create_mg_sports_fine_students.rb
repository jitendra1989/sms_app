class CreateMgSportsFineStudents < ActiveRecord::Migration
  def change
    create_table :mg_sports_fine_students do |t|
      t.integer :mg_sports_fine_id
      t.integer :mg_student_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
