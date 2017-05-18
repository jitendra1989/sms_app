class CreateMgLabs < ActiveRecord::Migration
  def change
    create_table :mg_labs do |t|
      t.string :lab_name
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
