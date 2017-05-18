class CreateMgFaqCategories < ActiveRecord::Migration
  def change
    create_table :mg_faq_categories do |t|
      t.string :category_name
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
