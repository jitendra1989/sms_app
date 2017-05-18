class CreateMgStudentScholarships < ActiveRecord::Migration
  def change
    create_table :mg_student_scholarships do |t|
      t.integer :mg_user_id
      t.string :name
      t.string :amount
      t.string :frequency
      t.date :start_date
      t.date :end_date

      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
