class CreateMgUsers < ActiveRecord::Migration
  def change
    create_table :mg_users do |t|
      t.string :user_name
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email
      t.string :hashed_password
      t.string :salt
      t.string :reset_password_code
      t.datetime :reset_password_code_until
      
      t.string :user_type
     
      
     # <!-- Audit Fields -->
      t.boolean :is_deleted
     t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by


      t.timestamps
    end
  end
end
