class CreateMgObservationGroups < ActiveRecord::Migration
  def change
    create_table :mg_observation_groups do |t|
      t.string :name
      t.string :header_name
      t.string :description
      t.integer :mg_cce_grades_set_id
      t.integer :observation_kind
      t.string :max_marks_float

      #audit field
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
