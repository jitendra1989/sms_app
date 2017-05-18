class CreateMgEmployees < ActiveRecord::Migration
  def change
    create_table :mg_employees do |t|
      
      t.integer :mg_nationality_id
      t.integer :mg_employee_type_id
      t.integer :mg_employee_category_id
      t.integer :mg_employee_position_id
      t.integer :mg_employee_department_id
      t.integer :mg_reporting_manager_id
      t.integer :mg_employee_grade_id
      t.integer :mg_user_id
      t.integer :mg_manager_id
      t.boolean :is_referred

      # Emergency Contact name and number

      t.string :emergency_contact_name
      t.integer :emergency_contact_number
      
      # Emergency Contact name and number
      t.text :hobby
      # need to check spell
      t.text :extra_curricular
      t.text :sport_activity


      t.string :language
      t.string :nationality
      t.string :employee_number
      t.date :joining_date
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :gender
      t.string :job_title
      t.string :qualification
      t.text :experience_detail
      t.integer :experience_year
      t.integer :experience_month
      t.boolean :status
      t.string :status_description
      t.date :date_of_birth
      t.string :marital_status
      t.integer :children_count
      t.string :father_name
      t.string :mother_name
      t.string :husband_name
      t.string :blood_group
      t.string :photo_file_name
      t.string :photo_content_type
      t.binary :photo_data
      t.integer :photo_file_size
      t.string :additional_detail
      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by


      t.timestamps
    end
  end
end
