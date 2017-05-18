class CreateMgPollOptionAlumnis < ActiveRecord::Migration
  def change
    create_table :mg_poll_option_alumnis do |t|
      t.integer :mg_alumni_polling_id
      t.string :paticular
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
