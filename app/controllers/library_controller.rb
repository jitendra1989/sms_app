class LibraryController < ApplicationController
  before_filter :login_required
  layout "mindcom"


def stack_management
@stack_management_data=MgLibraryStackManagement.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end

def stack_management_new
render :layout=>false
  end
def stack_management_create
stack_management=MgLibraryStackManagement.new(stack_management_params)
stack_management.save
redirect_to :action=>'stack_management'
end

def stack_management_show
  @show_stack_data=MgLibraryStackManagement.find_by(:id=>params[:id])
render :layout=>false

end

def stack_management_edit
  @stack_management=MgLibraryStackManagement.find_by(:id=>params[:id])
render :layout=>false

end

def stack_management_update
  update_data=MgLibraryStackManagement.find_by(:id=>params[:id])
  update_data.update(update_stack_management_params)
redirect_to :action=>'stack_management'
  
end

def stack_management_delete

  delete_data=MgLibraryStackManagement.find_by(:id=>params[:id])
  delete_data.is_deleted=1
    delete_data.save
redirect_to :action=>'stack_management'

end
def print_book_details
  #resource_data=MgLibraryStackManagement.find_by(:id=>params[:id])
resource_data=MgResourceInventory.find_by(:id=>params[:id])
      school=MgSchool.find(session[:current_user_school_id])
      @@school_logo=school.logo.url(:medium, timestamp: false)
 pdf = Prawn::Document.new(:page_size => [350, 180]) do

       

                  repeat :all do

                        bounding_box [bounds.left, bounds.top-6],:align => :right, :width  => bounds.width do
                            font "Helvetica"
                            move_up 12
                            # if File.exists?("#{Rails.root}/public/#{@@school_logo}") 
                            #        image( "#{Rails.root}/public/#{@@school_logo}",:width =>  45)
                            #       # image ("#{Rails.root}/public/#{@@school_logo}"),:at=>[425,690],:width=>45
                            #       # image "#{Rails.root}/public/#{@@school_logo}", :width => 45, :align => :left
                            # end
                            move_down 12
                            move_up 10
                            text "Book Details", :align => :center, :size => 18
                            stroke_horizontal_rule
                        end
        move_down 10

        # footer
                       
                  end
               

                    bounding_box([bounds.left, bounds.top - 60], :width  => bounds.width, :height => bounds.height - 100) do

                    move_down 120
                   
      


                      end
                      draw_text "Resource No :", :at => [10,60] 
                      draw_text "#{resource_data.resource_number}",:at => [90,60]  
                      draw_text "Title       :", :at => [10,40]
                      draw_text "#{resource_data.name}",:at => [60,40]
                     
                      draw_text "Author   :", :at =>  [10,20] 
                      draw_text "#{resource_data.author}",:at => [60,20]
                      
                     subject_data=MgManageSubject.find_by(:id=>resource_data.mg_subject_id)
                      draw_text "Subject : ", :at => [10,0]

                      
                  stack_data=MgLibraryStackManagement.find_by(:id=>resource_data.stack_reference)
                        if subject_data.nil?
                           draw_text "General Reading",:at => [60,0]
                     
                    else
                       draw_text "#{subject_data.name}",:at => [60,0]
                    end
                      draw_text "Stack Reference:", :at => [10,-20]
                      draw_text "#{stack_data.room_no}/#{stack_data.rack_no}/#{stack_data.first_letter_of_title}",:at => [110,-20] 

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
                      }, :filename => "Book_Details.pdf", :type => "application/pdf", :disposition => 'inline'


end

def library_incharge_index
  @all_library_settings_data=MgLibraryEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end
  def select_incharge_for_library
    @school_id=session[:current_user_school_id]
  end

  def select_asst_incharge_for_library  
    @school_id=session[:current_user_school_id]
  end
  def library_asst_incharge_create
    #logger.infoax
    begin
   @params=params[:selected_employees]
 
   for j in 0...@params.length
    library_employee_data=MgLibraryEmployee.new
    library_employee_data.mg_employee_id=@params[j]
    library_employee_data.is_deleted=0
    library_employee_data.designation="Asst Library Incharge"

    library_employee_data.mg_school_id=session[:current_user_school_id]
    library_employee_data.created_by=session[:user_id]
   library_employee_data.save
  end#for end
  redirect_to :action=>'library_incharge_index'


rescue
  flash[:error]="Data Not Saved"
  redirect_to :action=>'library_incharge_index'
  end#begin end

  end
  def library_incharge_create
    begin
   @params=params[:selected_employees]
 
   for j in 0...@params.length
    library_employee_data=MgLibraryEmployee.new
    library_employee_data.mg_employee_id=@params[j]
    library_employee_data.is_deleted=0
    library_employee_data.designation="Library Incharge"

    library_employee_data.mg_school_id=session[:current_user_school_id]
    library_employee_data.created_by=session[:user_id]
   library_employee_data.save
  end#for end
  redirect_to :action=>'library_incharge_index'


rescue
  flash[:error]="Data Not Saved"
  redirect_to :action=>'library_incharge_index'
  end#begin end

  end
  def library_incharge_edit

render :layout=>false
  end
def asst_library_incharge_edit
render :layout=>false
  end
  def library_select_employees
@deptid=params[:dept_data]
    if params[:data]=="asst"
      employee_inc_data=MgLibraryEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:designation=>"Library Incharge").pluck(:mg_employee_id).uniq
      if employee_inc_data.length>0
       @deptid=params[:dept_data]
      @employeeList=MgEmployee.where("mg_employee_department_id=? AND mg_employee_category_id=? AND is_deleted=? AND mg_school_id=? AND id NOT IN (?)",@deptid,2,0,session[:current_user_school_id],employee_inc_data)
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
  else
   # debug
