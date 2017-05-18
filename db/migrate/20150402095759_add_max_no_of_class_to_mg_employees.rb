class AddMaxNoOfClassToMgEmployees < ActiveRecord::Migration
  def change
    add_column :mg_employees, :max_no_of_class, :integer
  end
end
