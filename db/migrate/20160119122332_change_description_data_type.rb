class ChangeDescriptionDataType < ActiveRecord::Migration
  def change
  	change_column :mg_fee_categories, :description, :text
  end
end