@employeeList=MgEmployee.where(:mg_employee_department_id=>@deptid,:mg_employee_category_id=>2,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
#puts @employeeList.inspect
#logger.infoKAHSDasdfas
#logger.oaisdhfi
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

  end
    else
      employee_asst_inc_data=MgLibraryEmployee.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:designation=>"Asst Library Incharge").pluck(:mg_employee_id).uniq
      if employee_asst_inc_data.length>0
      @employeeList=MgEmployee.where("mg_employee_department_id=? AND mg_employee_category_id=? AND is_deleted=? AND mg_school_id=? AND id NOT IN (?)",@deptid,2,0,session[:current_user_school_id],employee_asst_inc_data)
     
      #@employeeList=MgEmployee.where(:mg_employee_department_id=>@deptid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:designation=>"Asst Library Incharge")
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


  else
     @employeeList=MgEmployee.where(:mg_employee_department_id=>@deptid,:mg_employee_category_id=>2,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
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

  end

  end
 render :layout=>false
  end
def library_incharge_data_update
  @params=params[:selected_employees]
 # puts params[:selected_employees].inspect
 #logger.infoJHDG

  school_id=session[:current_user_school_id]
 for j in 0...@params.size

   library_employee_data=MgLibraryEmployee.where('mg_school_id=? and  mg_employee_id=? and designation=?', school_id,@params[j],"Library Incharge")

 if library_employee_data.size<1

    @data=MgLibraryEmployee.new()
    @data.is_deleted=0
    @data.created_by=session[:user_id]
    @data.mg_employee_id=@params[j]
    @data.mg_school_id=school_id
    @data.designation="Library Incharge"

    @data.save
  else
        library_employee_data[0].update(:is_deleted=>0,:mg_school_id=>school_id)

      end
    end

  library_employee_data=MgLibraryEmployee.where('is_deleted=? and mg_school_id=? and  mg_employee_id  NOT IN (?) and designation=?', 0,school_id,params[:selected_employees],"Library Incharge")
  #     puts library_employee_data.inspect 

 if library_employee_data.length>0
    for j in 0...library_employee_data.length
     
     data=MgLibraryEmployee.find_by(:id=>library_employee_data[j].id)
     if data.present?
    data.update(:is_deleted=>1)
   end
  end
   end
    #flash[:success]="Data has Updated"

   redirect_to :action=>'library_incharge_index'

  end

  def asst_library_incharge_data_update
    #logger.infoadgjka
  @params=params[:asst_selected_employees]
  school_id=session[:current_user_school_id]
 for j in 0...@params.size

   library_employee_data=MgLibraryEmployee.where('mg_school_id=? and  mg_employee_id=? and designation=?', school_id,@params[j],"Asst Library Incharge")

 if library_employee_data.size<1

    @data=MgLibraryEmployee.new()
    @data.is_deleted=0
    @data.created_by=session[:user_id]
    @data.mg_employee_id=@params[j]
    @data.mg_school_id=school_id
    @data.designation="Asst Library Incharge"

    @data.save
  else
        library_employee_data[0].update(:is_deleted=>0,:mg_school_id=>school_id)

      end
    end

  library_employee_data=MgLibraryEmployee.where('is_deleted=? and mg_school_id=? and  mg_employee_id  NOT IN (?) and designation=?', 0,school_id,params[:asst_selected_employees],"Asst Library Incharge")
  puts library_employee_data.inspect 

 if library_employee_data.length>0
    for j in 0...library_employee_data.length
     
     data=MgLibraryEmployee.find_by(:id=>library_employee_data[j].id)
     if data.present?
    data.update(:is_deleted=>1)
   end
  end
   end
   # flash[:success]="Data has Updated"

   redirect_to :action=>'library_incharge_index'

  end
  def index
    
    user=MgUser.find_by(:id=>session[:user_id])
    if user.user_type=="employee"
    employee=MgEmployee.find_by(:mg_user_id=>session[:user_id])
    incharge=MgLibraryEmployee.where(:mg_employee_id=>employee.id,:designation=>"Library Incharge").count
  else
    incharge=0
  end
    if user.user_type=="admin"||user.user_type=="principal" || incharge>0

    @category=MgResourceCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  else
  redirect_to root_path
  end
  end

  def edit
    @library=MgResourceCategory.find_by(:id=>params[:id])
    render :layout=>false

  end

  def new
    render :layout=>false
  end

  def update
    @library=MgResourceCategory.find_by(:id=>params[:id])
    @library.update(params_update_category)
    redirect_to :action=> "index"
  end

  def show
    @library=MgResourceCategory.find_by(:id=>params[:id])
    render :layout=>false

  end

  def delete
    @library=MgResourceCategory.find_by(:id=>params[:id])
    @library.update(:is_deleted=>1)
    redirect_to :back
  end

  def create
    category=MgResourceCategory.new(params_category)
    category.save
    redirect_to :action=> "index"
  end

  def resource
    @resource=MgResourceType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def resource_new
    #render :layout=>false
  end

  def resource_create
    resource=MgResourceType.new(params_resource)
    puts resource.inspect
    #logger.infoa
    resource.save
    redirect_to :action=> "resource"
  end

  def resource_show
    @resource=MgResourceType.find_by(:id=>params[:id])
    render :layout=>false
  end

def resource_edit
  @library=MgResourceType.find_by(:id=>params[:id])
end

def resource_update

  library=MgResourceType.find_by(:id=>params[:id])

   if params[:library][:is_non_issuable].to_i==1
    #logger.infoasD
     library.update(:name=>params[:library][:name],:description=>params[:library][:description],:mg_resource_category_id=>params[:library][:mg_resource_category_id],:max_issuable_count=>params[:library][:max_issuable_count],:max_borrow_day=>params[:library][:max_borrow_day],:renewal_period=>params[:library][:renewal_period],:max_renewals_allowed=>params[:library][:max_renewals_allowed],
      :prefix=>params[:library][:prefix],:is_non_issuable=>params[:library][:is_non_issuable])
   else
    library.update(params_update_resource)
    end

  redirect_to :action=> "resource"
end

def resource_delete
    @library=MgResourceType.find_by(:id=>params[:id])
    @library.update(:is_deleted=>1)
    redirect_to :back
end

def subject
  @subject=MgManageSubject.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def subject_new
    render :layout=>false
  
end

def subject_create
    subject=MgManageSubject.new(params_subject)
    subject.save
    redirect_to :action=> "subject"
end

def subject_show
  @subject=MgManageSubject.find_by(:id=>params[:id])
    render :layout=>false

end

def subject_edit
  @library=MgManageSubject.find_by(:id=>params[:id])
    render :layout=>false

end

def subject_update
  @library=MgManageSubject.find_by(:id=>params[:id])
  @library.update(params_update_subject)
  redirect_to :action=> "subject"
end

def subject_delete
    @library=MgManageSubject.find_by(:id=>params[:id])
    @library.update(:is_deleted=>1)
    redirect_to :back
end

def purchase
  @book_purchase_details=MgResourcePurchase.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order(date_of_purchase: :desc)
end

def purchase_new
  
end

def resource_type_list
   if params[:data1]=="demo"
   @resource_list = MgResourceType.where(:is_deleted=>0,:mg_resource_category_id=>params[:id],:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)

  @disabled_options = MgResourceType.where(:is_deleted=>0,:mg_resource_category_id=>params[:id],:mg_school_id=>session[:current_user_school_id],:max_issuable_count=>nil,:max_borrow_day=>nil,:renewal_period=>nil).pluck(:id)
 render :layout=>false
   else
    @resource_list = MgResourceType.where(:is_deleted=>0,:mg_resource_category_id=>params[:id],:mg_school_id=>session[:current_user_school_id])
   
    respond_to do |format|
      format.json  { render :json => @resource_list }
    end

  end
  
end


def purchase_create
  begin
MgResourcePurchase.transaction do
library_purchase=MgResourcePurchase.new(library_details_params)
@timeformat = MgSchool.find(session[:current_user_school_id])
@date_of_purchase = Date.strptime(params[:library_purchase_details][:date_of_purchase],@timeformat.date_format)
library_purchase.created_by=session[:user_id]
if library_purchase.save
  library_purchase.update(:date_of_purchase=>@date_of_purchase)
end
resource_category_id_arr=params[:mg_resource_category_id]
resource_type_id_arr=params[:mg_resource_type_id]
name_arr=params[:name]
author_arr=params[:author]
volume_arr=params[:volume]
year_arr=params[:year]
publication_arr=params[:publication]
isbn_arr=params[:isbn]
mg_course_id_arr=params[:mg_course_id]
mg_subject_id_arr=params[:mg_subject_id]
cost_arr=params[:cost]
no_of_copy_arr=params[:no_of_copy]
total_arr=params[:total]
for j in 0...resource_category_id_arr.length
  if resource_category_id_arr[j].present?
resource_information_details=MgResourceInformation.new()
resource_information_details.mg_resource_purchase_id=library_purchase.id
resource_information_details.mg_school_id=session[:current_user_school_id]
resource_information_details.is_deleted=0
resource_information_details.created_by=session[:user_id]
resource_information_details.updated_by=session[:user_id]
resource_information_details.mg_resource_category_id=resource_category_id_arr[j]
resource_information_details.mg_resource_type_id=resource_type_id_arr[j]
resource_information_details.name=name_arr[j]
resource_information_details.author=author_arr[j]
resource_information_details.volume=volume_arr[j]
resource_information_details.year=year_arr[j]
resource_information_details.publication=publication_arr[j]
resource_information_details.isbn=isbn_arr[j]
resource_information_details.mg_course_id=mg_course_id_arr[j]
resource_information_details.mg_subject_id=mg_subject_id_arr[j]
resource_information_details.cost=cost_arr[j]
resource_information_details.no_of_copy=no_of_copy_arr[j]
resource_information_details.total=total_arr[j]
resource_information_details.save
end
end#for end

redirect_to :action=>'purchase'

end#transaction end
rescue
  flash[:error]="Data Not Saved"
  redirect_to :action=>'purchase_new'
end#begin end
end
def purchase_edit
  @library_purchase_details=MgResourcePurchase.find(params[:id])
  @book_purchase_details=MgResourceInformation.where(:mg_resource_purchase_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])  
