class InventoryController < ApplicationController
    before_filter :login_required
    layout "mindcom"

def worker
# Parameters: {"mg_item_id"=>"3", "selecter"=>"mg_item_id", "_"=>"1447326077248"}

  if params[:selecter]=='mg_item_id'
    vendor_items=MgInventoryVendorItem.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_item_id=>params[:mg_item_id])
    str='<option value="">Select</option>'
    vendor_items.each do |e|
      vender=MgInventoryVendor.find_by(:id=>e.try(:mg_vendor_id),:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
      if vender.present?
        str+="<option value='#{e.try(:mg_vendor_id)}'>#{vender.try(:name)}</option>"
      end
    end
    @object=str
  end
  
  respond_to do |format|
          format.json  { render :json => {main: @object, sub: ""} }
  end
end

def inventory_proposal_show_item
  if params[:mg_inventory_vendor_id].present?
    @item_information_details=MgInventoryProposalItem.where(:is_deleted=>0,:mg_inventory_proposal_id=>params[:mg_inventory_proposal_id],:mg_school_id=>session[:current_user_school_id], :mg_inventory_vendor_id=>params[:mg_inventory_vendor_id])
  else
    @item_information_details=MgInventoryProposalItem.where(:is_deleted=>0,:mg_inventory_proposal_id=>params[:mg_inventory_proposal_id],:mg_school_id=>session[:current_user_school_id])

  end
   render :layout=>false
  

end

def gate_pass_excel
  mg_school_id=session[:current_user_school_id]
  begin
    if File.exists?(File.join(Rails.root, "public/xlsx_files", "gate_pass.xlsx"))
      File.delete(File.join(Rails.root, "public/xlsx_files", "gate_pass.xlsx"))
    end

    puts params[:mg_inventory_proposal_item_id].inspect
    GatePass.new(mg_school_id,params[:id], params[:mg_inventory_vendor_id], params[:mg_inventory_proposal_item_id])
    send_file File.exists?(File.join(Rails.root, "public/xlsx_files", "gate_pass.xlsx")) ? File.join(Rails.root, "public/xlsx_files", "gate_pass.xlsx") : File.join(Rails.root, "public/xlsx_files", "gate_pass_error.xlsx"), :type => "application/vnd.ms-excel", :filename => "gate_pass-(#{Date.today}).xlsx", :stream => false#, :readonly=>true
  rescue Exception => e
    puts e
    if File.exists?(File.join(Rails.root, "public/xlsx_files", "gate_pass_error.xlsx"))
      send_file File.join(Rails.root, "public/xlsx_files", "gate_pass_error.xlsx"), :type => "application/vnd.ms-excel", :filename => "gate_pass-(#{Date.today}).xlsx", :stream => false#, :readonly=>true
    end
  end
end

def items_unit
  @item_list=MgInventoryItem.where(:id=>params[:item_id]).pluck(:mg_item_unit_id)
  @unit=MgLabUnit.find_by(:id=>@item_list)
  @req_value=@unit.try(:unit_name)
      respond_to do |format|
      format.json  { render :json => {:str=>@req_value} }
    end
end

def auto_number
  while true do
    value = ""; 3.times{value  << (65 + rand(25)).chr}
    int_value = rand(999).to_s.center(3, rand(9).to_s)
    @req_value = value+""+int_value
    code_count=MgInventoryItem.where(:code=>@req_value,:mg_school_id=>session[:current_user_school_id]).count
    if code_count==0
      break
    end
  end
    respond_to do |format|
      format.json  { render :json => {:str=>@req_value} }
    end
end


def auto_item_code
  while true do
    value = ""; 3.times{value  << (65 + rand(25)).chr}
    int_value = rand(999).to_s.center(3, rand(9).to_s)
    @req_value = value+""+int_value
    code_count=MgInventoryVendor.where(:vendor_code=>@req_value,:mg_school_id=>session[:current_user_school_id]).count
    if code_count==0
      break
    end
  end
    respond_to do |format|
      format.json  { render :json => {:str=>@req_value} }
    end
end

def auto_proposal_code
  while true do
    value = ""; 3.times{value  << (65 + rand(25)).chr}
    int_value = rand(999).to_s.center(3, rand(9).to_s)
    @req_value = value+""+int_value
    code_count=MgInventoryProposal.where(:code=>@req_value,:mg_school_id=>session[:current_user_school_id]).count
    if code_count==0
      break
    end
  end
    respond_to do |format|
      format.json  { render :json => {:str=>@req_value} }
    end
end

def fee_module_communication

  @particular_data=MgFeeParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:name=>"inventory")

end

