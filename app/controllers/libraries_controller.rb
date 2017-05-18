class LibrariesController < ApplicationController
  layout "mindcom"
  before_filter :login_required
  def index
  @book_purchase_details=MgBookPurchase.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def new
    @school_id=session[:current_user_school_id]
  end
def create
begin
MgBookPurchase.transaction do
libraray_purchase_details=MgBookPurchase.new(library_details_params)
@timeformat = MgSchool.find(session[:current_user_school_id])
@date_of_purchase = Date.strptime(params[:library_purchase_details][:date_of_purchase],@timeformat.date_format)
libraray_purchase_details.created_by=session[:user_id]
if libraray_purchase_details.save
  libraray_purchase_details.update(:date_of_purchase=>@date_of_purchase)
end
book_name_arr=params[:book_name]
author_arr=params[:author]
publisher_arr=params[:publisher]
cost_arr=params[:cost]
no_of_copies_arr=params[:no_of_copies]
total_arr=params[:total]
class_arr=params[:select_class]
for j in 0...book_name_arr.length
book_purchase_details=MgBookPurchaseDetail.new()
book_purchase_details.mg_book_purchase_id=libraray_purchase_details.id
book_purchase_details.mg_school_id=session[:current_user_school_id]
book_purchase_details.is_deleted=0
book_purchase_details.created_by=session[:user_id]
book_purchase_details.book_name=book_name_arr[j]
book_purchase_details.author=author_arr[j]
book_purchase_details.publisher=publisher_arr[j]
book_purchase_details.cost=cost_arr[j]
book_purchase_details.no_of_copies=no_of_copies_arr[j]
book_purchase_details.total=total_arr[j]
book_purchase_details.mg_course_id=class_arr[j]
book_purchase_details.save
end#for end

redirect_to :action=>'index'

end#transaction end
rescue
  flash[:error]="Data Not Saved"
  redirect_to :action=>'new'
end#begin end
end

  def show
    @library_purchase_details=MgBookPurchase.find(params[:show_id])
    #@book_purchase_data=MgBookPurchaseDetail.where(:mg_book_purchase_id=>params[:show_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def edit
    @school_id=session[:current_user_school_id]

    @library_purchase_details=MgBookPurchase.find(params[:id])
    @book_purchase_details=MgBookPurchaseDetail.where(:mg_book_purchase_id=>params[:id],:is_deleted=>0,:mg_school_id=>@school_id)
  #redirect_to :action=>'index'
  end

  def update
 @params=params[:ids]
  school_id=session[:current_user_school_id]
  book_name_arr=params[:book_name]
author_arr=params[:author]
publisher_arr=params[:publisher]
cost_arr=params[:cost]
no_of_copies_arr=params[:no_of_copies]
total_arr=params[:total]
class_arr=params[:select_class]

    @library_purchase_details=MgBookPurchase.find(params[:id])
    @library_purchase_details.update(library_details_params)
    @timeformat = MgSchool.find(school_id)
@date_of_purchase = Date.strptime(params[:library_purchase_details][:date_of_purchase],@timeformat.date_format)
    @library_purchase_details.update(:date_of_purchase=>@date_of_purchase)
library_employee_data=MgBookPurchaseDetail.where('is_deleted=? and mg_school_id=? and mg_book_purchase_id=? and id  NOT IN (?)', 0,school_id,params[:id],params[:ids])
 if library_employee_data.length>0
    for j in 0...library_employee_data.length 
     data=MgBookPurchaseDetail.find_by(:id=>library_employee_data[j].id)
     puts data.inspect
     if data.present?
    data.update(:is_deleted=>1)
  end
  end
   end
 for j in 0...@params.size

   library_employee_data=MgBookPurchaseDetail.where('mg_school_id=? and mg_book_purchase_id=? and id=?', school_id,params[:id],@params[j])
 if library_employee_data.size<1
book_purchase_details=MgBookPurchaseDetail.new()
book_purchase_details.mg_book_purchase_id=params[:id]
book_purchase_details.mg_school_id=session[:current_user_school_id]
book_purchase_details.is_deleted=0
book_purchase_details.created_by=session[:user_id]
book_purchase_details.book_name=book_name_arr[j]
book_purchase_details.author=author_arr[j]
book_purchase_details.publisher=publisher_arr[j]
book_purchase_details.cost=cost_arr[j]
book_purchase_details.no_of_copies=no_of_copies_arr[j]
book_purchase_details.total=total_arr[j]
book_purchase_details.mg_course_id=class_arr[j]
book_purchase_details.save
  else


    library_employee_data[0].update(:is_deleted=>0,:mg_school_id=>school_id,:book_name=>book_name_arr[j],:author=>author_arr[j],:publisher=>publisher_arr[j],:cost=>cost_arr[j],:no_of_copies=>no_of_copies_arr[j],:total=>total_arr[j],:mg_course_id=>class_arr[j])
      end
    end
  
    flash[:success]="Data has Updated"

   redirect_to :action=>'index'
  end

  def destroy
