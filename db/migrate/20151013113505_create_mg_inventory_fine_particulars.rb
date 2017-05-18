class CreateMgInventoryFineParticulars < ActiveRecord::Migration
  def change
    create_table :mg_inventory_fine_particulars do |t|
      t.string :fine_name
      t.text :description
      t.integer :amount
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
