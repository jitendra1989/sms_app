class CreateMgMasterPaymentTypes < ActiveRecord::Migration
  def change
    create_table :mg_master_payment_types do |t|
      t.string :name
      t.text :description
      t.integer :mg_account_id
      t.boolean :is_to_central
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
