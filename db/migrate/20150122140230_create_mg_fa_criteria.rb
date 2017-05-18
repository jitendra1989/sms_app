class CreateMgFaCriteria < ActiveRecord::Migration
  def change
    create_table :mg_fa_criteria do |t|
      t.string :fa_name
      t.string :description
      t.integer :mg_fa_group_id
      t.integer :sort_order

      #audit field
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
