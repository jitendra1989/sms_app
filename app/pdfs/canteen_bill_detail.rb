class CanteenBillDetail < Prawn::Document
  def initialize(school,date_format,school_logo,student_id,batch_id,employee_id,employee_department_id,food_item_detail,bill_details_obj)
    super({:page_size => [595 ,842]})

    @school = school
    @food_item_detail = food_item_detail 
    @school_logo = school_logo
    @batch_id = batch_id
    @student_id = student_id
    @employee_id =employee_id
    @employee_department_id = employee_department_id
    @bill_details_obj=bill_details_obj
    
    @batchobj = MgBatch.where(:id=>@batch_id,:is_deleted=>0)
    @student_obj = MgStudent.find_by(:id=>@student_id,:is_deleted=>0)

    if @student_obj.present?
      @user_photo=@student_obj.avatar.url(:medium, timestamp: false)
    end
    @courseObj = MgCourse.find_by_id(@batchobj[0].try(:mg_course_id))
    @date_format = date_format

    @emp_department = MgEmployeeDepartment.find_by(:id=>@employee_department_id,:is_deleted=>0)
    @employee_obj = MgEmployee.find_by(:id=>@employee_id,:is_deleted=>0)
    if @employee_obj.present?
      @user_photo=@employee_obj.photo.url
    end
    logo
    #student_detail
    #student_image
    #table_content
    # footer
  end

  def logo 
    y_position = cursor - 0
    y_position1 = cursor - 15
    y_position2 = cursor - 115
    y_position3 = cursor - 140
    y_position_vertical_line = cursor - 420
    
    repeat :all do
      bounding_box([0, y_position], :width => 270, :height => 300) do
        font "Helvetica"
        if File.exists?("#{Rails.root}/public/#{@school_logo}")
          image ("#{Rails.root}/public/#{@school_logo}"),:width=>70
        else
          image ("#{Rails.root}/app/assets/images/logo.jpg"),:width=>70   
        end 
      end      

      bounding_box([70, y_position1], :width => 400, :height => 300) do
        text @school.school_name, :align => :center, :size => 20,:inline_format => true
      end
       
      bounding_box([0, y_position2], :width => 510, :height => 300) do
        stroke_horizontal_rule
      end
      
      footer
    end

    bounding_box([0, y_position3], :width => 370, :height => 300) do
      draw_text "General Information",  :at => [180, 302], :size => 12, style: :bold
      stroke do
        rectangle [0, 300],  510, 180 
        if  File.exists?("#{Rails.root}/public/#{@user_photo}")
          image ("#{Rails.root}/public/#{@user_photo}"),:height=>70,:width=>100,:at => [280,280]
        else
          rectangle [250, 270],  95, 100 
        end
      end

      # bounding_box([120, y_position_vertical_line], :width => 510, :height => 300) do
      #   stroke do
      #     vertical_line   250, 0,:at => 150
      #   end
      # end

      if @student_obj.present?
        draw_text "Name: #{@student_obj.first_name.capitalize} #{@student_obj.last_name.capitalize}",  :at => [10, 270], :size => 12#
        draw_text "Admission Number: #{@student_obj.try(:admission_number)}",  :at => [10, 250], :size => 12#, style: :bold
        draw_text "Date of Birth: #{@student_obj.try(:date_of_birth).try(:strftime,@date_format)}",  :at => [10, 230], :size => 12#, style: :bold
      else
        draw_text "Name: #{@employee_obj.first_name.capitalize} #{@employee_obj.last_name.capitalize}",  :at => [10, 270], :size => 12#
        draw_text "Employee Number: #{@employee_obj.try(:employee_number)}",  :at => [10, 250], :size => 12#, style: :bold
        draw_text "Date of Birth: #{@employee_obj.try(:date_of_birth).try(:strftime,@date_format)}",  :at => [10, 230], :size => 12#, style: :bold
        # draw_text "Father’s Name: #{@employee_obj.try(:father_name).try(:capitalize)}",  :at => [280, 250], :size => 12#, style: :bold
        # address="Address: #{@employee_address.try(:address_line1).try(:capitalize)} #{@employee_address.try(:address_line2)} #{@employee_address.try(:street)} #{@employee_address.try(:landmark)} #{@employee_address.try(:city)} #{@employee_address.try(:state)}"
        
        # [:shrink_to_fit].each_with_index do |mode, i|
        #   text_box address,:at =>[280, 200],
        #   :width => 210,
        #   :height => 110,
        #   :overflow => mode
        # end
      end
    end
  

    bounding_box([0, y_position3], :width => 510, :height => 530) do
      # start_new_page
      move_down(170)

      # start_new_page
      health_test_content
    end
  end
 
  def health_test_content
    move_down(25)
    text "Bill Details:", :size => 12, style: :bold
    widths = [130,170,90,120]
    cell_height = 10
    if @food_item_detail.present?
      count=0
      table([['Sr. No', 'Food Item','Quantity','Total Price']], :column_widths => widths, :cell_style => { size: 11.5,:font_style => :bold})
      @food_item_detail.each do |food_item|
        count=count+1

        food_item_name=MgFoodItem.find_by(:id=>food_item.mg_food_item_id)
        # @checkup_particular_id = MgHealthTest.where(:mg_check_up_type_id=>checkup_type_id,:is_deleted=>0,:mg_student_id=>@student_id,:mg_batch_id=>@batch_id).pluck("DISTINCT mg_checkup_particular_id")
        if food_item_name.present?
          # @checkup_particular_id.each do |particular_id|
            # checkup_particular = MgCheckupParticular.where("id=? and is_deleted=? and show_in_healthcard=? and (applicable=? or applicable=?) ",particular_id,0,true,'student','both')
            # if checkup_particular.present?
              # last_health_obj = MgHealthTest.where(:mg_checkup_particular_id=>particular_id,:mg_student_id=>@student_id,:mg_batch_id=>@batch_id,:is_deleted=>0).last
              table([[ count,food_item_name.try(:item_name),food_item.try(:quantity),food_item.try(:amount)]], :column_widths => widths, :cell_style => { size: 13 }) 
            # end
          # end
          # move_down(25)
        end
      end
      move_down(30)
      widths = [250,260]
      cell_height = 10
      table([['Total Amount','Paid Amount']], :column_widths => widths, :cell_style => { size: 11.5,:font_style => :bold})
      table([[ @bill_details_obj.total_amount,@bill_details_obj.paid_amount]], :column_widths => widths, :cell_style => { size: 13 }) 

    else
     table([['Sr. No', 'Food Item','Quantity','Total Price']], :column_widths => widths, :cell_style => { size: 11.5,:font_style => :bold})
     table([["...","...","...","..."]], :column_widths => widths, :cell_style => { size: 13 }) 
    end
  end

  def footer
    bounding_box [bounds.left, bounds.bottom + 45], :width  => bounds.width do
      font "Helvetica"
      stroke_horizontal_rule
      move_down(5)
      move_down 12
      
      draw_text "Terms & Conditions| Privacy Policy| About Us| Contact Us       Powered By - ©", :at => [30,3]
      image "#{Rails.root}/app/assets/images/mindcom-logo.png", :at=>[450,15], :width => 45, :align => :right
    end
  end
end