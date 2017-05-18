class CreateMgPlacementStudentDetails < ActiveRecord::Migration
  def change
    create_table :mg_placement_student_details do |t|
      t.string :name
      t.string :resume_headline
      t.string :current_position
      t.date :date_of_birth
      t.string :last_degree
      t.string :year_of_passing
      t.string :functional_area
      t.string :educational_qualification
      t.integer :experience
      t.text :technical_skills
      t.text :soft_skills
      t.integer :salary_expected
      t.text :address
      t.integer :contact_number
      t.string :email_id
      t.string :current_location
      t.string :preferred_location
      t.integer :mg_student_id
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted


      t.timestamps
    end
  end
end
