class CreateMgAddressBookFoms < ActiveRecord::Migration
  def change
    create_table :mg_address_book_foms do |t|
      t.string :name
      t.text :Address
      t.string :contact_number
      t.integer :mg_designation_fom_id
      t.string :email_id
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
