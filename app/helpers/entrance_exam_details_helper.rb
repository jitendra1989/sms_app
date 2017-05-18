module EntranceExamDetailsHelper 

  def entrance_exam_index(obtained_mark,total_marks)
    @final_marks = (obtained_mark*100)/total_marks
    return number_with_precision(@final_marks, precision: 2)    
  end
  def final_exam_index(obtained_mark,total_marks,previous_education_marks,previous_mark_weightage,entrance_marks_weightage)
    @total_entrance_marks = (obtained_mark*100)/total_marks   
    obtained_mark = obtained_mark.to_f
    total_marks = total_marks.to_i
    previous_education_marks = previous_education_marks.to_f
    previous_mark_weightage = previous_mark_weightage.to_f
    entrance_marks_weightage = entrance_marks_weightage.to_f

    @final_index = (previous_education_marks*previous_mark_weightage)/100 + (@total_entrance_marks*entrance_marks_weightage)/100
    return number_with_precision(@final_index, precision: 2)
  end
end
