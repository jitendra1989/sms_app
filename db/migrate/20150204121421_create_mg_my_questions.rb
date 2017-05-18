class CreateMgMyQuestions < ActiveRecord::Migration
  def change
    create_table :mg_my_questions do |t|
      t.string :title
      t.text :content
      t.integer :mg_employee_id


      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
