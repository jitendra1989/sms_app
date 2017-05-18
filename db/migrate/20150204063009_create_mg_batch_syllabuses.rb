class CreateMgBatchSyllabuses < ActiveRecord::Migration
  def change
    create_table :mg_batch_syllabuses do |t|
      t.integer :mg_syllabus_id
      t.references :mg_batch, index: true

      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
