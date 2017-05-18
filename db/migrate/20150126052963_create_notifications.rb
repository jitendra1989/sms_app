class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :mg_notifications do |t|
		t.integer :from_user_id
		t.integer :to_user_id
		t.string :subject
		t.string :description
		t.boolean :status
		

	    # Audit fields 	
	    t.boolean :is_deleted
	    t.integer :mg_school_id
	    t.integer :created_by
	    t.integer :updated_by
	    t.timestamps
    end
  end
end
