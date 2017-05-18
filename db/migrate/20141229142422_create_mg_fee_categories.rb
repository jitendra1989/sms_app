class CreateMgFeeCategories < ActiveRecord::Migration
  def change
    create_table :mg_fee_categories do |t|

      t.string :name
      t.string :description
    #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
