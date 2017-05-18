class AddMgEmployeeIdToMgBooksTransaction < ActiveRecord::Migration
  def change
    add_column :mg_books_transactions, :mg_employee_id, :integer
  end
end
