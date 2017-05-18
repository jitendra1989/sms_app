class CreateMgAddReports < ActiveRecord::Migration
  def change
    create_table :mg_add_reports do |t|
      t.integer :mg_vehicle_id
      t.integer :mg_report_type_id
      t.integer :entered_by
      t.date :valid_from
      t.date :valid_to
      t.text :comments
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.string :vendor_name
      t.float :amount
      t.date :payment_date
      t.integer :mg_payment_type_id
      t.boolean :is_payment_made
      t.timestamps
    end
  end
end
