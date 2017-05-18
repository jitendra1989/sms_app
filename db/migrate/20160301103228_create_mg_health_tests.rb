class CreateMgHealthTests < ActiveRecord::Migration
  def change
    create_table :mg_health_tests do |t|
      t.integer :mg_check_up_schedule_id
      t.string :user_type
      t.date :date
      t.integer :mg_check_up_type_id
      t.integer :mg_employee_department_id
      t.integer :mg_batch_id
      t.integer :mg_student_id
      t.integer :mg_employee_id
      t.string :normal
      t.string :recommendation
      t.integer :mg_checkup_particular_id
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
