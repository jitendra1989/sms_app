class AddbenificiarydetailsToMgPostalRecord < ActiveRecord::Migration
  def change
  	add_column :mg_postal_records, :user_type, :string
    add_column :mg_postal_records, :mg_batch_id, :integer
    add_column :mg_postal_records, :mg_student_id, :integer
    add_column :mg_postal_records, :mg_employee_department_id, :integer
    add_column :mg_postal_records, :mg_employee_id, :integer
  end
end