end
def purchase_update
  @params=params[:ids]
  school_id=session[:current_user_school_id]
  resource_category_id_arr=params[:mg_resource_category_id]
  resource_type_id_arr=params[:mg_resource_type_id]
  name_arr=params[:name]
  author_arr=params[:author]
  volume_arr=params[:volume]
  year_arr=params[:year]
  publication_arr=params[:publication]
  isbn_arr=params[:isbn]
  mg_course_id_arr=params[:mg_course_id]
  mg_subject_id_arr=params[:mg_subject_id]
  cost_arr=params[:cost]
  no_of_copy_arr=params[:no_of_copy]
  total_arr=params[:total]

    @library_purchase_details=MgResourcePurchase.find(params[:id])
    @library_purchase_details.update(library_details_params)
    @timeformat = MgSchool.find(session[:current_user_school_id])
    @date_of_purchase = Date.strptime(params[:library_purchase_details][:date_of_purchase],@timeformat.date_format)
    @library_purchase_details.update(:date_of_purchase=>@date_of_purchase)
    library_data=MgResourceInformation.where('is_deleted=? and mg_school_id=? and mg_resource_purchase_id=? and id  NOT IN (?)', 0,session[:current_user_school_id],params[:id],params[:ids])
 if library_data.length>0
    for j in 0...library_data.length 
     data=MgResourceInformation.find_by(:id=>library_data[j].id)
     if data.present?
    data.update(:is_deleted=>1)
  end
  end
   end
 for j in 0...@params.size

   library_data=MgResourceInformation.where('mg_school_id=? and mg_resource_purchase_id=? and id=?', session[:current_user_school_id],params[:id],@params[j])
 if library_data.size<1
  if resource_category_id_arr[j].present?
