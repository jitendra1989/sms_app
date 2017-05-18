class CreateMgSportTeamStudents < ActiveRecord::Migration
  def change
    create_table :mg_sport_team_students do |t|
      t.integer :mg_sport_team_id
      t.integer :mg_student_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
