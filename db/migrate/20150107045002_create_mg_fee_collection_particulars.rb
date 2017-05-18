class CreateMgFeeCollectionParticulars < ActiveRecord::Migration
  def change
    create_table :mg_fee_collection_particulars do |t|
      t.string :mg_fee_particular_name
      t.string :mg_fee_particular_description
      t.string :mg_fee_particular_amount
      t.integer :mg_fee_collection_id
      t.integer :mg_student_category_id
      t.string :mg_student_admission_number
      t.integer :mg_student_id

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
