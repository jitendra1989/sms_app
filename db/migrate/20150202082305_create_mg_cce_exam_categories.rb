class CreateMgCceExamCategories < ActiveRecord::Migration
  def change
    create_table :mg_cce_exam_categories do |t|
      t.string :name
      t.string :description

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :updated_by
      t.integer :created_by

      t.timestamps
    end
  end
end
