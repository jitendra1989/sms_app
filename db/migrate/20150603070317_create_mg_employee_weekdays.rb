class CreateMgEmployeeWeekdays < ActiveRecord::Migration
  def change
    create_table :mg_employee_weekdays do |t|
      t.integer :weekday
      t.string  :name
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
