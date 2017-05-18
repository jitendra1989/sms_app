class AddDesignationToMgEmployees < ActiveRecord::Migration
  def change
    add_column :mg_employees, :designation, :string
  end
end
