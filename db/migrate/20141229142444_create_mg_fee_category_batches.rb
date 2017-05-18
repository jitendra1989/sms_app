class CreateMgFeeCategoryBatches < ActiveRecord::Migration
  def change
    create_table :mg_fee_category_batches do |t|
      t.integer :mg_batch_id
      t.integer :mg_fee_id

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
