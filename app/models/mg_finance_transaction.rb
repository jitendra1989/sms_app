class MgFinanceTransaction < ActiveRecord::Base
	belongs_to :mg_student
	belongs_to :mg_finance_fee# mg_finance_transactions.finance_fee_id = mg_finance_fees.id

	belongs_to :mg_fee_category
	belongs_to :mg_school

	# for below comment association i didnot fount any specific tbl
	# belongs_to :mg_master_transaction
	# belongs_to :mg_finance
	# belongs_to :mg_payee
end
