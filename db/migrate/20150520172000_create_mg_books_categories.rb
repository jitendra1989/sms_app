class CreateMgBooksCategories < ActiveRecord::Migration
  def change
    create_table :mg_books_categories do |t|
      t.string :category_name
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
