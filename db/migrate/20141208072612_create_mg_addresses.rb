class CreateMgAddresses < ActiveRecord::Migration
  def change
    create_table :mg_addresses do |t|
      t.string :address_line1 #4
      t.string :address_line2#5
      t.string :address_type #3
      t.string :street #3
      #6 street
      #last landmark
      t.string :landmark
      
      t.string :city
      t.string :state
      t.string :country
      t.string :pin_code
      t.integer :country_code
     
      t.integer :mg_user_id #1
      # 2 user type will also come
      
      t.boolean :notification
      t.boolean :subscription

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by


      t.timestamps
    end
  end
end
