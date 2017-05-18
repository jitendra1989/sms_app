class AddMgFeeCategoryIdToMgSchool < ActiveRecord::Migration
  def change
    add_column :mg_schools, :mg_fee_category_id, :integer
  end
end