@destroy_data=MgBookPurchase.find(params[:id])
    @destroy_data.is_deleted=1
    @destroy_data.save
    redirect_to :action=>'index'
  end
  def library_settings_index
  @all_library_settings_data=MgLibrarySetting.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).all
  end
  def library_settings_new
    @school_id=session[:current_user_school_id]
  end
  
  def select_employees
     @deptid=params[:dept_data]
      @employeeList=MgEmployee.where(:mg_employee_department_id=>@deptid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @employee_ary=Array.new
      @employeeList.each do|list|
      list_ary=Array.new()
      first_name=list.first_name
      dept_data=MgEmployeeDepartment.find(list.mg_employee_department_id)
    if dept_data.present?
      dept_name=dept_data.department_name
    else
      dept_name="null"
    end
      key="#{first_name} "
      value=list.id
      list_ary.push(key,value)
      @employee_ary.push(list_ary)
    end
 render :layout=>false
  end


def library_settings_create
  begin
   @params=params[:selected_employees]
  MgLibrarySetting.transaction do
    library_setting_data=MgLibrarySetting.new(library_settings_params)
    library_setting_data.created_by=session[:user_id]
    library_setting_data.save
   for j in 0...@params.length
    library_employee_data=MgLibraryEmployee.new
    library_employee_data.mg_employee_id=@params[j]
    library_employee_data.is_deleted=0
    library_employee_data.mg_school_id=session[:current_user_school_id]
    library_employee_data.created_by=session[:user_id]
   library_employee_data.save
  end#for end
  redirect_to :action=>'library_settings_index'

end#transaction end
rescue
  flash[:error]="Data Not Saved"
  redirect_to :action=>'library_settings_new'
  end#begin end
end
def library_settings_show
  @library_data=MgLibrarySetting.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
end
def library_settings_edit
  @school_id=session[:current_user_school_id]

  @library_settings=MgLibrarySetting.find(params[:edit_id])
 render :layout=>false

end

def library_settings_update
   @params=params[:selected_employees]
  school_id=session[:current_user_school_id]
  library_settings_data=MgLibrarySetting.find(params[:id])
  library_settings_data.update(library_settings_params)



 for j in 0...@params.size

   library_employee_data=MgLibraryEmployee.where('mg_school_id=? and  mg_employee_id=?', school_id,@params[j])

 if library_employee_data.size<1

    @data=MgLibraryEmployee.new()
    @data.is_deleted=0
    @data.created_by=session[:user_id]
    @data.mg_employee_id=@params[j]
    @data.mg_school_id=school_id

    @data.save
  else
        library_employee_data[0].update(:is_deleted=>0,:mg_school_id=>school_id)

      end
    end

  library_employee_data=MgLibraryEmployee.where('is_deleted=? and mg_school_id=? and  mg_employee_id  NOT IN (?)', 0,school_id,params[:selected_employees])
  #     puts library_employee_data.inspect 

 if library_employee_data.length>0
    for j in 0...library_employee_data.length
     
     data=MgLibraryEmployee.find_by(:id=>library_employee_data[j].id)
     if data.present?
    data.update(:is_deleted=>1)
   end
  end
   end
    flash[:success]="Data has Updated"

   redirect_to :action=>'library_settings_show'
  end
  def books_category_index
    @all_books_category_data=MgBooksCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).all
  end
 def books_category_new
  @school_id=session[:current_user_school_id]
  render :layout=>false
  end
 def books_category_create
  books_category=MgBooksCategory.new(books_category_params)
  books_category.created_by=session[:user_id]
  if books_category.save
    flash[:success]="Books category has been created."
  end
  redirect_to :action=>'books_category_index'
  end

   def books_category_show
    @show_data=MgBooksCategory.find(params[:show_id])
  render :layout=>false

  end
  def books_category_edit
    @school_id=session[:current_user_school_id]
    @books_category=MgBooksCategory.find(params[:edit_id])
  render :layout=>false

  end
 
  def books_category_update
    update_data=MgBooksCategory.find(params[:id])
    if update_data.update(books_category_params)
    flash[:success]="Books category has been updated."

    end
  redirect_to :action=>'books_category_index'

  end
  def books_category_destroy
    @destroy_data=MgBooksCategory.find(params[:id])
    @destroy_data.is_deleted=1
    @destroy_data.save
    redirect_to :action=>'books_category_index'

  end

  def books_inventory_index
    @all_book_inventory_data=MgBooksInventory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).all
  end
  def books_inventory_new
    @school_id=session[:current_user_school_id]
    
  end
  def books_inventory_create
    @books_inventory=MgBooksInventory.new(books_inventory_params)
    @books_inventory.created_by=session[:user_id]
    @books_inventory.reserved_by=0
    #puts params.inspect
    #logger.infoASJDGH
   if @books_inventory.save
    flash[:success]="Books Inventory has been created."
   end
    redirect_to :action=>'books_inventory_index'

  end
  def books_inventory_show
    @inventory_data=MgBooksInventory.find(params[:show_id])
    render :layout=>false
  end
  def books_inventory_edit
    @school_id=session[:current_user_school_id]
    @books_inventory=MgBooksInventory.find(params[:id])

   # render :layout=>false

  end
  def books_inventory_update
    @books_inventory_update=MgBooksInventory.find(params[:id])
    if @books_inventory_update.update(books_inventory_params)
    flash[:success]="Books Inventory has been updated."
    end
    redirect_to :action=>'books_inventory_index'
  end
  def books_inventory_destroy
    @books_inventory_destroy=MgBooksInventory.find(params[:id])
    @books_inventory_destroy.is_deleted=1
    @books_inventory_destroy.save
    redirect_to :action=>'books_inventory_index'

  end

  def library_card_issue_index

  end
  def library_card_issue_new
    @school_id=session[:current_user_school_id]
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
     pdf = Prawn::Document.new(:page_size => [350, 180]) do

       

                  repeat :all do

                        bounding_box [bounds.left, bounds.top+25],:align => :right, :width  => bounds.width do
                            font "Helvetica"
                            if File.exists?("#{Rails.root}/public/#{@@school_logo}") 
                                   image( "#{Rails.root}/public/#{@@school_logo}",:width =>  45)
                                  # image ("#{Rails.root}/public/#{@@school_logo}"),:at=>[425,690],:width=>45
                                  # image "#{Rails.root}/public/#{@@school_logo}", :width => 45, :align => :left
                            end
                            move_up 10
                            text school.school_name, :align => :center, :size => 18
                            stroke_horizontal_rule
                        end
        move_down 10

        # footer
                       
                  end
               

                    bounding_box([bounds.left, bounds.top - 60], :width  => bounds.width, :height => bounds.height - 100) do

                    move_down 120
                    if  File.exists?("#{Rails.root}/public/#{student_photo}")
                            # image "#{Rails.root}/public/#{@@emp_photo}", :align => :right, :width =>45
                            image("#{Rails.root}/public/#{student_photo}", :at => [215,25], :width =>  35)
                    else

                    end


      


                      end
                      draw_text "Name   :", :at => [10,60] 
                      draw_text "#{student_data.first_name} #{student_data.last_name}",:at => [60,60]  
                      draw_text "Class    :", :at => [10,40]
                      draw_text "#{course_data.course_name}",:at => [60,40]
                     
                      draw_text "Section :", :at =>  [10,20] 
                      draw_text "#{batch_data.name}",:at => [60,20]
                      
                     
                      draw_text "Valid from: ", :at => [10,0]
                      draw_text "#{valid_from}",:at => [70,0]
                      draw_text "Valid To   :", :at => [10,-20]
                      draw_text "#{valid_to}",:at => [70,-20] 

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
  def sestion_for_selected_class
     @batch_list = MgBatch.where(:mg_course_id => params[:course_id])
        logger.info @batch_list.inspect
        @booleanValue=true
        render :json => {:name => @batch_list }
    # @batch_data=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>params[:course_id]).pluck(:name,:id)
    # render :layout=>false
  
  end
  def students_for_selected_section
    @student_data=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>params[:batch_id]).pluck(:first_name,:id)
    render :layout=>false
  
  end
  def book_issue_index
  end
  def search_books
    @value=params[:Value]
    
    data=params[:Data]
    @school_id=session[:current_user_school_id]
    if @value=="book_name"
      #@data = MgBooksInventory.where("book_name LIKE :book_name",{:book_name => "#{data}%"}).paginate(page: params[:page], per_page: 10)
     @sql="select id, book_no,book_name,status,author,publisher,edition,cost,mg_books_category_id,mg_course_id from mg_books_inventories where book_name LIKE '%#{data}%' and is_deleted='0' and mg_school_id='#{@school_id}' and non_issuable='0' and is_damaged='0'and is_lost='0'"
     elsif @value=="publisher"
      #@data = MgBooksInventory.where("book_name LIKE :book_name",{:book_name => "#{data}%"}).paginate(page: params[:page], per_page: 10)
        @sql="select id, book_no,book_name,status,author,publisher,edition,cost,mg_books_category_id,mg_course_id from mg_books_inventories where publisher LIKE '%#{data}%' and is_deleted='0' and mg_school_id='#{@school_id}' and non_issuable='0' and is_damaged='0'and is_lost='0'"
    else
      #@data = MgBooksInventory.where("book_name LIKE :book_name",{:book_name => "#{data}%"}).paginate(page: params[:page], per_page: 10)
       @sql="select id,book_no, book_name,author,status,publisher,edition,cost,mg_books_category_id,mg_course_id from mg_books_inventories where author LIKE '%#{data}%' and is_deleted='0' and mg_school_id='#{@school_id}' and non_issuable='0' and is_damaged='0'and is_lost='0'" 
    end
      @data=MgBooksInventory.find_by_sql(@sql)
      #logger.infosdhkj
      #puts @data.inspect
    render :layout=>false
  end

  def search
    # @value=params[:Value]
    
    # data=params[:Data]
    

    #   if @value=="book_name"
    #  @sql="select book_name from mg_books_inventories where book_name LIKE '%#{data}%'"
    #  elsif value=="publisher"
    #     @sql="select  book_no from mg_books_inventories where publisher LIKE '%#{data}%'"
    # else
    #    @sql="select book_no from mg_books_inventories where author LIKE '%#{data}%'" 
    # end
    #   @datas=MgBooksInventory.find_by_sql(@sql)
    # #render :layout=>false
    #   #puts @data.inspect
    #   #logger.infokmlmn
    #  render :json => {:data => @datas}
   end
  def books_information_data

   @inventory_data=MgBooksInventory.find(params[:book_id])
    render :layout=>false
  
  end 

  def update_status
      @inventaoru_update=MgBooksInventory.find(params[:book_id])
      @inventory_data_id=params[:book_id]
      @library_settings_data=MgLibrarySetting.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
   
    status= params[:status_dat]
    

    
    if status=="Issue"
    #@inventaoru_update.reserved_by=session[:user_id]
    #@inventaoru_update.mg_student_id=params[:student_id]
