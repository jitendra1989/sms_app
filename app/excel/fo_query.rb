class FoQuery
def initialize(mg_school_id, arr)
		puts "so what?????"
		puts arr.inspect
		@school=MgSchool.find(mg_school_id)
	    @@school_logo=@school.logo.url(:medium, timestamp: false)
	   excel(mg_school_id, arr)
	end
	
	def excel(mg_school_id, arr)
		puts "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
		puts arr
		puts "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
		workbook  = WriteXLSX.new(File.join(Rails.root, "public/xlsx_files", "foquery.xlsx"))
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
	    headings = ['Query Details', '']
	    w.write_row('E1', headings, heading)

	    school_name_headings = [@school.try(:school_name), "","","","",""]
	    w.write_row('B3', school_name_headings, text_format)
	    

	    headings = ['Query Details', '','','','','',"",""]
	    w.write_row('A6', headings, heading_center_title)
	    coloum_no_h=0
	
		    puts "schoollllllllllllllllllllllllllllllll"
		    puts mg_school_id
		    puts "schoollllllllllllllllllllllllllllllll"
       @query_record=MgQueryRecord.where("is_deleted=? and mg_school_id=? and id IN (?)",0,mg_school_id,arr.split(','))
       puts "=============================================="
      	puts @query_record.inspect
       puts "=============================================="
	    coloum_no_d=1
	    table_data=[]
	    count=0
	    # ======================================?
	    @query_record.each do |info|
	      coloumn_count_d=0
	      # item=MgInventoryItem.find_by(:id=>info.mg_item_id)
	      # unit_item=MgLabUnit.find_by(:id=>info.mg_unit_type_id)
	      table_data.push([count+=1,info.try(:query_number), info.try(:caller_name) ,info.try(:phone_number),info.try(:query),info.try(:response_given),info.try(:follow_up_action), ""])
	    end
	    # ======================================?

	    w.add_table(
		    "A18:H#{6+table_data.size}",
		    {
		        :data    => table_data,
		        :columns => [
		        	{ :header => 'Sr. No' },
		            { :header => 'Query Number' },
		            { :header => 'Caller Name' },
		            { :header => 'Phone Number' },
		            { :header => 'Query' },
		            { :header => 'Response Given' },
		            { :header  => 'Follow Up Action'},
		            { :header  => 'Action Required'}
		        ],
		        :autofilter => 10

		    }
		)

	    workbook.close
	    puts "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
	end

end