class RenameParticularInMgCheckupTypeParticular < ActiveRecord::Migration
  def change
  	rename_column :mg_checkup_particulars ,:particular, :particulars
  end
end