def inventory_fee_category

    @fees_category = MgFeeCategory.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:item_category_name=>"Inventory")

 end 

 def inventory_fee_category_new
   render :layout=>false
 end

  def inventory_fee_category_create
   @selected_batches = params[:selected_batches]
      @feedetails=MgFeeCategory.new()
      @feedetails.is_deleted=0
      @feedetails.mg_school_id=session[:current_user_school_id]
      @feedetails.item_category_name="Inventory"
      inventory_category=MgInventoryItemCategory.find_by(:id=>params[:name])
      @feedetails.mg_inventory_item_category_id=params[:name]
      @feedetails.name=inventory_category.name
      @feedetails.mg_account_id=params[:fesses][:mg_store_id]#inventory_category.name
      @feedetails.save
       @particularData=params[:inventorySelectedParticulars]
       
       for i in 0...@particularData.size
          @saveParticular=MgParticularType.new()
          item_data=MgInventoryItem.find_by(:id=>@particularData[i])
          @saveParticular.particular_name=item_data.name
          @saveParticular.mg_inventory_item_id=@particularData[i]
          @saveParticular.mg_fee_category_id=@feedetails.id
          @saveParticular.is_deleted=0
          @saveParticular.mg_school_id=session[:current_user_school_id]
          @saveParticular.save
       end
      redirect_to :action => "inventory_fee_category"
  end

  def inventory_fee_edit
    @fesses = MgFeeCategory.find(params[:id])
    @mg_batch_list=MgBatch.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id]).pluck(:name,:id, :mg_course_id) 
    @mg_fee_category_batch_list=MgFeeCategoryBatches.where(:mg_fee_id=>params[:id]).pluck(:mg_batch_id,:id)
    @dueFine=MgParticularType.where(:mg_fee_category_id=>params[:id])
    render :layout => false
  end

  def inventory_update_category
  @params=params[:inventorySelectedParticulars]
   # puts params[:selected_employees].inspect
   #logger.infoJHDG
  #  puts "khkhkhkhoo"
  # puts params.inspect
  #  puts @params.size

  # puts qsd
    school_id=session[:current_user_school_id]
   for j in 0...@params.size

     library_employee_data=MgParticularType.where('mg_school_id=? and  mg_inventory_item_id=?', school_id,@params[j])

   if library_employee_data.size<1

      @data=MgParticularType.new()
      @data.is_deleted=0
      @data.created_by=session[:user_id]
      @data.mg_fee_category_id=params[:category_id]
      @data.mg_inventory_item_id=@params[j]
      data1=@params[j]
      data2=MgInventoryItem.find_by(:id=>data1)
      @data.particular_name=data2.name
      @data.mg_school_id=school_id
      

      @data.save
    else
          library_employee_data[0].update(:is_deleted=>0,:mg_school_id=>school_id)

        end
      end

    library_employee_data=MgParticularType.where('is_deleted=? and mg_school_id=? and  mg_inventory_item_id  NOT IN (?) ', 0,school_id,params[:inventorySelectedParticulars])
    #     puts library_employee_data.inspect 

   if library_employee_data.length>0
      for j in 0...library_employee_data.length
       
       data=MgParticularType.find_by(:id=>library_employee_data[j].id)
       if data.present?
      data.update(:is_deleted=>1)
     end
    end
     end

     redirect_to :action=>"inventory_fee_category"
      

  end

  def inventory_delete_fee_category
    @feesparticular=MgFeeCategory.find(params[:id])
    @feesparticular.is_deleted =1
    @feesparticular.save
    redirect_to :action=>'inventory_fee_category'
  end

  def inventory_finance_fee
    if params[:id].nil? 
        @particular_list=MgFeeParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:fee_category=>session[:feedetails_id]).paginate(page: params[:page], per_page: 5)
      else
        @particular_list=MgFeeParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:fee_category=>params[:id]).paginate(page: params[:page], per_page: 5)
        @fee_category=MgFeeCategory.find(params[:id])
        session[:feedetails_id] = @fee_category.id
      end
  end

  def inventory_new_particular
    @subjects=MgFeeParticular.new()
    render :layout => false
  end
 
  def inventory_save_ParticularFee
    @selected_batches1 = params[:selected_batches1]
    @params=params[:selectedStudents]
    if params[:fesses2][:value1] == 'demo'  #using student admission number
      for i in 0...@params.size
        puts"inside if save particular"
        @feeParticularObj=MgFeeParticular.new(particular_params) 
        @feeParticularObj.name="Inventory"
        @data=MgStudent.find(@params[i])
        @batchID=@data.mg_batch_id
        @feeParticularObj.mg_batch_id=@batchID
        @feeParticularObj.admission_no= @data.admission_number
        save_account_id(params[:fesses2][:selected_account_id],params[:mg_account_id],@feeParticularObj)
        @feeParticularObj.save
      end
    end
    redirect_to :action=>'inventory_finance_fee',:controller=>'inventory',:id=>params[:id]
  end

  def save_account_id(selected_account_id,new_account_id,fees_particular_object)
    if selected_account_id.present?
      if selected_account_id=="central"
        fees_particular_object.is_to_central=1
      else
        fees_particular_object.mg_account_id=selected_account_id
      end
    elsif new_account_id.present?
      if new_account_id=="central"
        fees_particular_object.is_to_central=1
      else
        fees_particular_object.mg_account_id=new_account_id
      end
    end
  end

  def inventory_edit_fee_particular
    @fesses2 = MgFeeParticular.find(params[:id])
    #   @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    #    @info=Array.new
    #  @batches.each do |b|
    #  @info.push(b.id)
    # end
    @cceID=Array.new
    @cceID.push(@fesses2.mg_batch_id)
    logger.info @fesses2.inspect
    render :layout => false
  end
  def inventory_update_fee_particular
    @feeParticularObj = MgFeeParticular.find(params[:id])
    @feeParticularParams = update_particular_params
    @params=params[:selectedStudents]
    if(params[:fesses2][:value1]=='All')
      @feeParticularParams[:admission_no] = ''
      @feeParticularParams[:mg_student_category_id] =''
    end
    if(params[:fesses2][:value1]=='demo')
      @feeParticularParams[:admission_no] =  params[:fesses2][:admission_no] 
      @feeParticularParams[:mg_student_category_id] =''
    end
    if(params[:fesses2][:value1]=='demo2')         
      @feeParticularParams[:admission_no] = ''  
      @feeParticularParams[:mg_student_category_id] =params[:fesses2][:mg_student_category_id]
    end
    @feeParticularObj.update(@feeParticularParams)
    redirect_to :action=>'inventory_finance_fee',:id=>@feeParticularObj.fee_category
  end

  def inventory_destroy_fee_particular
    @feesparticular=MgFeeParticular.find(params[:id])
    @feesparticular.is_deleted =1
    @feesparticular.save
    redirect_to :action=>'inventory_finance_fee',:id=>@feesparticular.fee_category
  end

  def inventory_fee_category_item_data
    if params[:data1]=="data2"
      category_data=MgFeeCategory.find_by(:id=>params[:category])
      @particular_data=MgParticularType.where(:mg_fee_category_id=>category_data.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_inventory_item_id)
      @item_data=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:id]).where("id  IN (?)",@particular_data).pluck(:name,:id)
      @it_da=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:id]).where("id NOT in(?)",@particular_data).pluck(:name,:id)
      else
        @item_data=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:id]).pluck(:name,:id)
      end
    render :layout=>false
  end

  def inventory_fee_schedule
    @fee_collection_list=MgFeeCollection.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id],:collection_type=>"inventory").paginate(page: params[:page], per_page: 5)
  end

  def inventory_delete_fee_schedule
    @fee_fine_schedule=MgFeeCollection.find_by_id(params[:id])
    #@fee_discount.is_deleted =1
    @fee_fine_schedule.update(:is_deleted=>1)
    redirect_to :action=>'inventory_fee_schedule'
  end

  def cash_transaction
  end  

  def payment_status
  end

  def payment_status_report 
    @timeformat=MgSchool.find(session[:current_user_school_id])
    from_date= Date.strptime(params[:from_date],@timeformat.date_format)
    to_date= Date.strptime(params[:to_date],@timeformat.date_format)
    #@sales=MgInventorySalesInformation.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :date_of_sales=>from_date..to_date)
    render :layout=>false
  end

  def cash_transaction_report 
    @timeformat=MgSchool.find(session[:current_user_school_id])
    from_date= Date.strptime(params[:from_date],@timeformat.date_format)
    to_date= Date.strptime(params[:to_date],@timeformat.date_format)
    @sales=MgInventorySalesInformation.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :date_of_sales=>from_date..to_date)
    render :layout=>false
  end

  def cash_transaction_details
    @sales=MgInventorySalesInformation.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>params[:id])
    @sale_details=MgInventorySalesData.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_inventory_sales_information_id=>params[:id])
    render :layout=>false
  end

  def inventory_goods_purchased
  end

  def inventory_goods_report_generation
    @timeformat = MgSchool.find(session[:current_user_school_id])
    from_date= Date.strptime(params[:from_date],@timeformat.date_format)
    to_date= Date.strptime(params[:to_date],@timeformat.date_format)
    @inventory_proposal=MgInventoryProposal.where(:date=>from_date..to_date,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:status=>"accepted")
    render :layout=>false
  end

  def inventory_goods_ordered

  end

  def inventory_goods_ordered_generation
    @timeformat = MgSchool.find(session[:current_user_school_id])
    from_date= Date.strptime(params[:from_date],@timeformat.date_format)
    to_date= Date.strptime(params[:to_date],@timeformat.date_format)
    @inventory_proposal_item=MgInventoryProposalItem.where(:date=>from_date..to_date,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:status=>"AP")
    puts "88888888888888888888888888888888888888"
    render :layout=>false

  end


  def requirement_report_generation
      @timeformat = MgSchool.find(session[:current_user_school_id])
      f_date= Date.strptime(params[:from_date],@timeformat.date_format)
      t_date= Date.strptime(params[:to_date],@timeformat.date_format)
      @inventory_proposal=MgInventoryProposal.where(:date=>f_date..t_date, :status=>'accepted', :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
      @inventory_projection=MgInventoryProjection.where(:date=>f_date..t_date, :status=>'accepted', :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
     render :layout=>false
  end

  def inventory_damaged_goods
    @inventory_item_consumption=MgInventoryItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:consumption_type=>"damaged")
  end

  def requirement_report
    
  end

  def gate_pass
    
  end

  def gate_pass_show
    @vendor=MgInventoryVendor.find(params[:id])
    @school=MgSchool.find(session[:current_user_school_id])
    render :layout=>false
  end

  def gate_pass_pdf
    vendor=MgInventoryVendor.find(params[:id])
    school=MgSchool.find(session[:current_user_school_id])
    table_size={0 => 100, 1 => 208 }
    border_width=0.0
    @@school_logo=school.logo.url(:medium, timestamp: false)
    pdf = Prawn::Document.new(:page_size => [380, 250]) 
          pdf.table([[File.exists?("#{Rails.root}/public/#{@@school_logo}") ? {:image =>  "#{Rails.root}/public/#{@@school_logo}" ,  :scale => 0.15} : "","",school.try(:school_name)]],:column_widths => [35,3,270]) do
            row(0).style :align => :center
            row(0).style :border_width=>border_width
          end

          pdf.table([["Vendor Name",": "+vendor.try(:name).to_s ]],:column_widths => table_size) do
            #row(0).style :align => :center
            row(0).style :border_width=>0.0
          end

          pdf.table([["Contact Name",": "+ vendor.try(:contact_name).to_s ]],:column_widths => table_size) do
            #row(0).style :align => :center
            row(0).style :border_width=>0.0
          end
          pdf.table([["Phone Number",": "+vendor.try(:phone_number).to_s ]],:column_widths => table_size) do
            #row(0).style :align => :center
            row(0).style :border_width=>0.0
          end

          pdf.table([["Email Id",": "+vendor.try(:email).to_s ]],:column_widths => table_size) do
            #row(0).style :align => :center
            row(0).style :border_width=>0.0
          end

        send_data pdf.render,   :info => {
                        :Title => "My title",
                        :Author => "John Doe",
                        :Subject => "My Subject",
                        :Keywords => "test metadata ruby pdf dry",
                        :Creator => "ACME Soft App",
                        :Producer => "Prawn",
                        :CreationDate => Time.now
                        }, :filename => "gate_pass.pdf", :type => "application/pdf", :disposition => 'outline'
    
  end

  def library_card_issue_create

     course_data=MgCourse.find_by(:id=>params[:mg_course_id])
      batch_data=MgBatch.find_by(:id=>params[:mg_batch_id_for_data])
      student_data=MgStudent.find_by(:id=>params[:mg_student_school_id])

      student_photo=student_data.avatar.url(:medium, timestamp: false)

      valid_from=params[:card_issue]["valid_from"]
      valid_to=params[:card_issue]["valid_to"]
     


      school=MgSchool.find(session[:current_user_school_id])
      @@school_logo=school.logo.url(:medium, timestamp: false)
      data_len=school.school_name.length
      #data_len="MindCom International School gsdfjkagf ajsgfjasgdjfga fgasdgfqweraksdfjhaskdfasfdf gasdfgkasdfad".length

      # x=350
      # y=195
                           #if data_len.to_i<70

     pdf = Prawn::Document.new(:page_size => [380, 195]) do
     # else
     # pdf = Prawn::Document.new(:page_size => [395, 195]) do

     # end
      
        

                  repeat :all do


                        bounding_box [bounds.left, bounds.top+15],:align => :left, :width  => bounds.width do
                            font "Helvetica"
                            move_up 12
                            if File.exists?("#{Rails.root}/public/#{@@school_logo}") 
                                   image( "#{Rails.root}/public/#{@@school_logo}", :at => [0,0],:width =>  45)
                                  # image ("#{Rails.root}/public/#{@@school_logo}"),:at=>[425,690],:width=>45
                                  # image "#{Rails.root}/public/#{@@school_logo}", :width => 45, :align => :left
                            end
                            move_down 12
          

                            move_up 5 
  
                           if data_len.to_i<59
                         
               text_box(school.school_name,:align => :left,:at=>[50,-20],:left_margin => 80, :width => 200)
                          #text data_len.to_s, :align => :center, :size => 18 50,25 50,35
                            elsif data_len.to_i>59 && data_len.to_i<125  
                              #text data_len.to_s, :align => :center, :size => 18
                                 text_box(school.school_name,:align => :left,:at=>[50,-10],:left_margin => 80, :width => 300)
                               else
                                 text_box(school.school_name,:align => :left,:at=>[50,-10],:left_margin => 80, :width => 300)

                        end
end
         if data_len.to_i<59                
        move_down 60
elsif data_len.to_i>59 && data_len.to_i<125  
        move_down 60

      else 
        move_down 70

      end
        # footer
stroke_horizontal_rule
                       
                  end
 

                

                    bounding_box([bounds.left, bounds.top - 60], :width  => bounds.width, :height => bounds.height - 100) do

                    move_down 120
                    if  File.exists?("#{Rails.root}/public/#{student_photo}")
                            # image "#{Rails.root}/public/#{@@emp_photo}", :align => :right, :width =>45
                            image("#{Rails.root}/public/#{student_photo}", :at => [215,25], :width =>35)
                    else

                    end


      


                      end
                      if data_len.to_i>125
                      draw_text "Name:", :at => [8,65] 
                      draw_text "#{student_data.first_name} #{student_data.last_name}",:at => [48,65]
                      else
                         draw_text "Name:", :at => [8,70] 
                      draw_text "#{student_data.first_name} #{student_data.last_name}",:at => [48,70]
                      end  
                      draw_text "Class:", :at => [8,50]
                      draw_text "#{course_data.course_name}",:at => [46,50]
                     
                      draw_text "Section:", :at =>  [8,30] 
                      draw_text "#{batch_data.name}",:at => [55,30]
                      
                     draw_text "Student ID:", :at =>  [8,10] 
                      draw_text "#{student_data.admission_number}",:at => [72,10]


                      draw_text "Valid From: ", :at => [8,-10]
                      draw_text "#{valid_from}",:at => [70,-10]
                      draw_text "Valid To:", :at => [8,-30]
                      draw_text "#{valid_to}",:at => [56,-30] 

                      #text "Valid From"
                      #text "Valid To"

                    end
                     send_data pdf.render,   :info => {
                      :Title => "My title",
                      :Author => "John Doe",
                      :Subject => "My Subject",
                      :Keywords => "test metadata ruby pdf dry",
                      :Creator => "ACME Soft App",
                      :Producer => "Prawn",
                      :CreationDate => Time.now
                      }, :filename => "library_card.pdf", :type => "application/pdf", :disposition => 'inline'



  end


  def inventory_stack_management
  @stack_management_data=InventoryStackManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def inventory_stack_management_new
    render :layout=>false
  end
  def inventory_stack_management_create
    stack_management=InventoryStackManagement.new(stack_management_params)
    stack_management.mg_inventory_store_management_id=params[:mg_inventory_store_management_id]
    stack_management.mg_inventory_room_management_id=params[:mg_inventory_room_management_id]

    if stack_management.save
      redirect_to :action=>'inventory_stack_management'
    else
      flash[:notice]="Uniqeness of Room No, Rack No should be maintained"
      redirect_to :action=>'inventory_stack_management'
    end
  end

  def inventory_stack_management_show
    @show_stack_data=InventoryStackManagement.find_by(:id=>params[:id])
    render :layout=>false
  end

  def inventory_stack_management_edit
    @stack_management=InventoryStackManagement.find_by(:id=>params[:id])
    render :layout=>false
  end

  def inventory_stack_management_update
    update_data=InventoryStackManagement.find_by(:id=>params[:id])
    update_data.update(:mg_inventory_store_management_id=>params[:mg_inventory_store_management_id],:mg_inventory_room_management_id=>params[:mg_inventory_room_management_id])
    update_data.update(update_stack_management_params)
    redirect_to :action=>'inventory_stack_management'
  end


  def inventory_stack_management_delete

    delete_data=InventoryStackManagement.find_by(:id=>params[:id])
    if delete_data.update(:is_deleted=>1)
      redirect_to :action=>'inventory_stack_management'
    else
      puts "nnnnn"
      redirect_to :action=>'inventory_stack_management'
    end
  end
  def inventory_room_data
    @room_data=MgInventoryRoomManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_store_management_id=>params[:id]).pluck(:room_no,:id)
    render :layout=>false
  end
  def inventory_store_management
  @stack_management_data=MgInventoryStoreManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

def inventory_store_management_new
render :layout=>false
  end
def inventory_store_management_create
stack_management=MgInventoryStoreManagement.new(store_management_params)
stack_management.save
redirect_to :action=>'inventory_store_management'
end

def inventory_store_management_show
  @show_store_data=MgInventoryStoreManagement.find_by(:id=>params[:id])
render :layout=>false

end

def inventory_store_management_edit
  @store_management=MgInventoryStoreManagement.find_by(:id=>params[:id])
render :layout=>false

end

def inventory_store_management_update
  update_data=MgInventoryStoreManagement.find_by(:id=>params[:id])
  update_data.update(update_store_management_params)
redirect_to :action=>'inventory_store_management'
  
end

def inventory_store_management_delete

  delete_data=MgInventoryStoreManagement.find_by(:id=>params[:id])
  delete_data.is_deleted=1
    delete_data.save
redirect_to :action=>'inventory_store_management'

end
def inventory_room_management
@stack_management_data=MgInventoryRoomManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end

def inventory_room_management_new
render :layout=>false
  end
def inventory_room_management_create
stack_management=MgInventoryRoomManagement.new(room_management_params)
stack_management.save
redirect_to :action=>'inventory_room_management'
end

def inventory_room_management_show
  @show_store_data=MgInventoryRoomManagement.find_by(:id=>params[:id])
render :layout=>false

end

def inventory_room_management_edit
  @room_management=MgInventoryRoomManagement.find_by(:id=>params[:id])
render :layout=>false

end

def inventory_room_management_update
  update_data=MgInventoryRoomManagement.find_by(:id=>params[:id])
  
  puts update_room_management_params.inspect
  update_data.update(update_room_management_params)
redirect_to :action=>'inventory_room_management'
  
end

def inventory_room_management_delete

  delete_data=MgInventoryRoomManagement.find_by(:id=>params[:id])
  delete_data.is_deleted=1
    delete_data.save
redirect_to :action=>'inventory_room_management'

end


def assaign_store_manager
@store_manager_data=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

end
def assaign_store_manager_new
  
render :layout=>false

end
def assaign_store_manager_create

store_management=MgInventoryStoreManager.new()
store_management.mg_inventory_store_management_id=params[:mg_inventory_store_management_id]
store_management.mg_employee_department_id=params[:mg_employee_department_id]
store_management.mg_employee_id=params[:mg_employee_id] 
store_management.is_deleted=0
store_management.mg_school_id=session[:current_user_school_id]
store_management.created_by=session[:user_id]
store_management.updated_by=session[:user_id]

store_management.save
redirect_to :action=>'assaign_store_manager'
end
def assaign_store_manager_edit
@store_manager=MgInventoryStoreManager.find(params[:id])
render :layout=>false
end
def assaign_store_manager_show
@show_manager_data=MgInventoryStoreManager.find(params[:id])
render :layout=>false
end
def assaign_store_manager_update
store_manager=MgInventoryStoreManager.find(params[:id])
store_manager.update(:mg_inventory_store_management_id=>params[:mg_inventory_store_management_id],:mg_employee_id=>params[:mg_employee_id],:mg_employee_department_id=>params[:mg_employee_department_id])
redirect_to :action=>'assaign_store_manager'

end
def assaign_store_manager_delete
delete_data=MgInventoryStoreManager.find_by(:id=>params[:id])
  delete_data.is_deleted=1
    delete_data.save