# @inventaoru_update.issued_to=params[:student_id]

# max_days=@library_settings_data.max_borrow_days
# today_date=Date.today
#  due_date=today_date+max_days
#  @inventaoru_update.due_date=due_date
#  @inventaoru_update.status="Issued"
#  @inventaoru_update.save
    #render :layout=>false
   render :json => {:object_data=>@inventory_data_id,:name =>"Issued"}


elsif status=="Renew"

   render :json => {:object_data=>@inventory_data_id,:name =>"Renew"}
elsif status=="Return"
   render :json => {:object_data=>@inventory_data_id,:name =>"Return"}
    
  elsif status=="Reserved"
    # @inventaoru_update.reserved_by=params[:student_id]

    # max_days=@library_settings_data.max_borrow_days
    # today_date=Date.today
    # due_date=today_date+max_days

    # @inventaoru_update.reservation_due_date=due_date

    # @inventaoru_update.status="Reserved"
    # @inventaoru_update.save

   render :json => {:object_data=>@inventory_data_id,:name =>"Reserved"}
    

   end
  end

  def issue_data_status
  @inventory_data=params[:object_id]

    render :layout=>false

  end

  def save_issue_data_status

  @library_settings_data=MgLibrarySetting.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  if @library_settings_data.max_books_issuable==0

