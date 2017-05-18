class CreateMgAllergies < ActiveRecord::Migration
  def change
    create_table :mg_allergies do |t|
      t.integer :mg_batch_id
      t.integer :mg_student_id
      t.integer :mg_employee_department_id
      t.integer :mg_employee_id
      t.string :name
      t.text :description
      t.string :status
      t.text :medication_detail
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