redirect_to :action=>'assaign_store_manager'
end
def select_employee_for_manager
  manager_data=MgFinanceOfficer.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_id)
  if manager_data.present?
    employee_data=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>params[:id],:mg_employee_category_id=>2).where('id not in (?)',manager_data)
  else
    employee_data=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>params[:id],:mg_employee_category_id=>2)
  end
  @employee_arr=Array.new()
  employee_data.each do |data|
    demo_arr=Array.new()
    first_name=data.first_name
    last_name=data.last_name
    demo_arr.push("#{first_name} #{last_name}",data.id)
    @employee_arr.push(demo_arr)
  end
render :layout=>false

end
def assaign_financial_officer

end
def assaign_financial_officer_new
render :layout=>false

end
def assaign_financial_officer_create
finance_officer=MgFinanceOfficer.new
finance_officer.mg_employee_id=params[:mg_employee_id]
finance_officer.mg_employee_department_id=params[:mg_employee_department_id]
finance_officer.is_deleted=0
finance_officer.mg_school_id=session[:current_user_school_id]
finance_officer.created_by=session[:user_id]
finance_officer.updated_by=session[:user_id]
finance_officer.save
redirect_to :action=>'assaign_financial_officer_show'

end
def assaign_financial_officer_edit
@finance_officer=MgFinanceOfficer.find_by(:id=>params[:id])

render :layout=>false

end
def assaign_financial_officer_update
finance_officer=MgFinanceOfficer.find_by(:id=>params[:id])
finance_officer.update(:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id])
redirect_to :action=>'assaign_financial_officer_show'

end
def assaign_financial_officer_show

end
def select_finance_officer
 manager_data=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_employee_id)
 employee_data=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>params[:id],:mg_employee_category_id=>2).where('id not in (?)',manager_data)
  @employee_arr=Array.new()
  employee_data.each do |data|
    demo_arr=Array.new()
    first_name=data.first_name
    last_name=data.last_name
    demo_arr.push("#{first_name} #{last_name}",data.id)
    @employee_arr.push(demo_arr)
  end
render :layout=>false

end

def inventory_sales_index
  @sales_information=MgInventorySalesInformation.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

end
def inventory_sales

end

