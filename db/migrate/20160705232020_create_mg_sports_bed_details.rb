class CreateMgSportsBedDetails < ActiveRecord::Migration
  def change
    create_table :mg_sports_bed_details do |t|
      t.string :bed_no
      t.text :description
      t.string :status
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
