class CreateMgTopics < ActiveRecord::Migration
  def change
    create_table :mg_topics do |t|
      t.integer :mg_unit_id
      t.integer :mg_syllabus_id
      t.string :topic_name
      t.text :description

      
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
