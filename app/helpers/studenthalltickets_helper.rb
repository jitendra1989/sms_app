module StudenthallticketsHelper
  def student_record(student_id)
    @hall_ticket = MgStudentAdmission.find_by(:id=>student_id).hall_ticket_release
    if @hall_ticket.present?
      return "Released"
    else
      return "Not Release"      
    end
  end
end
