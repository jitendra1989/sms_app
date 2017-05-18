class CreateMgCanteenMeals < ActiveRecord::Migration
  def change
    create_table :mg_canteen_meals do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :mg_day_id
      t.integer :mg_meal_category_id
      t.integer :mg_food_item_id
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
