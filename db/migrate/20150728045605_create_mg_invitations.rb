class CreateMgInvitations < ActiveRecord::Migration
  def change
    create_table :mg_invitations do |t|
      t.boolean :employee
      t.boolean :guardian
      t.boolean :student
      t.integer :mg_batch_id
      t.integer :mg_employee_department_id
      t.integer :mg_event_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
