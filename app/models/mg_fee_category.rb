class MgFeeCategory < ActiveRecord::Base
	belongs_to :mg_school

    has_many :mg_fee_discounts
    has_many :mg_finance_transactions
	has_many :mg_fee_collections
	has_many :mg_fee_category_batches,:dependent => :destroy
  	accepts_nested_attributes_for :mg_fee_category_batches

  	has_many :mg_fee_particulars,:dependent => :destroy
  	accepts_nested_attributes_for :mg_fee_particulars
end
