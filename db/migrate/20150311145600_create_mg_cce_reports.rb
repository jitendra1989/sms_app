class CreateMgCceReports < ActiveRecord::Migration
  def change
    create_table :mg_cce_reports do |t|
      t.integer :mg_student_id
      t.integer :mg_batch_id

      t.timestamps
    end
  end
end