purchase_details=MgResourceInformation.new()
purchase_details.mg_resource_purchase_id=params[:id]
purchase_details.mg_school_id=session[:current_user_school_id]
purchase_details.is_deleted=0
purchase_details.created_by=session[:user_id]
purchase_details.mg_resource_category_id=resource_category_id_arr[j]
purchase_details.mg_resource_type_id=resource_type_id_arr[j]
purchase_details.name=name_arr[j]
purchase_details.author=author_arr[j]
purchase_details.volume=volume_arr[j]
purchase_details.year=year_arr[j]
purchase_details.publication=publication_arr[j]
purchase_details.isbn=isbn_arr[j]
purchase_details.mg_course_id=mg_course_id_arr[j]
purchase_details.mg_subject_id=mg_subject_id_arr[j]
purchase_details.cost=cost_arr[j]
purchase_details.no_of_copy=no_of_copy_arr[j]
purchase_details.total=total_arr[j]
purchase_details.save
else
end
  else
    library_data[0].update(:total=>total_arr[j],:no_of_copy=>no_of_copy_arr[j],:cost=>cost_arr[j],:mg_subject_id=>mg_subject_id_arr[j],:mg_course_id=>mg_course_id_arr[j],:isbn=>isbn_arr[j],
      :publication=>publication_arr[j],:year=>year_arr[j],:volume=>volume_arr[j],:name=>name_arr[j],:author=>author_arr[j],:mg_resource_type_id=>resource_type_id_arr[j],:mg_resource_category_id=>resource_category_id_arr[j],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      end
    end
    flash[:success]="Data has Updated"
    redirect_to :action=>'purchase'
end

def purchase_show
  @purchase=MgResourcePurchase.find_by(:id=>params[:id])
  render :layout=>false
end

def inventory
  @inventory=MgResourceInventory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
end

def inventory_new
  
end

def auto_resource_number
  inventory=MgResourceType.find_by(:id=>params[:id])
  if MgResourceInventory.where(:mg_school_id=>session[:current_user_school_id],:mg_resource_type_id=>params[:id]).count.zero? # empty array
                          @strVal='1'
                      else
                          @lastrecord = MgResourceInventory.where(:mg_school_id=>session[:current_user_school_id],:mg_resource_type_id=>params[:id]).last
                          str=@lastrecord.resource_number
                          puts "starttttttttttttttttt"
                          puts str
                          puts inventory.prefix.length
                          puts str.length
                          puts "starttttttttttttttttt"

                          m=inventory.prefix.length
                          n= str.length
                          tail= str.slice(m, n)
                          puts "taillllllllllllllllllllllllllllllllll"
                          
                          puts tail
                          puts "taillllllllllllllllllllllllllllllllll"

                          @lastrecord=tail
                          @last_resource_number= @lastrecord.to_i
                          puts "5555555555555555555555555555555555555555"
                          puts @last_resource_number
                          puts "5555555555555555555555555555555555555555"

                          @next_resource_number = @last_resource_number + 1;
                          puts "666666666666666666666666666666666666666666"
                          puts @next_resource_number
                          puts "666666666666666666666666666666666666666666"

                          @strVal = @next_resource_number.to_s

                      end
                      @number=inventory.prefix.to_s+""+@strVal
#render :json=>@number.to_json

respond_to do |format|
       format.json  { render :json => @number.to_json }
       end
  
end

def inventory_create
    resource=MgResourceInventory.new(params_resource_inventory)
    resource.mg_resource_type_id=params[:mg_resource_type_id]
    if params[:library][:mg_subject_id].to_i==0
      resource.mg_course_id=0
     # logger.infoX
    end
     # logger.infoX

    resource.save
    redirect_to :action=> "inventory"
end

def inventory_edit
  @library=MgResourceInventory.find_by(:id=>params[:id])
  @object=MgResourceType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:id, :name)
end

def inventory_update
  @library=MgResourceInventory.find_by(:id=>params[:id])
  

  @library.update(params_resource_update_inventory)
   if params[:library][:mg_subject_id].to_i==0
      
      @library.update(:mg_course_id=>0)
    end
  redirect_to :action=> "inventory"
    
end

def inventory_delete
    @library=MgResourceInventory.find_by(:id=>params[:id])
    @library.update(:is_deleted=>1)
    redirect_to :back
end

def inventory_show
  @inventory=MgResourceInventory.find_by(:id=>params[:id])
  render :layout=>false
end

def kiosk
  @kiosk=MgUser.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:user_type=>"kiosk").paginate(page: params[:page], per_page: 10)
end
def kiosk_new
  render :layout=>false
end

def kiosk_create
    kiosk=MgUser.new(params_user)
    kiosk.save
    role=MgRole.find_by(:role_name=>"kiosk")
    if role.id.present?
    @user_role = kiosk.mg_user_roles.build(:mg_role_id => role.id)
       @user_role.save 
     end
    redirect_to :action=> "kiosk"
