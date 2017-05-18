class CreateMgCheckupParticulars < ActiveRecord::Migration
  def change
    create_table :mg_checkup_particulars do |t|
      t.string :particular
      t.string :applicable
      t.boolean :checkbox
      t.string :mg_checkup_type_id
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
