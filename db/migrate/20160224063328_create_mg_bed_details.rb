class CreateMgBedDetails < ActiveRecord::Migration
  def change
    create_table :mg_bed_details do |t|

      t.integer :bed_no
      t.text :description
      t.string :status
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
