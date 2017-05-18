class CreateMgStudents < ActiveRecord::Migration
  def change
    create_table :mg_students do |t|
      t.string :admission_number
      t.string :nationality

      t.text :extra_curricular
      t.text :health_record
      t.text :class_record
      t.text :hobby
      t.text :sport_activity
      
      t.string :class_roll_number
      t.date :admission_date
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.integer :mg_batch_id
      t.integer :mg_course_id
      t.date :date_of_birth
      t.string :gender
      t.string :blood_group
      t.string :birth_place
      t.integer :mg_nationality_id
      t.string :language
      t.string :religion
      t.integer :mg_student_catagory_id
      t.boolean :is_sms_enable
      # avatar for student
      t.attachment :avatar

      t.string :status_description
      t.boolean :is_active
      
      t.boolean :has_paid_fees
      t.integer :mg_user_id
      

      # Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by


      t.timestamps
    end
  end
end
