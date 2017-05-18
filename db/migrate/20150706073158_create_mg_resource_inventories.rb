class CreateMgResourceInventories < ActiveRecord::Migration
  def change
    create_table :mg_resource_inventories do |t|
      t.integer :mg_resource_category_id
      t.integer :mg_resource_type_id
      t.string :resource_number
      t.string :name
      t.string :author
      t.string :volume
      t.string :year
      t.string :publication
      t.integer :isbn
      t.integer :mg_course_id
      t.integer :mg_subject_id
      t.string :stack_reference
      t.float :cost
      t.boolean :non_issuable
      t.boolean :is_damaged
      t.boolean :is_lost
      t.string :status
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
