class CreateMgGradeComponents < ActiveRecord::Migration
  def change
    create_table :mg_grade_components do |t|
      t.integer :mg_employee_grade_id
      t.integer :mg_salary_component_id
      t.float :amount
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