def inventory_sales_category_data
@item_data=MgInventoryItem.where(:item_type=>"Sale",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:id]).pluck(:name,:id)
render :layout=>false

  end
  def inventory_auto_generated_data
    @it_data=MgInventoryItem.find_by(:id=>params[:id])
    render :layout=>false
  end

  def inventory_sales_create
    puts params.inspect
    MgInventorySalesInformation.transaction do 
      cost_arr=params[:cost]
      no_of_copy_arr=params[:no_of_copy]
      total_arr=params[:total]
      customer_name=params[:library_purchase_details][:customer_name]
      #date_of_purchase=params[:library_purchase_details][:date_of_purchase]
      amount=params[:library_purchase_details][:amount]
      inventory_category_id_arr=params[:mg_inventory_category_id]
      inventory_item_id_arr=params[:mg_inventory_item_id]
      inventory_sales_information_data=MgInventorySalesInformation.new()
      inventory_sales_information_data.amount=amount
      inventory_sales_information_data.customer_name=customer_name
      @timeformat = MgSchool.find(session[:current_user_school_id])
      date_of_purchase_info = Date.strptime(params[:library_purchase_details][:date_of_purchase],@timeformat.date_format)

      inventory_sales_information_data.date_of_sales=date_of_purchase_info
      inventory_sales_information_data.is_deleted=0
      inventory_sales_information_data.mg_school_id=session[:current_user_school_id]
      
      inventory_sales_information_data.created_by=session[:user_id]
      inventory_sales_information_data.updated_by=session[:user_id]
      if params[:library_purchase_details][:account]=="central"
        inventory_sales_information_data.is_to_central=1
      else
        inventory_sales_information_data.mg_account_id=params[:library_purchase_details][:account]
      end
      inventory_sales_information_data.save

      # inventory_sales_information_data.mg_inventory_item_category_id=inventory_category_id_arr
      puts inventory_category_id_arr
      puts inventory_item_id_arr
      for j in 0...inventory_category_id_arr.length
        if inventory_category_id_arr[j].present?
          resource_information_details=MgInventorySalesData.new()
          resource_information_details.mg_inventory_sales_information_id=inventory_sales_information_data.id
          resource_information_details.mg_school_id=session[:current_user_school_id]
          resource_information_details.is_deleted=0
          resource_information_details.created_by=session[:user_id]
          resource_information_details.updated_by=session[:user_id]
          resource_information_details.mg_inventory_item_id=inventory_item_id_arr[j]
          resource_information_details.mg_inventory_item_category_id=inventory_category_id_arr[j]
          resource_information_details.cost_per_unit=cost_arr[j]
          resource_information_details.no_of_units=no_of_copy_arr[j]
          resource_information_details.total=total_arr[j]
          resource_information_details.save
        end
      end#for end
      #Bindhu Added for account starts
        from_account_id=""
        amount=params[:library_purchase_details][:amount]
        for_module="sales"
        particular_id=inventory_sales_information_data.id
        transaction_type="receivable"
        amount_transfer_type="credited"
        if params[:library_purchase_details][:account]=="central"
          to_account_id=""
          central_account_transaction=MgCentralAccountTransaction.send_transaction(from_account_id,to_account_id,amount,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
          central_account_transaction.save
        else
          to_account_id=params[:library_purchase_details][:account]
          account_transaction=MgAccountTransaction.add_transaction(from_account_id,to_account_id,amount,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
          account_transaction.save
        end
      #Bindhu Added for account ends
    end
    redirect_to :action=>"inventory_sales_index"
  end


def inventory_sales_show
    @sales_information=MgInventorySalesInformation.find_by(:id=>params[:id])
    render :layout=>false

end

def inventory_sales_edit
  data=params[:id]
  ids=data.split("-")
  @sales_information_data=MgInventorySalesInformation.find_by(:id=>ids[0])
  @sales_data=MgInventorySalesData.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:Mg_inventory_sales_information_id=>@sales_information_data.id)
  @item_data=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  @item_category=MgInventoryItemCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
#render :layout=>false
end

def inventory_sales_update
  MgInventorySalesInformation.transaction do
    @params=params[:ids]
    school_id=session[:current_user_school_id]
     
    inventory_item_category_id_arr=params[:mg_inventory_category_id]
    inventory_item_id_arr=params[:mg_inventory_item_id]
    cost_arr=params[:cost]
    no_of_copy_arr=params[:no_of_copy]
    total_arr=params[:total]
    @timeformat = MgSchool.find(school_id)
    date_of_purchase_info = Date.strptime(params[:library_purchase_details][:date_of_purchase],@timeformat.date_format)

    @inventory_sales_details=MgInventorySalesInformation.find(params[:id])
    @inventory_sales_details.update(:date_of_sales=>date_of_purchase_info,:amount=>params[:library_purchase_details][:amount])
    library_data=MgInventorySalesData.where('is_deleted=? and mg_school_id=? and mg_inventory_sales_information_id=? and id  NOT IN (?)', 0,session[:current_user_school_id],params[:id],params[:ids])
   
    if inventory_item_category_id_arr.present?
      for j in 0...inventory_item_category_id_arr.size
        inventory_data=MgInventorySalesData.where('mg_school_id=? and mg_inventory_sales_information_id=? and mg_inventory_item_category_id=? and mg_inventory_item_id=?', session[:current_user_school_id],params[:id],inventory_item_category_id_arr[j],inventory_item_id_arr[j])
        if inventory_data.present?
          inventory_data[0].update(:total=>total_arr[j],:no_of_units=>no_of_copy_arr[j],:cost_per_unit=>cost_arr[j],:mg_inventory_item_id=>inventory_item_id_arr[j],:mg_inventory_item_category_id=>inventory_item_category_id_arr[j])
         else
          purchase_details=MgInventorySalesData.new()
          purchase_details.mg_inventory_sales_information_id=params[:id]
          purchase_details.mg_inventory_item_category_id=inventory_item_category_id_arr[j]
          purchase_details.mg_inventory_item_id=inventory_item_id_arr[j]
          purchase_details.cost_per_unit=cost_arr[j]
          purchase_details.is_deleted=0
          purchase_details.mg_school_id=session[:current_user_school_id]
          purchase_details.created_by=session[:user_id]
          purchase_details.updated_by=session[:user_id]
          purchase_details.cost_per_unit=cost_arr[j]
          purchase_details.no_of_units=no_of_copy_arr[j]
          purchase_details.total=total_arr[j]
          purchase_details.save
        end
      end
    end
    #Bindhu Added for account starts
    if @inventory_sales_details.mg_account_id.present?
      amount_credited=MgAccountTransaction.where(:mg_particular_id=>params[:id],:amount_transfer_type=>"credited",:for_module=>"sales",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:amount)
      amount_debited=MgAccountTransaction.where(:mg_particular_id=>params[:id],:amount_transfer_type=>"debited",:for_module=>"sales",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:amount)
      account_transaction(amount_credited,amount_debited,params[:library_purchase_details][:amount],"MgAccountTransaction",params[:id])
    elsif @inventory_sales_details.is_to_central.present?
      amount_credited=MgCentralAccountTransaction.where(:mg_particular_id=>params[:id],:amount_transfer_type=>"credited",:for_module=>"sales",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:amount)
      amount_debited=MgCentralAccountTransaction.where(:mg_particular_id=>params[:id],:amount_transfer_type=>"debited",:for_module=>"sales",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:amount)
      account_transaction(amount_credited,amount_debited,params[:library_purchase_details][:amount],"MgCentralAccountTransaction",params[:id])
    end
    #Bindhu Added for account ends
    flash[:notice]="Data has Updated"
    redirect_to :action=>'inventory_sales_index'
  end
end
  #Bindhu Added for account starts
  def account_transaction(amount_created,amount_debited,amount_data,string_object,particular) 
    sum_of_amount_credited=0
    sum_of_amount_debited=0
    if amount_created.present?
      for i in 0...amount_created.size
        sum_of_amount_credited+=amount_created[i].to_i
      end
    end
    if amount_debited.present?
      for i in 0...amount_debited.size
        sum_of_amount_debited+=amount_debited[i].to_i
      end
    end
    updated_amount=sum_of_amount_credited - sum_of_amount_debited
    amount=updated_amount.to_i - amount_data.to_i
    if amount!=0
      if amount>0
        amount_transfer_type="debited"
      else
        amount_transfer_type="credited"
      end
      from_account_id=""
      for_module="sales"
      particular_id=particular
      transaction_type="receivable"
      if string_object=="MgAccountTransaction"
        to_account_id=params[:library_purchase_details][:account]
        account_transaction=MgAccountTransaction.add_transaction(from_account_id,to_account_id,amount.abs,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
        account_transaction.save
      elsif string_object=="MgCentralAccountTransaction"
        to_account_id=""
        central_account_transaction=MgCentralAccountTransaction.send_transaction(from_account_id,to_account_id,amount.abs,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
        central_account_transaction.save
      end 
    end
  end
#Bindhu Added for account ends

def inventory_sales_delete
delete_data=MgInventorySalesInformation.find_by(:id=>params[:id])
  delete_data.is_deleted=1
    delete_data.save
redirect_to :action=>'inventory_sales_index'
end


  def new
    render :layout=>false
  end

  def create
    itemCategory=MgInventoryItemCategory.new(params_category)
     if itemCategory.save
     else
        flash[:notice]="category already exist"
    end
    redirect_to :action=> "index"
  end

  def show
    @itemCategory=MgInventoryItemCategory.find_by(:id=>params[:id])
    render :layout=>false
  end

  def edit
    @inventory=MgInventoryItemCategory.find_by(:id=>params[:id])
    render :layout=>false
  end

  def delete
    @itemCategory=MgInventoryItemCategory.find_by(:id=>params[:id])
    @itemCategory.update(:is_deleted=>1,:updated_by=>session[:user_id])
    redirect_to :back
  end

  def updates
  @itemCategory=MgInventoryItemCategory.find_by(:id=>params[:id])
  @itemCategory.update(params_update_category)
  redirect_to :action=> "index"
  end

  def index
  @itemCategory=MgInventoryItemCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def item_new
    render :layout=>false
  end

  def item_create
    item=MgInventoryItem.new(params_item)
    if item.save
      if params[:inventory][:available_online]
       item.update(:available_online=>params[:inventory][:available_online], :reserved_for_offline=>params[:inventory][:reserved_for_offline], :online_price=>params[:inventory][:online_price])
      @files=params[:file]
      if @files.nil?
      else
        @files.each do |a|
        @fileupload=MgDocumentManagement.new()
        @fileupload.file=a
        @fileupload.document_type="Inventory"
        @fileupload.mg_user_id=session[:user_id]
        @fileupload.mg_inventory_item_id=item.try(:id)
        @fileupload.is_deleted=0
        @fileupload.mg_school_id=session[:current_user_school_id]
        @fileupload.created_by=session[:user_id]
        @fileupload.updated_by=session[:user_id]
        @fileupload.save
        end
      end
      end
     else
        flash[:notice]="Uniqeness of Item name, Code and prefix should be maintained"
    end
    redirect_to :action=> "item"
  end

  def item_show
    @item=MgInventoryItem.find_by(:id=>params[:id])
    @document=MgDocumentManagement.where(:mg_inventory_item_id=>params[:id],:document_type=>"Inventory",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def item_edit
    @inventory=MgInventoryItem.find_by(:id=>params[:id])
    render :layout=>false
  end

  def item_delete
    @item=MgInventoryItem.find_by(:id=>params[:id])
    @item.update(:is_deleted=>1)
    redirect_to :back
  end

  def item_update
  @item=MgInventoryItem.find_by(:id=>params[:id])
  if @item.update(params_update_item)
    if params[:inventory][:available_online]
       @item.update(:available_online=>params[:inventory][:available_online], :reserved_for_offline=>params[:inventory][:reserved_for_offline], :online_price=>params[:inventory][:online_price])
      @files=params[:file]
      if @files.nil?
      else
        @document=MgDocumentManagement.where(:mg_inventory_item_id=>params[:id],:document_type=>"Inventory",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @document.each do |f|
          f.update(:is_deleted=>1)
        end

        @files.each do |a|
        @fileupload=MgDocumentManagement.new()
        @fileupload.file=a
        @fileupload.document_type="Inventory"
        @fileupload.mg_user_id=session[:user_id]
        @fileupload.mg_inventory_item_id=@item.try(:id)
        @fileupload.is_deleted=0
        @fileupload.mg_school_id=session[:current_user_school_id]
        @fileupload.created_by=session[:user_id]
        @fileupload.updated_by=session[:user_id]
        @fileupload.save
        end
      end
    end
  end

  redirect_to :action=> "item"
  end

  def attachment_delete
    doc=MgDocumentManagement.find(params[:id])
    doc.update(:is_deleted=>1)
    redirect_to :back
  end

  def item
  @item=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def vendor_new
    int_value=1
    while true do
    @vendor_code = "V"+int_value.to_s
    code_count=MgInventoryVendor.where(:vendor_code=>@vendor_code,:mg_school_id=>session[:current_user_school_id]).count
    if code_count==0
      break
    end
    int_value=int_value+1
  end
    #render :layout=>false
  end

  def vendor_create
    @vendor=MgInventoryVendor.new(params_vendor)
    @vendor.save
    @category_id=params[:mginventoryitemcategory]
    @item_id=params[:mg_item_id]
    @unit_price=params[:unit_price]
      @params=params[:mginventoryitemcategory]
      for j in 0...@params.size
        if @category_id[j].to_i>0 && @item_id[j].to_i>0 && @unit_price[j].to_i>0
        @vendorItem=MgInventoryVendorItem.new()
        @vendorItem.mg_vendor_id=@vendor.id
        @vendorItem.mg_item_id=@item_id[j]
        @vendorItem.unit_price=@unit_price[j]
        @vendorItem.is_deleted=0
        @vendorItem.mg_school_id=session[:current_user_school_id]
        @vendorItem.created_by=session[:user_id]
        @vendorItem.updated_by=session[:user_id]
        @vendorItem.save
      end
    end
    redirect_to :action=> "vendor"
  end

  def vendor_show
    @item=MgInventoryVendor.find_by(:id=>params[:id])
    render :layout=>false

  end

  def vendor_edit
    @inventory=MgInventoryVendor.find_by(:id=>params[:id])
    @item_information_details=MgInventoryVendorItem.where(:is_deleted=>0,:mg_vendor_id=>@inventory.id,:mg_school_id=>session[:current_user_school_id])

  end

  def vendor_delete
    @item=MgInventoryVendor.find_by(:id=>params[:id])
    @item.update(:is_deleted=>1)
    redirect_to :back
  end

  def vendor_update
  @item=MgInventoryVendor.find_by(:id=>params[:id])
  @item.update(params_vendor)
  @temp_item=MgInventoryVendorItem.where(:mg_vendor_id=>params[:id])

  if @temp_item.present?
    @temp_item.each do |vendorItem|
      vendorItem.update(:is_deleted=>1)
    end
  end
  @category_id=params[:mginventoryitemcategory]
    @item_id=params[:mg_item_id]
    @unit_price=params[:unit_price]
      @params=params[:mginventoryitemcategory]
      for j in 0...@params.size
        if @category_id[j].to_i>0 && @item_id[j].to_i>0 && @unit_price[j].to_i>0
        @vendorItem=MgInventoryVendorItem.new()
        @vendorItem.mg_vendor_id=params[:id]
        @vendorItem.mg_item_id=@item_id[j]
        @vendorItem.unit_price=@unit_price[j]
        @vendorItem.is_deleted=0
        @vendorItem.mg_school_id=session[:current_user_school_id]
        @vendorItem.created_by=session[:user_id]
        @vendorItem.updated_by=session[:user_id]
        @vendorItem.save
      end
    end
  redirect_to :action=> "vendor"
  end

  def vendor
  @item=MgInventoryVendor.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def search_vendor
    
  end


  def comparing_vendor
    
  end

  def inventory_search_data
    
    @code_present="temp"
    if (params[:itemName].present? && params[:itemCode].present?)
    #@item=MgInventoryItem.where("is_deleted=? and mg_school_id=? and name LIKE ? and code LIKE ?",0,session[:current_user_school_id],"%#{params[:itemName]}%","%#{params[:itemCode]}%").pluck(:id)
    @item=MgInventoryItem.find_by(:id=>params[:itemName])
    @vendor=MgInventoryVendorItem.where("is_deleted=? and mg_school_id=? and mg_item_id IN (?)",0,session[:current_user_school_id],params[:itemName]).pluck(:mg_vendor_id)
    @search=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],@vendor)
    @code_present="yes"
    
    puts "norrrr"
    elsif params[:itemName].present?
    #@item=MgInventoryItem.where("is_deleted=? and mg_school_id=? and name LIKE ?",0,session[:current_user_school_id],"%#{params[:itemName]}%").pluck(:id)
    @item=MgInventoryItem.find_by(:id=>params[:itemName])
    @vendor=MgInventoryVendorItem.where("is_deleted=? and mg_school_id=? and mg_item_id IN (?)",0,session[:current_user_school_id],params[:itemName]).pluck(:mg_vendor_id)
    @search=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],@vendor)
    @code_present="no"
    
    puts "no"
    elsif params[:itemCode].present?
    #@item=MgInventoryItem.where("is_deleted=? and mg_school_id=? and code LIKE ?",0,session[:current_user_school_id],"%#{params[:itemCode]}%").pluck(:id)
    @item=MgInventoryItem.find_by(:id=>params[:itemCode])
    @vendor=MgInventoryVendorItem.where("is_deleted=? and mg_school_id=? and mg_item_id IN (?)",0,session[:current_user_school_id],params[:itemCode]).pluck(:mg_vendor_id)
    @search=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],@vendor)
    @code_present="yes"
    
    puts "yes"
    end
    
    render :layout=>false
    
  end

	def search_vendor_by_code
    	render :layout=>false
  	end

  def inventory_all_search_data
    @code_present="temp"
    if (params[:search_by]=="order_number")
      @proposal_id=MgInventoryProposal.where("is_deleted=? and mg_school_id=? and code LIKE ?",0,session[:current_user_school_id],"%#{params[:temp_val]}%").pluck(:id)
      @inventory_proposal_item=MgInventoryProposalItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_proposal_id=>@proposal_id)
      @code_present="code_for_supplier_name"
      @code_order_number_present="yes"
    elsif (params[:search_by]=="item_name")
      @item=MgInventoryItem.where("is_deleted=? and mg_school_id=? and name LIKE ?",0,session[:current_user_school_id],"%#{params[:temp_val]}%").pluck(:id)
      @vendor=MgInventoryVendorItem.where("is_deleted=? and mg_school_id=? and mg_item_id IN (?)",0,session[:current_user_school_id],@item).pluck(:mg_vendor_id)
      @search=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],@vendor)
      @code_present="no"
      @code_order_number_present="no"

    elsif (params[:search_by]=="item_code")
      @item=MgInventoryItem.where("is_deleted=? and mg_school_id=? and code LIKE ?",0,session[:current_user_school_id],"%#{params[:temp_val]}%").pluck(:id)
      @vendor=MgInventoryVendorItem.where("is_deleted=? and mg_school_id=? and mg_item_id IN (?)",0,session[:current_user_school_id],@item).pluck(:mg_vendor_id)
      @search=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],@vendor)
      @code_present="yes"
      @code_order_number_present="no"

    elsif (params[:search_by]=="supplier_name")
      @vendor_id=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and name LIKE ?",0,session[:current_user_school_id],"%#{params[:temp_val]}%").pluck(:id)
      @inventory_proposal_item=MgInventoryProposalItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_vendor_id=>@vendor_id)
      @code_present="code_for_supplier_name"
      @code_order_number_present="no"

  elsif (params[:search_by]=="supplier_code")
      @vendor_id=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and vendor_code LIKE ?",0,session[:current_user_school_id],"%#{params[:temp_val]}%").pluck(:id)
      @inventory_proposal_item=MgInventoryProposalItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_vendor_id=>@vendor_id)
      @code_present="code_for_supplier_name"
      @code_order_number_present="no"

    end
    
    render :layout=>false
    
  end


  def inventory_comparing_data
    @code_present="temp"
    if (params[:itemName].present? && params[:itemCode].present?)
    @item=MgInventoryItem.where("is_deleted=? and mg_school_id=? and name LIKE ? and code LIKE ?",0,session[:current_user_school_id],"%#{params[:itemName]}%","%#{params[:itemCode]}%").pluck(:id)
    @vendor=MgInventoryVendorItem.where("is_deleted=? and mg_school_id=? and mg_item_id IN (?)",0,session[:current_user_school_id],@item).pluck(:mg_vendor_id)
    @search=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],@vendor)
    @code_present="yes"
    
    puts "norrrr"
    elsif params[:itemName].present?
    @item=MgInventoryItem.where("is_deleted=? and mg_school_id=? and name LIKE ?",0,session[:current_user_school_id],"%#{params[:itemName]}%").pluck(:id)
    @vendor=MgInventoryVendorItem.where("is_deleted=? and mg_school_id=? and mg_item_id IN (?)",0,session[:current_user_school_id],@item).pluck(:mg_vendor_id)
    @search=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],@vendor)
    @code_present="no"
    
    puts "no"
    elsif params[:itemCode].present?
    @item=MgInventoryItem.where("is_deleted=? and mg_school_id=? and code LIKE ?",0,session[:current_user_school_id],"%#{params[:itemCode]}%").pluck(:id)
    @vendor=MgInventoryVendorItem.where("is_deleted=? and mg_school_id=? and mg_item_id IN (?)",0,session[:current_user_school_id],@item).pluck(:mg_vendor_id)
    @search=MgInventoryVendor.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],@vendor)
    @code_present="yes"
    
    puts "yes"
    end
    
    render :layout=>false
    
  end


  # ========================================Item Proposal Starts============================================

  def proposal_new
    @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_inventory_store_management_id)
    @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
    int_value=1
    while true do
    @vendor_code = "V"+int_value.to_s
    code_count=MgInventoryProposal.where(:code=>@vendor_code,:mg_school_id=>session[:current_user_school_id]).count
    if code_count==0
      break
    end
    int_value=int_value+1
  end
  end

  def proposal_create
      @proposal=MgInventoryProposal.new(params_proposal)
      @proposal.save
      @proposal.update(:status=>"pending", :code=>params[:inventory][:code])
      @timeformat = MgSchool.find(session[:current_user_school_id])
      @requirement_date = Date.strptime(params[:inventory][:date],@timeformat.date_format)
      @proposal.update(:date=>@requirement_date)
      # =============================================================================================
        mg_item_id_arr=params[:mg_item_id] #params[:mg_item_id]
        mg_unit_type_id_arr=params[:mg_unit_type_id]
        no_of_unit_arr=params[:no_of_unit]
        if params[:mg_item_id].present?
          for j in 0...params[:mg_item_id].size
            if (mg_item_id_arr[j].to_i>0 && mg_unit_type_id_arr[j].to_i>0 && no_of_unit_arr[j].to_i>0 && params[:mg_inventory_vendor_id][j].present?)
              item_information=MgInventoryProposalItem.new
              item_information.mg_item_id=mg_item_id_arr[j]
              item_information.mg_unit_type_id=mg_unit_type_id_arr[j]
              item_information.no_of_unit=no_of_unit_arr[j]
              item_information.mg_inventory_proposal_id=@proposal.id
              item_information.mg_inventory_vendor_id=params[:mg_inventory_vendor_id][j]
              item_information.mg_school_id=session[:current_user_school_id]
              item_information.is_deleted=0
              item_information.created_by=session[:user_id]
              item_information.updated_by=session[:user_id]
              item_information.save
          end
        end
      end
      # =============================================================================================
      begin
        @finance_officer=MgFinanceOfficer.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @finance_officer.each do |officer|
        employee=MgEmployee.find_by(:id=>officer.mg_employee_id)
        sender=MgEmployee.find_by(:mg_user_id=>session[:user_id])
        subject="New Proposal is created by "+sender.try(:first_name)+" "+sender.try(:last_name)
        if params[:inventory][:description].present?
            description=params[:inventory][:description]
        else
            description=""
        end
        notification=MgNotification.send_notification(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
        notification.save

        email=MgNotification.send_email(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id])
        email.save
        end
      rescue
      end
      # =============================================================================================
    redirect_to :action=> "proposal"
  end

  def proposal_show
    # @employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_inventory_store_management_id)
    @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
    @inventory=MgInventoryProposal.find_by(:id=>params[:id])
    @item_information_details=MgInventoryProposalItem.where(:is_deleted=>0,:mg_inventory_proposal_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    @vendor=MgInventoryVendor.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:id=> @item_information_details.pluck(:mg_inventory_vendor_id)).pluck(:name, :id)
    render :layout=>false
  end

  def proposal_edit
    # @employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_inventory_store_management_id)
    @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
    @inventory=MgInventoryProposal.find_by(:id=>params[:id])
    @item_information_details=MgInventoryProposalItem.where(:is_deleted=>0,:mg_inventory_proposal_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
  end

  def proposal_delete
    @proposal=MgInventoryProposal.find_by(:id=>params[:id])
    @proposal.update(:is_deleted=>1)
    @proposalItem=MgInventoryProposalItem.where(:mg_inventory_proposal_id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    @proposalItem.each do |proposal|
      @proposal.update(:is_deleted=>1)
    end
    redirect_to :back
  end

  def proposal_update  
  @item=MgInventoryProposal.find_by(:id=>params[:id])
  @item.update(:requisition_name=>params[:inventory][:requisition_name],:date=>params[:inventory][:date],:description=>params[:inventory][:description])
  @timeformat = MgSchool.find(session[:current_user_school_id])
  @requirement_date = Date.strptime(params[:inventory][:date],@timeformat.date_format)
  @item.update(:date=>@requirement_date)
  @temp_item=MgInventoryProposalItem.where(:mg_inventory_proposal_id=>params[:id])
  date_for_accepted=params[:date_of_accepted]
  
  
  if @temp_item.present?
    @temp_item.each do |vendorItem|
      vendorItem.update(:is_deleted=>1)
    end
  end
  # =========================================================================================================
        mg_item_id_arr=params[:mg_item_id]
        mg_unit_type_id_arr=params[:mg_unit_type_id]
        no_of_unit_arr=params[:no_of_unit]
        if params[:status].present?
            status_arr=params[:status]
        end
        for j in 0...mg_item_id_arr.length
          if (mg_item_id_arr[j].to_i>0 && mg_unit_type_id_arr[j].to_i>0 && no_of_unit_arr[j].to_i>0)
            item_information=MgInventoryProposalItem.new()
            item_information.mg_item_id=mg_item_id_arr[j]
            item_information.mg_unit_type_id=mg_unit_type_id_arr[j]
            item_information.no_of_unit=no_of_unit_arr[j]
            if params[:status][j].present?
                item_information.status=status_arr[j]
            end
            if params[:invoice_number][j].present?
                item_information.invoice_number=params[:invoice_number][j]
            end
            if params[:mg_inventory_vendor_id][j].present?
                item_information.mg_inventory_vendor_id=params[:mg_inventory_vendor_id][j]
            end
            if params[:date_of_accepted][j].present?
              accepted_date = Date.strptime(date_for_accepted[j],@timeformat.date_format)
                item_information.date=accepted_date
            end
            if params[:remark_description][j].present?
              item_information.remark_description=params[:remark_description][j]  
            end
            if params[:po_number][j].present?
              item_information.po_number=params[:po_number][j]  
            end
            item_information.mg_inventory_proposal_id=@item.id
            item_information.mg_school_id=session[:current_user_school_id]
            item_information.is_deleted=0
            item_information.created_by=session[:user_id]
            item_information.updated_by=session[:user_id]
            item_information.save
        end
      end
    # =====================================================================================================
  redirect_to :action=> "proposal"
  end

  # ========================================================================================
  
  def assign_po
    @item_ids=params[:array_values]
      @item_ids.each do |i|#
        @po_vendor_update=MgInventoryProposalItem.find_by(:id=>i)
        @po_vendor_update.update(:po_number=>params[:po_number],:mg_inventory_vendor_id=>params[:vendor_id])
      end
      respond_to do |format|
      format.json  { render :json => ["done","updated"] }
      # format.json  { render :json =>[@available_quantity.to_json,@total_quantity.to_json]}
    end
  end
  # =======================================================================================

  def proposal
    # @employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    @proposal=MgInventoryProposal.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).paginate(page: params[:page], per_page: 10)
  end


def proposal_excel
  #puts params[:id]
  @school=session[:current_user_school_id]
  
  puts "============first================================================================="
  puts params[:salary_deduction].inspect
  puts "============first================================================================="



  @ids=params[:salary_deduction]


  if params[:salary_deduction].present?
      @inventory_proposals=MgInventoryProposalItem.where("is_deleted=? and mg_school_id=? and id IN (?)",0,session[:current_user_school_id],params[:salary_deduction].split(","))
  end

  respond_to do |format|
    format.html
    format.xls do
      # response.headers['Content-Disposition'] = 'attachment; filename="' + " Payroll report" + '.xls"'
      response.headers['Content-Disposition'] = 'attachment; filename="' + "Item Proposal" + '.xls"'
      render "proposal_excel.xls.erb"
    end
  end
  
end

  #Bindhu Work Starts
  def item_management_index
    @items=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def item_management_new
    
  end

  def item_name_based_on_item_category
    @items=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:mg_inventory_item_category_id]).pluck(:name,:id)
   
    render :layout=>false
  end

  def rack_based_on_room
    @racks=InventoryStackManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_room_management_id=>params[:mg_inventory_room_id]).pluck(:rack_no,:id)
    render :layout=>false
  end

  def room_based_on_item
    room_id=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>params[:mg_inventory_item_id]).pluck(:mg_inventory_room_id)
    @rooms=MgInventoryRoomManagement.where("is_deleted=0 AND mg_school_id=? AND id IN (?)",session[:current_user_school_id],room_id).pluck(:room_no,:id)
    render :layout=>false
  end

  def rack_based_on_room_and_item
    rack_ids=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_room_id=>params[:mg_inventory_room_id],:mg_inventory_item_id=>params[:mg_inventory_item_id]).where("quantity_available > 0").pluck(:mg_inventory_rack_id)
    @racks=InventoryStackManagement.where("is_deleted=0 AND mg_school_id=? AND id IN (?)",session[:current_user_school_id],rack_ids).pluck(:rack_no,:id)
    render :layout=>false
  end

  def auto_generating_id_from_prefix
    item=MgInventoryItem.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:mg_inventory_item_id])
    item_count=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>params[:mg_inventory_item_id]).count
    increment_count=item_count.to_i+1
    @auto_generated_id=item.prefix+""+increment_count.to_s
    respond_to do |format|
      format.json  { render :json =>@auto_generated_id.to_json}
    end
    # render :layout=>false
  end

  def item_management_create
    item=MgInventoryItemManagement.new(item_management_params)
    if item.save
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      updated_date_of_expiry=Date.strptime(params[:mg_inventory_item_management][:date_of_expiry],school.date_format)
      item.update(:date_of_expiry=>updated_date_of_expiry)
      item.update(:quantity_available=>item.quantity)
      flash[:notice]="Stock added successfully"
      redirect_to item_management_index_path
    end
  end

  def item_management_edit
    @item=MgInventoryItemManagement.find(params[:id])
    # render :layout=>false
  end
  
  def item_management_update
    item=MgInventoryItemManagement.find(params[:id])
    if item.update(item_management_params)
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      if params[:mg_inventory_item_management][:date_of_expiry].present?
      updated_date_of_expiry=Date.strptime(params[:mg_inventory_item_management][:date_of_expiry],school.date_format)
      end
      item.update(:date_of_expiry=>updated_date_of_expiry)
      item.update(:quantity_available=>item.quantity)
      flash[:notice]="Stock updated successfully"
      redirect_to item_management_index_path
    end
  end

  def item_management_show
    @item=MgInventoryItemManagement.find(params[:id])
    render :layout=>false
  end

  def item_management_delete
    item=MgInventoryItemManagement.find(params[:id])
    if item.update(:is_deleted=>1)
      redirect_to item_management_index_path
    end
  end

  def inventory_item_consumption_index
    @consumption_items=MgInventoryItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def inventory_item_consumption_new
  end

  def auto_generating_id_from_prefix_consumption
    item=MgInventoryItem.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:mg_inventory_item_id])
    item_count=MgInventoryItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>params[:mg_inventory_item_id]).count
    increment_count=item_count.to_i+1
    @auto_generated_id=item.prefix+""+increment_count.to_s
    respond_to do |format|
      format.json  { render :json =>@auto_generated_id.to_json}
    end
  end

  def item_available_quantity
    @available_quantity,@total_quantity=quantity_available_method(params[:mg_inventory_item_id],params[:mg_inventory_rack_id])
    puts @available_quantity
    puts @total_quantity
    respond_to do |format|
      format.json  { render :json => [@available_quantity,@total_quantity] }
      # format.json  { render :json =>[@available_quantity.to_json,@total_quantity.to_json]}
    end
  end

  def inventory_item_consumption_create
    MgInventoryItemConsumption.transaction do
      item_consumption=MgInventoryItemConsumption.new(item_consumption_params)
      if item_consumption.save
        school=MgSchool.find_by(:id=>session[:current_user_school_id])
        updated_consumption_date=Date.strptime(params[:mg_inventory_item_consumption][:consumption_date],school.date_format)
        item_consumption.update(:consumption_date=>updated_consumption_date)

        item_in_stock=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_rack_id=>item_consumption.mg_inventory_rack_id,:mg_inventory_item_id=>item_consumption.mg_inventory_item_id)
        total_quantity_available_manage=item_consumption.quantity_available.to_i - item_consumption.quantity_consumed.to_i
        item_in_stock.each do |item_manage|
          item_manage.update(:quantity_available=>total_quantity_available_manage)
        end

        if item_consumption.consumption_type=="issued"
          #if item Consumption is issued for students Code Starts
          if params[:studentIds].present?
            student_list=params[:studentIds]
            student_list.each do |student_id|
              issued_item_consumption=MgInventoryIssuedItemConsumption.new
              issued_item_consumption.mg_inventory_item_consumption_id=item_consumption.id
              issued_item_consumption.mg_consumer_type=params[:mg_consumer_type_id]
              issued_item_consumption.mg_student_id=student_id
              issued_item_consumption.mg_batch_id=params[:mg_batch_id]
              issued_item_consumption.mg_school_id=session[:current_user_school_id]
              issued_item_consumption.is_deleted=0
              issued_item_consumption.created_by=session[:user_id]
              issued_item_consumption.updated_by=session[:user_id]
              issued_item_consumption.save
            end
          end
          #if item Consumption is issued for students Code Ends

          #if item Consumption is issued for employees Code starts
            if params[:employeeIds].present?
            employee_list=params[:employeeIds]
            employee_list.each do |employee_id|
              issued_item_consumption_employee=MgInventoryIssuedItemConsumption.new
              issued_item_consumption_employee.mg_inventory_item_consumption_id=item_consumption.id
              issued_item_consumption_employee.mg_consumer_type=params[:mg_consumer_type_id]
              issued_item_consumption_employee.mg_employee_id=employee_id
              issued_item_consumption_employee.mg_department_id=params[:mg_department_id]
              issued_item_consumption_employee.mg_school_id=session[:current_user_school_id]
              issued_item_consumption_employee.is_deleted=0
              issued_item_consumption_employee.created_by=session[:user_id]
              issued_item_consumption_employee.updated_by=session[:user_id]
              issued_item_consumption_employee.save
            end
          end
          #if item Consumption is issued for employees Code Ends
        end

        #For Notification
        quantity_available,total_quantity_available=quantity_available_method(item_consumption.mg_inventory_item_id,item_consumption.mg_inventory_rack_id)
        item_minimum_quantity_required=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>item_consumption.mg_inventory_item_id)
        
        if total_quantity_available.to_i < item_minimum_quantity_required[0].minimum_quantity_required.to_i
          #Notification will go to Store Manager
          item=MgInventoryItem.find_by(:id=>item_consumption.mg_inventory_item_id)
          subject="Item Threshold"
          description="Dear Sir/Madam,#{item.name} availablity is below minimum required."
          room=MgInventoryRoomManagement.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>item_consumption.mg_inventory_room_id)
          store_manager_id=MgInventoryStoreManager.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_store_management_id=>room.mg_inventory_store_management_id)
          to_employee=MgEmployee.where(:id=>store_manager_id.mg_employee_id)
          to_employee.each do |employee|
            notification=MgNotification.send_notification(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
            notification.save
            puts "notification Success"
          end
        end
        flash[:notice]="Item Consumption Added Successfully"
        redirect_to inventory_item_consumption_index_path
      else
        flash[:notice]="Error Occured"
        redirect_to inventory_item_consumption_index_path
      end
    end
  end

  def inventory_item_consumption_edit
    @item_consumption=MgInventoryItemConsumption.find(params[:id])
    @available_quantity,@total_quantity=quantity_available_method(@item_consumption.mg_inventory_item_id,@item_consumption.mg_inventory_rack_id)
    if @item_consumption.consumption_type=="issued"
      @item_issued_detail=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
      @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
      @department=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:department_name,:id)
      @employee_ids=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
      @student_ids=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
    end
    if @item_consumption.consumption_type=="onshelf"
      @item_damaged_return=MgInventoryItemDamaged.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
      @item_return=MgInventoryItemReturn.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
      if (@item_damaged_return.present?)
        if @item_damaged_return.mg_student_id.present?
          @consumer_type="student"
          damaged_student_ids=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
          @damaged_student_list=MgStudent.where("id IN (?)",damaged_student_ids).pluck(:first_name,:id)
          return_student_ids=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
          @return_student_list=MgStudent.where("id IN (?)",return_student_ids).pluck(:first_name,:id) 
        elsif @item_damaged_return.mg_employee_id.present?
          @consumer_type="employee"
          damaged_employee_ids=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
          @damaged_employee_list=MgEmployee.where("id IN (?)",damaged_employee_ids).pluck(:first_name,:id)
          return_employee_ids=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
          @return_employee_list=MgEmployee.where("id IN (?)",return_employee_ids).pluck(:first_name,:id)
        end
        @return_date=@item_damaged_return.return_date
      end
      if (@item_return.present?)
        @return_date=@item_return.return_date
        if @item_return.mg_student_id.present?
          @consumer_type="student"
          damaged_student_ids=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
          @damaged_student_list=MgStudent.where("id IN (?)",damaged_student_ids).pluck(:first_name,:id)
          return_student_ids=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_student_id)
          @return_student_list=MgStudent.where("id IN (?)",return_student_ids).pluck(:first_name,:id)
        elsif @item_return.mg_employee_id.present?
          @consumer_type="employee"
          damaged_employee_ids=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
          @damaged_employee_list=MgEmployee.where("id IN (?)",damaged_employee_ids).pluck(:first_name,:id)
          return_employee_ids=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id]).pluck(:mg_employee_id)
          @return_employee_list=MgEmployee.where("id IN (?)",return_employee_ids).pluck(:first_name,:id)
        end
      end
    end
  end

  def inventory_item_consumption_update
    MgInventoryItemConsumption.transaction do
      item_consumption=MgInventoryItemConsumption.find(params[:id])
      if item_consumption.update(item_consumption_params)
        school=MgSchool.find_by(:id=>session[:current_user_school_id])
        updated_consumption_date=Date.strptime(params[:mg_inventory_item_consumption][:consumption_date],school.date_format)
        item_consumption.update(:consumption_date=>updated_consumption_date)

        item_in_stock=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_rack_id=>item_consumption.mg_inventory_rack_id,:mg_inventory_item_id=>item_consumption.mg_inventory_item_id)
        total_quantity_available_manage=item_consumption.quantity_available.to_i - item_consumption.quantity_consumed.to_i
        item_in_stock.each do |item_manage|
          item_manage.update(:quantity_available=>total_quantity_available_manage)
        end
        #For Onshelf
        if(item_consumption.consumption_type=="onshelf")
          if(params[:damagedIds]).present?
            if(params[:consumer_type]=="employee")
              damaged_employee_list=params[:damagedIds]
              damaged_employee_list.each do |employee_id|
                is_employee_present_in_return=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
                if is_employee_present_in_return.present?
                  is_employee_present_in_return.update(:is_deleted=>1)
                end
                is_employee_present_in_damaged=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
                if is_employee_present_in_damaged.present?
                  is_employee_present_in_damaged.update(:is_deleted=>0)
                else
                  item_damaged=MgInventoryItemDamaged.new
                  item_damaged.mg_employee_id=employee_id
                  adding_audit_fields(item_damaged,params[:id],params[:return_date])
                end
              end
            elsif (params[:consumer_type]=="student")
              damaged_student_list=params[:damagedIds]
              damaged_student_list.each do |student_id|
                is_student_present_in_return=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
                if is_student_present_in_return.present?
                  is_student_present_in_return.update(:is_deleted=>1)
                end
                is_student_present_in_damaged=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
                if is_student_present_in_damaged.present?
                  is_student_present_in_damaged.update(:is_deleted=>0)
                else
                  item_damaged=MgInventoryItemDamaged.new
                  item_damaged.mg_student_id=student_id
                  adding_audit_fields(item_damaged,params[:id],params[:return_date])
               end
              end
             end
          end

          if(params[:returnIds]).present?
            if(params[:consumer_type]=="employee")
              return_employee_list=params[:returnIds]
              return_employee_list.each do |employee_id|
                is_employee_present_in_return=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
                if is_employee_present_in_return.present?

                  is_employee_present_in_return.update(:is_deleted=>1)
                end
                is_employee_present_in_damaged=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_employee_id=>employee_id,:mg_school_id=>session[:current_user_school_id])
                if is_employee_present_in_damaged.present?
                  is_employee_present_in_damaged.update(:is_deleted=>0)
                else
                  item_return=MgInventoryItemReturn.new
                  item_return.mg_employee_id=employee_id
                  adding_audit_fields(item_return,params[:id],params[:return_date])
                end
              end
            elsif (params[:consumer_type]=="student")
              return_student_list=params[:returnIds]
              return_student_list.each do |student_id|
                is_student_present_in_return=MgInventoryItemDamaged.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
                if is_student_present_in_return.present?
                  is_student_present_in_return.update(:is_deleted=>1)
                end
                is_student_present_in_damaged=MgInventoryItemReturn.find_by(:mg_inventory_item_consumption_id=>params[:id],:mg_student_id=>student_id,:mg_school_id=>session[:current_user_school_id])
                if is_student_present_in_damaged.present?
                  is_student_present_in_damaged.update(:is_deleted=>0)
                else
                  item_return=MgInventoryItemReturn.new
                  item_return.mg_student_id=student_id
                  adding_audit_fields(item_return,params[:id],params[:return_date])
                end
              end
            end
          end
        end
      end
      flash[:notce]="Item Consumption Updated Successfully"
      redirect_to inventory_item_consumption_index_path
    end
  end

  def adding_audit_fields(object,item_consumption_id,return_date)
    object.mg_inventory_item_consumption_id=item_consumption_id
    object.mg_school_id=session[:current_user_school_id]
    object.is_deleted=0
    object.created_by=session[:user_id]
    object.updated_by=session[:user_id]
    object.save
    if return_date.present?
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      returnDate = Date.strptime(return_date,school.date_format)
      object.update(:return_date=>returnDate)
    end
  end

  def inventory_item_consumption_show
    @item=MgInventoryItemConsumption.find(params[:id])
    if @item.consumption_type=="issued"
      @item_issued=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
    end
    @item_damaged=MgInventoryItemDamaged.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
    @item_returned=MgInventoryItemReturn.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:id])
    if @item_damaged.present?
      if @item_damaged[0].mg_student_id.present?
        @consumer_type="student"
      elsif @item_damaged[0].mg_employee_id.present?
        @consumer_type="employee"
      end
    end
    if @item_returned.present?
      if @item_returned[0].mg_student_id.present?
        @consumer_type="student"
      elsif @item_returned[0].mg_employee_id.present?
        @consumer_type="employee"
      end
    end
    render :layout=>false
  end

  def inventory_item_consumption_delete
    item_consumption=MgInventoryItemConsumption.find(params[:id])
    item_consumption.update(:is_deleted=>1)
    redirect_to inventory_item_consumption_index_path
  end

  def quantity_available_method(item_id,rack_id)
    item_quantity=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>item_id,:mg_inventory_rack_id=>rack_id)
    total_item_quantity=MgInventoryItemManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>item_id)
    
    total_quantity=0
    quantity_available=0
    
    total_item_quantity.each do |i_quantity|
      # quantity_available=quantity_available.to_i + i_quantity.quantity.to_i
      total_quantity=total_quantity.to_i + i_quantity.quantity.to_i
    end

    item_quantity.each do |i_quantity|
      quantity_available=quantity_available.to_i + i_quantity.quantity.to_i
      # total_quantity=total_quantity.to_i + i_quantity.quantity.to_i
    end
    
    item_consumed=MgInventoryItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>item_id,:mg_inventory_rack_id=>rack_id)
    total_item_consumed=MgInventoryItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_id=>item_id)
    
    total_consumed_value=0
    consumed_value=0
    
    item_consumed.each do |item|
      consumed_value=consumed_value.to_i + item.quantity_consumed.to_i
    end

    total_item_consumed.each do |item|
      total_consumed_value=total_consumed_value.to_i + item.quantity_consumed.to_i
    end

    @available_quantity=quantity_available - consumed_value
    @total_available_quantity=total_quantity - total_consumed_value
    
    # puts quantity_available
    # puts consumed_value
    
    puts @available_quantity
    puts @total_available_quantity

    return @available_quantity,@total_available_quantity
  end

  def item_search
  end

  def item_search_data
    if (params[:seach_item_name].present? && params[:search_item_code].present?)
      @items=MgInventoryItem.where("is_deleted=? AND mg_school_id=? AND name LIKE ? AND code LIKE ?",0,session[:current_user_school_id],"%#{params[:seach_item_name]}%","%#{params[:search_item_code]}%")
    elsif (params[:seach_item_name].present?)
      @items=MgInventoryItem.where("is_deleted=? AND mg_school_id=? AND name LIKE ?",0,session[:current_user_school_id],"%#{params[:seach_item_name]}%")
    elsif (params[:search_item_code].present?)
      @items=MgInventoryItem.where("is_deleted=? AND mg_school_id=? AND code LIKE ?",0,session[:current_user_school_id],"%#{params[:search_item_code]}%")
    end
    puts @items.inspect
    @item_name=params[:seach_item_name]
    @item_code=params[:search_item_code]
    render :layout=>false
  end

  def inventory_consumption_type_changes
    render :layout=>false
  end

  def inventory_consumption_for_employee
    @department=MgEmployeeDepartment.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:department_name,:id)
    render :layout=>false
  end

  def inventory_consumption_for_student
    @batches=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    render :layout=>false
  end

  def department_wise_employee_list
    @employees=MgEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>params[:mg_department_id])
    render :layout=>false

  end

  def batch_wise_student_list
    @students=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>params[:mg_batch_id])
    # puts ll
    render :layout=>false
  end

  def item_consumption_onshelf
    item_consumption_onshelf=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:mg_item_consumption_id])
    @consumer_type=item_consumption_onshelf[0].mg_consumer_type
    if @consumer_type=="student"
      student_ids=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:mg_item_consumption_id]).pluck(:mg_student_id)
      @issued_list=MgStudent.where("id in (?)",student_ids).pluck(:first_name,:id)
    elsif @consumer_type=="employee"
      employee_ids=MgInventoryIssuedItemConsumption.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_item_consumption_id=>params[:mg_item_consumption_id]).pluck(:mg_employee_id)
      @issued_list=MgEmployee.where("id in (?)",employee_ids).pluck(:first_name,:id)
    else
    end
    render :layout=>false
  end

  def inventory_item_report
    @items=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page],per_page: 10)
    @item_category_list=MgInventoryItemCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  end

  def inventory_item_report_by_category
    if (params[:item_category_id]=="all")||(params[:item_category_id]=="")
      @items=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page],per_page: 10)
    else 
      @items=MgInventoryItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_category_id=>params[:item_category_id]).paginate(page: params[:page],per_page: 10)
    end
    render :layout=>false
  end

  #Bindhu Work Ends

  #Bindhu Work Starts For Generate Fine
  def inventory_generate_fine
    @fines=MgInventoryFineParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def inventory_fine_particular_new
    render :layout=>false
  end

  def inventory_fine_particular_create
    MgInventoryFineParticular.transaction do
      inventory_fine_particular=MgInventoryFineParticular.new(inventory_fine_particular_params)
      inventory_fine_particular.save
      selected_student_ids=params[:selectedStudents]
      selected_student_ids.each do |student_id|
        fine_particular=MgFeeFineParticular.new(inventory_fine_params)
        student=MgStudent.find(student_id)
        fine_particular.mg_student_id=student_id
        fine_particular.mg_batch_id=student.mg_batch_id
        fine_particular.fine_from="inventory"
        fine_particular.mg_inventory_fine_particular_id=inventory_fine_particular.id
        if params[:inventory_new_fine_particular][:mg_account_id].present?
          if params[:inventory_new_fine_particular][:mg_account_id]=="central"
            fine_particular.is_to_central=1
          else
            fine_particular.mg_account_id=params[:inventory_new_fine_particular][:mg_account_id]
          end
        end
        if fine_particular.save
          current_school = MgSchool.find(session[:current_user_school_id])
          startDate = Date.strptime(params[:inventory_new_fine_particular][:start_date],current_school.date_format)
          endDate =Date.strptime(params[:inventory_new_fine_particular][:end_date],current_school.date_format)
          dueDate = Date.strptime(params[:inventory_new_fine_particular][:due_date],current_school.date_format)
          fine_particular.update(:start_date=>startDate,:end_date=>endDate,:due_date=>dueDate)
        end
      end
      flash[:notice]="Fine Created Successfully"
      redirect_to inventory_generate_fine_path
    end
  end


  def show_fine_fee_particular
    @fine_particular = MgInventoryFineParticular.find(params[:id])
    render :layout => false
  end

  def inventory_fine_particular_edit
    @fine_particular=MgInventoryFineParticular.find(params[:id])
    render :layout=>false
  end

  def inventory_fine_particular_update
    MgInventoryFineParticular.transaction do
      @fine_particular=MgInventoryFineParticular.find(params[:inventory_new_fine_particular][:ids])
      @fine_particular.update(:amount=>params[:inventory_new_fine_particular][:amount])
      @fine_particular_table=MgFeeFineParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_fine_particular_id=>params[:inventory_new_fine_particular][:ids])
      @fine_particular_table.each do |particular|
        particular.update(:amount=>params[:inventory_new_fine_particular][:amount])
        current_school = MgSchool.find(session[:current_user_school_id])
        startDate = Date.strptime(params[:start_date],current_school.date_format)
        endDate =Date.strptime(params[:end_date],current_school.date_format)
        dueDate = Date.strptime(params[:due_date],current_school.date_format)
        particular.update(:start_date=>startDate,:end_date=>endDate,:due_date=>dueDate)
      end
    end
    flash[:notice]="Fine particular updated successfully"
    redirect_to inventory_generate_fine_path
  end

  def destroy_fee_fine_particular
    @fine_particular=MgInventoryFineParticular.find(params[:id])
    @fine_particular.update(:is_deleted=>1)
    @fine_particular_table=MgFeeFineParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_inventory_fine_particular_id=>params[:id])
    @fine_particular_table.each do |particular|
      particular.update(:is_deleted=>1)
    end
    redirect_to inventory_generate_fine_path
  end

  #Bindhu Work Ends For Generate Fine


    #Kumar work Starts
  def select_department_wise_item
     # @subId=params[:mg_subject_id]
     @deptid=params[:dept_data]
     # if params[:mg_subject_id].present?
     #  empId=MgLaboratoryIncharge.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_subject_id=>@subId,:incharge_type=>"Assistant Incharge").pluck(:mg_employee_id)
     #            if empId.present?
     #                  @employeeList=MgEmployee.where("mg_employee_department_id=? and is_deleted=? and mg_school_id=? and id NOT IN (?)",@deptid,0,session[:current_user_school_id],empId)
     #            else
                      @employeeList=MgInventoryItem.where(:mg_category_id=>@deptid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      #           end
      # else
      # #@employeeList=MgEmployee.where("mg_employee_department_id=? and is_deleted=? and mg_school_id=?",@deptid,0,session[:current_user_school_id])
      # @employeeList=MgEmployee.where(:mg_employee_department_id=>@deptid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      
      # end
      @employee_ary=Array.new
      @employeeList.each do|list|
      list_ary=Array.new()
      item_name=list.name
      dept_data=MgInventoryItemCategory.find_by(:id=>list.mg_category_id)
    if dept_data.present?
      dept_name=dept_data.name
    else
      dept_name="null"
    end
      key="#{item_name}(#{dept_data.try(:name)}) "
      value=list.id
      list_ary.push(key,value)
      @employee_ary.push(list_ary)
    end
 render :layout=>false
  end

  def category_wise_item
    puts "============================================================="
    puts params[:mg_category_id]
    puts params[:vendor_id]
    puts "============================================================="

    temp=MgInventoryVendorItem.where(:mg_vendor_id=>params[:vendor_id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
     if temp.present?
      tempItem=""
      temp.each do |vendor|
        if params[:mg_category_id].present?
          tempItemName=MgInventoryItem.find_by(:mg_category_id=>params[:mg_category_id],:id=>vendor.mg_item_id)
            if tempItemName.present?
            else
              next
            end
        else
          tempItemName=MgInventoryItem.find_by(:id=>vendor.mg_item_id)
        end
        #tempItemName=MgInventoryItem.find_by(:id=>vendor.mg_item_id)
        tempItem+=tempItemName.try(:name)
        tempItem+=", "
      end

      strlength=tempItem.length
      @reqStr=tempItem.slice(0,strlength-2)
      #return @reqStr
      respond_to do |format|
      format.json  { render :json =>@reqStr.to_json}
    end
    else
      @nill=""
      #return @nill
      respond_to do |format|
      format.json  { render :json =>@nill.to_json}
    end
    end

  end


  def proposal_review
    @proposal=MgInventoryProposal.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end



  def review_edit
    @inventory=MgInventoryProposal.find_by(:id=>params[:id])
    @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>@inventory.mg_user_id).pluck(:mg_inventory_store_management_id)
    @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
    @inventory=MgInventoryProposal.find_by(:id=>params[:id])
    @item_information_details=MgInventoryProposalItem.where(:is_deleted=>0,:mg_inventory_proposal_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
  end


  def proposal_report_show
      @inventory=MgInventoryProposal.find_by(:id=>params[:id])
      @employee=MgEmployee.find_by(:id=>@inventory.mg_employee_id)
      @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>@employee.id).pluck(:mg_inventory_store_management_id)
      @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
      @inventory=MgInventoryProposal.find_by(:id=>params[:id])
      @item_information_details=MgInventoryProposalItem.where(:is_deleted=>0,:mg_inventory_proposal_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
      render :layout=>false
  end


  def projection_report_show
      @inventory=MgInventoryProjection.find_by(:id=>params[:id])
      # @employee=MgEmployee.find_by(:id=>@inventory.mg_employee_id)
      @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_inventory_store_management_id)
      @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
      @inventory=MgInventoryProjection.find_by(:id=>params[:id])
      @item_information_details=MgInventoryProjectionItem.where(:is_deleted=>0,:mg_inventory_projection_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
      render :layout=>false
  end

    def review_update
      @item=MgInventoryProposal.find_by(:id=>params[:id])
      @item.update(:status=>params[:status], :remark=>params[:inventory][:remark] ,:amount=>params[:amount])
      if params[:mg_account_id].present?
        if params[:mg_account_id]=="central"
          @item.update(:is_from_central=>1)
        else
          @item.update(:mg_account_id=>params[:mg_account_id])
        end
      end
       # ===========================================================================================
      if params[:status]=="rejected"
          begin
            employee=MgEmployee.find_by(:id=>@item.mg_employee_id)
            sender=MgEmployee.find_by(:mg_user_id=>session[:user_id])
            subject="Proposal is rejected"
            if params[:inventory][:remark].present?
                description=params[:inventory][:remark]
            else
                description=""
            end
            notification=MgNotification.send_notification(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
            notification.save
            email=MgNotification.send_email(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id])
            email.save
          rescue
          end
      end
      # =============================================================================================
      # =======================================================================================
       if params[:status]=="accepted"
          if @item.is_from_central.present?
            transaction_object=MgCentralAccountTransaction.where(:for_module=>"vendor",:mg_particular_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            from_account_id=""
            vendor_transaction(from_account_id,transaction_object,params[:amount],params[:id],"MgCentralAccountTransaction")
          elsif @item.mg_account_id.present?
            transaction_object=MgAccountTransaction.where(:for_module=>"vendor",:mg_particular_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            from_account_id=params[:mg_pre_account_id]#.to_i
            vendor_transaction(from_account_id,transaction_object,params[:amount],params[:id],"MgAccountTransaction")
          end
        
      end
      # =======================================================================================

      redirect_to :action=>"proposal_review"
    end

    #Bindhu Added for Acounts Starts
    def vendor_transaction(from_account_id,transaction_object,amount,vendor_particular_id,string_account_type)
      credited_amount=0
      debited_amount=0
      transaction_object.each do |particular|
        if particular.try(:amount_transfer_type)=="credited"
          credited_amount+=particular.try(:amount)
        elsif particular.try(:amount_transfer_type)=="debited"
          debited_amount+=particular.try(:amount)
        end
      end
      params_amount=amount.to_i
      temp_amount=0
      temp_amount=credited_amount-debited_amount
      if temp_amount<0
        temp_amount=temp_amount*-1
      end
      if temp_amount>params_amount
        amount_transfer_type="credited"
        amount=temp_amount-params_amount
      elsif temp_amount<params_amount
        amount_transfer_type="debited"
        amount=params_amount-temp_amount
      end
      to_account_id=""
      for_module="vendor"
      particular_id=vendor_particular_id
      transaction_type="payable"
      if string_account_type=="MgAccountTransaction"
        account_transaction=MgAccountTransaction.add_transaction(from_account_id,to_account_id,amount.abs,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
        account_transaction.save
      elsif string_account_type=="MgCentralAccountTransaction"
        central_account_transaction=MgCentralAccountTransaction.send_transaction(from_account_id,to_account_id,amount.abs,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
        central_account_transaction.save
      end
    end
    #Bindhu Added for Acounts Ends

    def projection
      # @employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
      @proposal=MgInventoryProjection.where(:mg_user_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    end


    def projection_new
        # @employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
        @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_inventory_store_management_id)
        @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
        #render :layout=>false
    end


    def projection_create
      
      @proposal=MgInventoryProjection.new(params_proposal)
      @proposal.save
      @proposal.update(:status=>"pending")
      @timeformat = MgSchool.find(session[:current_user_school_id])
      @requirement_date = Date.strptime(params[:inventory][:date],@timeformat.date_format)
      @proposal.update(:date=>@requirement_date)
      # =============================================================================================
        mg_item_id_arr=params[:inventory][:mg_item_id]
        mg_unit_type_id_arr=params[:mg_unit_type_id]
        no_of_unit_arr=params[:no_of_unit]

        for j in 0...mg_item_id_arr.length
          if (mg_item_id_arr[j].to_i>0 && mg_unit_type_id_arr[j].to_i>0 && no_of_unit_arr[j].to_i>0)
        item_information=MgInventoryProjectionItem.new()
        item_information.mg_item_id=mg_item_id_arr[j]
        item_information.mg_unit_type_id=mg_unit_type_id_arr[j]
        item_information.no_of_unit=no_of_unit_arr[j]
        item_information.mg_inventory_projection_id=@proposal.id
        item_information.mg_school_id=session[:current_user_school_id]
        item_information.is_deleted=0
        item_information.created_by=session[:user_id]
        item_information.updated_by=session[:user_id]
        item_information.save
        end
      end
      # ===========================================================================================
      begin
        @finance_officer=MgFinanceOfficer.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @finance_officer.each do |officer|
        employee=MgEmployee.find_by(:id=>officer.mg_employee_id)
        sender=MgEmployee.find_by(:mg_user_id=>session[:user_id])
        subject="New Projection is created by "+sender.try(:first_name)+" "+sender.try(:last_name)
        if params[:inventory][:description].present?
            description=params[:inventory][:description]
        else
            description=""
        end
        notification=MgNotification.send_notification(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
        notification.save

        email=MgNotification.send_email(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id])
        email.save
        end
      rescue
      end
      # =============================================================================================
    redirect_to :action=> "projection"
  end

    def projection_update

  @item=MgInventoryProjection.find_by(:id=>params[:id])
  @item.update(:requisition_name=>params[:inventory][:requisition_name],:date=>params[:inventory][:date],:description=>params[:inventory][:description])
  @timeformat = MgSchool.find(session[:current_user_school_id])
  @requirement_date = Date.strptime(params[:inventory][:date],@timeformat.date_format)
  @item.update(:date=>@requirement_date)

  @temp_item=MgInventoryProjectionItem.where(:mg_inventory_projection_id=>params[:id])

  if @temp_item.present?
    @temp_item.each do |vendorItem|
      vendorItem.update(:is_deleted=>1)
    end
  end
  # =========================================================================================================
        mg_item_id_arr=params[:mg_item_id]
        mg_unit_type_id_arr=params[:mg_unit_type_id]
        no_of_unit_arr=params[:no_of_unit]
        
        for j in 0...mg_item_id_arr.length
          if (mg_item_id_arr[j].to_i>0 && mg_unit_type_id_arr[j].to_i>0 && no_of_unit_arr[j].to_i>0)
        item_information=MgInventoryProjectionItem.new()
        item_information.mg_item_id=mg_item_id_arr[j]
        item_information.mg_unit_type_id=mg_unit_type_id_arr[j]
        puts no_of_unit_arr[j]
        item_information.no_of_unit=no_of_unit_arr[j]

        item_information.mg_inventory_projection_id=@item.id
        item_information.mg_school_id=session[:current_user_school_id]
        item_information.is_deleted=0
        item_information.created_by=session[:user_id]
        item_information.updated_by=session[:user_id]
        item_information.save
        end
      end
    # =====================================================================================================
  redirect_to :action=> "projection"
  end

  def projection_show
    # @employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_inventory_store_management_id)
    @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
    @inventory=MgInventoryProjection.find_by(:id=>params[:id])
    @item_information_details=MgInventoryProjectionItem.where(:is_deleted=>0,:mg_inventory_projection_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
  
    render :layout=>false
  end


  def projection_review
    @proposal=MgInventoryProjection.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end



    def projection_review_edit
      @inventory=MgInventoryProjection.find_by(:id=>params[:id])
      @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>@inventory.mg_user_id).pluck(:mg_inventory_store_management_id)
      @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
      @inventory=MgInventoryProjection.find_by(:id=>params[:id])
      @item_information_details=MgInventoryProjectionItem.where(:is_deleted=>0,:mg_inventory_projection_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    end

    def projection_review_update
      @item=MgInventoryProjection.find_by(:id=>params[:id])
      @item.update(:status=>params[:status], :remark=>params[:inventory][:remark])
      # ===========================================================================================
      if params[:status]=="rejected"
          begin
            employee=MgEmployee.find_by(:id=>@item.mg_employee_id)
            sender=MgEmployee.find_by(:mg_user_id=>session[:user_id])
            subject="Projection is rejected"
            if params[:inventory][:remark].present?
                description=params[:inventory][:remark]
            else
                description=""
            end
            notification=MgNotification.send_notification(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id],0,session[:user_id],session[:user_id])
            notification.save
            email=MgNotification.send_email(session[:user_id],employee.mg_user_id,subject,description,session[:current_user_school_id])
            email.save
          rescue
          end
      end
      # =============================================================================================
     
      redirect_to :action=>"projection_review"
    end

    def projection_edit
      # @employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
      @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_inventory_store_management_id)
      @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)
      @inventory=MgInventoryProjection.find_by(:id=>params[:id])
      @item_information_details=MgInventoryProjectionItem.where(:is_deleted=>0,:mg_inventory_projection_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    end

    def projection_delete
        @proposal=MgInventoryProjection.find_by(:id=>params[:id])
        @proposal.update(:is_deleted=>1)
        @proposalItem=MgInventoryProjectionItem.where(:mg_inventory_projection_id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
        @proposalItem.each do |proposal|
        @proposal.update(:is_deleted=>1)
      end
      redirect_to :back
    end
  #Kumar work Ends

  def select_inventory_category
  
   puts params
   @mg_inventory_item = MgInventoryItem.where(:mg_category_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
   respond_to do |format|
     format.json  { render :json => @mg_inventory_item }
   end
  end
  
  def index_store_manager
    @store_manager=MgUser.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:user_type=>"store_manager").paginate(page: params[:page], per_page: 10)
  end
    
  def new_store_manager 
    render :layout=>false
  end

  def create_store_manager
      school_subdomain= MgSchool.where(:id=>session[:current_user_school_id],:is_deleted=>0)
      @subdomain = school_subdomain[0].subdomain
      @user_name = @subdomain + params[:store_manager][:user_name]

    MgInventoryStoreManager.transaction do
      store_manager=MgUser.new(store_manager_login_params)
      store_manager.user_name=@user_name
      store_manager.save

      role=MgRole.find_by(:role_name=>"store_manager")
      if role.id.present?
        @user_role = store_manager.mg_user_roles.build(:mg_role_id => role.id)
        @user_role.save 
      end
      inventory_store_manager=MgInventoryStoreManager.new
      inventory_store_manager.mg_user_id=store_manager.id
      inventory_store_manager.mg_inventory_store_management_id=params[:mg_inventory_store_management_id]
      inventory_store_manager.is_deleted=0
      inventory_store_manager.mg_school_id=session[:current_user_school_id]
      inventory_store_manager.created_by=session[:user_id]
      inventory_store_manager.updated_by=session[:user_id]
      if inventory_store_manager.save
        flash[:notice]="Manager created successfully."
      else
        flash[:error]="Manager already created for store."
        @_errors=true
      end
      raise ActiveRecord::Rollback if @_errors
    end
    redirect_to :action=> "index_store_manager"
  end

  def edit_store_manager
    @store_manager=MgUser.find(params[:id])
    render :layout=>false
  end

  def update_store_manager
    
    @user_name = params[:subdomain] + params[:store_manager][:user_name]

    user=MgUser.find(params[:store_manager][:id])
    if user.update(:user_name=>@user_name)
      flash[:notice]="Manager updated successfully."
    else
      flash[:error]="Error occured,Please try later."
    end

    if params[:change_store_username]=="change_username_by_admin"
      redirect_to :action=>"index_store_manager"
    elsif params[:change_store_username]=="change_username_by_user"
      redirect_to :action=>"store_information"
    end
  end

  def show_store_manager
    @store_manager=MgUser.find_by(:id=>params[:id])
    render :layout=>false
  end

  

def store_manager_change_password
    @store_manager_variable=false
    @fff = params[:store_manager]
    @curr = @fff[:name]
    id=@fff[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)

    #@bool=@user.authenticate(user_name, @curr)

    # if  @bool==nil
    #   #flash[:notice] = "Please enter correct password !"
    #   store_manager_variable=true
    # else
      @pass = params[:store_manager]
      @passw = @pass[:password]  
      @rpass = params[:store_manager]  
      @rpassw = @rpass[:hashed_password] 
      if @passw==@rpassw
        if @user
          @userMe=MgUser.find(id)
          @userMe.update(store_manager_password_params)
        end  
      else
        flash[:notice] = "Re Entered password didn't matched !"
      end
    #end
  
    # if store_manager_variable==true
    #   flash[:notice] = "Invalid Password..."
    # else
      flash[:notice] = "Password Change Successfully..."
    #end

    if params[:change_store_password]=="change_password_by_admin"
      redirect_to :action => "index_store_manager"
    elsif params[:change_store_password]=="change_password_by_user"
      redirect_to :action => "store_information"
    end
  end







  def delete_store_manager
    
    MgUser.transaction do
      mg_user=MgUser.find_by(:id=>params[:id])
      mg_user.update(:is_deleted=>1)
      store_manager=MgInventoryStoreManager.find_by(:mg_user_id=>params[:id])
      store_manager.update(:is_deleted=>1)
    end
    redirect_to :action=> "index_store_manager"
  end


  
  def index_financial_officer
    @financial_manager=MgUser.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:user_type=>"financial_manager").paginate(page: params[:page], per_page: 10)
  end

  def new_financial_manager
    render :layout=>false
  end

  def create_financial_officer
    school_subdomain= MgSchool.where(:id=>session[:current_user_school_id],:is_deleted=>0)
    @subdomain = school_subdomain[0].subdomain
    @user_name = @subdomain + params[:financial_manager][:user_name]
    @user_role_save=[] #add
    MgUser.transaction do #add
      financial_manager=MgUser.new(params_user)
      financial_manager.user_name=@user_name
      @user_role_save.push(financial_manager.save) #add
      role=MgRole.find_by(:role_name=>"financial_manager")
      if role.id.present?
        @user_role = financial_manager.mg_user_roles.build(:mg_role_id => role.id)
        @user_role_save.push(@user_role.save) #add
      end
      if @user_role_save.include?(false) #add
        raise ActiveRecord::Rollback #add
      end #add
    end

    if @user_role_save.include?(false) #add
      flash[:error] = "There is some problem" #add
    else #add
      flash[:notice] = "Financial Manager Created Successfully" #add
    end #add
    redirect_to :action=> "index_financial_officer"
  end

  def show_financial_manager
    @financial_obj=MgUser.find_by(:id=>params[:id])
    render :layout=>false
  end

  

  def change_financial_password

    @boolean_val=false
    @fff = params[:financial_manager]
    @curr = @fff[:name]
    id=@fff[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)

    #@bool=@user.authenticate(user_name, @curr)

    
    #if  @bool==nil
      # flash[:notice] = "Please enter correct password !"
      #@boolean_val=true
    #else
      @pass = params[:financial_manager]
      @passw = @pass[:password]  #new pass
      @rpass = params[:financial_manager]  
      @rpassw = @rpass[:hashed_password] #confirm pass
      if @passw==@rpassw
        if @user
          @userMe=MgUser.find(id)
          @userMe.update(password_params)
        end  
      else
        flash[:notice] = "Re Entered password didn't matched !"
      end
    #end
    
    # if @boolean_val==true
    #   flash[:notice] = "Invalid Password..."
    #   #redirect_to :action => "index_financial_officer"
    # else
      flash[:notice] = "Password Change Successfully..."
      #redirect_to :action => "index_financial_officer"
    #end
    if params[:change_financial_password]=="change_password_by_admins"
      redirect_to :action => "index_financial_officer"
    elsif params[:change_financial_password]=="change_password_by_manager"
      redirect_to :action => "change_credential"
    end

  end







  def edit_financial_manager
    @financial_manager=MgUser.find_by(:id=>params[:id])
    render :layout=>false
  end

  def update_financial_manager
    @user_name = params[:subdomain] + params[:financial_manager][:user_name]
    financial_manager=MgUser.find_by(:id=>params[:financial_manager][:id])
    #financial_manager.update(params_user_update)

    if financial_manager.update(:user_name=>@user_name)
      flash[:notice]="Manager updated successfully."
    else
      flash[:error]="Error occured,Please try later."
    end
    if params[:change_financial_username]=="change_username_by_admins"
      redirect_to :action=> "index_financial_officer"
    elsif params[:change_financial_username]=="change_username_by_manager"
      redirect_to :action=> "change_credential"
    end
        
  end

  def delete_financial_manager
    financial_manager=MgUser.find_by(:id=>params[:id])
    financial_manager.update(:is_deleted=>1)
    redirect_to :action=> "index_financial_officer"
  end

  def store_information
    @store_manager=MgInventoryStoreManager.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_inventory_store_management_id)
    @store_management=MgInventoryStoreManagement.where("is_deleted=? and mg_school_id=? and id=?",0,session[:current_user_school_id],@store_manager)

  end

  def about_store
    @store_obj=MgInventoryStoreManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def change_credential
    @financial_manager=MgUser.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:user_type=>"financial_manager")
  end


  def unique_username
    school_subdomain= MgSchool.where(:id=>session[:current_user_school_id],:is_deleted=>0)
    @subdomain = school_subdomain[0].subdomain
    @user_name = @subdomain + params[:user_name]
    @user_validate = MgUser.where("is_deleted=? and mg_school_id=? and user_name=?",0,session[:current_user_school_id],@user_name)
    if @user_validate.present?
      @data=1
    else
      @data=0
    end
    respond_to do |format|
      format.json  { render :json => @data.to_json }
    end
  end

  def multiple_item_search
    
  end



end



private
  def params_category
    params.require(:inventory).permit(:name,:description,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def params_update_category
    params.require(:inventory).permit(:name,:description,:is_deleted,:updated_by,:mg_school_id)
  end

  def params_item
    params.require(:inventory).permit(:mg_item_unit_id, :name, :code, :mg_category_id, :item_type, :prefix,:minimum_quantity_required,:description,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def params_update_item
    params.require(:inventory).permit(:mg_item_unit_id, :name, :code, :mg_category_id, :item_type, :prefix,:minimum_quantity_required,:description,:is_deleted,:updated_by,:mg_school_id)
  end


  def params_vendor
    params.require(:inventory).permit(:vendor_code, :category, :name, :contact_name, :street_address, :city,:state,:postal_code, :country,:phone_number,:fax_number,:email,:information,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def params_update_vendor
    params.require(:inventory).permit(:category, :name, :contact_name, :street_address, :city,:state,:postal_code, :country,:phone_number,:fax_number,:email,:information,:is_deleted,:updated_by,:mg_school_id)
  end

  def params_proposal
    params.require(:inventory).permit(:mg_store_id, :mg_user_id, :requisition_name, :date, :description, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end

  #Bindhu Work Start
  def item_management_params
    params.require(:mg_inventory_item_management).permit(:remark, :date_of_expiry, :mg_inventory_item_category_id, :mg_inventory_item_id, :item_prefix,:label_text,:item_type,:mg_inventory_room_id,:mg_inventory_rack_id,:quantity,:minimum_quantity,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def item_consumption_params
    params.require(:mg_inventory_item_consumption).permit(:mg_inventory_item_category_id, :mg_inventory_item_id, :item_prefix,:item_type,:mg_inventory_room_id,:mg_inventory_rack_id,:quantity_available,:quantity_consumed,:consumption_date,:consumption_type,:is_deleted,:created_by,:updated_by,:mg_school_id,:description)
  end

  def inventory_fine_params
    params.require(:inventory_new_fine_particular).permit(:fine_name,:amount,:start_date,:end_date,:due_date,:mg_inventory_item_id, :is_deleted,:created_by,:updated_by,:mg_school_id,:description)
  end

  def inventory_fine_particular_params
    params.require(:inventory_new_fine_particular).permit(:fine_name,:amount,:is_deleted,:created_by,:updated_by,:mg_school_id,:description)
  end
  #Bindhu Work end

  def stack_management_params
    params.require(:stack_management).permit(:rack_no,:prefix,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end
  def update_stack_management_params
    params.require(:stack_management).permit(:rack_no,:prefix)
  end

  def store_management_params
    params.require(:store_management).permit(:store_name,:description,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end
  def update_store_management_params
    params.require(:store_management).permit(:store_name,:description)
  end
  def room_management_params
    params.require(:room_management).permit(:room_no,:mg_inventory_store_management_id,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end
  def update_room_management_params
    params.require(:room_management).permit(:mg_inventory_store_management_id,:room_no)
  end

  def particular_params
    params.require(:fesses2).permit(:mg_particular_type_id,:description,:fee_category,:is_deleted, :mg_school_id,:amount,
     :admission_no)
  end

  def update_particular_params
    params.require(:fesses2).permit(:name,:description,:fee_category,:is_deleted, :mg_school_id,:amount, :admission_no, :mg_student_category_id)
  end

  #Bindhu Starts for store_manager
  def store_manager_login_params
    params.require(:store_manager).permit(:is_deleted,:mg_school_id,:created_by,:updated_by,:user_type,:user_name,:password)
  end
  #Bindhu ends for store_manager


  def store_manager_password_params
    params.require(:store_manager).permit(:password)
  end 

  def params_user
    params.require(:financial_manager).permit(:is_deleted,:mg_school_id,:created_by,:updated_by,:user_type,:user_name,:password)
  end

  def password_params
    params.require(:financial_manager).permit(:password)
  end

  def params_user_update
    params.require(:financial_manager).permit(:is_deleted,:mg_school_id,:updated_by,:user_type,:user_name)
  end
