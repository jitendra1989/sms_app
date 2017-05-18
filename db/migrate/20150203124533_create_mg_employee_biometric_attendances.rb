class CreateMgEmployeeBiometricAttendances < ActiveRecord::Migration
  def change
    create_table :mg_employee_biometric_attendances do |t|
      t.date :date
      t.time :check_in
      t.time :check_out
      t.integer :mg_employee_id

      
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
