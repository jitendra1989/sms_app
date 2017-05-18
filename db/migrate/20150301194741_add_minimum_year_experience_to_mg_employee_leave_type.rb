class AddMinimumYearExperienceToMgEmployeeLeaveType < ActiveRecord::Migration
  def change
    add_column :mg_employee_leave_types, :minimum_year_experience, :integer
    add_column :mg_employee_leave_types, :minimum_month_experience, :integer
    add_column :mg_employee_leave_types, :gender, :string
    add_column :mg_employee_leave_types, :is_leave_should_not_be_deducted, :boolean
  end
end