@inventaoru_update=MgBooksInventory.find(params[:inventory_id])
      
  @inventaoru_update.issued_to=params[:student_id]
@student_lib_inforamtion=MgBooksInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])

max_days=@library_settings_data.max_borrow_days
today_date=Date.today
 due_date=today_date+max_days
 @inventaoru_update.due_date=due_date
 @inventaoru_update.status="Issued"
 @inventaoru_update.issued_date=Date.today
 @inventaoru_update.reservation_due_date=""
 @inventaoru_update.save
 books_transaction_history=MgBooksTransaction.new
 books_transaction_history.mg_student_id=params[:student_id]
 books_transaction_history.start_date=Date.today
 books_transaction_history.issued_by=session[:user_id]
 books_transaction_history.is_deleted=0
 books_transaction_history.mg_school_id=session[:current_user_school_id ]
 books_transaction_history.status="Issued"
 books_transaction_history.created_by=session[:user_id]
 books_transaction_history.updated_by=session[:user_id]
 books_transaction_history.mg_books_inventory_id=params[:inventory_id]
 books_transaction_history.save

  else
  @inventaoru_update=MgBooksInventory.find(params[:inventory_id])
      
  @inventaoru_update.issued_to=params[:student_id]
@student_lib_inforamtion=MgBooksInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])
if @student_lib_inforamtion.length<=@library_settings_data.max_books_issuable-1
max_days=@library_settings_data.max_borrow_days
today_date=Date.today
 due_date=today_date+max_days
 @inventaoru_update.due_date=due_date
 @inventaoru_update.status="Issued"
 @inventaoru_update.issued_date=Date.today
 @inventaoru_update.reservation_due_date=""
 @inventaoru_update.save
 books_transaction_history=MgBooksTransaction.new
 books_transaction_history.mg_student_id=params[:student_id]
 books_transaction_history.start_date=Date.today
 books_transaction_history.issued_by=session[:user_id]
 books_transaction_history.is_deleted=0
 books_transaction_history.mg_school_id=session[:current_user_school_id ]
 books_transaction_history.status="Issued"
 books_transaction_history.created_by=session[:user_id]
 books_transaction_history.updated_by=session[:user_id]
 books_transaction_history.mg_books_inventory_id=params[:inventory_id]
 books_transaction_history.save
else
   render :json => {:name =>"Not saved"}
