module AlumniHelper
  def get_together(mg_user_id,get_together_id)
    @mg_user_id=mg_user_id
    if @mg_user_id.present?
      alumni_obj=MgAlumni.find_by(:is_deleted=>0,:mg_user_id=>session[:user_id])
      if alumni_obj.present?
        @mg_alumni_obj=MgGetTogether.where(:is_deleted=>0,:mg_alumni_get_together_id=>get_together_id,:mg_alumni_id=>alumni_obj.id)
      else
        @mg_alumni_obj=nil
      end
      return @mg_alumni_obj
    else
      return nil
    end
  end
end
