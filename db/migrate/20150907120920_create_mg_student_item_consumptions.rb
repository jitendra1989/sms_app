class CreateMgStudentItemConsumptions < ActiveRecord::Migration
  def change
    create_table :mg_student_item_consumptions do |t|
      t.integer :mg_student_id
      t.integer :mg_course_id
      t.integer :mg_batch_id
      t.integer :mg_item_consumption_id
      t.string :consumption_type
      t.integer :mg_item_id
      t.string :quantity_consumption
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
