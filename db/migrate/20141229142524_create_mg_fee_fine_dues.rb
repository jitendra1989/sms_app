class CreateMgFeeFineDues < ActiveRecord::Migration
  def change
    create_table :mg_fee_fine_dues do |t|
    	t.integer :mg_fee_fine_id
      t.string :days_after_due_date
      t.string :amount
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
