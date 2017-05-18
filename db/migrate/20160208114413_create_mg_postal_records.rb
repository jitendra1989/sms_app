class CreateMgPostalRecords < ActiveRecord::Migration
  def change
    create_table :mg_postal_records do |t|
      t.string :recipient_name
      t.text :address
      t.string :dispatch_number
      t.string :transaction_flow
      t.date :received_date
      t.string :mode_of_dispatch
      t.string :category
      t.string :dispatcher
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end

