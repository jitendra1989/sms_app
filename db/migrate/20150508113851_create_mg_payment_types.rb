class CreateMgPaymentTypes < ActiveRecord::Migration
  def change
    create_table :mg_payment_types do |t|
      t.string :payment_type_name
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
