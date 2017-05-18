class SelectedStudentList < Prawn::Document
  def initialize(session_id,students_id,mg_course_id,school,school_logo,date_format)
    super({:page_size => [595 ,842]})
    @session_id = session_id 
    @students_id=students_id
    @mg_course_id = mg_course_id
    @school = school
    @school_logo = school_logo
    @date_format = date_format

    @count=0
    logo
    #student_detail
    #student_image
    #table_content
    # footer
    
  end

  def logo 
    y_position = cursor - 0
    y_position1 = cursor - 15
    y_position2 = cursor - 90
    y_position3 = cursor - 110
    y_position4 = cursor - 140

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

    bounding_box([0, y_position3], :width => 270, :height => 300) do
      @course_name = MgCourse.where(:id=>@mg_course_id,:is_deleted=>0)
      text "Class Name: #{@course_name[0].course_name.capitalize}", :size => 12, style: :bold
      text "Date: #{Date.today.strftime(@date_format)}", :size => 12, style: :bold
    end

    bounding_box([0, y_position4], :width => 530, :height => 550) do
      table_content
    end
  end

  def table_content
    table product_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [50,190,165,105]
    end
  end
  def product_rows
    move_down(25)
    [['SR.No', 'Student Name','Guardian Name','Date of Birth']] +

    @students_id.split(",").map do |dd|
      @stu_obj = MgStudentAdmission.where(:id=>dd)
      [@count+=1,@stu_obj[0].try(:first_name)+" "+@stu_obj[0].try(:middle_name)+" "+@stu_obj[0].try(:last_name),@stu_obj[0].try(:guardian_name),@stu_obj[0].try(:date_of_birth).strftime(@date_format)]
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