class MgFinanceFee < ActiveRecord::Base
	belongs_to :mg_fee_collection
	belongs_to :mg_student #mg_finance_fees.student_id = mg_students.id
	belongs_to :mg_school

    has_many :mg_finance_transactions

end
