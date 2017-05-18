class CreateMgEntranceExamDetails < ActiveRecord::Migration
  def change
    create_table :mg_entrance_exam_details do |t|

    	t.integer :mg_course_id
    	t.date :start_date
    	t.time :start_time
    	t.time :end_time
    	t.string :exam_venue

    	t.integer :is_deleted
    	t.integer :mg_school_id
    	t.integer :created_by
    	t.integer :updated_by    	

      t.timestamps
    end
  end
end

