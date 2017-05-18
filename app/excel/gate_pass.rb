class GatePass < WriteXLSX

	def initialize(mg_school_id, mg_inventory_proposal_id,mg_vendor_id,mg_inventory_proposal_item_id)
		puts "so what?????"
		puts mg_inventory_proposal_item_id.inspect
		@school=MgSchool.find(mg_school_id)
	    @@school_logo=@school.logo.url(:medium, timestamp: false)
	    @item_information_details=MgInventoryProposalItem.where(:id=>mg_inventory_proposal_item_id.to_s.split(","),:is_deleted=>0,:mg_inventory_proposal_id=>mg_inventory_proposal_id,:mg_school_id=>mg_school_id, :mg_inventory_vendor_id=>mg_vendor_id)
	    @mg_inventory_vendor_items=MgInventoryVendorItem.find_by(@item_information_details[0].mg_item_id)
	    @vendors=MgInventoryVendor.find_by(:id=>mg_vendor_id, :is_deleted=>0, :mg_school_id=>mg_school_id)
		gate_pass_excel
	end
	
	def gate_pass_excel

		workbook  = WriteXLSX.new(File.join(Rails.root, "public/xlsx_files", "gate_pass.xlsx"))
	    w = workbook.add_worksheet
	    heading = workbook.add_format(:align => 'center', :bold => 1)
	    heading_center = workbook.add_format(:align => 'center', :bold => 1, :fg_color=>'silver')
	    heading_center_title = workbook.add_format(:align => 'center', :bold => 1, :fg_color=>'silver', :size=>'16')
	    heading_left = workbook.add_format(:align => 'left', :bold => 1)
	    heading_value = workbook.add_format(:align => 'left')
	    school_name = workbook.add_format(:align => 'left', :bold => 1, :size=>'16')
	    w.set_column(0, 0, 23)
	    w.set_column(1, 100, 20)
	    w.set_row(2, 40)
	    w.set_row(5, 30)
	    w.set_row(17, 25)


	    text_format = workbook.add_format(
	        :bold   => 1,
	        # :italic => 1,
	        :color  => 'blue',
	        # :fg_color=>'blue',
	        :size   => 16,
	        :font   => 'Lucida Calligraphy'
	    )
	    text_format1= workbook.add_format(
	        :bold   => 1,
	        # :italic => 1,
	        # :color  => 'red',
	        :size   => 14,
	        :font   => 'Lucida Calligraphy'
	    )
	    w.insert_image(1, 0, File.exists?("#{Rails.root}/public/#{@@school_logo}") ? "#{Rails.root}/public/#{@@school_logo}" : File.join(Rails.root, "app/assets/images", "logo.jpg"), x=0, y=0, x_scale=0.4, y_scale=0.4)
	    headings = ['Gate Pass', '']
	    w.write_row('E1', headings, heading)

	    school_name_headings = [@school.try(:school_name), "","","","",""]
	    w.write_row('B3', school_name_headings, text_format)
	    

	    headings = ['Vendor Details', '','','','','',""]
	    w.write_row('A6', headings, heading_center_title)
	    coloum_no_h=0
		    w.write(7, coloum_no_h, 'Vendor Name',heading_left)
		    w.write(8, coloum_no_h, 'Vendor Code',heading_left)
		    w.write(9, coloum_no_h, 'Contact Person',heading_left)
		    w.write(10, coloum_no_h, 'Street Address',heading_left)
		    w.write(11, coloum_no_h, 'City',heading_left)
		    w.write(12, coloum_no_h, 'State',heading_left)
		    w.write(13, coloum_no_h, 'Pincode',heading_left)
		    w.write(14, coloum_no_h, 'Country',heading_left)
		    w.write(15, coloum_no_h, 'Phone Number',heading_left)
		    w.write(16, coloum_no_h, 'Fax Number',heading_left)
		    w.write(16, coloum_no_h, 'email id',heading_left)
		    w.write(16, coloum_no_h, 'Information',heading_left)

	    coloum_no_d=1
		    w.write(7, coloum_no_d, @vendors.try(:name).try(:capitalize))
		    w.write(8, coloum_no_d, @vendors.try(:vendor_code))
		    w.write(9, coloum_no_d, @vendors.try(:contact_name).try(:capitalize))
		    w.write(10, coloum_no_d, @vendors.try(:street_address).try(:capitalize))
		    w.write(11, coloum_no_d, @vendors.try(:city).try(:capitalize))
		    w.write(12, coloum_no_d, @vendors.try(:state).try(:capitalize))
		    w.write(13, coloum_no_d, @vendors.try(:postal_code).try(:capitalize))
		    w.write(14, coloum_no_d, @vendors.try(:country).try(:capitalize))
		    w.write(15, coloum_no_d, @vendors.try(:phone_number).try(:capitalize))
		    w.write(16, coloum_no_d, @vendors.try(:fax_number).try(:capitalize))
		    w.write(16, coloum_no_d, @vendors.try(:email).try(:capitalize))
		    w.write(16, coloum_no_d, @vendors.try(:information).try(:capitalize))

	    table_data=[]
	    count=0
	    @item_information_details.each do |info|
	      coloumn_count_d=1
	      item=MgInventoryItem.find_by(:id=>info.mg_item_id)
	      unit_item=MgLabUnit.find_by(:id=>info.mg_unit_type_id)
	      table_data.push([count+=1,item.present? ? item.try(:name) : "No Data",unit_item.present? ? unit_item.try(:unit_name) : "No Data",info.try(:no_of_unit).present? ?  info.try(:no_of_unit): "No Data","","",""])
	    end

	    w.add_table(
		    "A18:G#{18+table_data.size}",
		    {
		        :data    => table_data,
		        :columns => [
		        	{ :header => 'Sr. No' },
		            { :header => 'Item Name' },
		            { :header => 'Unit Type' },
		            { :header => 'Units' },
		            { :header => 'Supply Units' },
		            { :header => 'Cost/Unit' },
		            { :header  => 'Total'}
		        ],
		        :autofilter => 10

		    }
		)

	    workbook.close
	end
end 