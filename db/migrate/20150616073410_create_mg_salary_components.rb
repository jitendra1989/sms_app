class CreateMgSalaryComponents < ActiveRecord::Migration
  def change
    create_table :mg_salary_components do |t|
      t.string :name
      t.boolean :is_deduction
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
