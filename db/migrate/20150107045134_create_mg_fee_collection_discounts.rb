class CreateMgFeeCollectionDiscounts < ActiveRecord::Migration
  def change
    create_table :mg_fee_collection_discounts do |t|
      t.string :mg_discount_type
      t.string :mg_discount_name
      t.integer :mg_discount_receiver_id
      t.integer :mg_fee_collection_id
      t.string :mg_discount
      t.boolean :is_percent

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
