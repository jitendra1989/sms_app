class CreateMgPhones < ActiveRecord::Migration
  def change
    create_table :mg_phones do |t|
      t.string :phone_number
      t.string :phone_type
      t.boolean :notification
      t.boolean :subscription
      t.integer :mg_user_id
      # User type

      
      #Audit fields
        t.boolean :is_deleted
        t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      
      t.timestamps
    end
  end
end
