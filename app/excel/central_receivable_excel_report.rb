class CentralReceivableExcelReport < WriteXLSX

	def initialize(mg_school_id,f_date, t_date, amount_transfer_type,mg_user_id)
		puts "so what?????"
		@school=MgSchool.find(mg_school_id)
	    @@school_logo=@school.logo.url(:medium, timestamp: false)
	    unless mg_user_id.present?
		    if(amount_transfer_type.present?)
		      @transaction=MgCentralAccountTransaction.where(:current_date=>f_date..t_date, :transaction_type=>'receivable', :is_deleted=>0, :mg_school_id=>mg_school_id, :amount_transfer_type=>amount_transfer_type)
		    else
		      @transaction=MgCentralAccountTransaction.where(:current_date=>f_date..t_date, :transaction_type=>'receivable', :is_deleted=>0, :mg_school_id=>mg_school_id)
		    end
		else
			account_id=MgAccount.where(:mg_user_id=>mg_user_id,:is_deleted=>0).pluck(:id)
		    if amount_transfer_type==""
		      @transaction=MgAccountTransaction.where("current_date IN (?) and is_deleted=? and mg_school_id=? and (mg_to_account_id IN (?) or mg_from_account_id IN (?))",f_date..t_date,0,mg_school_id,account_id,account_id).order(:for_module)
		    else
		      @transaction=MgAccountTransaction.where("amount_transfer_type=? and current_date IN (?) and is_deleted=? and mg_school_id=? and (mg_to_account_id IN (?) or mg_from_account_id IN (?))",amount_transfer_type,f_date..t_date,0,mg_school_id,account_id,account_id).order(:for_module)
		    end
		end
	    # params[:amount_transfer_type]=="all"
		gate_pass_excel
	end
	
	def gate_pass_excel

		workbook  = WriteXLSX.new(File.join(Rails.root, "public/xlsx_files", "central_receivable_excel_report.xlsx"))
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
	    # w.set_row(17, 25)


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
	    w.insert_image(1, 0, File.exists?("#{Rails.root}/public/#{@@school_logo}") ? "#{Rails.root}/public/#{@@school_logo}" : File.join(Rails.root, "app/assets/images", "logo.jpg"), x=0, y=0, x_scale=1, y_scale=1)
		    # headings = ['Gate Pass', '']
		    # w.write_row('E1', headings, heading)

	    school_name_headings = [@school.try(:school_name), "","","","",""]
	    w.write_row('B3', school_name_headings, text_format)
	    

	    headings = ['Account Details', '','','','']
	    w.write_row('A6', headings, heading_center_title)
	   

	    table_data=[]
	    count=0
	    @transaction.each do |info|
	      coloumn_count_d=1
	      table_data.push([count+=1,info.try(:for_module).to_s.capitalize,info.try(:amount_transfer_type).to_s.capitalize,info.current_date.present? ? info.current_date.strftime(@school.date_format) : "",info.try(:amount).to_f.round(2)])
	    end

	    w.add_table(
		    "A8:E#{8+table_data.size}",
		    {
		        :data    => table_data,
		        :columns => [
		        	{ :header => 'Sr. No' },
		            { :header => 'From' },
		            { :header => 'Transaction Type' },
		            { :header => 'Date' },
		            { :header => 'Amount' }
		        ],
		        :autofilter => 10

		    }
		)

	    workbook.close
	end
end 

