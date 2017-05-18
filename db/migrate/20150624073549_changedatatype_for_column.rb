class ChangedatatypeForColumn < ActiveRecord::Migration
  def change
  	change_column :mg_books_inventories, :book_no, :string
  end
end
