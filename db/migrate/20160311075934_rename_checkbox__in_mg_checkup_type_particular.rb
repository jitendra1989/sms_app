class RenameCheckboxInMgCheckupTypeParticular < ActiveRecord::Migration
  def change
  	rename_column :mg_checkup_particulars ,:checkbox, :show_in_healthcard
  end
end
