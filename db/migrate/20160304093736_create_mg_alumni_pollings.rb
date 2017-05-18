class CreateMgAlumniPollings < ActiveRecord::Migration
  def change
    create_table :mg_alumni_pollings do |t|
      t.text :question
      t.text :description
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