end

def book_search
  
end


def kiosk_edit
  @library=MgUser.find_by(:id=>params[:id])
  render :layout=>false
end
def kiosk_update
  kiosk=MgUser.find_by(:id=>params[:id])
  kiosk.update(params_user_update)
    redirect_to :action=> "kiosk"

end

def kiosk_delete
  kiosk=MgUser.find_by(:id=>params[:id])
  kiosk.update(:is_deleted=>1)
  redirect_to :action=> "kiosk"
end

def kiosk_show
  @library=MgUser.find_by(:id=>params[:id])
  render :layout=>false

end

def change_password
   @@a=false
    @fff = params[:library]
    @curr = @fff[:name]
    id=@fff[:user_id]
    user_name = MgUser.where(:id =>id).pluck(:user_name)
    @user=MgUser.where(:id =>id)

@bool=@user.authenticate(user_name, @curr)

if  @bool==nil
  flash[:notice] = "Please enter correct password !"
  @@a=true
else
    @pass = params[:library]
    @passw = @pass[:password]
    @rpass = params[:library]
    @rpassw = @rpass[:hashed_password]
    if @passw==@rpassw
      if @user
            @userMe=MgUser.find(id)
       @userMe.update(password_params)
    end  
    else
    flash[:notice] = "Re Entered password didn't matched !"
    end
end
  
   if @@a==true
    flash[:notice] = "Invalid Password..."
    redirect_to library_kiosk_url
  else
    redirect_to :action => "kiosk"
  end
  
end

def prefix_validation
  puts params[:id].inspect
  #logger.infoDJGsd
  @prefix_count=MgResourceType.where(:mg_school_id=>session[:current_user_school_id],:prefix=>params[:id]).count
  respond_to do |format|
       format.json  { render :json => @prefix_count.to_json }
       end
end

def prefix_edit_validation
  
  @resource_type=MgResourceType.where(:mg_school_id=>session[:current_user_school_id],:prefix=>params[:id]).pluck(:id)
  
  if @resource_type.present?
  @resource_inventory=MgResourceInventory.where(:mg_school_id=>session[:current_user_school_id],:mg_resource_type_id=>@resource_type,:is_deleted=>0).count
  else
  @resource_inventory=0
  end
  
  respond_to do |format|
       format.json  { render :json => @resource_inventory.to_json }
       end
end

def type_wise_search
  @inventory=MgResourceInventory.where(:mg_resource_type_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  render :layout=>false
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

  def section_for_selected_class
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


   def search_books
    @value=params[:Value]
    @datas=params[:Data]
    @school_id=session[:current_user_school_id]
    @sql="select id,mg_resource_category_id,issued_date,due_date,mg_resource_type_id,renewal_count,issued_to,name,author,volume,year,publication,user_type from mg_resource_inventories where resource_number='#{@datas}' and is_deleted='0' and mg_school_id='#{@school_id}' and non_issuable='0' and is_damaged='0'and is_lost='0'"
     
    @data=MgResourceInventory.find_by_sql(@sql)

    render :layout=>false
  end

def employee_student_information
  @resource_type_id=params[:resource_type]
  inventory_data=MgResourceInventory.find(@resource_type_id)
  @resource_id=MgResourceType.find(inventory_data.mg_resource_type_id)
  @user_data=MgUser.find_by(:user_name=>params[:Data])
  @resource_category_id=params[:value]
  if @user_data.user_type=="student"
    @student_data=MgStudent.find_by(:mg_user_id=>@user_data,:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
  elsif @user_data.user_type=="employee"
    @employee_data=MgEmployee.find_by(:mg_user_id=>@user_data,:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)

end
render :layout=>false

end

def save_issue_data_status_for_library
  @library_settings_data=MgResourceType.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:category_id])

  @inventaoru_update=MgResourceInventory.find(params[:resource_type_id])
  puts "dataa"

  if params[:status_data]=="Employee"
    @inventaoru_update.issued_to=params[:working_id]

    max_days=@library_settings_data.max_borrow_day
    today_date=Date.today
    due_date=today_date+max_days

    weekday=[0,1,2,3,4,5,6]
    my_days = MgEmployeeWeekday.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0).pluck(:weekday)
    my_days=weekday-my_days


    daysss=due_date#+holiday
   for i in 0...7
      if my_days.include?(daysss.strftime("%w").to_i)
        daysss +=1
      else
      end
    end
        
    @inventaoru_update.due_date=daysss

    @inventaoru_update.status="Issued"
    @inventaoru_update.user_type="employee"

    @inventaoru_update.issued_date=Date.today
    @inventaoru_update.renewal_count=0
    @inventaoru_update.save

    books_transaction_history=MgBooksTransaction.new
    books_transaction_history.mg_employee_id=params[:working_id]
    books_transaction_history.start_date=Date.today
    books_transaction_history.issued_by=session[:user_id]
    books_transaction_history.is_deleted=0
    books_transaction_history.mg_school_id=session[:current_user_school_id ]
    books_transaction_history.status="Issued"
    books_transaction_history.created_by=session[:user_id]
    books_transaction_history.updated_by=session[:user_id]
    books_transaction_history.mg_resource_inventory_id=params[:resource_type_id]
    books_transaction_history.user_type= params[:status_data]

    books_transaction_history.save
  else
    @inventaoru_update.issued_to=params[:working_id]

    student_infor=MgStudent.find_by(:id=>params[:working_id])
    batch_infor=MgBatch.find_by(:id=>student_infor.mg_batch_id)
    course_info=MgCourse.find_by(:id=>batch_infor.mg_course_id)

    puts "Sdataa"
    weekday=["0","1","2","3","4","5","6"]
    my_days = MgWeekday.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:mg_wing_id=>course_info.mg_wing_id).pluck(:weekday)
    puts my_days.inspect
    puts "lADHHADHkAKHDKKASKDKA"

    my_days=weekday-my_days
    puts my_days.inspect
    puts "lADHHADHkAKHDKKASKDKA12312313"

    max_days=@library_settings_data.max_borrow_day

    puts "Sdataa"
    today_date=Date.today
    due_date=today_date+max_days
    daysss=due_date#+holiday
    for i in 0...7
      if my_days.include?(daysss.strftime("%w"))
        daysss +=1
      else
      end
    end
    puts "======================================================="
    puts my_days.inspect
    puts daysss.strftime("%w").to_i
    puts daysss
    @inventaoru_update.due_date=daysss
    @inventaoru_update.status="Issued"
    @inventaoru_update.user_type="student"

    @inventaoru_update.issued_date=Date.today
 
    @inventaoru_update.save

    books_transaction_history=MgBooksTransaction.new
    books_transaction_history.mg_student_id=params[:working_id]
    books_transaction_history.start_date=Date.today
    books_transaction_history.issued_by=session[:user_id]
    books_transaction_history.is_deleted=0
    books_transaction_history.mg_school_id=session[:current_user_school_id ]
    books_transaction_history.status="Issued"
    books_transaction_history.created_by=session[:user_id]
    books_transaction_history.updated_by=session[:user_id]
    books_transaction_history.mg_resource_inventory_id=params[:resource_type_id]
    books_transaction_history.user_type= params[:status_data]

    books_transaction_history.save
  end
