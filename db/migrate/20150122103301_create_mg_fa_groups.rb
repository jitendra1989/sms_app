class CreateMgFaGroups < ActiveRecord::Migration
  def change
    create_table :mg_fa_groups do |t|
      t.string :name
      t.string :description
      t.integer :mg_cce_exam_category_id
      t.integer :mg_cce_grades_set_id
      t.float :max_marks

      #audit field
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
