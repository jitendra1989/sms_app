class CreateMgSportsFines < ActiveRecord::Migration
  def change
    create_table :mg_sports_fines do |t|
      t.string :fine_name
      t.text :description
      t.integer :mg_account_id
      t.integer :amount
      t.integer :mg_batches_id
      t.integer :mg_student_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
