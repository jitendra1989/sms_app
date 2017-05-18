class CreateMgGroupedBatches < ActiveRecord::Migration
  def change
    create_table :mg_grouped_batches do |t|
      t.integer :mg_batch_group_id
      t.integer :mg_batch_id
      t.integer :mg_school_id
      t.integer :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
