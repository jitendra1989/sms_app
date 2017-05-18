class ChangeDescriptionDataTypeInFeeFine < ActiveRecord::Migration
  def change
  	change_column :mg_fee_fines, :fine_description, :text
  end
end
