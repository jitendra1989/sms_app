class AddMgCanteenIdToMgCanteenMeal < ActiveRecord::Migration
  def change
    add_column :mg_canteen_meals, :mg_canteen_id, :integer
  end
end
