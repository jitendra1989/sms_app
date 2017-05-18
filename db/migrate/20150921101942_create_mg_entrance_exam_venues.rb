class CreateMgEntranceExamVenues < ActiveRecord::Migration
  def change
    create_table :mg_entrance_exam_venues do |t|
      
      t.text :exam_venue
      t.string :institute_name
      t.integer :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by 

      t.timestamps
    end
  end
end