end

def save_return_data
 invenotry_data_id=params[:inventory_id]
   
    fine_amount=params[:fine_amount]
    book_status=params[:extent_of_damage]
    no_of_days_delayed=params[:no_of_days_delayed]
    MgResourceInventory.transaction do
      @inventory_data=MgResourceInventory.find(params[:inventory_id])
      if @inventory_data.user_type=="employee"

    books_transaction_data=MgBooksTransaction.new
    books_transaction_data.start_date=@inventory_data.issued_date
    books_transaction_data.end_date=Date.today
    books_transaction_data.due_date=@inventory_data.due_date
    books_transaction_data.mg_employee_id=@inventory_data.issued_to
    books_transaction_data.user_type=@inventory_data.user_type

    books_transaction_data.received_by=session[:user_id]
    books_transaction_data.created_by=session[:user_id]
    books_transaction_data.updated_by=session[:user_id]
    #books_transaction_data.issued_by=@inventory_data.reserved_by
    books_transaction_data.mg_school_id=session[:current_user_school_id]
    books_transaction_data.is_deleted=0
    books_transaction_data.mg_resource_inventory_id=params[:inventory_id]
    books_transaction_data.status="on-shelf"
if book_status.present?
    books_transaction_data.return_book_condition=book_status
    books_transaction_data.is_it_returned_as_was_taken=true

end
if no_of_days_delayed.present?
books_transaction_data.no_of_days_delayed=no_of_days_delayed
books_transaction_data.is_there_a_delay=true

  end
    books_transaction_data.save


  
      @inventory_data.status="On-shelf"
      #@inventory_data.mg_student_id=params[:student_id]
      @inventory_data.issued_to=0
      @inventory_data.due_date=nil
      @inventory_data.issued_date=nil
      @inventory_data.user_type=nil

      @inventory_data.save

    else
 books_transaction_data=MgBooksTransaction.new
    books_transaction_data.start_date=@inventory_data.issued_date
    books_transaction_data.end_date=Date.today
    books_transaction_data.due_date=@inventory_data.due_date
    books_transaction_data.mg_student_id=@inventory_data.issued_to
    books_transaction_data.user_type=@inventory_data.user_type

    books_transaction_data.received_by=session[:user_id]
    books_transaction_data.created_by=session[:user_id]
    books_transaction_data.updated_by=session[:user_id]
    #books_transaction_data.issued_by=@inventory_data.reserved_by
    books_transaction_data.mg_school_id=session[:current_user_school_id]
    books_transaction_data.is_deleted=0
    books_transaction_data.return_book_condition=book_status
    books_transaction_data.mg_resource_inventory_id=params[:inventory_id]
    books_transaction_data.status="on-shelf"

    if book_status.present?
    books_transaction_data.return_book_condition=book_status
    books_transaction_data.is_it_returned_as_was_taken=true

end
if no_of_days_delayed.present?
books_transaction_data.no_of_days_delayed=no_of_days_delayed
books_transaction_data.is_there_a_delay=true

  end
      if fine_amount.present?
         books_transaction_data.is_fine_applicable="yes"
    books_transaction_data.amount=fine_amount
      end
    books_transaction_data.save

      if params[:boolean_data].to_i==0
      if fine_amount.present?
     @fine_particular=MgFeeFineParticular.new
    @fine_particular.fine_name="library_late_fine"
    @fine_particular.fine_from="Library"
    @fine_particular.amount=fine_amount

    if params[:account_id]=="central"
      @fine_particular.is_to_central=1
    else
      @fine_particular.mg_account_id=params[:account_id]
    end  

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
 end

  
      @inventory_data.status="On-shelf"
      #@inventory_data.mg_student_id=params[:student_id]
      @inventory_data.issued_to=0
      @inventory_data.due_date=nil
      @inventory_data.issued_date=nil
      @inventory_data.user_type=nil
      @inventory_data.renewal_count=0

      @inventory_data.save



  
end
end
   render :layout=>false

  end
def update_renew_data


  

@inventaoru_update=MgResourceInventory.find(params[:resource_type_id])
@library_settings_data=MgResourceType.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_resource_category_id=>@inventaoru_update.mg_resource_category_id)

