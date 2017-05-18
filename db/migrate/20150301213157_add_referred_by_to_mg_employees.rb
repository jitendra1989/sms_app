class AddReferredByToMgEmployees < ActiveRecord::Migration
  def change
    add_column :mg_employees, :referred_by, :string
  end
end
