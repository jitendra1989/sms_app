class CreateMgMultiSchoolAccesses < ActiveRecord::Migration
  def change
    create_table :mg_multi_school_accesses do |t|
      t.integer :mg_user_id
      
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
