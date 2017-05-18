class CreateMgSportTeamEmployees < ActiveRecord::Migration
  def change
    create_table :mg_sport_team_employees do |t|
      t.integer :mg_sport_team_id
      t.integer :mg_employee_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
