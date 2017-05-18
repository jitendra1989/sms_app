class CreateMgPollOptionAlumniParticulars < ActiveRecord::Migration
  def change
    create_table :mg_poll_option_alumni_particulars do |t|
      t.integer :mg_poll_option_alumni_id
      t.string :paticular
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
