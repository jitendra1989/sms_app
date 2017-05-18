class CreateMgCallerCategoryFoms < ActiveRecord::Migration
  def change
    create_table :mg_caller_category_foms do |t|
      t.string :name
      t.text :description
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