if @inventaoru_update.user_type=="employee"

  max_days=@library_settings_data.max_borrow_day
today_date=Date.today
 due_date=today_date+max_days
     no_of_days=max_days+1


  weekday=[0,1,2,3,4,5,6]
     my_days = MgEmployeeWeekday.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0).pluck(:weekday)
     my_days=weekday-my_days

    

      #   $dayCount=0
      #   holiday=0
      # for i in 0...no_of_days
      #           date=Date.today+i
              
      #           arr = date.to_s.split('-');
      #           month= arr[1].to_i
      #           year=arr[0].to_i
      #           day =arr[2].to_i

              
                
      #           $dayCheck= Date.new(year.to_i,month.to_i,day.to_i)+$dayCount
      #           dayName=$dayCheck.strftime("%w")
                
            
      #               if my_days.include?(dayName.to_i)   
                    
      #                 holiday +=1
                      
      #               end
               

      #                 $dayCount +=1

                
      #             puts "holiday===>#{holiday}"

               
      # end  
      
  #@inventaoru_update.issued_to=params[:working_id]
#@student_lib_inforamtion=MgResourceInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])

max_days=@library_settings_data.max_borrow_day
today_date=Date.today
 due_date=today_date+max_days
 daysss=due_date#+holiday
 for i in 0...7
        if my_days.include?(daysss.strftime("%w").to_i)
         # logger.infoAsDASDs
        daysss +=1
        else
        end
        end
          #logger.abcdef
 @inventaoru_update.due_date=daysss

 @inventaoru_update.status="Renewed"
 @inventaoru_update.user_type="employee"


 @inventaoru_update.renewal_count=@inventaoru_update.renewal_count+1

 @inventaoru_update.issued_date=Date.today
 
 @inventaoru_update.save

 books_transaction_history=MgBooksTransaction.new
 books_transaction_history.mg_employee_id=params[:working_id]
 books_transaction_history.start_date=Date.today
 books_transaction_history.issued_by=session[:user_id]
 books_transaction_history.is_deleted=0
 books_transaction_history.mg_school_id=session[:current_user_school_id ]
 books_transaction_history.status="Renewed"
 books_transaction_history.created_by=session[:user_id]
 books_transaction_history.updated_by=session[:user_id]
 books_transaction_history.mg_resource_inventory_id=params[:resource_type_id]
 books_transaction_history.user_type= "employee"

 books_transaction_history.save

  else

    
     student_infor=MgStudent.find_by(:id=>@inventaoru_update.issued_to)
     puts params[:working_id].inspect
     batch_infor=MgBatch.find_by(:id=>student_infor.mg_batch_id)
     course_info=MgCourse.find_by(:id=>batch_infor.mg_course_id)


  weekday=["0","1","2","3","4","5","6"]
     my_days = MgWeekday.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:mg_wing_id=>course_info.mg_wing_id).pluck(:weekday)
     puts my_days.inspect

     my_days=weekday-my_days

     puts my_days.inspect

     puts params[:working_id]
max_days=@library_settings_data.max_borrow_day

     no_of_days=max_days+1


      #   $dayCount=0
      #   holiday=0
      # for i in 0...no_of_days
      #           date=Date.today+i
      #           arr = date.to_s.split('-');
      #           month= arr[1].to_i
      #           year=arr[0].to_i
      #           day =arr[2].to_i
      #           $dayCheck= Date.new(year.to_i,month.to_i,day.to_i)+$dayCount
      #           dayName=$dayCheck.strftime("%w")
      #               if my_days.include?(dayName)   
      #                 holiday +=1
      #               end
      #                 $dayCount +=1

                
      #             puts "holiday===>#{holiday}"

               
      # end  
     #@inventaoru_update.issued_to=params[:working_id]
#@student_lib_inforamtion=MgResourceInventory.where("issued_to=? or reserved_by=?",params[:student_id],params[:student_id])

max_days=@library_settings_data.max_borrow_day
today_date=Date.today
 due_date=today_date+max_days
 daysss=due_date#+holiday
 for i in 0...7
        if my_days.include?(daysss.strftime("%w"))
          #logger.infoSDAsdaD
        daysss +=1
        else
        end
        end
        #logger.asd123
 @inventaoru_update.due_date=daysss

 
 @inventaoru_update.status="Renewed"
 @inventaoru_update.user_type="student"

 @inventaoru_update.renewal_count=@inventaoru_update.renewal_count+1

 @inventaoru_update.issued_date=Date.today
 
 @inventaoru_update.save

 books_transaction_history=MgBooksTransaction.new
 books_transaction_history.mg_student_id=@inventaoru_update.issued_to
 books_transaction_history.start_date=Date.today
 books_transaction_history.issued_by=session[:user_id]
 books_transaction_history.is_deleted=0
 books_transaction_history.mg_school_id=session[:current_user_school_id ]
 books_transaction_history.status="Renewed"
 books_transaction_history.created_by=session[:user_id]
 books_transaction_history.updated_by=session[:user_id]
 books_transaction_history.mg_resource_inventory_id=params[:resource_type_id]
 books_transaction_history.user_type= "student"

 books_transaction_history.save

