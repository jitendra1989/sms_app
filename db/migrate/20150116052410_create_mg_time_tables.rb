class CreateMgTimeTables < ActiveRecord::Migration
  def change
    create_table :mg_time_tables do |t|
      t.string :name
      t.date :start_date
      
      #Audit fields
      t.date :end_date
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
