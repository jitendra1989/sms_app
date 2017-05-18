class CreateMgFeeParticulars < ActiveRecord::Migration
  def change
    create_table :mg_fee_particulars do |t|

      t.string :fee_category
      t.string :name
      t.string :description
      t.date :start_date
      t.date :end_date
      t.date :due_date
      t.string :amount
      
#      t.string :category
      t.integer :mg_batch_id
      t.integer :mg_particular_type_id

      t.string :admission_no
      t.integer :mg_student_category_id	

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
