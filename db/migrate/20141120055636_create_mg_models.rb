class CreateMgModels < ActiveRecord::Migration
  def change
    create_table :mg_models do |t|

      t.string :model_name
    	t.integer :index
    	t.string :description
    	# Audit fields
     #  t.boolean :is_deleted
     #  t.integer :mg_school_id
    	# t.integer :created_by
    	# t.integer :updated_by

      t.timestamps
    end
  end
end
