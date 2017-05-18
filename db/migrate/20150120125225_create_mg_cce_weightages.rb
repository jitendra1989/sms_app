class CreateMgCceWeightages < ActiveRecord::Migration
  def change
    create_table :mg_cce_weightages do |t|
      t.string :weightages
      t.string :criteria_type
      t.integer :mg_cce_exam_category_id

      #audit field
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
