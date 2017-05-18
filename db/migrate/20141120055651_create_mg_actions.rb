class CreateMgActions < ActiveRecord::Migration
  def change
    create_table :mg_actions do |t|
    	t.string :action_name
    	t.string :description

    	#Audit fields
     #  t.boolean :is_deleted
     #  t.integer :mg_school_id
    	# t.integer :created_by
    	# t.integer :updated_by
      t.timestamps
    end
  end
end
