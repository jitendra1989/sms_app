class CreateMgSportsPayDeductiionLists < ActiveRecord::Migration
  def change
    create_table :mg_sports_pay_deductiion_lists do |t|
      t.integer :mg_pay_deduction_details_id
      t.integer :mg_employee_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