end
end
  end

  def fine_status
    @inventory_id=params[:object_id]
    @studentid=params[:student_id]
  @library_settings_data=MgLibrarySetting.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    max_days=@library_settings_data.max_borrow_days

     today_date=Date.today

     @due_date=today_date+max_days

      @inventaoru_update=MgBooksInventory.find(params[:object_id])

    if Date.today>@inventaoru_update.due_date
     
      @no_of_days=@due_date-Date.today
      
      @amount=@library_settings_data.fine_for_late_return*@no_of_days
    end

   render :layout=>false

  end

  def save_fee_fine_particulars
    invenotry_data_id=params[:inventory_id]
    amount=params[:amount]
    fine_amount=params[:fine_amount]
    book_status=params[:book_status]
    MgBooksInventory.transaction do
      @inventory_data=MgBooksInventory.find(params[:inventory_id])
      

    books_transaction_data=MgBooksTransaction.new
    books_transaction_data.start_date=@inventory_data.issued_date
    books_transaction_data.end_date=Date.today
    books_transaction_data.due_date=@inventory_data.due_date
    books_transaction_data.mg_student_id=@inventory_data.issued_to
    books_transaction_data.received_by=session[:user_id]
    books_transaction_data.created_by=session[:user_id]
    books_transaction_data.updated_by=session[:user_id]
    books_transaction_data.issued_by=@inventory_data.reserved_by
    books_transaction_data.mg_school_id=session[:current_user_school_id]
    books_transaction_data.is_deleted=0
    books_transaction_data.return_book_condition=book_status
    books_transaction_data.mg_books_inventory_id=params[:inventory_id]
    books_transaction_data.status="On-shelf"
    books_transaction_data.save


    if amount.present?
    @fine_particulars=MgFeeFineParticular.new
    @fine_particulars.fine_name="library_book_damage_fine"
    @fine_particulars.fine_from="Library"
    @fine_particulars.amount=amount
    student_data=MgStudent.find(@inventory_data.issued_to)

    @fine_particulars.mg_batch_id=student_data.mg_batch_id
    @fine_particulars.mg_student_id=@inventory_data.issued_to
    @fine_particulars.mg_school_id=session[:current_user_school_id]
    @fine_particulars.start_date=Date.today
    @fine_particulars.due_date=Date.today+14
    @fine_particulars.end_date=Date.today+14

    @fine_particulars.is_deleted=0
   @fine_particulars.save
  end

   if fine_amount.present?
     @fine_particular=MgFeeFineParticular.new
    @fine_particular.fine_name="library_late_fine"
    @fine_particular.fine_from="Library"
    @fine_particular.amount=fine_amount
    student_data=MgStudent.find(@inventory_data.issued_to)

    @fine_particular.mg_batch_id=student_data.mg_batch_id
     @fine_particular.start_date=Date.today
    @fine_particular.due_date=Date.today+14
    @fine_particular.end_date=Date.today+14

    @fine_particular.mg_student_id=@inventory_data.issued_to
    @fine_particular.mg_school_id=session[:current_user_school_id]
    @fine_particular.is_deleted=0
   @fine_particular.save
   end
      @inventory_data.status="On-shelf"
      #@inventory_data.mg_student_id=params[:student_id]
      @inventory_data.issued_to=nil
      @inventory_data.due_date=0000-00-00
      @inventory_data.save
   @data=MgBooksInventory.find(@inventory_data.id)
   if @data.reserved_by!=0
       @data.update(:status=>"Reserved")
   end
  data_settings= MgLibrarySetting.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  no_of_days=data_settings.max_days_on_reservation_after_return
  if no_of_days!=0 and @data.issued_to==nil and @data.reserved_by!=0
    @data.update(:reservation_due_date=>Date.today+no_of_days)
  end
  end


   render :layout=>false

  end


def renew_fine_status

 @inventory_id=params[:object_id]
    @studentid=params[:student_id]
  @library_settings_data=MgLibrarySetting.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    max_days=@library_settings_data.max_borrow_days

    today_date=Date.today

    @due_date=today_date+max_days

      @inventaoru_update=MgBooksInventory.find(params[:object_id])

    if Date.today>@inventaoru_update.due_date
      @inventaoru_update.due_date=@due_date
      @inventaoru_update.save
      @no_of_days=@due_date-Date.today
      @amount=@library_settings_data.fine_for_late_return*@no_of_days
      @inventaoru_update=MgBooksInventory.find(params[:object_id])
    @inventaoru_update.due_date=@due_date
    @inventaoru_update.status="Issued"
    @inventaoru_update.save
    mg_books_transaction_history=MgBooksTransaction.new
    mg_books_transaction_history.mg_student_id=@inventaoru_update.issued_to
    mg_books_transaction_history.start_date=Date.today
    mg_books_transaction_history.issued_by=session[:user_id]
    mg_books_transaction_history.received_by=session[:user_id]
    mg_books_transaction_history.created_by=session[:user_id]
    mg_books_transaction_history.updated_by=session[:user_id]
    mg_books_transaction_history.is_deleted=session[:user_id]
    mg_books_transaction_history.mg_school_id=session[:current_user_school_id]
    mg_books_transaction_history.mg_books_inventory_id=params[:object_id]
    mg_books_transaction_history.status="Issued"

   render :layout=>false

    else
    @inventaoru_update=MgBooksInventory.find(params[:object_id])
    @inventaoru_update.due_date=@due_date
    @inventaoru_update.status="Issued"
    @inventaoru_update.save
    mg_books_transaction_history=MgBooksTransaction.new
    mg_books_transaction_history.mg_student_id=@inventaoru_update.issued_to
    mg_books_transaction_history.start_date=Date.today
    mg_books_transaction_history.issued_by=session[:user_id]
    mg_books_transaction_history.received_by=session[:user_id]
    mg_books_transaction_history.created_by=session[:user_id]
    mg_books_transaction_history.updated_by=session[:user_id]
    mg_books_transaction_history.is_deleted=session[:user_id]
    mg_books_transaction_history.mg_school_id=session[:current_user_school_id]
    mg_books_transaction_history.mg_books_inventory_id=params[:object_id]
    mg_books_transaction_history.status="Issued"
    mg_books_transaction_history.save
   render :json => {:name =>"Return"}

    end


