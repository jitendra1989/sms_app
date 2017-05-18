class CreateMgResourcePurchases < ActiveRecord::Migration
  def change
    create_table :mg_resource_purchases do |t|
      t.string :vendor_name
      t.date :date_of_purchase
      t.float :amount_paid
      t.string :invoice_number
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
