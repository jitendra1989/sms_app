class CreateMgInventoryProposalItems < ActiveRecord::Migration
  def change
    create_table :mg_inventory_proposal_items do |t|
      t.integer :mg_inventory_proposal_id
      t.integer :mg_item_id
      t.integer :mg_unit_type_id
      t.integer :no_of_unit
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
