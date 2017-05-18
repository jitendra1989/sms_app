class AddEndDateToMgFeeFineParticular < ActiveRecord::Migration
  def change
    add_column :mg_fee_fine_particulars, :end_date, :date
  end
end