end
  end

  def library_report_generation
     @timeformat = MgSchool.find(session[:current_user_school_id])
       
        from_date= Date.strptime(params[:from_date],@timeformat.date_format)
        to_date= Date.strptime(params[:to_date],@timeformat.date_format)
       
    data=MgResourcePurchase.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:date_of_purchase=>from_date..to_date).pluck(:id)
    puts data.inspect
    puts "sjdddddddddddddddddddddddddddddddddddddddddddddddddddddddh"
    #logger.infoshdka
    @book_purchase_details=MgResourceInformation.where(:mg_resource_purchase_id=>data,:mg_course_id=>params[:class_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_resource_category_id=>params[:category_id],:mg_resource_type_id=>params[:type_id])

      @demo_data=MgResourceType.find(params[:type_id])
   render :layout=>false

  end
  def resource_type_data
    @resource_type_data=MgResourceType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_resource_category_id=>params[:category_id]).pluck(:name,:id)
    render :layout=>false
  end

  def damaged_book_list
  @data=MgResourceInventory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_damaged=>1)

  end
  def borrowed_book_list
      @data=MgResourceInventory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_damaged=>0,:status=>["Issued","Renewed"])
  end
  def search_reserve_books_index
  if params[:id]=="search"
  mg_school_id=session[:current_user_school_id]
  @name=params[:name]
  @category=params[:resorce_category]
  @type=params[:select_type]
  @number=params[:resource_no]
  @author=params[:author]
  @year=params[:year]
  @publications=params[:publication]
  @class=params[:select_class]
  @subject=params[:subject]
  @volume=params[:volume]
  @isbn=params[:isbn]
  @str="is_deleted=0"
  if params[:name].present?
     @str += " and name='#{params[:name]}'"
  end
   if params[:resorce_category].present?
     @str += " and mg_resource_category_id='#{params[:resorce_category]}'"
  end
   if params[:select_type].present?
     @str += " and mg_resource_type_id='#{params[:select_type]}'"
  end
   if params[:resource_no].present?
     @str += " and resource_number='#{params[:resource_no]}'"
  end 
  if params[:author].present?
     @str += " and author='#{params[:author]}'"
  end
   if params[:year].present?
     @str += " and year='#{params[:year]}'"
  end
   if params[:publication].present?
     @str += " and publication='#{params[:publication]}'"
  end
   if params[:select_class].present?
     @str += " and mg_course_id='#{params[:select_class]}'"
  end
   if params[:subject].present?
     @str += " and mg_subject_id='#{params[:subject]}'"
  end
   if params[:volume].present?
     @str += " and volume='#{params[:volume]}'"
  end
   if params[:isbn].present?
     @str += " and isbn='#{params[:isbn]}'"
  end

 @category_type_data=MgResourceType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  @object=MgResourceInventory.where( :mg_school_id=>mg_school_id,:is_deleted=>0,:non_issuable=>0).where(@str)

  # @object1=MgResourceInventory.where( :mg_school_id=>mg_school_id)

else
  @demo="data1"
  end
end

# def no_of_sunday(start_of_month,end_of_month)
#     mg_school_id=session[:current_user_school_id]
#     weekday=[0,1,2,3,4,5,6]
#      my_dayss = MgWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
#      my_dayss=weekday-my_dayss
#      puts "weekday----->#{my_dayss.inspect}"
#           result = (start_of_month..end_of_month).to_a.select {|k| my_dayss.include?(k.wday)}
#     puts "result.inspect  -------#{result.inspect}"
#     return result.count
#   end


private

def params_category
  params.require(:library).permit(:name,:description,:is_deleted,:created_by,:updated_by,:mg_school_id)
end

def params_update_category
  params.require(:library).permit(:name,:description,:is_deleted,:updated_by,:mg_school_id)
end

def params_resource
  params.require(:library).permit(:prefix,:max_renewals_allowed,:renewal_period,:max_borrow_day,:max_issuable_count,:name,:description,:fine_per_day,:mg_resource_category_id,:is_deleted,:created_by,:updated_by,:mg_school_id,:is_non_issuable)
end

def params_update_resource
  params.require(:library).permit(:prefix,:max_renewals_allowed,:renewal_period,:max_borrow_day,:max_issuable_count,:fine_per_day,:name,:description,:mg_resource_category_id,:is_deleted,:updated_by,:mg_school_id,:is_non_issuable)
end

def params_subject
  params.require(:library).permit(:name,:description,:is_deleted,:created_by,:updated_by,:mg_school_id)
end

def params_update_subject
  params.require(:library).permit(:name,:description,:is_deleted,:updated_by,:mg_school_id)
end

def library_details_params
    params.require(:library_purchase_details).permit(:vendor_name,:date_of_purchase,:amount_paid,:invoice_number,:is_deleted,:mg_school_id)
  end

def params_resource_inventory
  params.require(:library).permit(:mg_resource_category_id,:mg_resource_type_id,:resource_number,:name,:author,:volume,:year,:publication,:isbn,:mg_course_id,:mg_subject_id,:stack_reference,:cost,:non_issuable,:is_damaged,:is_lost,:status,:is_deleted,:mg_school_id,:created_by,:updated_by)
end

def params_resource_update_inventory
  params.require(:library).permit(:resource_number,:name,:author,:volume,:year,:publication,:isbn,:mg_course_id,:mg_subject_id,:stack_reference,:cost,:non_issuable,:is_damaged,:is_lost,:status,:is_deleted,:mg_school_id,:updated_by)
end

def params_user
  params.require(:library).permit(:is_deleted,:mg_school_id,:created_by,:updated_by,:user_type,:user_name,:password)
end

def params_user_update
  params.require(:library).permit(:is_deleted,:mg_school_id,:updated_by,:user_type,:user_name)
end

def password_params
  params.require(:library).permit(:password)
end

def stack_management_params

  params.require(:stack_management).permit(:room_no,:rack_no,:first_letter_of_title,:is_deleted,:mg_school_id,:created_by,:updated_by)

end
def update_stack_management_params

  params.require(:stack_management).permit(:room_no,:rack_no,:first_letter_of_title)

end


end
