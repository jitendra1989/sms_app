class CreateMgFeeDiscounts < ActiveRecord::Migration
  def change
    create_table :mg_fee_discounts do |t|

      t.string :discount_type
      t.string :name
      t.integer :mg_receiver_id
      t.integer :mg_batch_id
      t.integer :mg_fee_category_id
      t.string :discount
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
