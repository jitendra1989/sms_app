class CreateMgResourceInformations < ActiveRecord::Migration
  def change
    create_table :mg_resource_informations do |t|
      t.integer :mg_resource_category_id
      t.integer :mg_resource_type_id
      t.string :name
      t.string :author
      t.string :volume
      t.integer :year
      t.string :publication
      t.string :isbn
      t.integer :mg_course_id
      t.integer :mg_subject_id
      t.float :cost
      t.integer :no_of_copy
      t.float :total
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
