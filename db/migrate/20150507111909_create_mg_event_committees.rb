class CreateMgEventCommittees < ActiveRecord::Migration
  def change
    create_table :mg_event_committees do |t|
      t.string :committee_name
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
