class RenameFirstLetterOfTitleToPrefixInItemStackManagement < ActiveRecord::Migration
  def change
  	rename_column :inventory_stack_managements, :first_letter_of_title, :prefix
  end
end
