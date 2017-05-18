class CreateMgCanteens < ActiveRecord::Migration
  def change
    create_table :mg_canteens do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
