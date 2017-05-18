class CreateMgWeekdays < ActiveRecord::Migration
  def change
    create_table :mg_weekdays do |t|
      t.integer :mg_batch_id
      t.integer :mg_wing_id
      t.string :weekday
      t.string :name
      t.integer :sort_order
      t.integer :day_of_week

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      
      t.timestamps
    end
  end
end
