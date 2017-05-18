class AddDueDateToMgFeeFineParticular < ActiveRecord::Migration
  def change
    add_column :mg_fee_fine_particulars, :due_date, :date
  end
end
