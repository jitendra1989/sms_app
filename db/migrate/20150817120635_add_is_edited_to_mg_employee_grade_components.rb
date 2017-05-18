class AddIsEditedToMgEmployeeGradeComponents < ActiveRecord::Migration
  def change
    add_column :mg_employee_grade_components, :is_edited, :boolean
  end
end
