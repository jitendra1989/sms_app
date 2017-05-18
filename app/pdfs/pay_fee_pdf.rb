class PayFeePdf < Prawn::Document
  def initialize(total_fee,fee_detail,student_name,mg_student,mg_course,mg_batch,school_logo,school,date_format)
    super({:page_size => [650, 580]})

   #:top_margin => 70,
    @total_fee = total_fee
    @fee_detail = fee_detail
    @student_name = student_name
    @mg_student = mg_student
    @mg_course = mg_course
    @mg_batch = mg_batch
    @school_logo = school_logo
    @school = school
    @date_format = date_format

    logo
    student_detail
    table_content
    footer      
  end

  def logo  
    bounding_box [bounds.left, bounds.top],:align => :right, :width  => bounds.width do
      font "Helvetica"
      if File.exists?("#{Rails.root}/public/#{@school_logo}")
          image ("#{Rails.root}/public/#{@school_logo}"),:width=>90
      end       
      text @school.school_name, :align => :center, :size => 30
      stroke_horizontal_rule
    end
    move_down 10
  end

  def student_detail     
     text "Payment Date : #{@student_name.updated_at.strftime(@date_format)}", :size => 12
     move_down 6
     text "Student Name : #{@student_name.first_name.capitalize} #{@student_name.middle_name.capitalize} #{@student_name.last_name.capitalize}", :size => 12
     move_down 2
     text "Date of Birth : #{@student_name.date_of_birth.strftime(@date_format)}", :size => 12
     move_down 2
     text "Admission Number : #{@mg_student[0].admission_number}", :size => 12
     move_down 2
     text "Semester & Section : #{@mg_course.course_name.capitalize} #{@mg_batch.name}", :size => 12
     move_down 15     
  end 

  def table_content
    table([['Fee Type', 'Description', 'Amount']]) do
      row(0).style :align => :center
      row(0).font_style = :bold           
      self.column_widths = [100, 100,100]
    end
    @fee_detail.each do |fee_detail|
      table([[fee_detail["name"],  fee_detail["description"], fee_detail["amount"]]],:row_colors => ['DDDDDD', 'FFFFFF'],:column_widths => [100,100,100])
    end
    table([['','Total Amount', @total_fee]],:column_widths => [100,100,100]) do
      row(0).font_style = :bold
    end
  end



  def footer
    bounding_box [bounds.left, bounds.bottom + 45], :width  => bounds.width do
      font "Helvetica"
      stroke_horizontal_rule
      move_down(5)
      
      move_down 12
      
      draw_text "Terms & Conditions| Privacy Policy| About Us| Contact Us       Powered By - ©", :at => [70,3]
      image "#{Rails.root}/app/assets/images/mindcom-logo.png", :at=>[495,15], :width => 45, :align => :right
    end
  end
end