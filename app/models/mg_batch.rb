class MgBatch < ActiveRecord::Base
   #validates :mg_employee_id, uniqueness: true
	belongs_to :mg_course
	belongs_to :mg_school
	belongs_to :mg_employee
  has_many :mg_time_table_change_entries
  

  delegate :course_name,:section_name, :code, :to => :mg_course

    has_many :mg_fee_discounts
    has_many :mg_grouped_exams

	 has_many :mg_students, -> { where is_deleted: 0}
   accepts_nested_attributes_for :mg_students
   
   has_many :mg_exam_groups
   accepts_nested_attributes_for :mg_exam_groups

   has_many :mg_grading_levls,:dependent => :destroy
   accepts_nested_attributes_for :mg_grading_levls

   has_many :mg_grouped_exams,:dependent => :destroy
   accepts_nested_attributes_for :mg_grouped_exams

   #Bindhu start
    has_many :mg_fee_category_batches
	  has_many :mg_fee_collections
    has_many :mg_fee_particulars
    has_many :mg_exam_groups
    has_many :mg_grading_levels
    has_many :mg_student_attendances
	has_many :mg_weekdays
	has_many :mg_batch_subjects
	has_many :mg_batch_syllabuses
	has_many :mg_class_timings
	has_many :mg_time_table_entries
	has_many :mg_assessment_scores

	delegate :course_name,:to => :mg_course
  delegate :mg_wing_id,:to => :mg_course
	
   has_many :mg_grouped_batches
 #scope :active, lambda{ {:conditions => {  :is_deleted => 0 }} }
  #scope :active, lambda{ {:conditions => { :is_deleted => 0 } } }

  #scope :active,lambda{ {:conditions => { :is_deleted=>false },:joins=>:MgCourse,:select=>"`mg_batches`.*,CONCAT(mg_courses.code,'-',mg_batches.name) as course_full_name",:order=>"course_full_name"} }
  scope :active,lambda{where(:is_deleted=>0).joins(:mg_course).select("`mg_batches`.*,CONCAT(mg_courses.code,'-',mg_batches.name) as course_full_name",:order=>"course_full_name")}

  #scope :demo,lambda{active.joins(:mg_course)}
  #scope :recent,lambda{demo.select("`mg_batches`.*,CONCAT(mg_courses.code,'-',mg_batches.name) as course_full_name",:order=>"course_full_name")} 
  #scope :active,lambda{where(:is_deleted=>0)}


	def course_batch_name
		"#{course_name} - #{name}"
	end	
  def course_batch_code
    "#{code} - #{name}"
  end 

  def mg_wing_id_for_batch
    "#{mg_wing_id}"
  end


	def full_name
    "#{code} - #{name}"
  end
#Bindhu end
#
#def batch_course_info()
#	@art=:mg_course.course_name
#  "Name: #{@art}. Batch: #{user.name}"
#end

def grading_level_list
    levels = self.mg_grading_levels
    levels.empty? ? MgGradingLevel.default : levels
  end

def find_batch_rank
    @students = MgStudent.where(self.id)
    @grouped_exams = MgGroupedExam.where(self.id)
    ordered_scores = []
    student_scores = []
    ranked_students = []
    @students.each do|student|
      score = MgGroupedExamReport.find_by(:mg_student_id=>student.id,:mg_batch_id=>student.mg_batch_id,:score_type=>"c")
      marks = 0
      unless score.nil?
        marks = score.marks
      end
      ordered_scores << marks
      student_scores << [student.id,marks]
    end
    ordered_scores = ordered_scores.compact.uniq.sort.reverse
    @students.each do |student|
      marks = 0
      student_scores.each do|student_score|
        if student_score[0]==student.id
          marks = student_score[1]
        end
      end
      ranked_students << [(ordered_scores.index(marks) + 1),marks,student.id,student]
    end
    ranked_students = ranked_students.sort
  end
def normal_enabled?
    self.grading_type.nil? or self.grading_type=="0"
  end

