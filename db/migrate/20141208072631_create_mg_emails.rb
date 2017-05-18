class CreateMgEmails < ActiveRecord::Migration
  def change
    create_table :mg_emails do |t|

      t.string :mg_email_id
      t.string :email_type
      t.boolean :notification
      t.boolean :subscription
      t.integer :mg_user_id
      # user type
      
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
