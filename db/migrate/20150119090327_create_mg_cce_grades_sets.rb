class CreateMgCceGradesSets < ActiveRecord::Migration
  def change
    create_table :mg_cce_grades_sets do |t|
      t.string :name

      #audit field are required
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by


      t.timestamps
    end
  end
end
