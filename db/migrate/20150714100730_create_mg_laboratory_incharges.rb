class CreateMgLaboratoryIncharges < ActiveRecord::Migration
  def change
    create_table :mg_laboratory_incharges do |t|
      t.integer :mg_employee_id
      t.string :incharge_type
      t.integer :mg_subject_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
