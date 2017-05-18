class ReportPdf < Prawn::Document
  def initialize(student_name,exam_detail,course_name,school_logo,school,date_format,session_id)
    #super#({:page_size => [450, 380],:margin=>[25,25,25,25]})
    super({:page_size => [595 ,842]})
    @student_name = student_name
    @exam_detail = exam_detail
    @course_name = course_name
    @school_logo = school_logo
    @school = school
    @date_format = date_format
    @session_id = session_id

    logo
    #student_detail
    #table_content
    footer    
  end

    def logo  
    y_position = cursor + 13
    y_position1 = cursor - 5
    #repeat :all do
    
      bounding_box([0, y_position], :width => 270, :height => 300) do
        font "Helvetica"
        if File.exists?("#{Rails.root}/public/#{@school_logo}")
          image ("#{Rails.root}/public/#{@school_logo}"),:width=>60
        else
          image ("#{Rails.root}/app/assets/images/logo.jpg"),:width=>60   
        end 
      end    

      bounding_box([60, y_position1], :width => 330, :height => 300) do
        text @school.school_name, :align => :center, :size => 20,:inline_format => true
        move_down(18)
      
      stroke do
        stroke_horizontal_rule
        horizontal_line(-50, 460)
      end
    
      move_down(19)
      draw_text "Student Name: #{@student_name.first_name.capitalize} #{@student_name.middle_name.capitalize} #{@student_name.last_name.capitalize}", :at => [-40, cursor], :size => 12
      move_down(13)
      draw_text "Date of Birth: #{@student_name.date_of_birth.strftime(@date_format)}", :at => [-40, cursor], :size => 12
      move_down(13)
      draw_text "Class: #{@course_name.try(:course_name)} #{@batch_name.try(:name)}", :at => [-40, cursor], :size => 12
     
      stroke do
        rectangle [300, 245], 85, 85
      end
      move_down(45)
      bounding_box([-40, cursor], :width => 550, :height => 350) do
        move_down(0)
        table_content
      end
    #end
  end
  end

  def table_content
    table product_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [75, 75, 75,250]
    end
  end
 
  def product_rows
    move_down(25)
    @school = MgSchool.where(:id=>@session_id,:is_deleted=>0)
    [['Exam Date', 'Start Time', 'End Time','Venue']] +
    #@student_name.each do |product|
    if @school[0].is_test_center==true
      @vanue_name=MgEntranceExamVenue.where(:id=>@exam_detail.mg_entrance_exam_venue_id,:is_deleted=>0)
      [[@exam_detail.start_date.strftime(@date_format), @exam_detail.start_time.strftime("%l:%M%P"), @exam_detail.end_time.strftime("%l:%M%P"), @vanue_name[0].try(:institute_name)+","+@vanue_name[0].exam_venue]]
    elsif @school[0].is_test_center==false
      [[@exam_detail.start_date.strftime(@date_format), @exam_detail.start_time.strftime("%l:%M%P"), @exam_detail.end_time.strftime("%l:%M%P"), @school[0].try(:school_name)+","+@school[0].try(:address_line1)+' '+@school[0].try(:address_line2)+' '+@school[0].try(:street)+' '+@school[0].try(:landmark)+' '+@school[0].try(:city)+' '+@school[0].try(:state)+' '+@school[0].try(:pin_code).to_s]]
    end
    #end
  end

  def footer
    bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
      font "Helvetica"
      stroke_horizontal_rule
      
      
      move_down 17
      
      draw_text "Terms & Conditions| Privacy Policy| About Us| Contact Us Powered By - ©", :at => [0,3], :size => 14
      image "#{Rails.root}/app/assets/images/mindcom-logo.png", :at=>[460,15], :width => 55, :align => :right
    end
  end
end