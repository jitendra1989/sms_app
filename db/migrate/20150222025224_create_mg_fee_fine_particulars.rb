class CreateMgFeeFineParticulars < ActiveRecord::Migration
  def change
    create_table :mg_fee_fine_particulars do |t|
      t.string :fine_name
      t.text :description
      t.string :fine_from
      t.float :amount
      t.integer :mg_batch_id
      t.integer :mg_student_category_id
      t.integer :mg_student_id

      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
