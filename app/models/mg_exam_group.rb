class MgExamGroup < ActiveRecord::Base
	belongs_to :mg_batch
	belongs_to :mg_cce_exam_category
	belongs_to :mg_school

	has_many :mg_exams
	has_many :mg_grouped_exams

def batch_average_marks(marks)
    batch = self.mg_batch
    exams = self.mg_exams
    batch_students = batch.mg_students
    total_students_marks = 0
    #   total_max_marks = 0
    students_attended = []
    exams.each do |exam|
      batch_students.each do |student|
        exam_score = MgExamScore.find_by(:mg_student_id=>student.id,:mg_exam_id=>exam.id)
        unless exam_score.nil?
          unless exam_score.marks.nil?
            total_students_marks = total_students_marks+exam_score.marks
            unless students_attended.include? student.id
              students_attended.push student.id
            end
          end
        end
      end
      #      total_max_marks = total_max_marks+exam.maximum_marks
    end
    unless students_attended.size == 0
      puts students_attended.size.inspect
      puts total_students_marks.inspect
      #logger.infoadjas

      batch_average_marks = total_students_marks/students_attended.size
    else
      batch_average_marks = 0
    end
    return batch_average_marks #if marks == 'marks'
    #   return total_max_marks if marks == 'percentage'
  end



 def subject_wise_batch_average_marks(subject_id)
    batch = self.mg_batch
    subject = MgSubject.find(subject_id)
    puts "sdfjgsjb3469435sdfjkghjksh30456347"
    puts subject.id
    puts self.id
total_students_marks = 0
 students_attended = []

    exam = MgExam.find_by(:mg_exam_group_id=>self.id,:mg_subject_id=>subject.id)
    puts exam.inspect
if exam.nil?
    else
    puts subject.inspect

    batch_students = batch.mg_students
    puts "================"
    #logger.info batch_students.inspect
puts "========end========"

    #total_students_marks = 0
    #   total_max_marks = 0
   #students_attended = []

    batch_students.each do |student|
      #puts "students"
      #puts student.id
     # puts "exam"
    	#puts exam.id 
      
    
      exam_score = MgExamScore.find_by(:mg_student_id=>student.id,:mg_exam_id=>exam.id)
      puts "================"
      puts exam_score.inspect
   
    
      unless exam_score.nil?
        total_students_marks = total_students_marks+ (exam_score.marks || 0)
        puts total_students_marks
         
        unless students_attended.include? student.id
          students_attended.push student.id
          puts "jayanthsdfklgldfgvdf"
           puts students_attended.size
           # logger.infoasdhirfgu
        end
        
      end
    
    end

    end
   # logger.infoasdhirfgu
    puts "sdjkfhksd34694756sdlkjfgo"
     puts total_students_marks

     puts students_attended
    #logger.infoasdfs
    #      total_max_marks = total_max_marks+exam.maximum_marks
    unless students_attended.size == 0
      subject_wise_batch_average_marks = total_students_marks/students_attended.size.to_f
      puts subject_wise_batch_average_marks
     # logger.infoasdhirfgu
    else
      subject_wise_batch_average_marks = 0
    end
    return subject_wise_batch_average_marks
    #   return total_max_marks if marks == 'percentage'
  end
def total_marks(student)
    exams = MgExam.where(self.id)
    total_marks = 0
    max_total = 0
    exams.each do |exam|
      

      exam_score = MgExamScore.find_by(:mg_exam_id=>exam.id,:mg_student_id=>student.id)
      total_marks = total_marks + (exam_score.marks || 0) unless exam_score.nil?
      max_total = max_total + exam.maximum_marks unless exam_score.nil?
     
      puts  max_total
     
    end

    result = [total_marks,max_total]
    
   
  end


end
