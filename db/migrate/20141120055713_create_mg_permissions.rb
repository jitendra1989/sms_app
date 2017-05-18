class CreateMgPermissions < ActiveRecord::Migration
  def change
    create_table :mg_permissions do |t|

    	t.integer 'mg_model_id'
    	t.integer 'mg_action_id'
    	
    	# Audit fields
     #  t.boolean 'is_deleted'
     #  t.integer 'mg_school_id'
    	# t.integer 'created_by'
    	# t.integer 'updated_by'


      t.timestamps
    end
  end
end
