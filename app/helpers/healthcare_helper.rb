module HealthcareHelper
  def specialization(mg_specialization_id)
    puts"heplderrrrrrrrrrrrrrrrrr"
    puts"heplderrrrrrrrrrrrrrrrrr"
    if mg_specialization_id.present?
      specialization_obj=MgSpecialization.find_by(:id=>mg_specialization_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      return specialization_obj
    else
      return nil
    end
  end
end
