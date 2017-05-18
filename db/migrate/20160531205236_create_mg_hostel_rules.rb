class CreateMgHostelRules < ActiveRecord::Migration
  def change
    create_table :mg_hostel_rules do |t|
      t.integer :mg_hostel_details_id
      t.string :name
      t.text :description
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
