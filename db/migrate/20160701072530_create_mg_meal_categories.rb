class CreateMgMealCategories < ActiveRecord::Migration
  def change
    create_table :mg_meal_categories do |t|
      t.string :name
      t.integer :priority
      t.text :description

      t.integer :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id
      t.timestamps
    end
  end
end
