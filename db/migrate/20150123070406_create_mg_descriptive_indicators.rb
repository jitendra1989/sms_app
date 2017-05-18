class CreateMgDescriptiveIndicators < ActiveRecord::Migration
  def change
    create_table :mg_descriptive_indicators do |t|
      t.string :name
      t.string :description
      t.integer :mg_fa_criteria_id
      t.string :describable_type
      t.integer :describable_id
      t.integer :sort_order
      t.integer :describable_id

      #audit field
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
