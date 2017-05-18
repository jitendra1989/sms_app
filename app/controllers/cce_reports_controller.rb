class CceReportsController < ApplicationController
  
  layout "mindcom"
    before_filter :login_required

    def student_wise_report
      #@batches = MgBatch.active
      @batches = MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      #logger.info(@batches)
    #   @batch=MgBatch.where(:is_deleted=>0).pluck(:name,:id, :mg_course_id)
      # @course_batches=[]
      # @batch.each do|b|
      #   course_batch=[]
      #   course=MgCourse.where(:id=>b[2],:is_deleted=>0).pluck(:course_name)
      #   @data1=course[0]
      #   @data2=b[0]
      #   course_batch[0]="#{@data1}-#{@data2}"
      #   course_batch[1]=b[1]
      #   @course_batches.push(course_batch)
      # end
    
    end

    def section_wise_report

      @allTerms=MgCceExamCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name, :id)

    end


    def make_scholastic_report
   
  end


  def generate_report
    student_id=params[:id]
    student=MgStudent.find(student_id)
    batch_name=MgBatch.find(student.mg_batch_id)
    @@photo=student.avatar.url(:medium,:timestamp=>false)
    school=MgSchool.find(session[:current_user_school_id])

###########################
 fa1_marks_array=Array.new
