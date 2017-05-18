class CreateMgGradingLevels < ActiveRecord::Migration
  def change
    create_table :mg_grading_levels do |t|
      t.string :name
      t.integer :mg_batch_id
      t.string :min_score
      t.string :order
      t.string :credit_points
      t.string :description
      
      #Audit fields
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
