class CreateInventoryStackManagements < ActiveRecord::Migration
  def change
    create_table :inventory_stack_managements do |t|
      t.string :room_no
      t.string :rack_no
      t.string :first_letter_of_title
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