student = MgStudent.find(params[:id])
  batch = MgBatch.find(student.mg_batch_id)
  exam_groups = MgExamGroup.where(:mg_batch_id=>batch.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  cce_category_ids = exam_groups.pluck(:cce_exam_category_id)
  overall_year = 0

   data_hash = Hash.new

exam_groups.each do |eg|
  exams_list = MgExam.where(:mg_exam_group_id=>eg.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  cce_category = MgCceExamCategory.find(eg.cce_exam_category_id)
  overall_total = 0
  overall_marks = 0

exams_list.each do|el|
  subject=MgSubject.find(el.mg_subject_id)
  fa_group_ids = MgFaGroupsSubject.where(:mg_subject_id=>subject.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_fa_group_id)
  fa_group_list = MgFaGroup.where(:id=>fa_group_ids,:mg_cce_exam_category_id=>cce_category.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  exam_score=MgExamScore.find_by(:mg_student_id=>params[:id],:mg_exam_id=>el.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  sa_score = if exam_score.present? then exam_score.marks else 0 end

  score_data = Array.new
  total_data = Array.new  
  sa_data=Array.new

    fa_group_list.each do |fg|

    fa_criteria_list = MgFaCriteria.where(:mg_fa_group_id=>fg.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    all_di = MgDescriptiveIndicator.where(:describable_type=>"FaCriteria", :mg_fa_criteria_id => fa_criteria_list.pluck(:id),:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    di_total = all_di.sum(:total_marks)
    all_asmts = MgAssessmentScore.where(:mg_student_id=>params[:id],:mg_descriptive_indicator_id=> all_di.pluck(:id),:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    mk_obt = all_asmts.sum(:marks_obtained)
    
    total_data.push(di_total)
    score_data.push(mk_obt)
  end
    total_data.push(el.maximum_marks)
    #score_data.push(sa_score)
    sa_data.push(sa_score)

    data_hash[subject.subject_name+"-total-"+cce_category.name]=total_data 
    data_hash[subject.subject_name+"-"+cce_category.name]=score_data 

    data_hash[subject.subject_name+"-sa-scores"+cce_category.name]=sa_data
  
  end 

    
  
end

 gradeLevelArray = MgGradingLevel.where(:mg_batch_id=>student.mg_batch_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('min_score DESC')
  

cce_category_array=Array.new
cce_category_name_array=Array.new

cce_category_array.push("")
exam_groups.each do |eg|
  cce_category = MgCceExamCategory.find(eg.cce_exam_category_id)
  cce_category_array << cce_category.name
  cce_category_name_array << cce_category.name
end
cce_category_array.push("Year")

  @@sid = session[:current_user_school_id]

#:page_size=>"EXECUTIVE"
    pdf = Prawn::Document.new(:page_layout => :landscape) do
 

   
       @@school_logo=school.logo.url(:medium,:timestamp=>false)

           repeat :all do
 # header#
                        bounding_box [bounds.left, bounds.top],:align => :right, :width  =>bounds.width  do
                          font "Helvetica"
                          if File.exists?("#{Rails.root}/public/#{@@school_logo}") 
                             image( "#{Rails.root}/public/#{@@school_logo}",:width =>  45)
                            # image ("#{Rails.root}/public/#{@@school_logo}"),:at=>[425,690],:width=>45
                            # image "#{Rails.root}/public/#{@@school_logo}", :width => 45, :align => :left
                          
                           end
                           move_up 15
                          text school.school_name, :align => :center, :size => 18
                          stroke_horizontal_rule
                         end
        move_down 10

        # footer
                        bounding_box [bounds.left, bounds.bottom + 5], :width  => bounds.width do
                            font "Helvetica"
              stroke_horizontal_rule
              move_down(5)
              # image "#{Rails.root}/app/assets/images/mindcom-logo.png", :width => 45, :align => :left
              # text " Powered By - ©", :size => 12
              move_down 10
              # draw_text "Terms & Conditions| Privacy Policy| About Us| Contact Us",:at => [70,3]
              draw_text "Powered By - ©", :at => [400,3]
              image "#{Rails.root}/app/assets/images/mindcom-logo.png", :at=>[495,15], :width => 45, :align => :right
                        end
                  end


    bounding_box([bounds.left, bounds.top - 60], :width  => bounds.width, :height => bounds.height - 55) do
      if File.exists?("#{Rails.root}/public/#{@@photo}")
        image ("#{Rails.root}/public/#{@@photo}"),:at=>[425,650],:width=>45
    end
       move_down 15      
        text "Name: #{student.first_name} #{student.last_name}" 
        text "Admission Number: #{student.admission_number}"
        text "Class & Section: #{batch_name.course_batch_name}"
        
        move_down 5

        widths=Array.new
        widths.push(56)

        @f=cce_category_name_array.length
      for i in 1...@f+1
        widths.push(188)
       end
       widths.push(92)
        # widths = [35,35,35,35]
        cell_height = 8
        font_size=8
        text "Scholastic"
       
        if exam_groups.present?
        table([cce_category_array],:column_widths => widths, :cell_style => { size: font_size }) 
        @width=Array.new
        @width.push(56)

@e=cce_category_name_array.length
for i in 1...@e+1
  @width.push(32,32,32,47,45)
end
  @width.push(49)
  @width.push(43)
font_size=10




@d=0
@c=cce_category_name_array.length
@@data_ary=Array.new
@@data_ary.push("subjects")
for i in 1...@c+1
  @@data_ary.push("#{"FA"}#{i+@d}")
  @@data_ary.push("#{"FA"}#{i+1+@d}")
  @@data_ary.push("#{"SA"}#{i}")
  @@data_ary.push("#{"Overall"}")
  @@data_ary.push("#{"Grade"}")
  
@d=@d+1
end
@@data_ary.push("Overall")
@@data_ary.push("Grade")

puts @@data_ary.inspect

  table([@@data_ary], :column_widths => @width, :cell_style => { size: font_size }) 



  exams_list = MgExam.where(:mg_exam_group_id=>exam_groups[0].id,:is_deleted=>0,:mg_school_id=>@@sid)
  exams_list.each do|el|
  subject=MgSubject.find(el.mg_subject_id)

  row_data  = Array.new
#<tr>
#<td><%=subject.subject_name%></td>
  row_data.push(subject.subject_name)

 overall_year =0
 exam_groups.each do |eg|
  cce_category = MgCceExamCategory.find(eg.cce_exam_category_id)
  marks_data = data_hash[subject.subject_name+"-"+cce_category.name]
  total_data = data_hash[subject.subject_name+"-total-"+cce_category.name]
  sa_marks_data=data_hash[subject.subject_name+"-sa-scores"+cce_category.name]

  fa_weightagies = MgCceWeightages.find_by(:criteria_type=>"fa",:mg_cce_exam_category_id=>cce_category.id,:is_deleted=>0,:mg_school_id=>@@sid)
  if fa_weightagies.present?
fa_weightage=fa_weightagies.weightages.to_f

else
  fa_weightage=0

end
  sa_weitghagies = MgCceWeightages.find_by(:criteria_type=>"sa",:mg_cce_exam_category_id=>cce_category.id,:is_deleted=>0,:mg_school_id=>@@sid)

if sa_weitghagies.present?
sa_weitghage=sa_weitghagies.weightages.to_f

else
  sa_weitghage=0

end

  if total_data.present?
    if total_data[0].present?
      fa1_total=total_data[0]
    else
      fa1_total=0
    end

    if total_data[1].present?
      fa2_total=total_data[1]
    else
      fa2_total=0
    end

    if total_data[2].present?
      sa1_total=total_data[2]
    else
      sa1_total=0
    end
  else
      fa1_total=0
      fa2_total=0
      sa1_total=0
  end

  # fa1_total = if total_data[0] then total_data[0] else 0 end
  # fa2_total = if total_data[1] then total_data[1] else 0 end
  # sa1_total = if total_data[2] then total_data[2] else 0 end

  term_denominator = (fa1_total*fa_weightage)+(fa2_total*fa_weightage)+(sa1_total*sa_weitghage)   


  if marks_data.present?
    if marks_data[0].present?
      fa1_marks=marks_data[0]
    else
      fa1_marks=0
    end

    if marks_data[1].present?
      fa2_marks=marks_data[1]
    else
      fa2_marks=0
    end

    if marks_data[2].present?
      sa1_marks=marks_data[2]
    else
      sa1_marks=0
    end
  else
      fa1_marks=0
      fa2_marks=0
      sa1_marks=0
  end

  # fa1_marks = if marks_data[0] then marks_data[0] else 0 end
  # fa2_marks = if marks_data[1] then marks_data[1] else 0 end
  # sa1_marks = if sa_marks_data[0] then sa_marks_data[0] else 0 end

  term_numerator= (fa1_marks*fa_weightage)+(fa2_marks*fa_weightage)+(sa1_marks*sa_weitghage)  

   term_percentage = 0
   if(term_denominator>0 && term_numerator>0)
     term_percentage = ((term_numerator/term_denominator)*100).to_i
   end  

   term_grade="z"
   
  gradeLevelArray.each do |gradeObj|
    term_grade = gradeObj.name
      if term_percentage > gradeObj.min_score
        term_grade = gradeObj.name
        break
      end
    end

   overall_year+=term_percentage


#<td><%=fa1_marks.to_i%></td>
#<td><%=fa2_marks.to_i%></td>
#<td><%=sa1_marks.to_i%></td>
#<td><%=term_percentage%></td>
#<td><%=term_grade%></td>
row_data.push(fa1_marks.to_i)
row_data.push(fa2_marks.to_i)
row_data.push(sa1_marks.to_i)
row_data.push(term_percentage)
row_data.push(term_grade)


  end


  grade="z"
  overall_year=(overall_year/2).to_i
  gradeLevelArray.each do |gradeObj|
    grade = gradeObj.name
      if overall_year > gradeObj.min_score
        grade = gradeObj.name
        break
      end
  end
row_data.push(overall_year)
row_data.push(grade)

#<td><%=overall_year%></td>
#<td><%=grade%></td>
#</tr>
font_size=8
table([row_data],:column_widths => @width, :cell_style => { size: font_size })

  end
 move_down 10
#</table>
else
  text "Exam was not conducted", size: 10
end




#<h4>Co-Scholastic</h4>

text "Co-Scholastic"

  batch = MgBatch.find(student.mg_batch_id)
  observation_group_ids = MgCourseObservationGroup.where(:mg_course_id=>batch.mg_course_id,:is_deleted=>0,:mg_school_id=>@@sid).pluck(:mg_observation_group_id)
  observation_groups = MgObservationGroup.where(:id=>observation_group_ids,:is_deleted=>0,:mg_school_id=>@@sid)
  observation_groups.each do |og|
    observations = MgObservation.where(:mg_observation_group_id=>og.id,:is_deleted=>0,:mg_school_id=>@@sid)



  #<table border="1">
  # <tr>
  # <td colspan="2"><%=og.name%></td>
  # </tr>
  # <tr>
  # <th>Descriptive Indicator</th>
  # <th>Grade</th>  
  # </tr>
  
  table([[og.name]],:column_widths => 300, :cell_style => { size: 10 })
  table([["Descriptive Indicator","Grade"]],:column_widths => [200,100], :cell_style => { size: 8 })

    observations.each do |ob|
      descriptive_indicators = MgDescriptiveIndicator.where(:describable_id=>ob.id,:is_deleted=>0,:mg_school_id=>@@sid)
      di_count = descriptive_indicators.count
      if di_count>0
      assesment_scores = MgAssessmentScore.where(:mg_student_id=>student.id,:mg_descriptive_indicator_id=>descriptive_indicators.pluck(:id),:is_deleted=>0,:mg_school_id=>@@sid)
      
      points_sum = 0

      assesment_scores.each do |asc|
        grade_id = asc.marks_obtained
        cce_grade = MgCceGrade.find(grade_id)
        @grade_set_id = cce_grade.mg_cce_grades_set_id
        points_sum+= cce_grade.grade_point
      end 

      final_points = points_sum/di_count

      gradeLevelArray = MgCceGrade.where(:mg_cce_grades_set_id=>@grade_set_id,:is_deleted=>0,:mg_school_id=>@@sid).order('grade_point DESC')

      di_grade = ""
      gradeLevelArray.each do |gradeObj|
        di_grade = gradeObj.name
          if final_points > gradeObj.grade_point
            di_grade = gradeObj.name
            break
          end
        end

  
  table([[ob.name,di_grade]],:column_widths => [200,100], :cell_style => { size: 8 })
 
  # <tr>
  #   <td><%=ob.name%></td>
  #   <td><%=di_grade%></td>
  # </tr> 

  end
    
  end 
move_down 10
#  </table>
 # <br/>

end
move_down 20
text("___________")
text "Class Teacher"#, ("Principal",)
move_up 20
text "_______",:align => :right
text "Principal",:align => :right






    end
               
                      
    end
            send_data pdf.render,   :info => {
                      :Title => "My title",
                      :Author => "John Doe",
                      :Subject => "My Subject",
                      :Keywords => "test metadata ruby pdf dry",
                      :Creator => "ACME Soft App",
                      :Producer => "Prawn",
                      :CreationDate => Time.now
                      }, :filename => "x.pdf", :type => "application/pdf", :disposition => 'inline'
  end
    





    def getStudentRecordFromBatchId

      batchId=params[:batchId]

      @studentRecord=MgStudent.where(:mg_batch_id=>batchId, :is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

      render :json => { :studentRecord => @studentRecord}

    end

    def cce_report
    # @studentId=params[:studentId]
    # @studentObj = MgStudent.find(@studentId)
    # @batchId = @studentObj.mg_batch_id

    # @examGroups = MgExamGroup.where(:mg_batch_id=>@batchId, :is_deleted=>0)

  #     render :layout => false


      @studentId=params[:studentId]
    @studentObj = MgStudent.find(@studentId)
    @batchId = @studentObj.mg_batch_id
    @batchObj = MgBatch.find(@batchId)
    logger.info(@batchId )
    @examGroups = MgExamGroup.where(:mg_batch_id=>@batchId, :is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

      render :layout => false


    end

end
