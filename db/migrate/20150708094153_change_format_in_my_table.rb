class ChangeFormatInMyTable < ActiveRecord::Migration
  def change
    change_column :mg_books_transactions, :amount, :float
    change_column :mg_books_transactions, :no_of_days_delayed, :integer
  end
end
