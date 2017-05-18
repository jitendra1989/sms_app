class CreateMgWings < ActiveRecord::Migration
  def change
    create_table :mg_wings do |t|
      t.string :wing_name
      t.boolean :status

      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
