class CreateMgHostelDetails < ActiveRecord::Migration
  def change
    create_table :mg_hostel_details do |t|
      t.string :name
      t.text :description
      t.string :category
      t.integer :total
      t.integer :occupancy
      t.integer :availability
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_deleted
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
