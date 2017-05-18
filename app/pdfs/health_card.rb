class HealthCard < Prawn::Document
  def initialize(school,date_format,school_logo,student_id,batch_id,employee_id,employee_department_id,health_record_obj,vaccination_detail,allergy,booster_dose)
    super({:page_size => [595 ,842]})

    @school = school
    @health_record_obj = health_record_obj 
    @vaccination_detail=vaccination_detail
    @allergy = allergy
    @booster_dose = booster_dose
    @school_logo = school_logo
    @batch_id = batch_id
    @student_id = student_id
    @employee_id =employee_id
    @employee_department_id = employee_department_id
    
    @batchobj = MgBatch.where(:id=>@batch_id,:is_deleted=>0)
    @student_obj = MgStudent.find_by(:id=>@student_id,:is_deleted=>0)

    if @student_obj.present?
      @user_photo=@student_obj.avatar.url(:medium, timestamp: false)
      @guardian_obj = MgGuardian.find_by(:mg_student_id=>@student_obj.id,:is_deleted=>0)
      if @guardian_obj.present?
        @guardian_address = MgAddress.find_by(:mg_user_id=>@guardian_obj.mg_user_id,:address_type=>'Permanent',:is_deleted=>0)
        @mobile_number = MgPhone.find_by(:mg_user_id=>@guardian_obj.mg_user_id,:phone_type=>'mobile',:is_deleted=>0)
        @phone_number = MgPhone.find_by(:mg_user_id=>@guardian_obj.mg_user_id,:phone_type=>'phone',:is_deleted=>0)
      end
    end
    @courseObj = MgCourse.find_by_id(@batchobj[0].try(:mg_course_id))
    @date_format = date_format

    @emp_department = MgEmployeeDepartment.find_by(:id=>@employee_department_id,:is_deleted=>0)
    @employee_obj = MgEmployee.find_by(:id=>@employee_id,:is_deleted=>0)
    if @employee_obj.present?
      @user_photo=@employee_obj.photo.url
      @employee_address = MgAddress.find_by(:mg_user_id=>@employee_obj.mg_user_id,:address_type=>'Permanent',:is_deleted=>0)
      @employee_mobile_number = MgPhone.find_by(:mg_user_id=>@employee_obj.mg_user_id,:phone_type=>'mobile',:is_deleted=>0)
      @employee_phone_number = MgPhone.find_by(:mg_user_id=>@employee_obj.mg_user_id,:phone_type=>'phone',:is_deleted=>0)
    end

    @big_array=[]
    if @vaccination_detail.present?
      @vaccination_detail.each do |vaccs_details|
        small_array=[]
        if vaccs_details.is_particular_student==true
          small_array.push(vaccs_details.try(:name),vaccs_details.try(:age_recommended),vaccs_details.try(:due_date),vaccs_details.try(:date))
          @big_array.push(small_array)
        else
          small_array.push(vaccs_details.try(:mg_vaccination).try(:name),vaccs_details.try(:mg_vaccination).try(:age_recommended),vaccs_details.try(:due_date),vaccs_details.try(:date))
          @big_array.push(small_array)
        end
      end
    end

    @booster_big_array=[]
    if @booster_dose.present?
      @booster_dose.each do |booster_details|
        small_array=[]
        if booster_details.is_particular_student==true
          small_array.push(booster_details.try(:name),booster_details.try(:frequency),booster_details.try(:due_date),booster_details.try(:date))
          @booster_big_array.push(small_array)
        else
          small_array.push(booster_details.try(:mg_booster_dose).try(:name),booster_details.try(:mg_booster_dose).try(:frequency),booster_details.try(:due_date),booster_details.try(:date))
          @booster_big_array.push(small_array)
        end
      end
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
        rectangle [0, 300],  510, 250 
        if  File.exists?("#{Rails.root}/public/#{@user_photo}")
          image ("#{Rails.root}/public/#{@user_photo}"),:height=>70,:width=>100,:at => [60,200]
        else
          rectangle [60, 200],  95, 100 
        end
      end

      bounding_box([120, y_position_vertical_line], :width => 510, :height => 300) do
        stroke do
          vertical_line   250, 0,:at => 150
        end
      end

      if @student_obj.present?
        draw_text "Name: #{@student_obj.first_name.capitalize} #{@student_obj.last_name.capitalize}",  :at => [10, 270], :size => 12#
        draw_text "Date of Birth: #{@student_obj.try(:date_of_birth).try(:strftime,@date_format)}",  :at => [10, 250], :size => 12#, style: :bold
        draw_text "Admission Number: #{@student_obj.try(:admission_number)}",  :at => [280, 270], :size => 12#, style: :bold
        draw_text "Guardian’s Name: #{@guardian_obj.try(:first_name).try(:capitalize)} #{@guardian_obj.try(:last_name).try(:capitalize)}",  :at => [280, 250], :size => 12#, style: :bold
        address="Address: #{@guardian_address.try(:address_line1).try(:capitalize)} #{@guardian_address.try(:address_line2)} #{@guardian_address.try(:street)} #{@guardian_address.try(:landmark)} #{@guardian_address.try(:city)} #{@guardian_address.try(:state)}"
        draw_text "Mobile No: #{@mobile_number.try(:phone_number)}",  :at => [280, 230], :size => 12#, style: :bold
        draw_text "Phone No: #{@phone_number.try(:phone_number)}",  :at => [280, 210], :size => 12#, style: :bold
        
        [:shrink_to_fit].each_with_index do |mode, i|
          text_box address,:at =>[280, 200],
          :width => 210,
          :height => 110,
          :overflow => mode
        end
      else
        draw_text "Name: #{@employee_obj.first_name.capitalize} #{@employee_obj.last_name.capitalize}",  :at => [10, 270], :size => 12#
        draw_text "Date of Birth: #{@employee_obj.try(:date_of_birth).try(:strftime,@date_format)}",  :at => [10, 250], :size => 12#, style: :bold
        draw_text "Employee Number: #{@employee_obj.try(:employee_number)}",  :at => [280, 270], :size => 12#, style: :bold
        draw_text "Father’s Name: #{@employee_obj.try(:father_name).try(:capitalize)}",  :at => [280, 250], :size => 12#, style: :bold
        address="Address: #{@employee_address.try(:address_line1).try(:capitalize)} #{@employee_address.try(:address_line2)} #{@employee_address.try(:street)} #{@employee_address.try(:landmark)} #{@employee_address.try(:city)} #{@employee_address.try(:state)}"
        draw_text "Mobile No: #{@employee_mobile_number.try(:phone_number)}",  :at => [280, 230], :size => 12#, style: :bold
        draw_text "Phone No: #{@employee_phone_number.try(:phone_number)}",  :at => [280, 210], :size => 12#, style: :bold
        
        [:shrink_to_fit].each_with_index do |mode, i|
          text_box address,:at =>[280, 200],
          :width => 210,
          :height => 110,
          :overflow => mode
        end
      end
    end
  

    bounding_box([0, y_position3], :width => 500, :height => 530) do
      start_new_page

      table_content
      booster_does_content
      allergy_content
      start_new_page
      health_test_content
      normal_detail_space
    end
  end

 
  def table_content
    table product_rows do
      row(0).font_style = :bold
      self.header = true
      #self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [180, 180,70,70]
    end
  end
 
  def product_rows
    move_down(25)
    text "Vaccinations Report:", :size => 12, style: :bold
    if @big_array.present?
      [['Immunization', 'Age Recommended','Due Date','Date']] +
      @big_array.map do |c|
        [c[0],c[1],c[2].try(:strftime,@date_format),c[3].try(:strftime,@date_format)]
      end
    else
      [['Immunization', 'Age Recommended','Due Date','Date']] +
      [['...','...','...','...']] 
    end
  end

  def allergy_content
    table allergy_rows do
      row(0).font_style = :bold
      self.header = true
      #self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [80,160,80,180]
    end
  end
 
  def allergy_rows
    move_down(25)
    text "Allergy Report:", :size => 12, style: :bold
    if @allergy.present?
      [['Allergy', 'What Happened','How Severe', 'Medication Details']] +
      @allergy.map do |c|
        [c.try(:name),c.try(:description),c.try(:status),c.try(:medication_detail)]
      end
    else
      [['Name','What Happened', 'How Severe', 'Medication Detail']] +
      [['...', '...', '...', '...']]
    end
  end

  def booster_does_content
    table booster_does_rows do
      row(0).font_style = :bold
      self.header = true
      #self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [180,180,70,70]
    end
  end
 
  def booster_does_rows
    move_down(25)
    text "Booster Doses Report:", :size => 12, style: :bold
    if @booster_big_array.present?
      [['Immunization', 'Frequency','Due Date','Date']] +
      @booster_big_array.map do |c|
        [c[0],c[1],c[2].try(:strftime,@date_format),c[3].try(:strftime,@date_format)]
      end
    else
      [['Immunization', 'Frequency','Due Date','Date']] +
      [['...','...','...','...']]
    end
  end

  # def health_test_content
  #   table health_test_rows do
  #     row(0).font_style = :bold
  #     self.header = true
  #     self.row_colors = ['DDDDDD', 'FFFFFF']
  #     self.column_widths = [100,90,80,80,150]
  #   end
  # end
 
  def health_test_content
    move_down(25)
    text "Health Report:", :size => 12, style: :bold
    widths = [130,90,60,70,150]
    cell_height = 10
    if @health_record_obj.present?
      @health_record_obj.each do |checkup_type_id|
        table([['Checkup Type', 'Particular','Normal','Result','Recommendation']], :column_widths => widths, :cell_style => { size: 11.5,:font_style => :bold})

        @checkup_particular_id = MgHealthTest.where(:mg_check_up_type_id=>checkup_type_id,:is_deleted=>0,:mg_student_id=>@student_id,:mg_batch_id=>@batch_id).pluck("DISTINCT mg_checkup_particular_id")
        if @checkup_particular_id.present?
          @checkup_particular_id.each do |particular_id|
            checkup_particular = MgCheckupParticular.where("id=? and is_deleted=? and show_in_healthcard=? and (applicable=? or applicable=?) ",particular_id,0,true,'student','both')
            if checkup_particular.present?
              last_health_obj = MgHealthTest.where(:mg_checkup_particular_id=>particular_id,:mg_student_id=>@student_id,:mg_batch_id=>@batch_id,:is_deleted=>0).last
              table([[ checkup_particular[0].try(:mg_checkup_type).try(:name),checkup_particular[0].try(:particulars),checkup_particular[0].try(:normal),last_health_obj.try(:result),last_health_obj.try(:recommendation)]], :column_widths => widths, :cell_style => { size: 13 }) 
            end
          end
          move_down(25)
        end
      end
    else
     table([['Checkup Type', 'Particular','Normal','Result','Recommendation']], :column_widths => widths, :cell_style => { size: 11.5,:font_style => :bold})
     table([["...","...","...","...","..."]], :column_widths => widths, :cell_style => { size: 13 }) 
    end
  end

  def normal_detail_space
    move_down(30)
    draw_text "Signature of Doctor.....................",  :at => [300, -20], :size => 10
    draw_text "Name of the Doctor.....................",  :at => [300, -40], :size => 10
    
    # bounding_box [bounds.left, bounds.bottom + 0], :width  => bounds.width do
    #   font "Helvetica"
    #   move_down(5)
    #   move_down 12
      
    #   draw_text "Signature of Doctor.....................",  :at => [300, 30], :size => 10
    #   draw_text "Name of the Doctor.....................",  :at => [300, 45], :size => 10
    # end
  end
  

  def product_rows_ee
    
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