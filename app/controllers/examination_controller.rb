class ExaminationController < ApplicationController

  layout "mindcom"
    before_filter :login_required



def section_subjects
      #@batches = MgBatch.active.where(:mg_school_id=>session[:current_user_school_id])
       @school_id =  session[:current_user_school_id]
       @batches = MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       #puts @batches.inspect
       #logger.asd
    end


 def generated_report6

      @subjects=Array.new
    @batch_id=params[:mg_batch_id]
    @batchSubjects = MgBatchSubject.where(:mg_batch_id=>@batch_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @batchSubjects.each do |sub|
      @subject=MgSubject.find_by(:id=>sub.mg_subject_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @subjectArr=Array.new
      if @subject.present?
      @subjectArr.push(@subject.subject_name,@subject.id)
      @subjects.push(@subjectArr)
    end
  end
  # puts @batchSubjects.inspect
  # puts @subjects.inspect
  
  #logger.infoZXDJCD
      #@subject=MgBatchSubject.find_by(:mg_subject_id=>params[:mg_subject_id],:mg_batch_id=>params[:mg_batch_id])

      #@batch = @subject.mg_batch

      #@exam_groups = MgExamGroup.where(:mg_batch_id=>@batch.id)

      #@exam_groups = MgExamGroup.where(:mg_batch_id=>params[:mg_batch_id])
    end

def generate_pdf6

@@subjects=Array.new
    @@batch_id=params[:id]
    @batchSubjects = MgBatchSubject.where(:mg_batch_id=>@@batch_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @batchSubjects.each do |sub|
      @subject=MgSubject.find_by(:id=>sub.mg_subject_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @subjectArr=Array.new
      if @subject.present?
      @subjectArr.push(@subject.subject_name,@subject.id)
      @@subjects.push(@subjectArr)
    end
  end
school=MgSchool.find(session[:current_user_school_id])
 school_logo=school.logo.url(:medium,:timestamp=>false)


    pdf = Prawn::Document.new do

                  repeat :all do


                    # header
                       bounding_box [bounds.left, bounds.top],:align => :right, :width  => bounds.width do
                          font "Helvetica"
                          if File.exists?("#{Rails.root}/public/#{school_logo}") 
                             image( "#{Rails.root}/public/#{school_logo}",:width =>  45)
                            # image ("#{Rails.root}/public/#{@@school_logo}"),:at=>[425,690],:width=>45
                            # image "#{Rails.root}/public/#{@@school_logo}", :width => 45, :align => :left
                          
                           end
                           move_up 15
                          text school.school_name, :align => :center, :size => 18
                          stroke_horizontal_rule
                         end
        move_down 10
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
           
                         #move_down 25
        #widths=[56,188,188,92]
widths=[86,66,56,56]

        # widths = [35,35,35,35]
        cell_height = 8
        font_size=8
        @exam_groups = MgExamGroup.where(:mg_batch_id=>@@batch_id)
 @exam_groups.each do |exam_group| 
 text  exam_group.name 
  move_down(5)
    table([["Subjects","Highest", "lowest","Average"]], :column_widths => widths, :cell_style => { size: font_size })

total_max_marks=0
total_min_marks=0
total_avreage_marks=0
@@subjects.each do |sub|
      #table([[sub[0],"Highest", "lowest","Average"]], :column_widths => widths, :cell_style => { size: font_size })

      @subject=MgBatchSubject.find_by(:mg_subject_id=>sub[1],:mg_batch_id=>@@batch_id,:is_deleted=>0)

      puts "hsdkfhskdf"
      puts @subject.inspect
@subjectsId=MgSubject.find_by(:id=>@subject.mg_subject_id)

 @batch = @subject.mg_batch

@students = @batch.mg_students
#      <%#=@students.inspect%>
exam = MgExam.find_by(:mg_subject_id=>@subjectsId.id,:mg_exam_group_id=>exam_group.id)
 exam_score_max=MgExamScore.where(:mg_exam_id=>exam.id).pluck(:marks).max unless exam.nil?
 exam_score_min=MgExamScore.where(:mg_exam_id=>exam.id).pluck(:marks).min unless exam.nil?
 

  table([[sub[0],exam_score_max.present? ? exam_score_max : '-', exam_score_min.present? ? exam_score_min : '-',exam_group.subject_wise_batch_average_marks(@subjectsId.id).present? ? exam_group.subject_wise_batch_average_marks(@subjectsId.id) : '-']], :column_widths => widths, :cell_style => { size: font_size })

end

#@demodatas=""
      @exam_group = MgExamGroup.find( exam_group.id)
      # @batch = @exam_group.mg_batch
     # @students=@batch.mg_students.by_first_name
     @count=0
     @total_marks=Array.new
     @students.each do |stu|
      @student = MgStudent.find_by(:id=>stu.id)
      
     @total_marks_obtained=0
      
      @batch = @student.mg_batch
      @general_subjects = MgBatchSubject.where(@student.mg_batch.id)
      
      @exams = []
      @general_subjects.each do |sub|
         exam = MgExam.find_by(:mg_exam_group_id=>@exam_group.id,:mg_subject_id=>sub.id)
        @exams.push exam unless exam.nil?

     end

      exam_score = [] 
     @exams.each do |exam| 


exam_score.push exam.mg_exam_scores.find_by(:mg_student_id=>@student.id) unless exam.mg_exam_scores.find_by(:mg_student_id=>@student.id).nil?

 end

 exam_score.each do |es|
es.mg_exam.mg_subject.subject_name

 marks_obtained=es.marks.to_f 
 #maximum_marks=es.mg_exam.maximum_marks.to_f 
 puts "ajfhkshdkhfkskhdfkks"
 puts marks_obtained.inspect
 if es.marks.present?
  @total_marks_obtained +=es.marks.to_f
  end

end
 @count +=1
@total_marks.push(@total_marks_obtained)
end
@max_element=@total_marks.max{ |a,b| a.to_f <=> b.to_f }
@min_element=@total_marks.min{ |a,b| a.to_f <=> b.to_f }


table([["Total",@max_element, @min_element,((@total_marks.inject{|sum,x| sum + x })/@count).round(2)]], :column_widths => widths, :cell_style => { size: font_size })

end
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








    def exam_wise_reports
      #@batches = MgBatch.active
      @batches = MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

      logger.info(@batches)
      #logger.inffj
    @exam_groups = []
    end
def list_exam_types
  batch = MgBatch.find(params[:mg_batch_id])
   logger.info(batch.inspect)
   
    @exam_groups = MgExamGroup.where(:mg_batch_id=>batch.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    #render(:update) do |page|
      #page.replace_html 'exam-group-select', :partial=>'exam_group_select'
   #end
   render :layout=>false
end
def list_batch_groups
  
      @batch_groups = MgBatchGroup.where(:mg_course_id=>params[:mg_course_id]).pluck(:name,:id)
     render :layout=>false
        
    
end


def generate_reports
    if request.post?
      unless !params[:mg_course_id]==""
        @course = MgCourse.find(params[:mg_course_id])
        if @course.has_batch_groups_with_active_batches
          unless !params[:mg_batch_group_id]==""
            @batch_group = MgBatchGroup.find(params[:mg_batch_group_id])
            @batches = @batch_group.mg_batches
          end
        else
          @batches = @course.active_batches
        end
      end
      if @batches
        @batches.each do|batch|
         
          batch.generate_batch_reports
        end
       flash[:notice]="Report generation in queue for batches #{@batches.collect(&:full_name).join(", ")}. <a href='/scheduled_jobs/Batch/1'>Click Here</a> to view the scheduled job."

      else
        flash[:notice]="#{t('flash11')}"
        return
      end
    end
  end
def generated_report
  
   if params[:id].nil? 
    puts "i am in if1"
      if params[:mg_batch_id].empty? or params[:mg_exam_group_id].empty?
         puts "i am in if1"
        flash[:notice] = "Duplicate Record is present "
        redirect_to :action=>'exam_wise_reports' and return
      end
    end
   logger.info params[:mg_exam_group_id]
   logger.info params[:mg_batch_id]


if params[:id].nil?
      @exam_group = MgExamGroup.find(params[:mg_exam_group_id])
      @batch = @exam_group.mg_batch
      @students=@batch.mg_students.by_first_name
      @student = @students.first  unless @students.empty?
      logger.info(@student.inspect)
      #logger.infodfsd
      @examgroupIds=""
      @demodatas=1
      # if @student.nil?
      #   flash[:notice] = "#{t('flash_student_notice')}"
      #   redirect_to :action => 'exam_wise_report' and return
      # end
       @general_subjects = MgBatchSubject.where(@batch.id)
       @exams = []
        @general_subjects.each do |sub|
         exam = MgExam.find_by(:mg_exam_group_id=>@exam_group.id,:mg_subject_id=>sub.id)
         logger.info(exam.inspect)
         @exams.push exam unless exam.nil?
         @exams.inspect
        #@exams.dkcf 
       end

     else
    
  #@demo=params[:studentID]
  #@ids=@demo.split("-")
   @studentIds=params[:student_id]
   @examgroupIds=params[:groupID]
  


      @demodatas=""
      @exam_group = MgExamGroup.find( @examgroupIds)
      # @batch = @exam_group.mg_batch
     # @students=@batch.mg_students.by_first_name
      @student = MgStudent.find_by(:id=>@studentIds)
      
     
      @batch = @student.mg_batch
      @general_subjects = MgBatchSubject.where(@student.mg_batch.id)
      # student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@student.batch.id}")
      # elective_subjects = []
      # student_electives.each do |elect|
      #   elective_subjects.push Subject.find(elect.subject_id)
      # end
      #@subjects = general_subjects + elective_subjects
      @exams = []
      @general_subjects.each do |sub|
         exam = MgExam.find_by(:mg_exam_group_id=>@exam_group.id,:mg_subject_id=>sub.id)
        @exams.push exam unless exam.nil?
         #@students = Student.find(studentIds)

      end
      render :layout=>false
      end
 
  end
def generate_pdf

    ids=params[:id]
    @Id=ids.split("-")
    @studentIds=@Id[0]
   @examgroupIds=@Id[1]
  


      @demodatas=""
      @@exam_group = MgExamGroup.find( @examgroupIds)
      # @batch = @exam_group.mg_batch
     # @students=@batch.mg_students.by_first_name
      @student = MgStudent.find_by(:id=>@studentIds)
      
     
    #@@class_average_marks= @exam_group.batch_average_marks('marks').to_f
     #puts "jayanth"
     #puts @@class_average_marks.inspect
    

     
     #logger.infozxjgdjzgj

      @batch = @student.mg_batch
      @general_subjects = MgBatchSubject.where(@student.mg_batch.id)
      # student_electives = StudentsSubject.find_all_by_student_id(@student.id,:conditions=>"batch_id = #{@student.batch.id}")
      # elective_subjects = []
      # student_electives.each do |elect|
      #   elective_subjects.push Subject.find(elect.subject_id)
      # end
      #@subjects = general_subjects + elective_subjects
      @exams = []
      @general_subjects.each do |sub|
         exam = MgExam.find_by(:mg_exam_group_id=>@@exam_group.id,:mg_subject_id=>sub.id)
        @exams.push exam unless exam.nil?

     end


exam_score = [] 

@exams.each do |exam| 


exam_score.push exam.mg_exam_scores.find_by(:mg_student_id=>@student.id) unless exam.mg_exam_scores.find_by(:mg_student_id=>@student.id).nil?

 end

 total_credits=0 
   total_weighted_marks=0 

   @name="#{@student.first_name} - #{@student.admission_number}"
   puts @name.inspect
   #logger.infoJDGja
    
    total_max_marks = 0
 
    
    total_marks_obtained=0.0
    total_percentage=0.0
    max_marks=0
    count=0
    total_max_marks = 0


 school=MgSchool.find(session[:current_user_school_id])
 school_logo=school.logo.url(:medium,:timestamp=>false)

 student=MgStudent.find(@studentIds)
 @@photo=student.avatar.url(:medium,:timestamp=>false)

    pdf = Prawn::Document.new do
       repeat :all do


                    # header
                       bounding_box [bounds.left, bounds.top],:align => :right, :width  => bounds.width do
                          font "Helvetica"
                          if File.exists?("#{Rails.root}/public/#{school_logo}") 
                             image( "#{Rails.root}/public/#{school_logo}",:width =>  45)
                            # image ("#{Rails.root}/public/#{@@school_logo}"),:at=>[425,690],:width=>45
                            # image "#{Rails.root}/public/#{@@school_logo}", :width => 45, :align => :left
                          
                           end
                           move_up 15
                          text school.school_name, :align => :center, :size => 18
                          stroke_horizontal_rule
                         end
        move_down 10
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
    if ("#{Rails.root}/public/#{@@photo}").present?
        image ("#{Rails.root}/public/#{@@photo}"),:at=>[405,670],:width=>45
    end


move_down 15      
        text "Name: #{student.first_name} #{student.last_name}" 
        text "Admission Number: #{student.admission_number}"
        #text "Class & Section: #{batch_name.course_batch_name}"
        
        move_down 45
        #widths=[56,188,188,92]
widths=[86,66,56,56,56]

        # widths = [35,35,35,35]
        cell_height = 8
        font_size=8
  
 
  table([["Subjects","Marks Obtained", "Max Marks","Grade","Percentage"]], :column_widths => widths, :cell_style => { size: font_size },:row_colors => ["ddddde", "FFFFFF"],:position => :center) 
   exam_score.each do |es|


table([[es.mg_exam.mg_subject.subject_name,es.marks.present? ? marks_obtained=es.marks.to_f : '-',es.marks.present? ? maximum_marks=es.mg_exam.maximum_marks.to_f : '-' ,es.mg_grading_level.present? ? es.mg_grading_level.name : "-",es.marks.present? ? percentage=((es.marks.to_f/es.mg_exam.maximum_marks.to_f)*100).round(2) : '-']],:column_widths => widths,:cell_style => { size: font_size },:row_colors => ["ddddde", "FFFFFF"],:position => :center) 
total_max_marks = total_max_marks+es.mg_exam.maximum_marks
if es.marks.present?
            total_marks_obtained +=es.marks.to_f
            total_percentage +=percentage.to_f
            max_marks +=maximum_marks 
            count +=1
          end
end
@@class_average_marks=@@exam_group.batch_average_marks('marks') unless total_max_marks == 0
@@class_average=((@@exam_group.batch_average_marks('marks')*100/total_max_marks)).round(2) unless total_max_marks == 0 
widt=[320]
table([[""]],:column_widths => widt, :cell_style => { size: font_size },:position => :center)
table([["Total Marks",total_marks_obtained,max_marks,"-",(total_percentage/count).round(2)]], :column_widths => widths, :cell_style => { size: font_size },:row_colors => ["ddddde", "FFFFFF"],:position => :center) 

#table([[@@class_average_marks]])
table([["Class Average Marks:#{@@class_average_marks}|Class Average %:#{@@class_average}"]],:column_widths => widt, :cell_style => { size: font_size },:row_colors => ["ddddde", "FFFFFF"],:position => :center) 

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



  
def consolidated_exam_report
    @exam_group = MgExamGroup.find(params[:id])
    @batch = @exam_group.mg_batch
  end
def subject_wise_report
    @batches = MgBatch.active
    @subjects = []
  end

  def list_subjects
   @subjects=Array.new

    @batchSubjects = MgBatchSubject.where(:mg_batch_id=>params[:mg_batch_id])
    @batchSubjects.each do |sub|
      @subject=MgSubject.find_by(:id=>sub.mg_subject_id)
      @subjectArr=Array.new
      @subjectArr.push(@subject.subject_name,@subject.id)
      @subjects.push(@subjectArr)
  end
  render :layout=>false
  end

  def generated_report2
    #subject-wise-report-for-batch
    unless params[:mg_subject_id] == ""
      
      @subject=MgBatchSubject.find_by(:mg_subject_id=>params[:mg_subject_id],:mg_batch_id=>params[:mg_batch_id])
      @subjects=MgSubject.find(@subject.mg_subject_id)

      @batch = @subject.mg_batch
      @students = @batch.mg_students
      @exam_groups = MgExamGroup.where(:mg_batch_id=>@batch.id)
    else
      flash[:notice] = "enter the subject"
      redirect_to :action=>'subject_wise_report'
    end
  end

  def subject_rank
    @batches = MgBatch.active
    @subjects = []
  end

  def list_batch_subjects
    @subjects=Array.new

    @batchSubjects = MgBatchSubject.where(:mg_batch_id=>params[:mg_batch_id])
    @batchSubjects.each do |sub|
      @subject=MgSubject.find_by(:id=>sub.mg_subject_id)
      @subjectArr=Array.new
      @subjectArr.push(@subject.subject_name,@subject.id)
      @subjects.push(@subjectArr)
  end
  render :layout=>false
end

  def student_subject_rank
    unless params[:mg_subject_id] == ""

      @subject=MgBatchSubject.find_by(:mg_subject_id=>params[:mg_subject_id],:mg_batch_id=>params[:mg_batch_id])
      @individualSubject=MgSubject.find_by(:id=>@subject.mg_subject_id)
      @batch=@subject.mg_batch
      @students=@batch.mg_students.by_first_name
      @exam_groups=MgExamGroup.where(:mg_batch_id=>@batch.id)
    else
      flash[:notice] = "select the subject"
      redirect_to :action=>'subject_rank'
    end
  end

  def batchWise_rank
     @batches = MgBatch.active
  end
def batch_wise_student_rank

  if params[:mg_batch_id].empty?
      flash[:notice] = "Select A Batch To Continue"
      redirect_to :action=>'batchWise_rank' and return
    else
      @batch = MgBatch.find(params[:mg_batch_id])
      @students = MgStudent.where(:mg_batch_id=>@batch.id)
      @grouped_exams = MgGroupedExam.where(:mg_batch_id=>@batch.id)
      @ranked_students = @batch.find_batch_rank
    end
end

  def index
  end


  def new

          @bachid=params[:id]

 
          if @bachid!=nil

  @batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id, :mg_course_id)
  @course_batches=[]
  @batch.each do|b|
 course_batch=[]
course=MgCourse.where(:id=>b[2],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name)
    @data1=course[0]
    @data2=b[0]
    combineCourseBatch=#{@data1}-#{@data2},#{b[1]}
    puts combineCourseBatch
    course_batch[0]="#{@data1}-#{@data2}"

    course_batch[1]=b[1]

    @course_batches.push(course_batch)

  end
  @grade=MgGradingLevel.new()

else
logger.info("new mwthod2")
  @batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id, :mg_course_id)
  @course_batches=[]
  @batch.each do|b|
 course_batch=[]
    course=MgCourse.where(:id=>b[2],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name)
    @data1=course[0]
    @data2=b[0]
    combineCourseBatch=#{@data1}-#{@data2},#{b[1]}
    puts combineCourseBatch
    course_batch[0]="#{@data1}-#{@data2}"
    course_batch[1]=b[1]
    @course_batches.push(course_batch)

  end
  puts @course_batches.inspect
  @grade=MgGradingLevel.new()


end

  end

   def ranking_new
    @Id=params[:id]
  @course=MgCourse.pluck(:course_name,:id)
  end

  def add_grades
#adding to hidden value
  @batchId=params[:batch_id]
  logger.info(@batchId)
  render :layout=>false
  end  


  def ranking_newdata
  @courseId=params[:mg_course_id]
  render :layout=>false
  @rankingData=MgRankingLevels.where(:mg_course_id=>params[:mg_course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  logger.info(@data)
  end


  def ranking_create
  priority=params[:priority]
  @rankingData=MgRankingLevels.new(ranking_params)
  @rankingData.save  
   @ids=@rankingData.mg_course_id
  redirect_to :action=>'ranking_new',:id=>@ids
  end


  def ranking_edit
    
  @rankings=MgRankingLevels.find(params[:id])
  logger.info(@rankings.inspect)
  render :layout=>false
  end


  def ranking_update
  @rankings=MgRankingLevels.find(params[:id])
   @id=@rankings.mg_course_id
  logger.info(@rankings.inspect)
  @rankings.update(ranking_update_params)
  redirect_to :action=>'ranking_new',:id=>@id
  end


def ranking_destroy
  @rankings=MgRankingLevels.find(params[:id])
  @rankings.is_deleted =1
  @rankings.save
  @id=@rankings.mg_course_id
 redirect_to :action=>'ranking_new',:id=>@id
  end


  def add_new_grade

    puts "Create Here step -hello- 1"
    @grade=MgGradingLevel.new(grade_params)
    
    
    @grade.save
    @ids=@grade.mg_batch_id
        puts "Create Here step --2"
          puts "new method============"
 redirect_to :action=>'new', :id=>@ids

  end

  def show
   # puts "show method============"
if params[:mg_batch_id] == ""


@grades=MgGradingLevel.where(:mg_batch_id=>nil,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order("min_score  DESC")
render :json => {:name => @grades }
else
#logger.info params[:mg_batch_id]
logger.info("i am in else condition")
@grades=MgGradingLevel.where(:mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order("min_score DESC")  
render :json => {:name => @grades }
  end
    #render :layout=>false
  end
  

  def edit
@grades=MgGradingLevel.find(params[:id])



@id=@grades.id
render :layout=>false
  end

  def update
 @grades=MgGradingLevel.find(params[:id])
@ids=@grades.mg_batch_id
 @grades.update(update_params)
 redirect_to :action=>'new',:id=>@ids
  end

  def destroy
@grades=MgGradingLevel.find(params[:id])
@grades.is_deleted =1
@grades.save
@ids=@grades.mg_batch_id

redirect_to :action=>'new',:id=>@ids
  end


  def designation_new
     @Id=params[:id]
@course=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
  end
  

  def designation_newData  
@courseId=params[:mg_course_id]
@designationData=MgClassDesignation.where(:mg_course_id=>params[:mg_course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
render :layout=>false
  end


  def designation_create
@designationData=MgClassDesignation.new(designation_params)
@designationData.save
@id=@designationData.mg_course_id
redirect_to :action=>'designation_new',:id=>@id
  end  


  def designation_edit
@designations=MgClassDesignation.find(params[:id])
render :layout=>false

  end


  def designation_update
@designations=MgClassDesignation.find(params[:id])
@designations.update(update_designation_params)
@id=@designations.mg_course_id
redirect_to :action=>'designation_new',:id=>@id
  end


  def designation_destroy
@designations=MgClassDesignation.find(params[:id])
@designations.is_deleted =1
@designations.save
@id=@designations.mg_course_id
redirect_to :action=>'designation_new',:id=>@id
  end  

def exammanagement_index
@course=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
end


def exammanagement_new

@course=MgCourse.where(:id=>params[:mg_course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
logger.info @course.inspect
@batch=MgBatch.where(:mg_course_id=>params[:mg_course_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
logger.info @batch.inspect
render :layout=>false
end  

def exammanagement_newLink
@id=params[:id]
@examData=MgExamGroup.where(:mg_batch_id=>@id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end

def exammanagement_addnewdata
@id=params[:id]
puts "step ---2"
puts @id
end

def exammanagement_newcreate
   
   
@data=MgExamGroup.new(exammanagement_params)

@id=@data.mg_batch_id

@data.save

  @ids=@data.id

count=params[:count]
@custFieldNameIds =params[:data_field]
puts @custFieldNameIds.inspect


 for j in 0...count.to_i
  j=j+1
  @custFieldValObj = params[:"data_field_#{j}"]
  logger.info(@custFieldValObj.inspect)
  mg_subject_id=@custFieldValObj[0]
  max_score=@custFieldValObj[1]
  min_score=@custFieldValObj[2]
  start_date=@custFieldValObj[3]
  end_date=@custFieldValObj[4]


  @saveExam=MgExam.new(:maximum_marks=>max_score,:minimum_marks=>min_score,
       :start_time=>start_date,:end_time=>end_date,:mg_exam_group_id=>@ids,:mg_subject_id=>mg_subject_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  @saveExam.save

 end



redirect_to :controller=>'examination',:action=>'exammanagement_newLink',:id=>@id
end

def exammanagement_examGroups
  @examgroup=params[:id]
   @demo=@examgroup.split("-")
  @examgroupids=@demo[0]
  
  @category_id=@demo[1] 

  @groupData=MgExam.where(:mg_exam_group_id=>@examgroupids,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end

def exammanagement_examGroupsNew
  @examgroupid=params[:id]
  @category_id=params[:CategoryId]

  
 @subject=MgSubject.pluck(:subject_name,:id)
render :layout=>false
end
def exammanagement_examGroupsCreate
  @examGroupData=MgExam.new(exammanagementeExamGroupsNew)
   id=params[:category_id]
  @examGroupData.mg_school_id=session[:current_user_school_id]
  @ids=@examGroupData.mg_exam_group_id
@id="#{@ids}-#{id}"
puts @id

  @examGroupData.save
  

redirect_to :action=>'exammanagement_examGroups',:id=>@id
end
def exammanagement_examGroupsEdit
  @ExamsGroups=MgExam.find(params[:id])
  @category_id=params[:category_id]
   @subject=MgSubject.pluck(:subject_name,:id)
  render :layout=>false
end
def exammanagement_examGroupsUpdate
  @groupData=MgExam.find(params[:id])
  category_id=params[:category_id]
  @ids=@groupData.mg_exam_group_id
  @id="#{@ids}-#{category_id}"
  @groupData.update(exammanagementeExamUpdateGroupsNew)
redirect_to :action=>'exammanagement_examGroups',:id=>@id

end
def exammanagement_examGroupsDestroy
  @groupSets=MgExam.find(params[:id])
  category_id=params[:category_id]

  @ids=@groupSets.mg_exam_group_id
  @groupSets.is_deleted =1
  @groupSets.save
  @id="#{@ids}-#{category_id}"
redirect_to :action=>'exammanagement_examGroups',:id=>@id

end


def exammanagement_resultEntryIndex
  @examsId=params[:id]


  logger.info(@examsId.inspect)
  @demo=@examsId.split("-")
@examId=@demo[0]
puts @examId
@sub_id=@demo[1] 
puts @sub_id
@category_id=@demo[2] 
@marks=Array.new
@remarks=Array.new
@grades=Array.new
  @data=MgExamScore.where(:mg_exam_id=>@examId,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @data.each do |scores|
      @marks.push(scores.marks)
      @remarks.push(scores.remarks)
      @id=scores.mg_grading_level_id
      if(!@id.nil?)
        @grade=MgGradingLevel.find_by(:id=>@id)
        if(!@grade.nil?)
        @grades.push(@grade.name)
      end
    end
  end
logger.info("================")

logger.info(@examId)

  @mgExamObj=MgExam.find_by(:id=>@examId)
  #@mgExamObj=MgExam.find(@examId)
  logger.info(@mgExamObj.inspect)

  #@mgExamGroupObj=MgExamGroup.where(:id=>@mgExamObj[0].mg_exam_group_id,:is_deleted=>0)
    @mgExamGroupObj=MgExamGroup.where(:id=>@mgExamObj.mg_exam_group_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  #@batchId = @mgExamGroupObj[0].mg_batch_id
  @batchId = @mgExamGroupObj[0].mg_batch_id
  #logger.info(@batchId)
   @studentObj = MgStudent.where(:mg_batch_id=>@batchId,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  @batchdata=MgBatch.find(@batchId)
  @course_id=@batchdata.mg_course_id
  #logger.info("========1========")
   #logger.info(@course_id)
  @id=MgCourse.find(@course_id)
  #logger.info("=========2=======")
  #logger.info(@id.grading_type)

  #jayanth
  #@grade_type=@id.grading_type
  

end

def setGradeFromMarks
  @marks = params[:marks]
  @batchId = params[:batchId]

  @gradeLevelArray = MgGradingLevel.where(:mg_batch_id=>@batchId,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('min_score DESC')
  @gradeLevel 
  @gradeLevelId

  @gradeLevelArray.each do |gradeObj|
      if @marks.to_f > gradeObj.min_score
        @gradeLevel = gradeObj.name
        @gradeLevelId = gradeObj.id

        break
      end
  end
 render :json => { :gradeLevel => @gradeLevel, :gradeLevelId => @gradeLevelId}

end


def exam_result_entry_create
    @examId = params[:exam_id]
    @marksArray = params[:marks]
    @remarksArray = params[:remarks]
    @studentIdArray = params[:studentIds]
    @gradeIdArray = params[:graging_level_id]
    @category_id=params[:category_id]
    @sub_id=params[:sub_id]


    for i in 0...@marksArray.size
      marks = @marksArray[i]
      remarks = @remarksArray[i]
      studentId = @studentIdArray[i]
      gradeId = @gradeIdArray[i]

      @examScoreObj = MgExamScore.new(:mg_student_id=>studentId,:mg_exam_id=>@examId,
        :marks=>marks,:mg_grading_level_id=>gradeId,:remarks=>remarks,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @examScoreObj.save

      @id="#{@examId}-#{@sub_id}-#{@category_id}"

    end
    redirect_to :action=>'exammanagement_resultEntryIndex',:id=>@id

end

def exammanagement_resultEntryDataIndex
  @ids=params[:id]


  @demo=@ids.split("-")
@subID=@demo[0]
@exam_id=@demo[1] 
@category_id=@demo[2] 
puts "asdjlj"
puts @subID
puts @exam_id


@groupData=MgFaGroupsSubject.where(:mg_subject_id=>@subID,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

@value=Array.new
@groupData.each do|data|
  @value.push(data.mg_fa_group_id)
end


end
def exammanagement_resultEntryShow
    @id=params[:id]
    puts @id

@demo=@id.split("-")
@faGroupid=@demo[0]
@exam_id=@demo[1] 
@sub_id=@demo[2]
@category_id=@demo[3]
@studentId=@demo[4]
puts "hellllooo"
puts @studentId

#logger.infoasjd
puts @category_id

puts @faGroupid
puts @exam_id


   @faGroupData=MgFaCriteria.where(:mg_fa_group_id=>@faGroupid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  @observationDatas=MgExam.find(@exam_id)

  @id=@observationDatas.mg_exam_group_id
  @list=MgExamGroup.find(@id)
        @batchID=@list.mg_batch_id

    @studentdata=MgStudent.where(:mg_batch_id=>@batchID,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
 #@indicators=MgDescriptiveIndicator.where(:describable_id=> @ids,:is_deleted=>0,:describable_type=>"Observation")
render :layout=>false

end
def exammanagement_resultEntryCreate
  sub_id=params[:id]

    category_ids=params[:category_id]
    
    
    
 mg_student_id=params[:exams][:mg_student_id]

 
  mg_batch_id=params[:exams][:mg_batch_id]
  exam_id=params[:exams][:mg_exam_id]

  @grade=params[:mg_grade_id]
 # console.log(@grade.inspect)
 puts @grade.inspect
  @descriptiveIndicator=params[:assaignData]




  for i in 0...@grade.size

      descriptive=@descriptiveIndicator[i]
      gradePoint=@grade[i]

      @assessmentScoreObj=MgAssessmentScore.where(:mg_student_id=>mg_student_id,:mg_batch_id=>mg_batch_id,:mg_descriptive_indicator_id=>descriptive,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

      puts "@assessmentScoreObj"
      puts @assessmentScoreObj.inspect
      if @assessmentScoreObj.size>0

         puts "inside if"
         @assessmentScoreObj[0].update(:marks_obtained=>gradePoint)
      else   
      
      #descriptive=@descriptiveIndicator[i]
      if gradePoint!=""

       @assesmentData=MgAssessmentScore.new(:mg_student_id=>mg_student_id,:marks_obtained=>gradePoint,
          :mg_batch_id=>mg_batch_id,:mg_descriptive_indicator_id=>descriptive,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        
      @assesmentData.save
    end

      end
  end

       logger.info("=========================")
     
      @idParam =  "#{sub_id}-#{exam_id}-#{category_ids}"
      redirect_to :action=>'exammanagement_resultEntryDataIndex',:id=>@idParam

end






def exammanagement_destroy
@id=params[:id]
@demo=@id.split("-")
@eid=@demo[0]
@batch_id=@demo[1] 

@examinations=MgExamGroup.find(@eid)
@examinations.is_deleted =1
@examinations.save

redirect_to :controller=>'examination',:action=>'exammanagement_newLink',:id=>@batch_id

end
def exammanagement_coScholasticResultEntry
  @id=params[:id]

  @observations=MgObservationGroup.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

end
def exammanagement_coScholasticGradeEntry
  @id=params[:id]
@demo=@id.split("-")
@eid=@demo[0]
@batch_id=@demo[1] 
@student_id=@demo[2] 
logger.info(@student_id)


logger.info("=================")
logger.info(@batch_id)
logger.info(@eid)
  @observationDatas=MgObservation.where(:mg_observation_group_id=>@eid,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  logger.info(@observationDatas.inspect)
  @student_list=MgStudent.where(:mg_batch_id=>@batch_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
 #@indicators=MgDescriptiveIndicator.where(:describable_id=> @ids,:is_deleted=>0,:describable_type=>"Observation")
render :layout=>false
end

def exammanagement_saveCoScholasticGradeEntry



  mg_student_id=params[:exams][:mg_student_id]
  mg_batch_id=params[:exams][:mg_batch_id]

  @grade=params[:mg_grade_id]
  logger.info("===================hello==================")
  logger.info(@grade.inspect)

  @descriptiveIndicator=params[:assaignData]
  #@descriptiveIndicator.each do |data|
  logger.info("=====================================")
  logger.info(@grade.size)
     for i in 0...@descriptiveIndicator.size
descriptive=@descriptiveIndicator[i]
gradePoint=@grade[i]
@assessmentScoreObj=MgAssessmentScore.where(:mg_student_id=>mg_student_id,:mg_batch_id=>mg_batch_id,:mg_descriptive_indicator_id=>descriptive,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

      puts "@assessmentScoreObj"
      puts @assessmentScoreObj.inspect
      if @assessmentScoreObj.size>0

         puts "inside if"
         @assessmentScoreObj[0].update(:marks_obtained=>gradePoint)
      else   

     if gradePoint!=""

    @assesmentData=MgAssessmentScore.new(:mg_student_id=>mg_student_id,:marks_obtained=>gradePoint,
      :mg_batch_id=>mg_batch_id,:mg_descriptive_indicator_id=>descriptive,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       @assesmentData.save

     end
   end
 end
       redirect_to :action=>'exammanagement_coScholasticResultEntry',:id=>mg_batch_id
end

def exammanagement_connectExamData
          @id=params[:id]
  @examinations=MgExamGroup.where(:mg_batch_id => params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]) 
              @IDS=Array.new
              @examinations.each do |a|
               @IDS.push(a.id)
              end

          @alldata=MgGroupedExam.where(:mg_batch_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          @ID=Array.new
          @alldata.each do |value|
            @demo=value.mg_exam_group_id
            @ID.push(@demo)
          end


end

def connect_Exam_create 

  totalcheckbox=params[:full_course]
 #@data=MgGroupedExam.new(connectexammanagementeExam)
 @data=params[:mg_batch_id]
 logger.info("=====================================")
 @batch=@data.to_i
 logger.info(@batch)
 logger.info(@data)

    #@ids=@data.mg_batch_id
  @weightages=params[:Value]

   @demo=@weightages.split(",")
  logger.info(@demo.size)
 @demodata=Array.new
   for i in 0...@demo.size 
    
      @demodata.push(@demo[i])
     end
     logger.info(@demodata)

  # end
  # logger.info(@demodata.inspect)  #@weight=@weightages.to_f
  
  logger.info(@weightages[0])
  allWeightage=params[:allWeightage]
  @cid=params[:checked]

 @checked=@cid.split(",")
 logger.info(@checked)


  if allWeightage.to_i<=100

#for i in 0...totalcheckbox.size
 for i in 0...@checked.size
#logger.info(@checked[i])
  @checked_weekday=MgGroupedExam.where(:mg_batch_id=>@batch,:mg_exam_group_id=>@checked[i])
       puts "inside checked for"
       if @checked_weekday.size<1
         puts "inside checked for"
  #@datas=MgGroupedExam.new()
   @checked_r=MgGroupedExam.new()
    @checked_r.mg_batch_id=@batch
    logger.info(@checked[i])
  @checked_r.mg_exam_group_id=@checked[i]
  @checked_r.weightage=@demodata[i].to_f
   @checked_r.is_deleted=0
 @checked_r.save
 else
      puts "inside checked else"
        @checked_weekday[0].update(:weightage=>@demodata[i].to_f,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       flash[:notice] = "Invalid User Name or Password"
      end
end

    #This for updating the is_deleted=1
    @uncid=params[:unchecked]
    @unchecked=@uncid.split(",")
     logger.info @uncid.inspect
    for i in 0... @unchecked.size
      puts "inside unchecked for"
       @unchecked_weekday=MgGroupedExam.where(:mg_batch_id=>@batch,:mg_exam_group_id=>@unchecked[i])
        if @unchecked_weekday.size>0
           puts "inside unchecked if"
          @unchecked_weekday[0].update(:is_deleted=>1)
        end
         puts "inside unchecked for end"
    end
else

end
#redirect_to :action=>'exammanagement_connectExamData',:id=>@data
end


def cce_new
#render :layout=>false
end


def cceBasic_Settings

end


def cceBasic_gradeSets
  @cceData=MgCceGradesSet.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

end


def cceBasic_gradeSetsData
  render :layout=>false
end


def cceBasic_gradeSetscreate
  @cceData=MgCceGradesSet.new(cceBasic_grades)
  @cceData.save
  redirect_to :action=>'cceBasic_gradeSets'
end

def cceBasic_gradeSetsEditData
  @gradeSets=MgCceGradesSet.find(params[:id])
  render :layout=>false
end


def cceBasic_gradeSetsUpdateData
  @gradeSets=MgCceGradesSet.find(params[:id])
  @gradeSets.update(cceBasic_grades)
  redirect_to :action=>'cceBasic_gradeSets'
end


def cceBasic_gradeSetsDestroyData
  @gradeSets=MgCceGradesSet.find(params[:id])
  logger.info(@gradeSets)
  @gradeSets.is_deleted =1
  @gradeSets.save
redirect_to :action=>'cceBasic_gradeSets'
end

def addGradeSet_new
  @id=params[:id]
 @gradeSets=MgCceGradesSet.find(params[:id])
  @addGradeSetData=MgCceGrade.where(:mg_cce_grades_set_id=>@id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  logger.info(@id)

end


def addGradeSet_newData
  @school_id=session[:current_user_school_id]
  @id=params[:id]
  render :layout=>false
end


def addGradeSet_newDataCreate
  
  @cceDatas=MgCceGrade.new(addGradeSet)
  @id=@cceDatas.mg_cce_grades_set_id
  @cceDatas.save
  redirect_to :action=>'addGradeSet_new',:id=>@id
end


def addGradeSet_newDataEdit
@addGrade=MgCceGrade.find(params[:id])
render :layout=>false
end  


def addGradeSet_newDataUpdate
  @ids=params[:id]
  logger.info(@ids)
  @gradeSets=MgCceGrade.find(params[:id])
  @id=@gradeSets.mg_cce_grades_set_id
  @gradeSets.update(addGradeSetPoint)
redirect_to :action=>'addGradeSet_new',:id=>@id
end


def addGradeSet_newDataDestroy
@gradeSets=MgCceGrade.find(params[:id])
  @ids=@gradeSets.mg_cce_grades_set_id
  @gradeSets.is_deleted =1
  @gradeSets.save
redirect_to :action=>'addGradeSet_new',:id=>@ids
end  

def cceExamCategory_index
@cceExamData=MgCceExamCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end

def cceExamCategory_new
  render :layout=>false
end


def cceExamCategory_create
@cceExamDatas=MgCceExamCategory.new(cceExamCategory)
  @cceExamDatas.save
  redirect_to :action=>'cceExamCategory_index'
end


def cceExamCategory_edit
  
@examCategory=MgCceExamCategory.find(params[:id])
render :layout=>false
end


def cceExamCategory_update
  @examCategory=MgCceExamCategory.find(params[:id])
  @examCategory.update(cceExamCategory)
redirect_to :action=>'cceExamCategory_index'
end


def cceExamCategory_destroy
@examCategory=MgCceExamCategory.find(params[:id])
  @examCategory.is_deleted =1
  @examCategory.save
redirect_to :action=>'cceExamCategory_index'
end


def cceWeightages_index
   @cceWeightage=MgCceWeightages.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
end


def cceWeightages_new
  @categories=MgCceExamCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  logger.info(@categories)
  render :layout=>false
end


def cceWeightages_create

  @cceWeightages=MgCceWeightages.new(cceExamWeightages)
  @cceWeightages.save
  redirect_to :action=>'cceWeightages_index'
end  
def cceWeightages_edit
  @categories=MgCceExamCategory.pluck(:name,:id)
  @cceWeightage=MgCceWeightages.find(params[:id])
  @weightage_id=@cceWeightage.mg_cce_exam_category_id
render :layout=>false
end
def cceWeightages_update
  @cceWeightage=MgCceWeightages.find(params[:id])
  @cceWeightage.update(cceExamWeightages)
  redirect_to :action=>'cceWeightages_index'

end
def cceWeightages_destroy
@cceWeightage=MgCceWeightages.find(params[:id])
@cceWeightage.is_deleted =1
  @cceWeightage.save
redirect_to :action=>'cceWeightages_index'
end

def cceAssaignWeightages_index
  @Id=params[:id]
  #where(:grading_type=>1
  @course=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
end
def cceAssaignWeightages_new
  @id=params[:mg_course_id]
  @WeightageID=MgCceWeightagesCourse.where(:mg_course_id=>@id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  logger.info("===============")
  logger.info (@WeightageID)
 @cceID=Array.new
  @WeightageID.each do |a|
     
    logger.info a.inspect
     #a.mg_course_id
     @cceID.push(a.mg_cce_weightages_id)

end
logger.info @cceID.inspect

  @weightages=MgCceWeightages.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @info=Array.new
  @weightages.each do |b|
   @info.push(b.id)
end
logger.info @info.inspect

  render :layout=>false

end
def cceAssaignWeightages_create
  @id=params[:mg_course_id]
  @cid=params[:checked]
 
  logger.info "======================================"
  logger.info @cid.inspect
 

    @checked=@cid.split(",")
    #This for updating the is_deleted=0 and creating new record
    for i in 0...@checked.size
       @checked_weekday=MgCceWeightagesCourse.where(:mg_course_id=>@id,:mg_cce_weightages_id=>@checked[i],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       puts "inside checked for"
       if @checked_weekday.size<1
         puts "inside checked if"
          @checked_r=MgCceWeightagesCourse.new()
          @checked_r.mg_course_id=@id
          @checked_r.mg_cce_weightages_id=@checked[i]
          @checked_r.is_deleted=0
          @checked_r.mg_school_id=session[:current_user_school_id]
          @checked_r.save
          puts "inside checked end"
     else
      puts "inside checked else"
        @checked_weekday[0].update(:is_deleted=>0)
      end
      
    end

    #This for updating the is_deleted=1
    @uncid=params[:unchecked]
    @unchecked=@uncid.split(",")
     logger.info @uncid.inspect
    for i in 0... @unchecked.size
      puts "inside unchecked for"
       @unchecked_weekday=MgCceWeightagesCourse.where(:mg_course_id=>@id,:mg_cce_weightages_id=>@unchecked[i],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        if @unchecked_weekday.size>0
           puts "inside unchecked if"
          @unchecked_weekday[0].update(:is_deleted=>1)
        end
         puts "inside unchecked for end"
    end

redirect_to :action=>'cceAssaignWeightages_index', :id=>@id

end




def Co_Scholastic_index
@course_id  
end
def Co_Scholastic_new
  @observationData=MgObservationGroup.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  
end
def Co_Scholastic_newData

  @observations=MgCceGradesSet.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  logger.info(@observations)
  render :layout=>false
  end
  def Co_Scholastic_newDataCreate
    @observationDatas=MgObservationGroup.new(coScholastic)
  @observationDatas.save
  redirect_to :action=>'Co_Scholastic_new'
end
def Co_Scholastic_newDataEdit
     @observations=MgCceGradesSet.pluck(:name,:id)
   @observation=MgObservationGroup.find(params[:id])
  
 render :layout=>false
end
def Co_Scholastic_newDataUpdate
   @observation=MgObservationGroup.find(params[:id])
  @observation.update(coScholastic)
  redirect_to :action=>'Co_Scholastic_new'

end
def Co_Scholastic_newDataDestroy
   @observation=MgObservationGroup.find(params[:id])
   @observation.is_deleted =1
   @observation.save
   redirect_to :action=>'Co_Scholastic_new'

end
def Co_Scholastic_newDataShow

@observation=MgObservationGroup.find(params[:id])
@ids=@observation.mg_cce_grades_set_id
@observations=MgCceGradesSet.find_by(:id=>@ids)
@criteria=MgObservation.where(:mg_observation_group_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

end

def Co_Scholastic_criteriaNew
@id=params[:id]
render :layout=>false
end

def Co_Scholastic_criteriaCreate
  @observationDatas=MgObservation.new(coScholasticCriteria)
  @id=@observationDatas.mg_observation_group_id
  @observationDatas.save
  redirect_to :action=>'Co_Scholastic_newDataShow',:id=>@id
end
def Co_Scholastic_criteriaEdit
@criteriaData=MgObservation.find(params[:id])
  
 render :layout=>false
end
def Co_Scholastic_criteriaUpdate
  @criteriaDatas=MgObservation.find(params[:id])
  @id=@criteriaDatas.mg_observation_group_id
  @criteriaDatas.update(coScholasticCriteriadata)
  redirect_to :action=>'Co_Scholastic_newDataShow',:id=>@id
end
def Co_Scholastic_criteriaDestroy
  @observations=MgObservation.find(params[:id])
  @id=@observations.mg_observation_group_id
   @observations.is_deleted =1
   @observations.save
   redirect_to :action=>'Co_Scholastic_newDataShow',:id=>@id

end
def Co_Scholastic_newIndicatorData
@observation=MgObservation.find(params[:id])
@ids=params[:id]
logger.info(@ids)
@indicators=MgDescriptiveIndicator.where(:describable_id=> @ids,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:describable_type=>"Observation")
end
def Co_Scholastic_newIndicatorNew
@ids=params[:id]
render :layout=>false
end
def Co_Scholastic_newIndicatorCreate
  @indicatorData=MgDescriptiveIndicator.new(coScholasticIndicatorData)
@id=@indicatorData.describable_id
  @indicatorData.save
redirect_to :action=>'Co_Scholastic_newIndicatorData',:id=>@id
  end

def Co_Scholastic_newIndicatorEdit
@coCriterias=MgDescriptiveIndicator.find(params[:id])
  
 render :layout=>false
  end
  def Co_Scholastic_newIndicatorUpdate
@indicatorCriteriaDatas=MgDescriptiveIndicator.find(params[:id])
@id=@indicatorCriteriaDatas.describable_id
@indicatorCriteriaDatas.update(coScholasticUpdateIndicatorData)
redirect_to :action=>'Co_Scholastic_newIndicatorData',:id=>@id
  end
  def Co_Scholastic_newIndicatorDestroy
@Indicatorobservations=MgDescriptiveIndicator.find(params[:id])
  @id=@Indicatorobservations.describable_id
  @Indicatorobservations.is_deleted =1
  @Indicatorobservations.save
  redirect_to :action=>'Co_Scholastic_newIndicatorData',:id=>@id

  end



def Co_ScholasticCourseObservation_index
  @Id=params[:id]
  logger.info(@Id.inspect)
  #logggger.inf
  @curent_school=MgSchool.find(session[:current_user_school_id])
  #:grading_type=>@curent_school.grading_system
  @course=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
end
def Co_ScholasticCourseObservation_new

  @id=params[:mg_course_id]

@observationID=MgCourseObservationGroup.where(:mg_course_id=>@id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@cceID=Array.new
  @observationID.each do |a|
     
    logger.info a.inspect
     #a.mg_course_id
     @cceID.push(a.mg_observation_group_id)
end

  @observation=MgObservationGroup.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @info=Array.new
  @observation.each do |b|
   @info.push(b.id)
end
logger.info @info.inspect
  render :layout=>false
end
def Co_ScholasticCourseObservation_create


@id=params[:mg_course_id]
  @cid=params[:checked]
 
  logger.info "======================================"
  logger.info @cid.inspect
 

    @checked=@cid.split(",")
    #This for updating the is_deleted=0 and creating new record
    for i in 0...@checked.size
       @checked_weekday=MgCourseObservationGroup.where(:mg_course_id=>@id,:mg_observation_group_id=>@checked[i],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       puts "inside checked for"
       if @checked_weekday.size<1
         puts "inside checked if"
          @checked_r=MgCourseObservationGroup.new()
          @checked_r.mg_course_id=@id
          logger.info(@checked[i])
          @checked_r.mg_observation_group_id=@checked[i]
          @checked_r.is_deleted=0
           @checked_r.mg_school_id=session[:current_user_school_id]
          @checked_r.save
          puts "inside checked end"
     else
      puts "inside checked else"
        @checked_weekday[0].update(:is_deleted=>0)
      end
      
    end

    #This for updating the is_deleted=1
    @uncid=params[:unchecked]
    @unchecked=@uncid.split(",")
     logger.info @uncid.inspect
    for i in 0... @unchecked.size
      puts "inside unchecked for"
       @unchecked_weekday=MgCourseObservationGroup.where(:mg_course_id=>@id,:mg_observation_group_id=>@unchecked[i],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        if @unchecked_weekday.size>0
           puts "inside unchecked if"
          @unchecked_weekday[0].update(:is_deleted=>1)
        end
         puts "inside unchecked for end"
    end

redirect_to :action=>'Co_ScholasticCourseObservation_index', :id=>@id

end

def scholastic_index

end
def scholastic_formativeAssessmentnew
   @observation=MgFaGroup.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
   
  end
def scholastic_formativeAssessmentnewData
  @assesment=MgCceExamCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
render :layout=>false
end
def scholastic_formativeAssessmentnewCreate
@assesment=MgFaGroup.new(scholasticData)
@assesment.save
redirect_to :action=>'scholastic_formativeAssessmentnew'
end
def scholastic_formativeAssessmentEdit
   @assesment=MgCceExamCategory.pluck(:name,:id)
@assessments=MgFaGroup.find(params[:id])
  render :layout=>false
end
def scholastic_formativeAssessmentUpdate
@assessmentsDatas=MgFaGroup.find(params[:id])
@assessmentsDatas.update(scholasticData)
  redirect_to :action=>'scholastic_formativeAssessmentnew'

end
def scholastic_formativeAssessmentDestroy
  @scholasticobservations=MgFaGroup.find(params[:id])
   @scholasticobservations.is_deleted =1
   @scholasticobservations.save
   redirect_to :action=>'scholastic_formativeAssessmentnew'
  end


  def scholastic_formativeCriteriaIndex
    @criteria=MgFaGroup.find(params[:id])
@ids=@criteria.mg_cce_exam_category_id
@observations=MgCceExamCategory.find(@ids)

@criteriadata=MgFaCriteria.where(:mg_fa_group_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

  end
def scholastic_formativeCriteriaNew
  @ids=params[:id]
  render :layout=>false
end
def scholastic_formativeCriteriaCreate
  @criterias=MgFaCriteria.new(scholasticCriteriaData)
  @id=@criterias.mg_fa_group_id
  @criterias.save
redirect_to :action=>'scholastic_formativeCriteriaIndex',:id=>@id
  end
  def scholastic_formativeCriteriaEdit
@criteriasdatas=MgFaCriteria.find(params[:id])
  
 render :layout=>false
  end
  def scholastic_formativeCriteriaUpdate
@criteriaDatas=MgFaCriteria.find(params[:id])
@id=@criteriaDatas.mg_fa_group_id
@criteriaDatas.update(scholasticCriteriaUpdateData)
redirect_to :action=>'scholastic_formativeCriteriaIndex',:id=>@id
  end
def scholastic_formativeCriteriaDestroy
  @observations=MgFaCriteria.find(params[:id])
  @id=@observations.mg_fa_group_id
  @observations.is_deleted =1
  @observations.save
  redirect_to :action=>'scholastic_formativeCriteriaIndex',:id=>@id
end
def scholastic_formativeIndicatorIndex
   @fa_Criteria=MgFaCriteria.find(params[:id])
    @ids=params[:id]
    logger.info(@ids)
    @indicator=MgDescriptiveIndicator.where(:mg_fa_criteria_id=> @ids,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:describable_type=>"FaCriteria")

end

def scholastic_formativeIndicatorNewData
  @ids=params[:id]
  render :layout=>false
end
def scholastic_formativeIndicatorCreate
@indicatorData=MgDescriptiveIndicator.new(scholasticIndicatorData)
@id=@indicatorData.mg_fa_criteria_id
  @indicatorData.save
redirect_to :action=>'scholastic_formativeIndicatorIndex',:id=>@id
end
def scholastic_formativeIndicatorEdit
  @indicator=MgDescriptiveIndicator.find(params[:id])
  render :layout=>false
end
def scholastic_formativeIndicatorUpdate
@criteriaDatas=MgDescriptiveIndicator.find(params[:id])
@id=@criteriaDatas.mg_fa_criteria_id
@criteriaDatas.update(scholasticUpdateIndicatorData)
redirect_to :action=>'scholastic_formativeIndicatorIndex',:id=>@id
end
def scholastic_formativeIndicatorDestroy
  @observations=MgDescriptiveIndicator.find(params[:id])
  @id=@observations.mg_fa_criteria_id
  @observations.is_deleted =1
  @observations.save
  redirect_to :action=>'scholastic_formativeIndicatorIndex',:id=>@id
  end




def ScholasticFaGroups_index
  @course=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
end
def ScholasticFaGroups_new
  # @subjects=Array.new
  @keyValues=Array.new

  @id=params[:mg_course_id]
  @batchID=MgBatch.where(:mg_course_id=>@id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@batchID.each do |value|
  logger.info("inside loop")
  @batsubID=MgBatchSubject.where(:mg_batch_id=>value.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  logger.info "========================="
  logger.info(@batsubID.inspect)

@batsubID.each do |subID|
@subjects=Array.new
 @subjectId=subID.mg_subject_id
  @ID=MgSubject.find(@subjectId)
  @subjects.push( @ID.subject_name)
  @subjects.push( @ID.id)



logger.info ("i am inside")
  logger.info @subjects
@keyValues.push(@subjects)
 

    logger.info @keyValues
end
end

  #@subject=MgSubject.where(:mg_course_id=>@id).pluck(:subject_name,:id)
  render :layout=>false
end
def ScholasticFaGroups_newData

@id=params[:mg_subject_id]
logger.info "========================"
logger.info @id
@observationID=MgFaGroupsSubject.where(:mg_subject_id=>@id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
@cceID=Array.new
  @observationID.each do |a|
     
    logger.info a.inspect
     #a.mg_course_id
     @cceID.push(a.mg_fa_group_id)
end

  @groups=MgFaGroup.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  @info=Array.new
  @groups.each do |b|
   @info.push(b.id)
end
logger.info @info.inspect
  render :layout=>false
  #render :layout=>false




end
def ScholasticFaGroups_create


@id=params[:mg_course_id]
@ids=params[:mg_subject_id]
  @cid=params[:checked]
 
  logger.info "======================================"
  logger.info @cid.inspect
 

    @checked=@cid.split(",")
    #This for updating the is_deleted=0 and creating new record
    for i in 0...@checked.size
       @checked_weekday=MgFaGroupsSubject.where(:mg_subject_id=>@ids,:mg_fa_group_id=>@checked[i],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       puts "inside checked for"
       if @checked_weekday.size<1
         puts "inside checked if"
          @checked_r=MgFaGroupsSubject.new()
          @checked_r.mg_subject_id=@ids
          @checked_r.mg_fa_group_id=@checked[i]
          @checked_r.is_deleted=0
          @checked_r.mg_school_id=session[:current_user_school_id]
          @checked_r.save
          puts "inside checked end"
     else
      puts "inside checked else"
        @checked_weekday[0].update(:is_deleted=>0)
      end
      
    end

    #This for updating the is_deleted=1
    @uncid=params[:unchecked]
    @unchecked=@uncid.split(",")
     logger.info @uncid.inspect
    for i in 0... @unchecked.size
      puts "inside unchecked for"
       @unchecked_weekday=MgFaGroupsSubject.where(:mg_subject_id=>@ids,:mg_fa_group_id=>@unchecked[i],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        if @unchecked_weekday.size>0
           puts "inside unchecked if"
          @unchecked_weekday[0].update(:is_deleted=>1)
        end
         puts "inside unchecked for end"
    end

redirect_to :action=>'ScholasticFaGroups_index', :id=>@id










#   @data=params[:message_ids]
  

# @data.each do |key|
#     @data= MgFaGroupsSubject.new()
#         @demo= key.split(",")
#        @data.mg_subjects_id=@demo[0]
#         @data.mg_fa_groups_id=@demo[1]
#         @data.save
#       end
#    redirect_to :action=>'ScholasticFaGroups_index'



end





private

  def grade_params
    params.require(:grades).permit(:name,:mg_batch_id,:min_score,:order,:credit_points,:description,:is_deleted,:mg_school_id)
  end

  def ajax_grade_params
    params.permit(:name,:min_score,:credit_points,:description,:mg_school_id)
  end

  def update_params
    params.require(:grades).permit(:name,:min_score,:order,:credit_points,:description,:is_deleted,:mg_school_id)
  end
end
def ranking_params
    params.require(:rankings).permit(:name,:priority,:mg_course_id,:gpa,:marks,:marks_limit_type,:subject_count,:subject_limit_type,:full_course,:is_deleted,:mg_school_id)
  end
  def ranking_update_params
    params.require(:rankings).permit(:name,:gpa,:marks,:marks_limit_type,:subject_count,:subject_limit_type,:full_course,:is_deleted,:mg_school_id)
  end

  def designation_params
    params.require(:designations).permit(:name,:marks,:mg_course_id,:is_deleted,:mg_school_id)
  end
   def update_designation_params
    params.require(:designations).permit(:name,:marks,:is_deleted,:mg_school_id)
  end

  def exammanagement_params
    params.require(:exams).permit(:name,:exam_type,:mg_batch_id,:is_published,:is_final_exam,:result_published,:is_deleted,:cce_exam_category_id,:mg_school_id)
  end

  def cceBasic_grades
    params.require(:gradeSets).permit(:name,:is_deleted,:mg_school_id)
  end
  def addGradeSet
    params.require(:addGrade).permit(:name,:grade_point,:mg_cce_grades_set_id,:is_deleted,:mg_school_id)
  end
  def addGradeSetPoint
    params.require(:addGrade).permit(:name,:grade_point,:is_deleted,:mg_school_id)
  end
  def cceExamCategory
    params.require(:examCategory).permit(:name,:description,:is_deleted,:mg_school_id)
  end
  def cceExamWeightages
    params.require(:cceWeightage).permit(:weightages,:criteria_type,:mg_cce_exam_category_id,:is_deleted,:mg_school_id)
  end
  def coScholastic
    params.require(:observation).permit(:name,:header_name,:mg_cce_grades_set_id,:description,:observation_kind,:is_deleted,:mg_school_id)
  end
  def coScholasticCriteria
    params.require(:criteriaData).permit(:name,:mg_observation_group_id,:description,:is_deleted,:mg_school_id)
  end
   def coScholasticCriteriadata
    params.require(:criteriaData).permit(:name,:description,:is_deleted,:mg_school_id)
  end
  def scholasticData
    params.require(:assessments).permit(:name,:description,:max_marks,:mg_cce_exam_category_id,:is_deleted,:mg_school_id)
  end
  def scholasticCriteriaData
    params.require(:criterias).permit(:fa_name,:description,:mg_fa_group_id,:is_deleted,:mg_school_id)
  end
  def scholasticCriteriaUpdateData
    params.require(:criteriasdatas).permit(:fa_name,:description,:is_deleted,:mg_school_id)
  end
  def scholasticIndicatorData
    params.require(:indicator).permit(:name,:mg_fa_criteria_id,:describable_type,:description,:is_deleted,:mg_school_id,:total_marks)
  end
  def scholasticUpdateIndicatorData
    params.require(:indicator).permit(:name,:description,:total_marks)
  end
  def coScholasticIndicatorData
    params.require(:coCriterias).permit(:name,:describable_id,:describable_type,:description,:is_deleted,:mg_school_id,:total_marks)
  end
  def coScholasticUpdateIndicatorData
    params.require(:coCriterias).permit(:name,:description,:is_deleted,:mg_school_id,:total_marks)
  end

  def exammanagementeExamGroupsNew
    params.require(:ExamsGroups).permit(:mg_subject_id,:mg_exam_group_id,:start_time,:end_time,:maximum_marks,:minimum_marks,:is_deleted,:mg_school_id)
  end
  def exammanagementeExamUpdateGroupsNew
    params.require(:ExamsGroups).permit(:mg_subject_id,:start_time,:end_time,:maximum_marks,:minimum_marks,:is_deleted,:mg_school_id)
  end
  def connectexammanagementeExam
    params.require(:connect_Exam).permit(:mg_batch_id)
  end