class CreateMgGuests < ActiveRecord::Migration
  def change
    create_table :mg_guests do |t|
      t.string :guest_name
      t.string :guest_details
      t.string :mobile_no
      t.string :email_id
      t.string :status
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