end


def save_renew_fee_fine_particulars
    fine_amount=params[:fine_amount]

     @fine_particular=MgFeeFineParticular.new
    @fine_particular.fine_name="library_late_fine"
    @fine_particular.fine_from="Library"
    @fine_particular.amount=fine_amount
    student_data=MgStudent.find(params[:student_id])

    @fine_particular.mg_batch_id=student_data.mg_batch_id
     @fine_particular.start_date=Date.today
    @fine_particular.due_date=Date.today+14
    @fine_particular.end_date=Date.today+14

    @fine_particular.mg_student_id=params[:student_id]
    @fine_particular.mg_school_id=session[:current_user_school_id]
    @fine_particular.is_deleted=0
   @fine_particular.save
   render :layout=>false
  

end

def reserved_fine_status
  @inventory_data=params[:object_id]
   render :layout=>false
  
end

def save_reservation_data 
 @library_settings_data=MgLibrarySetting.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
 if @library_settings_data.max_books_issuable==0
  @inventaoru_update=MgBooksInventory.find(params[:inventory_id])

  @student_lib_inforamtion=MgBooksInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])
  if params[:student_id].to_i==@inventaoru_update.issued_to.to_i
   render :json => {:Same =>"Same Id"}

  else
 
      @inventaoru_update.reserved_by=params[:student_id]
    @inventaoru_update.status="Reserved"
    @inventaoru_update.save
    books_transaction_history=MgBooksTransaction.new
    books_transaction_history.mg_student_id=params[:student_id]
    books_transaction_history.issued_by=session[:user_id]
    books_transaction_history.start_date=Date.today
    books_transaction_history.is_deleted=0
    books_transaction_history.mg_school_id=session[:current_user_school_id]
    books_transaction_history.created_by=session[:user_id]
    books_transaction_history.updated_by=session[:user_id]     
    books_transaction_history.status="Reserved"
    books_transaction_history.mg_books_inventory_id=params[:inventory_id]          
    books_transaction_history.save
   render :layout=>false

 

end #first if end

 else

      @inventaoru_update=MgBooksInventory.find(params[:inventory_id])

  @student_lib_inforamtion=MgBooksInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])
  if params[:student_id].to_i==@inventaoru_update.issued_to.to_i
   render :json => {:Same =>"Same Id"}

  else
  if @student_lib_inforamtion.length<=@library_settings_data.max_books_issuable-1
      @inventaoru_update.reserved_by=params[:student_id]
    @inventaoru_update.status="Reserved"
    @inventaoru_update.save
    books_transaction_history=MgBooksTransaction.new
    books_transaction_history.mg_student_id=params[:student_id]
    books_transaction_history.issued_by=session[:user_id]
    books_transaction_history.start_date=Date.today
    books_transaction_history.is_deleted=0
    books_transaction_history.mg_school_id=session[:current_user_school_id]
    books_transaction_history.created_by=session[:user_id]
    books_transaction_history.updated_by=session[:user_id]     
    books_transaction_history.status="Reserved"
    books_transaction_history.mg_books_inventory_id=params[:inventory_id]          
    books_transaction_history.save
   render :layout=>false
 else
   render :json => {:name =>"Not Saved"}
 end #Third if end

end #second if end
end #first if end
end #class End
def issue_data_status_validation
@inventory_data=params[:object_id]
   render :layout=>false
end
def save_issued_validate_data
 @library_settings_data=MgLibrarySetting.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
if @library_settings_data.max_books_issuable==0
@inventaoru_update=MgBooksInventory.find(params[:inventory_id])

      @student_lib_inforamtion=MgBooksInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])

      if @inventaoru_update.reserved_by.to_i==params[:student_id].to_i

  @inventaoru_update.issued_to=params[:student_id]

max_days=@library_settings_data.max_borrow_days
today_date=Date.today
 due_date=today_date+max_days
 @inventaoru_update.due_date=due_date
 @inventaoru_update.status="Issued"
 @inventaoru_update.issued_to=params[:student_id]
 @inventaoru_update.issued_date=Date.today
 @inventaoru_update.reservation_due_date=""

 @inventaoru_update.reserved_by=0

 @inventaoru_update.save

 books_transactions_history=MgBooksTransaction.new
 books_transactions_history.mg_student_id=params[:student_id]
 books_transactions_history.start_date=Date.today
 books_transactions_history.issued_by=session[:user_id]
 books_transactions_history.created_by=session[:user_id]
 books_transactions_history.updated_by=session[:user_id]
 books_transactions_history.status="Issued"
 books_transactions_history.is_deleted=0
 books_transactions_history.mg_school_id=session[:current_user_school_id]
 books_transactions_history.mg_books_inventory_id=params[:inventory_id]
 books_transactions_history.mg_student_id=params[:student_id]
books_transactions_history.save
   render :json => {:name =>"Saved"}

      else


   render :json => {:name =>"notsaved"}

      end

     

