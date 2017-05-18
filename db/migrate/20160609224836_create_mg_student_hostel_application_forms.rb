class CreateMgStudentHostelApplicationForms < ActiveRecord::Migration
  def change
    create_table :mg_student_hostel_application_forms do |t|
      t.integer :mg_student_id
      t.integer :mg_guardian_id
      t.integer :mg_course_id
      t.integer :mg_batch_id
      t.string :admission_number
      t.date :date_of_application
      t.string :mobile_no
      t.string :email_id
      t.text :contact_address
      t.string :status
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
