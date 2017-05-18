class CreateMgStudentAdmissions < ActiveRecord::Migration
  def change
    create_table :mg_student_admissions do |t|

      t.date :date_of_birth
      t.integer :mg_course_id
      t.string :grade
      t.integer :year
      t.string :course
      t.boolean :is_sibling
      t.string :is_selected_for_entrance_test
      t.string :is_shortlisted_for_admission
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :gender
      t.string :blood_group      
      t.string :birth_place
      t.string :nationality
      t.string :language
      t.string :religion
      t.string :mg_c_address_line1
      t.string :mg_c_address_line2
      t.string :mg_c_street
      t.string :mg_c_landmark
      t.string :mg_c_city
      t.string :mg_c_state
      t.integer :mg_c_pin_code
      t.string :mg_c_country
      t.string :mg_p_address_line1
      t.string :mg_p_address_line2
      t.string :mg_p_street
      t.string :mg_p_landmark
      t.string :mg_p_city
      t.string :mg_p_state
      t.integer :mg_p_pin_code
      t.string :mg_p_country
      t.integer :phone_number
      t.integer :mobile_number, :limit => 8
      t.string :mg_email_id
      t.integer :amount
      t.string :school_name
      t.integer :marks_obtained
      t.integer :total_marks
      t.boolean :has_paid
      t.integer :mg_user_id
      t.boolean :hall_ticket_release
      t.string :guardian_name      

      t.timestamps
    end
  end
end