else#########################################

    @inventaoru_update=MgBooksInventory.find(params[:inventory_id])

      @student_lib_inforamtion=MgBooksInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])
    if (@student_lib_inforamtion.length<=@library_settings_data.max_books_issuable-1) || (@inventaoru_update.reserved_by.to_i==params[:student_id].to_i)

      if @inventaoru_update.reserved_by.to_i==params[:student_id].to_i

  @inventaoru_update.issued_to=params[:student_id]

max_days=@library_settings_data.max_borrow_days
today_date=Date.today
 due_date=today_date+max_days
 @inventaoru_update.due_date=due_date
 @inventaoru_update.status="Issued"
 @inventaoru_update.issued_to=params[:student_id]
 @inventaoru_update.issued_date=Date.today
 @inventaoru_update.reservation_due_date=""

 @inventaoru_update.reserved_by=0

 @inventaoru_update.save

 books_transactions_history=MgBooksTransaction.new
 books_transactions_history.mg_student_id=params[:student_id]
 books_transactions_history.start_date=Date.today
 books_transactions_history.issued_by=session[:user_id]
 books_transactions_history.created_by=session[:user_id]
 books_transactions_history.updated_by=session[:user_id]
 books_transactions_history.status="Issued"
 books_transactions_history.is_deleted=0
 books_transactions_history.mg_school_id=session[:current_user_school_id]
 books_transactions_history.mg_books_inventory_id=params[:inventory_id]
 books_transactions_history.mg_student_id=params[:student_id]
books_transactions_history.save
   render :json => {:name =>"Saved"}

      else


   render :json => {:name =>"notsaved"}

      end

      else
   render :json => {:name =>"Not saved"}
   end
   end #first if end
  end

  def cancel_reservation_data
      @inventary_update=MgBooksInventory.find(params[:inventory_id])
      student_id=MgStudent.find(@inventary_update.reserved_by)
     
    #user_id=MgUser.find_by(:id=>student_id.mg_user_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      
    
   #@email_from = MgEmail.where(:mg_user_id => session[:user_id])
     
      puts @email_from.inspect
      begin
              # notification work start
             
            @message = Message.new
              @email_from = MgEmail.where(:mg_user_id => session[:user_id])
            @message.subject =  "Libraray"
              @message.description = "Dear Student\n Thanks & Regards"
           
                #Thread.new do
                     
                        @email_to = MgEmail.where(:mg_user_id => student_id.mg_user_id)

                        
                          puts "Start Step >--------------------------------------------------------->  1   "
                          #puts params[:events][:title].inspect
                          puts session[:user_id]
                          puts "End Step >--------------------------------------------------------->  2   "

                          @message.to_user_id = @email_to[0][:mg_email_id ]
                        @message.from_user_id = @email_from[0][:mg_email_id ]
                    server_response = NotificationMailer.send_mail(@message).deliver!
                    db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                                    :to_user_id => student_id.mg_user_id,
                                    :subject => @message.subject,
                                    :description => @message.description,
                                    :is_deleted => 0,
                                    :from_user_id =>session[:user_id],
                                    :status => 0)
                          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                      :email_addrs_to => @message.to_user_id,
                                                      # current school Id will come here
                                                :mg_school_id => session[:current_user_school_id] ,
                                                      :email_addrs_by => @message.from_user_id,
                                                      :email_subject => 'test',
                                                     :email_server_description => server_description(server_response.status) )

                    puts " Ste p >-------------------------> status"
                     # puts @email_to[0][:mg_email_id ]
                    puts " Ste p >-------------------------> status"
                        
                      
                  #end
              
                #flash.now[:notice]="Mail Sent Successfully."
              # notification work end
            rescue Net::SMTPFatalError => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Email Id is not valid."
              #flash.keep(:notice)
            rescue ArgumentError => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Email to address is not present."
              #flash.keep(:notice)
            rescue Exception => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Error while sending email,Please contact admin."
              #flash.keep(:notice)
            end
    
      @inventary_update.status="Issued"
      @inventary_update.reserved_by=0
      @inventary_update.reservation_due_date=""

      @inventary_update.save
      
   render :layout=>false
#end
  end

  def server_description(code_s)
    
    case code_s.to_s

          when '0'
              return "Email address is not correct"
        
          when '211'   
              return "A system status message."
          when '214'   
              return "A help message for a human reader follows."
          when '220'   
              return "SMTP Service ready."
          when '221'   
              return "Service closing."
          when '250'   
              return "Requested action taken and completed. The best message of them all."
          when '251'   
              return "The recipient is not local to the server, but the server will accept and forward the message."
          when '252'   
              return "The recipient cannot be VRFYed, but the server accepts the message and attempts delivery."
          when '354'   
              return "Start message input and end with . This indicates that the server is ready to accept the message itself (after you have told it who it is from and where you want to to go)."



          when '421'   
              return "The service is not available and the connection will be closed."
          when '450'   
              return "The requested command failed because the users mailbox was unavailable (for example because it was locked). Try again later."
          when '451'   
              return "The command has been aborted due to a server error. Not your fault. Maybe let the admin know."
          when '452'   
              return "The command has been aborted because the server has insufficient system storage."


          when '500'   
              return "The server could not recognize the command due to a syntax error. "

          when '501'   
              return "A syntax error was encountered in command arguments."
          when '502'   
              return "This command is not implemented."
          when '503'   
              return "The server has encountered a bad sequence of commands."
          when '504'   
              return "A command parameter is not implemented."

          when '550'   
              return "The requested command failed because the users mailbox was unavailable (for example because it was not found, or because the command was rejected for policy reasons)."
          when '551'   
              return "The recipient is not local to the server. The server then gives a forward address to try."
          when '552'   
              return "The action was aborted due to exceeded storage allocation."
          when '553'   
              return "The command was aborted because the mailbox name is invalid."
          when '554'   
              return "The transaction failed. Blame it on the weather."
          
    end
   
  end
