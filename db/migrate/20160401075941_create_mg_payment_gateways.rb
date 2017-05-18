class CreateMgPaymentGateways < ActiveRecord::Migration
  def change
    create_table :mg_payment_gateways do |t|
      t.integer :mg_master_payment_type_id
      t.integer :mg_wing_id
      t.string :time_table_year
      t.integer :mg_employee_specialization_id
      t.integer :mg_alumni_id
      t.float :amount
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :upated_by
      t.integer :mg_finance_fee_id

      t.timestamps
    end
  end
end
