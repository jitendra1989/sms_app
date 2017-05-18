class CreateMgObservations < ActiveRecord::Migration
  def change
    create_table :mg_observations do |t|
      t.string :name
      t.string :description
      t.integer :mg_observation_group_id
      t.integer :sort_order

      #audit field
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :updated_by
      t.integer :created_by

      t.timestamps
    end
  end
end