def generate_batch_reports

    grading_type = self.grading_type
    students = self.mg_students
    
    
    grouped_exams = self.mg_exam_groups.reject{|e| !MgGroupedExam.exists?(:mg_batch_id=>self.id, :mg_exam_group_id=>e.id)}
    puts grouped_exams.inspect
    puts self.id
    #logger.asDGF
    unless grouped_exams.empty?

      subject = self.mg_batch_subjects
      puts subject.inspect
      subjects=Array.new
      subject.each do|sub|
      subj=MgSubject.find(sub.mg_subject_id)
      subjects.push(subj)
      #logger.insdjkahfkchs
    end
      unless students.empty?
        st_scores = MgGroupedExamReport.where(:mg_student_id=>students,:mg_batch_id=>self.id)
         
        unless st_scores.empty?

          st_scores.map{|sc| sc.destroy}
        end
        subject_marks=[]
        exam_marks=[]
        grouped_exams.each do|exam_group|
          subjects.each do|subject|
            exam = MgExam.find_by(:mg_exam_group_id=>exam_group.id,:mg_subject_id=>subject.id)
            unless exam.nil?
              students.each do|student|
                #unless is_assigned_elective==0
                  percentage = 0
                  marks = 0
                  score = MgExamScore.find_by(:mg_exam_id=>exam.id,:mg_student_id=>student.id)

                  if grading_type.nil? or self.normal_enabled?
                    unless score.nil? or score.marks.nil?

                      percentage = (((score.marks.to_f)/exam.maximum_marks.to_f)*100)*((8.to_f)/100)
                      marks = score.marks.to_f

                    end

                  
                  end

                  flag=0
                  puts "agsdjfga"
                  puts student.id
                  puts subject.id
                  puts percentage
                   

                  subject_marks.each do|s|
                    
                     #logger.infosdfsd
                    if s[0]==student.id and s[1]==subject.id
                      s[2] << percentage.to_f
                      flag=1
                    end
                  end
                    puts flag
                    #logger.hdfk
                  unless flag==1
                    #logger.asDGF
                    subject_marks << [student.id,subject.id,[percentage.to_f]]
                  end
                  e_flag=0

                  exam_marks.each do|e|
                    if e[0]==student.id and e[1]==exam_group.id
                      e[2] << marks.to_f
                      if grading_type.nil? or self.normal_enabled?
                        e[3] << exam.maximum_marks.to_f
                      end
                      e_flag = 1
                    end
                  end

                  unless e_flag==1
                    if grading_type.nil? or self.normal_enabled?
                      #logger.infoasdf
                      exam_marks << [student.id,exam_group.id,[marks.to_f],[exam.maximum_marks.to_f]]
                    end
                  #end
                end
              end
            end
          end
        end
        
        subject_marks.each do|subject_mark|
          student_id = subject_mark[0]
          subject_id = subject_mark[1]
          marks = subject_mark[2].sum.to_f

          prev_marks = MgGroupedExamReport.find_by(:mg_student_id=>student_id,:mg_subject_id=>subject_id,:mg_batch_id=>self.id,:score_type=>"s")
       puts "asdkadkkkskfka90707"
           puts prev_marks.inspect
          #logger.asDGF
          unless prev_marks.nil?
            logger.adhfk
            prev_marks.update_attributes(:marks=>marks)
          else
            #logger.adhfk
            MgGroupedExamReport.create(:mg_batch_id=>self.id,:mg_student_id=>student_id,:marks=>marks,:score_type=>"s",:mg_subject_id=>subject_id)
          end
        end
        exam_totals = []
        exam_marks.each do|exam_mark|
          student_id = exam_mark[0]
          exam_group = MgExamGroup.find(exam_mark[1])
          score = exam_mark[2].sum
          max_marks = exam_mark[3].sum
          tot_score = 0
          percent = 0
          unless max_marks.to_f==0
            if grading_type.nil? or self.normal_enabled?
              tot_score = (((score.to_f)/max_marks.to_f)*100)
              percent = (((score.to_f)/max_marks.to_f)*100)*((8.to_f)/100)
            end
          end
          prev_exam_score = MgGroupedExamReport.find_by(:mg_student_id=>student_id,:mg_exam_group_id=>exam_group.id,:score_type=>"e")
          unless prev_exam_score.nil?
            prev_exam_score.update_attributes(:marks=>tot_score)
          else
            MgGroupedExamReport.create(:mg_batch_id=>self.id,:mg_student_id=>student_id,:marks=>tot_score,:score_type=>"e",:mg_exam_group_id=>exam_group.id)
          end
          exam_flag=0
          exam_totals.each do|total|
            if total[0]==student_id
              total[1] << percent.to_f
              exam_flag=1
            end
          end
          unless exam_flag==1
            exam_totals << [student_id,[percent.to_f]]
          end
        end
        exam_totals.each do|exam_total|
          student_id=exam_total[0]
          total=exam_total[1].sum.to_f
          prev_total_score = MgGroupedExamReport.find_by(:mg_student_id=>student_id,:mg_batch_id=>self.id,:score_type=>"c")
          unless prev_total_score.nil?
            prev_total_score.update_attributes(:marks=>total)
          else
            MgGroupedExamReport.create(:mg_batch_id=>self.id,:mg_student_id=>student_id,:marks=>total,:score_type=>"c")
          end
        end
      end
    end
  end




end