def cancel_reservation_data_for_second_condition
   @inventary_update=MgBooksInventory.find(params[:inventory_id])
    student_id=MgStudent.find(@inventary_update.reserved_by)
     
    #user_id=MgUser.find_by(:id=>student_id.mg_user_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      
    
  # @email_from = MgEmail.where(:mg_user_id => session[:user_id])
     
      puts @email_from.inspect
      begin
              # notification work start
             
            @message = Message.new
              @email_from = MgEmail.where(:mg_user_id => session[:user_id])
            @message.subject =  "Libraray"
              @message.description = "Dear Student\n Thanks & Regards"
           
                #Thread.new do
                     
                        @email_to = MgEmail.where(:mg_user_id => student_id.mg_user_id)

                        
                          puts "Start Step >--------------------------------------------------------->  1   "
                          #puts params[:events][:title].inspect
                          puts session[:user_id]
                          puts "End Step >--------------------------------------------------------->  2   "

                          @message.to_user_id = @email_to[0][:mg_email_id ]
                        @message.from_user_id = @email_from[0][:mg_email_id ]
                    server_response = NotificationMailer.send_mail(@message).deliver!
                    db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                                    :to_user_id => student_id.mg_user_id,
                                    :subject => @message.subject,
                                    :description => @message.description,
                                    :is_deleted => 0,
                                    :from_user_id =>session[:user_id],
                                    :status => 0)
                          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                                      :email_addrs_to => @message.to_user_id,
                                                      # current school Id will come here
                                                :mg_school_id => session[:current_user_school_id] ,
                                                      :email_addrs_by => @message.from_user_id,
                                                      :email_subject => 'test',
                                                     :email_server_description => server_description(server_response.status) )

                    puts " Ste p >-------------------------> status"
                     # puts @email_to[0][:mg_email_id ]
                    puts " Ste p >-------------------------> status"
                        
                      
                  #end
              
                #flash.now[:notice]="Mail Sent Successfully."
              # notification work end
            rescue Net::SMTPFatalError => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Email Id is not valid."
              #flash.keep(:notice)
            rescue ArgumentError => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Email to address is not present."
              #flash.keep(:notice)
            rescue Exception => e
              puts "inside Exception in principal"
              #flash.now[:notice]="Error while sending email,Please contact admin."
              #flash.keep(:notice)
            end
    
      @inventary_update.status="On-shelf"
      @inventary_update.reserved_by=0
      @inventary_update.save
      
   render :layout=>false

end

def particular_student_library_records
  
  @student_lib_inforamtion=MgBooksInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])
  


   render :layout=>false

  end
  def class_by_class_report
  end
  def library_report_generation
     @timeformat = MgSchool.find(session[:current_user_school_id])
       
        from_date= Date.strptime(params[:from_date],@timeformat.date_format)
        to_date= Date.strptime(params[:to_date],@timeformat.date_format)
       
    data=MgBookPurchase.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:date_of_purchase=>from_date..to_date).pluck(:id)
    puts data.inspect
    puts "sjdddddddddddddddddddddddddddddddddddddddddddddddddddddddh"
    #logger.infoshdka
    @book_purchase_details=MgBookPurchaseDetail.where(:mg_book_purchase_id=>data,:mg_course_id=>params[:class_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

   render :layout=>false

  end
 def damaged_book_list
  @data=MgBooksInventory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_damaged=>1)

  end
  def borrowed_book_list
      @data=MgBooksInventory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_damaged=>0,:status=>"Issued")

  end

  private 
  def library_details_params
    params.require(:library_purchase_details).permit(:vendor_name,:date_of_purchase,:Amount_paid,:is_deleted,:mg_school_id)
  end
  def library_settings_params
    params.require(:library_settings).permit(:max_books_issuable,:max_borrow_days,:fine_for_late_return,:max_days_on_reservation_after_return,:is_deleted,:mg_school_id)
  end
  def books_category_params
    params.require(:books_category).permit(:category_name,:is_deleted,:mg_school_id)
  end
  def books_inventory_params
    params.require(:books_inventory).permit(:book_no,:book_name,:author,:publisher,:edition,:cost,:mg_books_category_id,:mg_course_id,:non_issuable,:is_damaged,:is_lost,:status,:is_deleted,:mg_school_id)
  end

end
