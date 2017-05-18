class CreateMgFeeCollections < ActiveRecord::Migration
  def change
    create_table :mg_fee_collections do |t|
      t.string :name
      t.integer :mg_fee_category_id
      t.integer :mg_batch_id
      t.integer :mg_fine_id
      t.date :start_date
      t.date :end_date
      t.date :due_date

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
