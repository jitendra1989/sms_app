class CreateMgBoosterDoseDetails < ActiveRecord::Migration
  def change
    create_table :mg_booster_dose_details do |t|
    	t.integer :mg_booster_dose_id
    	t.integer :mg_student_id
		t.integer :mg_batch_id
		t.integer :mg_time_table_id
    	t.date :date
      	t.integer :mg_school_id
      	t.boolean :is_deleted
      	t.integer :created_by
      	t.integer :updated_by
        t.timestamps
    end
  end
end
