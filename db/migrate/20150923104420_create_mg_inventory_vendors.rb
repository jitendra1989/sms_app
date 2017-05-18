class CreateMgInventoryVendors < ActiveRecord::Migration
  def change
    create_table :mg_inventory_vendors do |t|
      t.string :category
      t.string :name
      t.string :contact_name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :postal_code
      t.string :country
      t.string :phone_number
      t.string :fax_number
      t.string :email
      t.text :information
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
