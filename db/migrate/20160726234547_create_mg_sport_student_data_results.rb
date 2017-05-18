class CreateMgSportStudentDataResults < ActiveRecord::Migration
  def change
    create_table :mg_sport_student_data_results do |t|
      t.integer :mg_sports_result_id
      t.integer :mg_students_id
      t.string :rank
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
