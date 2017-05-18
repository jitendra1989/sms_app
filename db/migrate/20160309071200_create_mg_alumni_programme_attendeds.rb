class CreateMgAlumniProgrammeAttendeds < ActiveRecord::Migration
  def change
    create_table :mg_alumni_programme_attendeds do |t|
      t.integer :mg_wing_id
      t.string :time_table_year
      t.integer :mg_employee_specialization_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
