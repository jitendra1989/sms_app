class CreateMgGetTogethers < ActiveRecord::Migration
  def change
    create_table :mg_get_togethers do |t|
      t.integer :mg_alumni_get_together_id
      t.integer :mg_alumni_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
