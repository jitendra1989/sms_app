class MgFeeCollection < ActiveRecord::Base

	belongs_to :mg_fee_category
	belongs_to :mg_batch
	belongs_to :mg_fee_fine #mg_fee_collections.mg_fine_id = mg_fee_fines.id
	belongs_to :mg_school


	has_many :mg_fee_collection_particulars , :dependent => :destroy
    accepts_nested_attributes_for :mg_fee_collection_particulars

    has_many :mg_fee_collection_discounts , :dependent => :destroy
    accepts_nested_attributes_for :mg_fee_collection_discounts

    has_many :mg_finance_fees , :dependent => :destroy
    accepts_nested_attributes_for :mg_finance_fees
end
