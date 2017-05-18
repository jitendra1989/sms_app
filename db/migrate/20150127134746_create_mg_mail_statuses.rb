class CreateMgMailStatuses < ActiveRecord::Migration
  def change
    create_table :mg_mail_statuses do |t|

      t.integer :status_code
      t.string  :email_addrs_to
      t.string  :email_addrs_by
      t.string  :email_subject
      t.string  :email_server_description

	    # Audit fields 	
	    t.boolean :is_deleted
	    t.integer :mg_school_id
	    t.integer :created_by
	    t.integer :updated_by

      t.timestamps
    end
  end
end
