class MgFinanceTransactionDetail < ActiveRecord::Base
		belongs_to :mg_fee_collection,:polymorphic=>true
		delegate :name,:to => :mg_fee_collection
		# delegate :id,:to => :mg_fee_collection
		belongs_to :mg_fee_particular
		belongs_to :mg_fee_collection_discount
		delegate :mg_discount_name,:to => :mg_fee_collection_discount

		def particular_name
			
		end

		def collection_discount_name
			"#{mg_discount_name}"
		end
		
		def collection_name

			name=MgFeeCollection.find(mg_collection_id)
				"#{name.name}"
		end	
end
